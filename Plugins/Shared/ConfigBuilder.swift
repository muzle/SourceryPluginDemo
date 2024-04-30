import Foundation
import PackagePlugin

final class ConfigBuilder {
	// MARK: - Methods

	func set(context: PluginContext) {
		self.context = context
	}

	func set(target: Target) {
		self.target = target
	}

	func buildArgumentsForBuildToolPlugin() throws -> [String] {
		let dirPath = try buildConfigDirPath()
		let configPath = dirPath.appending(Constants.configName)
		let outputPath = try makeOutputFilePath()
		var config = try SourceryConfig(path: configPath)
		config.output = outputPath.string
		return try config.makeBuildToolPluginArguments(configDirectory: dirPath)
	}

	func buildArgumentsForSourceryCommandPlugin() throws -> [String] {
		let dirPath = try buildConfigDirPath()
		let configPath = dirPath.appending(Constants.configName)
		let config = try SourceryConfig(path: configPath)
		return try config.makeCommandPluginArguments(configDirectory: dirPath)
	}

	// MARK: - Private properties

	private var context: PluginContext?
	private var target: Target?

	// MARK: - Private methods

	private func buildConfigDirPath() throws -> Path {
		let fileManager = FileManager.default
		if let target, fileManager.fileExists(atPath: target.directory.appending(Constants.configName).string) {
			return target.directory
		}
		if let context, fileManager.fileExists(atPath: context.package.directory.appending(Constants.configName).string) {
			return context.package.directory
		}
		throw "[‼️] No \(Constants.configName) found"
	}

	private func makeOutputFilePath() throws -> Path {
		guard let context else { throw "[‼️] No PluginContext found" }
		return context.pluginWorkDirectory.appending([/*Constants.outputDirName, */Constants.outputFileName])
	}
}
