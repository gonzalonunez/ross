# Ross 🧼

![](https://github.com/gonzalonunez/ross/actions/workflows/build.yml/badge.svg)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalonunez%2Fross%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/gonzalonunez/ross)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalonunez%2Fross%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/gonzalonunez/ross)

Ross is a Swift command-line tool to remove all comments from Swift code.

```diff
-/**
-Registers a handler in an `Application` for a given path.
-
-- Parameters:
-  - app: The `Application` to register the handler in.
-  - path: The path to register the handler for.
-*/
public func register(in app: Application, for path: String) {
  app.on(method, path.pathComponents) { [handle] req async throws in
    try await handle(req)
  }
}
```

## Basic usage

```
swift run ross <directory> [--remove-plain <remove-plain>]
```

```
ARGUMENTS:
  <directory>             The folder whose contents you want to remove comments from.

OPTIONS:
  --remove-plain <remove-plain>
                          Whether or not Ross should remove plain comments. (default: true)
  -h, --help              Show help information.
```

It is recommended to pair this with [swift-format](https://github.com/apple/swift-format), specifically the `"maximumBlankLines"` rule, in order to deal with any extraneous newlines that may remain after comments are removed.

## Why Ross?

Charles Ross, President Harry Truman's White House press secretary, was responsible for the first recorded usage of ["no comment"](https://en.wikipedia.org/wiki/No_comment) as a stock answer to a question.
