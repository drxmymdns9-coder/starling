# Horizon iOS port

This branch starts from the Starling Android port because it already contains the mobile renderer policy, touch controls, account/download flow, and sandboxed resource model. iOS is a separate host: shared gameplay and rendering code stays in Rust, while UIKit, Metal presentation, lifecycle, secure storage, keyboard, audio, and haptics remain native adapters.

## Current milestone

- Added `crates/horizon-ios`, a dedicated Rust host package.
- Added an iOS ABI boundary in `crates/horizon-client/src/ios_main.rs`.
- Added `codemagic.yaml`, an XcodeGen spec, and a Rust iOS build script for Codemagic.
- Added a Swift `MTKView` host that exercises the Rust lifecycle bridge.
- Kept Android and desktop entry points unchanged.
- Added no fake iOS build claim: the host still needs Xcode and a real iOS device for compilation and validation.

## Build order

1. Create the Xcode host and `MTKView` surface.
2. Add an iOS `winit` event-loop adapter or a small native event pump matching the existing Android runtime API.
3. Connect `wgpu` Metal surface creation to the iOS view.
4. Port touch events into the shared touch layout and map the on-screen controls to gameplay actions.
5. Implement iOS sandbox paths, security-scoped file import, Keychain account storage, URL callback login, audio, haptics, and background/foreground handling.
6. Reuse Starling's resource preparation/download flow without shipping Mojang assets in the app.
7. Add device tiers, memory budgets, crash reports, and an IPA build script for sideloading.
8. Reapply Ely.by authentication from Elyhorizon after the base Horizon client is playable on iOS.

## Codemagic setup

The workflow is `ios-unsigned`. It deliberately does not configure `ios_signing`, does not call `xcode-project use-profiles`, and builds with `CODE_SIGNING_ALLOWED=NO` and `CODE_SIGNING_REQUIRED=NO`. It packages the resulting `.app` as `build/ios/ipa/Horizon-unsigned.ipa`. The IPA is intended for the user's own signing/repackaging workflow; Codemagic does not need an Apple certificate or provisioning profile for this build.

## Important constraint

The iOS artifact cannot be built or signed in this Linux workspace. The Rust source and Xcode host can be prepared here, but the first device build must run on macOS with Xcode and an Apple signing identity.
