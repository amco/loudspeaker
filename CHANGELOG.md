# Changelog

### 1.0.0

This release contains breaking changes so read the changes carefully to see how you may be effected.

##### Added

* 3x assets
* Added iPhone X/safe area layout support
* Added icons and loading screen to example project
* Added configuration
  * Allows configuration of volume, interval to update progress bar and elapsed string, and accuracy for taps on progress to jump playback
  * All `LSPAudioViewController` instances must be initialized with a `LSPConfiguration` instance
  * A default configuration is available from `deafultConfiguration` in `LSPConfigurationBuilder` or you can build your own
  * Player frame is now determined by `LSPAudioViewController`'s frame
* Added `show` and `hide:` to `LSPAudioViewController` to toggle the default presentation animations
* Added accessibility to interactive elements
  * Accessibility elements are localized to English, localization strings available to be overridden by other languages
* Added scrubbing gesture to progress bar
* Added `jumpToProgress:` in `LSPAudioViewController` to move playback to an exact progress point
* Added `setVolume:` in `LSPAudioPlayer` to set player volume during playback
* More tests

##### Removed

* Removed iOS 8 support
* Removed static `sharedInstance` and `player` references from `LSPAudioPlayer`
* Removed `bottomConstraint`, `observationInterval`, `seekTolerance`, `title`, and `URL` properties from `LSPAudioViewController`
  * These were moved into configurations or completely removed as they were unnecessary

##### Changed

* Changed `audioViewController:didClosePlayer:` to be called after close animation is finished
* `LSPAudioViewController` no longer overrides `view`; instead, the player UI is located in `playerView`

##### Fixed

* Fixed timestamp not updating when playback paused but timeline tapped to change position
* Fixed timestamp displaying inaccurate times when starting or stopping playback

### 0.2.0

* Dropped iOS 7 support
* Updated Masonry to 1.1
