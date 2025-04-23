# XCallbackURL

A Swift package for handling x-callback-url protocol in iOS, macOS, tvOS, watchOS, and visionOS applications.

## Overview

XCallbackURL is a Swift package that provides a simple and type-safe way to work with the [x-callback-url protocol](https://x-callback-url.com/specification/). This protocol standardizes the use of URLs and registered URL schemes for inter-app communication on Apple's platforms.

The x-callback-url protocol allows apps to:
- Launch other apps with specific actions
- Pass data and context information
- Receive callbacks for success, error, or cancellation
- Return control back to the source app

## Requirements

- iOS 16.0+
- macOS 13.0+
- tvOS 16.0+
- watchOS 9.0+
- visionOS 1.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/kradenkov/XCallbackURL.git", from: "1.0.0")
]
```

## Usage

### URL Structure

The x-callback-url protocol follows this structure:
```
[scheme]://x-callback-url/[action]?[x-callback parameters]&[action parameters]
```

### Creating x-callback-url URLs

```swift
import XCallbackURL

// Create a callback configuration
let callbacks = try CallbacksConfiguration(
    source: "MyApp", // The friendly name of the source app
    onSuccess: Callback(url: URL(string: "myapp://success")!), // URL to return to on success
    onError: Callback(url: URL(string: "myapp://error")!), // URL to return to on error
    onCancel: Callback(url: URL(string: "myapp://cancel")!) // URL to return to on cancel
)

// Create an x-callback-url
let url = try URL.xCallbackURL(
    scheme: "otherapp", // The target app's URL scheme
    action: "doSomething", // The action to perform
    callbacks: callbacks,
    parameters: [
        URLQueryItem(name: "param1", value: "value1"),
        URLQueryItem(name: "param2", value: "value2")
    ]
)
```

### Handling x-callback-url URLs

To handle incoming x-callback-url URLs in your app:

1. Register your URL scheme in your app's Info.plist
2. Implement URL handling in your app delegate or scene delegate

```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    
    // Check if it's an x-callback-url
    if url.host == URL.Reserved.host {
        // Handle the callback
        // You can access:
        // - Source app name from x-source parameter
        // - Success callback URL from x-success parameter
        // - Error callback URL from x-error parameter
        // - Cancel callback URL from x-cancel parameter
        // - Action-specific parameters from other query items
    }
}
```

## Features

- Type-safe URL creation following the x-callback-url specification
- Support for all standard x-callback parameters (x-source, x-success, x-error, x-cancel)
- Validation of URL schemes and parameters
- Support for custom action parameters
- Comprehensive error handling
- Cross-platform support (iOS, macOS, tvOS, watchOS, visionOS)

## License

This project is licensed under the terms of the license included in the repository.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## References

- [x-callback-url Specification](https://x-callback-url.com/specification/)
- [x-callback-url Examples](https://x-callback-url.com/examples/)
