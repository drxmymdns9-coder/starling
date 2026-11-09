# iOS port TODO

- [x] Start from Starling Android rather than the desktop-only Elyhorizon fork.
- [x] Add a dedicated `horizon-ios` Rust package.
- [x] Add an idempotent Rust lifecycle ABI boundary.
- [x] Add Codemagic workflow, Rust iOS build script, and XcodeGen project spec.
- [x] Add Swift Xcode host and `MTKView` surface scaffold.
- [ ] Build the iOS target on macOS and resolve target-specific dependencies.
- [ ] Connect Metal presentation and resize/orientation handling.
- [ ] Feed UIKit touch events into Horizon's shared touch controls.
- [ ] Add iOS file paths and security-scoped imports.
- [ ] Add Keychain-backed account storage and browser callback login.
- [ ] Add audio, haptics, keyboard/controller support.
- [ ] Bring up a local world and save/load on a real iPhone.
- [ ] Bring up multiplayer and resource downloads.
- [ ] Port Ely.by login after base iOS playability.
- [ ] Produce a sideloadable IPA.
