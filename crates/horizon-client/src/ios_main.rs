//! iOS host bridge.
//!
//! This is intentionally a small ABI boundary. UIKit owns the application
//! lifecycle and the Metal-backed view; the Rust game loop will be connected
//! behind these functions in the next milestone. Keeping the boundary small
//! lets the shared Horizon simulation stay platform-neutral.
#![cfg(target_os = "ios")]

use std::sync::atomic::{AtomicBool, AtomicU32, Ordering};

static RUNNING: AtomicBool = AtomicBool::new(false);
static ACTIVE_TOUCHES: AtomicU32 = AtomicU32::new(0);

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

/// Notify Rust that a finger started on the game surface.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_touch_begin(_id: u64, _x: f32, _y: f32) {
    ACTIVE_TOUCHES.fetch_add(1, Ordering::AcqRel);
}

/// Notify Rust that an active finger moved on the game surface.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_touch_move(_id: u64, _x: f32, _y: f32) {}

/// Notify Rust that a finger ended or was cancelled.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_touch_end(_id: u64, _x: f32, _y: f32) {
    let _ = ACTIVE_TOUCHES.fetch_update(Ordering::AcqRel, Ordering::Acquire, |count| {
        Some(count.saturating_sub(1))
    });
}

/// Exposed for the native host's lifecycle and smoke tests.
#[unsafe(no_mangle)]
pub extern "C" fn horizon_ios_active_touches() -> u32 {
    ACTIVE_TOUCHES.load(Ordering::Acquire)
}
