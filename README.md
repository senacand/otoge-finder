# Otoge Finder - Music Game Locator for iOS
Easily find arcades with your favorite music game around you.

## Development
Core tech stacks:
- [SwiftUI](https://developer.apple.com/xcode/swiftui/), Apple's declarative UI library
  - Note that this app requires **iOS 17** as it uses the updated MapKit Framework
- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [SwiftPM](https://www.swift.org/documentation/package-manager/) for package management


Otoge Finder stores list of games for ALL.Net and e-amusement locally, powered by [Otoge.app](https://github.com/djzmo/otoge-app) fetch script. However, this project also contains an option to directly communicate with Otoge.app server by replacing the dependency value in `Dependencies.swift`.


Replace this:
```swift
private enum AppArcadeRepository: DependencyKey {
    static let liveValue: ArcadeRepositoryProtocol = LocalArcadeRepository()
}
```

with this:
```swift
private enum AppArcadeRepository: DependencyKey {
    static let liveValue: ArcadeRepositoryProtocol = OtogeAppArcadeRepository()
}
```


