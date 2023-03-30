# Ross 🧼

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
swift run ross <directory>
```

```
ARGUMENTS:
  <directory>             The folder whose contents you want to remove comments from

OPTIONS:
  -h, --help              Show help information.
```

It is recommended to pair this with [swift-format](https://github.com/apple/swift-format), specifically the `"maximumBlankLines"` rule, in order to deal with any extraneous newlines that may remain after comments are removed.

## Why Ross?

Charles Ross, President Harry Truman's White House press secretary, was responsible for the first recorded usage of ["no comment"](https://en.wikipedia.org/wiki/No_comment) as a stock answer to a question.
