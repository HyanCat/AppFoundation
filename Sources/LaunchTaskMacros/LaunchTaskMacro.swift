import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LaunchTaskMacros: ConformanceMacro {
    public static func expansion(of node: AttributeSyntax, providingConformancesOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        return [ ("LaunchTask", nil) ]
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
