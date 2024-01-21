import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LaunchTaskMacros: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let launchTaskExtension = try ExtensionDeclSyntax("extension \(type.trimmed): LaunchTask {}")
        return [launchTaskExtension]
    }
}

extension LaunchTaskMacros: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let status: DeclSyntax =
                    """
                    var status: LaunchTaskStatus = .none
                    """
        let autoload: DeclSyntax =
                    """
                    func autoload() {
                        LaunchTaskManager.shared.register(task: self)
                    }
                    """
        return [status, autoload]
    }
}

@main
struct LaunchTaskPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LaunchTaskMacros.self,
    ]
}
