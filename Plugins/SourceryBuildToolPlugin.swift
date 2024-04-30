import PackagePlugin

@main
struct SourceryBuildToolPlugin: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
		let builder = ConfigBuilder()
		builder.set(target: target)
		builder.set(context: context)
		let arguments = try builder.buildArgumentsForBuildToolPlugin()
		let executablePath = try context.tool(named: Constants.toolName).path
		return [
			.prebuildCommand(
				displayName: Constants.buildToolPluginDisplayName,
				executable: executablePath,
				arguments: arguments,
				environment: [:],
				outputFilesDirectory: context.pluginWorkDirectory
			)
		]
    }
}
