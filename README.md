![ios](https://img.shields.io/badge/iOS-13-green)
![tv](https://img.shields.io/badge/tvOS-13-green)
![watch](https://img.shields.io/badge/watchOS-6-green)
![mac](https://img.shields.io/badge/macOS-10.15-green)

# ActivityView

A SwiftUI view for presenting a `UIActivityViewController` correctly across all platforms.

## Example

```swift
struct ShareView: View {
    @State private var isPresented = false

    var body: some View {
        return Button("Share") { isPresented = true }
            .activity(
                isPresented: $isPresented,
                items: ["text"]
            )
    }
}
```

## Features

- Familiar API – Similar to alert, sheet, etc...
- Supports all platforms
- Nested activity controllers
- Popover on iPad, modal everywhere else

## Installation

The library is provided as an open-source Swift package. So simply add the dependency to your package list:

`https://github.com/shaps80/ActivityView.git`

