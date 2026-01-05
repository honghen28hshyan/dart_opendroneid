## [0.7.3](https://github.com/dronetag/dart-opendroneid/compare/v0.7.2...v0.7.3) (2025-08-19)

## [0.7.2](https://github.com/dronetag/dart-opendroneid/compare/v0.7.1...v0.7.2) (2025-08-19)

## [0.7.1](https://github.com/dronetag/dart-opendroneid/compare/v0.7.0...v0.7.1) (2025-08-19)

# [0.7.0](https://github.com/dronetag/dart-opendroneid/compare/v0.6.2...v0.7.0) (2025-06-18)


### Bug Fixes

* Fix throwable parse method used in parseODIDMessageStream ([7c9efee](https://github.com/dronetag/dart-opendroneid/commit/7c9efeea58ae6c5e9284f7af0bc74dd8d40534c7))
* Make unnecessary nullable decoders outputs non-nullable ([527be7d](https://github.com/dronetag/dart-opendroneid/commit/527be7d0f932b5317a4e6334839830b20aa9decc))
* **tests:** Remove default nullable expectations ([3143554](https://github.com/dronetag/dart-opendroneid/commit/3143554ffc5dffba6fdb3dca2b607b9304b9a29e))
* Use existing raw var in basic_id_message_parser.dart ([15408c1](https://github.com/dronetag/dart-opendroneid/commit/15408c1e5ff40fd96e1e5dda9d4d935eeae89f62))


### Code Refactoring

* Replace parses calls and update main parseODIDMessage method ([d2b9d59](https://github.com/dronetag/dart-opendroneid/commit/d2b9d59afbea30c6dff049245cf4cb17b9fd1b3e))


### Features

* Add ParseWarning and ParseResult models ([f8027a4](https://github.com/dronetag/dart-opendroneid/commit/f8027a473597d3682ae76e33dec7eada1bbea3b4))
* Introduce concept of warnings to relax parsing and validation strictness (DT-4114) ([#9](https://github.com/dronetag/dart-opendroneid/issues/9)) ([90f3f27](https://github.com/dronetag/dart-opendroneid/commit/90f3f2752c72222077cf03e3ae8bd353489e6e23))


### BREAKING CHANGES

* parseODIDMessage now returns ParseResult and throws!
                 Legacy applications should switch to tryParseODIDMessage
                 and use .message field

## [0.6.2](https://github.com/dronetag/dart-opendroneid/compare/v0.6.1...v0.6.2) (2025-03-24)


### Bug Fixes

* Fall back to unkown if speed accuracy is null ([4d230d3](https://github.com/dronetag/dart-opendroneid/commit/4d230d33aff37db302ae864497be0d4ec4021efb))

## [0.6.1](https://github.com/dronetag/dart-opendroneid/compare/v0.6.0...v0.6.1) (2025-03-21)


### Bug Fixes

* **ci:** Fix *artifact and checkout deprecated actions versions ([174e8a7](https://github.com/dronetag/dart-opendroneid/commit/174e8a7c38289c139d59b19055dabf6a19c6689e))
* Fix absolute timestamp conversion (DT-3811) ([#7](https://github.com/dronetag/dart-opendroneid/issues/7)) ([00540a0](https://github.com/dronetag/dart-opendroneid/commit/00540a0ee359ab7c8c330c3de7d14428f8e2c98a))
* Fix absolute timestamp implementation ([99784cf](https://github.com/dronetag/dart-opendroneid/commit/99784cf6cb612c667c99070e20e9bd69b14b59c2))

# [0.6.0](https://github.com/dronetag/dart-opendroneid/compare/v0.5.0...v0.6.0) (2024-12-17)


### Features

* add filterODIDMessageStream and validateODIDMessage methods ([61f8148](https://github.com/dronetag/dart-opendroneid/commit/61f8148caeefc7c7be4885d90bb292b15d49392a))
* add odid message validators ([febf1fc](https://github.com/dronetag/dart-opendroneid/commit/febf1fcb426dab55ca8eacb19530d9e6e40d7e80))
* add validators and method to filter out invalid msgs ([#6](https://github.com/dronetag/dart-opendroneid/issues/6)) ([4b79657](https://github.com/dronetag/dart-opendroneid/commit/4b7965725e4690d24d02dd1f154b5525dd1b053f))

# [0.5.0](https://github.com/dronetag/dart-opendroneid/compare/v0.4.2...v0.5.0) (2024-11-21)


### Bug Fixes

* Location timestamp encoding ([31c3e9c](https://github.com/dronetag/dart-opendroneid/commit/31c3e9ce101e0b4a137ab5443b79f6d579e77251))


### Features

* add tests for encoders ([96ca2e3](https://github.com/dronetag/dart-opendroneid/commit/96ca2e3c13ca73d0bcf3eb94277bc6a65a8e2b8b))
* added encoders ([f6fe3ae](https://github.com/dronetag/dart-opendroneid/commit/f6fe3aec10bc3c9db08b327d357e6bc69792184e))
* encoders from "dri_receiver" to "dart_opendroneid" ([#5](https://github.com/dronetag/dart-opendroneid/issues/5)) ([44dbd41](https://github.com/dronetag/dart-opendroneid/commit/44dbd4134a16243133659a78272ff89fe5717f71))
* enhance encoders tests with parsers integration and decoders ([41e4c3b](https://github.com/dronetag/dart-opendroneid/commit/41e4c3b99ac81126c83a3f7321b69ab1619d1b4f))
* Export encoders ([f30ff79](https://github.com/dronetag/dart-opendroneid/commit/f30ff79f75829641017a6d1a714b76369e3c1198))

## [0.4.2](https://github.com/dronetag/dart-opendroneid/compare/v0.4.1...v0.4.2) (2024-07-18)


### Bug Fixes

* Fix getAbsoluteTimestamp double-conversion to UTC ([5f10e2f](https://github.com/dronetag/dart-opendroneid/commit/5f10e2fead98bdaa830e62b86e9f1437907588a0))
* Fix getAbsoluteTimestamp double-conversion to UTC ([#4](https://github.com/dronetag/dart-opendroneid/issues/4)) ([c48f14e](https://github.com/dronetag/dart-opendroneid/commit/c48f14e3159366422e5129390e07b3bb9167014a))

## [0.4.1](https://github.com/dronetag/dart-opendroneid/compare/v0.4.0...v0.4.1) (2024-04-02)

# [0.4.0](https://github.com/dronetag/dart-opendroneid/compare/v0.3.0...v0.4.0) (2024-02-01)


### Features

* add tests for auth messages ([eab999b](https://github.com/dronetag/dart-opendroneid/commit/eab999b51b9e9fd4177ede15dd030486dff8ceb4))
* implement auth message parser and decoders ([3289574](https://github.com/dronetag/dart-opendroneid/commit/3289574021bfe2e191e6ebb02b9313654e390c7c))
* Implement support for Auth messages ([#3](https://github.com/dronetag/dart-opendroneid/issues/3)) ([0c5cc67](https://github.com/dronetag/dart-opendroneid/commit/0c5cc674416935b4ddc4b7b1cec7375ee5fb2e5a))

# [0.3.0](https://github.com/dronetag/dart-opendroneid/compare/v0.2.6...v0.3.0) (2023-10-01)


### Features

* Re-export all message data types ([6161f8e](https://github.com/dronetag/dart-opendroneid/commit/6161f8ef402248ef465f83daa1985a76732388aa))

## [0.2.6](https://github.com/dronetag/dart-opendroneid/compare/v0.2.5...v0.2.6) (2023-09-11)


### Bug Fixes

* **ci:** Stop using dart-lang/setup-dart as it's broken ([aa15219](https://github.com/dronetag/dart-opendroneid/commit/aa1521917ce9c80568766ac5999adc1df2ff0c45))

## [0.2.5](https://github.com/dronetag/dart-opendroneid/compare/v0.2.4...v0.2.5) (2023-09-11)


### Bug Fixes

* **ci:** Fix semantic release & pub.dev incompatibilities ([1dc2732](https://github.com/dronetag/dart-opendroneid/commit/1dc273254094c4b35fee819fc0832939a2e5668e))

## [0.2.4](https://github.com/dronetag/dart-opendroneid/compare/v0.2.3...v0.2.4) (2023-09-11)


### Bug Fixes

* **ci:** Add manual trigger for the subsequent publish ([fbb709a](https://github.com/dronetag/dart-opendroneid/commit/fbb709ac2d550c5f3b69c4898ebaab2220889d46))

## [0.2.3](https://github.com/dronetag/dart-opendroneid/compare/v0.2.2...v0.2.3) (2023-09-11)


### Bug Fixes

* **ci:** Fix .releaserc prepare step ([a50a8fc](https://github.com/dronetag/dart-opendroneid/commit/a50a8fcc18246e908b0f484bf3965bc1ac6d09fc))
* **ci:** Release commit should not skip CI ([e0332dd](https://github.com/dronetag/dart-opendroneid/commit/e0332ddcfcc002600ba99b767f310fb7e4b29324))

## [0.2.2](https://github.com/dronetag/dart-opendroneid/compare/v0.2.1...v0.2.2) (2023-09-10)


### Bug Fixes

* **ci:** Fix publish token permissions ([82726f9](https://github.com/dronetag/dart-opendroneid/commit/82726f9e45e87f50c3b00fa1be8114cfdb486af5))

## [0.2.1](https://github.com/dronetag/dart-opendroneid/compare/v0.2.0...v0.2.1) (2023-09-10)

# [0.2.0](https://github.com/dronetag/dart-opendroneid/compare/v0.1.0...v0.2.0) (2023-09-10)


### Bug Fixes

* **ci:** Avoid using Flutter installers and use clean Dart setup ([a3f1af1](https://github.com/dronetag/dart-opendroneid/commit/a3f1af19469d0287cfe537a5695f6e07a2eb0f75))
* **ci:** Change the repository target for libopendroneid build ([d93d7b4](https://github.com/dronetag/dart-opendroneid/commit/d93d7b450caad14c0188c0af88379e2aeb69a8aa))
* **ci:** ffigen must be run for both analysis & tests ([a44d86b](https://github.com/dronetag/dart-opendroneid/commit/a44d86b50d2788493938b0c31bcb4e6f7e5cb9ce))
* **ci:** Remove --no-fatal-infos from dart analyze ([4d621d1](https://github.com/dronetag/dart-opendroneid/commit/4d621d15c3e148a99352fd37add62be710f2a953))
* edit message pack offset ([97154ef](https://github.com/dronetag/dart-opendroneid/commit/97154ef6fde0a39090963c39b6c83cd01e66d5dd))
* Exclude opendroneid_core_library test folder from linting ([6b9155f](https://github.com/dronetag/dart-opendroneid/commit/6b9155f9fee603b5383c85c376389aecb36412af))
* Fix message length check of MessagePack objects ([#1](https://github.com/dronetag/dart-opendroneid/issues/1)) ([5460fae](https://github.com/dronetag/dart-opendroneid/commit/5460fae4abc04784f536cab64b3084193cb1bd82))


### Features

* **ci:** Build libopendroneid for tests ([1035062](https://github.com/dronetag/dart-opendroneid/commit/1035062584de9b64ce7786bc76180199cccb50c3))

## 0.1.0

- Initial published version
