//! iOS host bridge.
//!
//! This is intentionally a small ABI boundary. UIKit owns the application
//! lifecycle and the Metal-backed view; the Rust game loop will be connected
//! behind these functions in the next milestone. Keeping the boundary small
//! lets the shared Horizon simulation stay platform-neutral.
#![cfg(target_os = "ios")]

use std::sync::atomic::{AtomicBool, Ordering};

static RUNNING: AtomicBool = AtomicBool::new(false);

/// Start the Rust side of the iOS client.
///
/// The Swift host calls this after the `MTKView` and sandbox directories are
/// ready. It is idempotent so background/foreground transitions cannot start
/// two game loops.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_start() -> bool {
    !RUNNING.swap(true, Ordering::AcqRel)
}

/// Stop the Rust side before iOS suspends or terminates the scene.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_stop() -> bool {
    RUNNING.swap(false, Ordering::AcqRel)
}

/// Return whether the Rust host is currently active.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_is_running() -> bool {
    RUNNING.load(Ordering::Acquire)
}
