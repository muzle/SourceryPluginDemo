import PackagePlugin
import Foundation

@main
struct SourceryCommandPlugin: CommandPlugin {
	func performCommand(context: PluginContext, arguments: [String]) async throws {
		let targetsNames = findTargets(in: arguments)
		let tool = try context.tool(named: Constants.toolName)
		let targets = try context.package.targets(named: targetsNames)

		for target in targets {
			let builder = ConfigBuilder()
			builder.set(context: context)
			builder.set(target: target)
			let configArguments = (try? builder.buildArgumentsForSourceryCommandPlugin()) ?? []
			let arguments = configArguments + findNoTargets(in: arguments)
			try tool.run(arguments: arguments)
		}
	}

	private func findTargets(in arguments: [String]) -> [String] {
		var targets = [String]()
		var it = 0

		while it < arguments.count {
			defer { it += 1 }
			if arguments[it] == Consts.target {
				it += 1
				targets.append(arguments[it])
			}
		}

		return targets
	}

	private func findNoTargets(in arguments: [String]) -> [String] {
		var args = [String]()
		var it = 0

		while it < arguments.count {
			defer { it += 1 }
			if arguments[it] != Consts.target {
				args.append(arguments[it])
			} else {
				it += 1
			}
		}

		return args
	}

	enum Consts {
		static let target = "--target"
	}
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SourceryCommandPlugin: XcodeCommandPlugin {
	func performCommand(context: XcodePluginContext, arguments: [String]) throws {
		let apolloPath = "\(context.pluginWorkDirectory)/../../checkouts/apollo-ios"
		let process = Process()
		let path = try context.tool(named: "sh").path
		process.executableURL = URL(fileURLWithPath: path.string)
		process.arguments = ["\(apolloPath)/scripts/download-cli.sh", context.xcodeProject.directory.string]
		try process.run()
		process.waitUntilExit()
	}
}
#endif

private extension PluginContext.Tool {
	func run(arguments: [String]) throws {
		let task = Process()
		task.executableURL = URL(fileURLWithPath: path.string)
		task.arguments = arguments

		try task.run()
		task.waitUntilExit()

		// Check whether the subprocess invocation was successful.
		if task.terminationReason == .exit && task.terminationStatus == 0 {
			// do something?
		} else {
			let problem = "\(task.terminationReason):\(task.terminationStatus)"
			Diagnostics.error("\(name) invocation failed: \(problem)")
		}
	}
}
