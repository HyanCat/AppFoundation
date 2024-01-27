// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     @Launch
///     class ValidateTask {
///         func onLaunch(options: [LaunchOptionsKey : Any]?) async -> Bool {
///             return await doSomething()
///         }
///     }
///
@attached(extension, conformances: LaunchTask)
@attached(member, names: named(status), named(autoload()))
public macro Launch() = #externalMacro(module: "LaunchTaskMacros", type: "LaunchTaskMacros")
