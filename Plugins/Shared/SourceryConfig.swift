import Foundation
import PackagePlugin

struct SourceryConfig: Codable {
	let sources: [String]
	let templates: [String]
	let forceParse: [String]
	let arguments: [SourceryArgument]
	var output: String?

	// MARK: - Init

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.sources = try container.decodeIfPresent([String].self, forKey: .sources) ?? []
		self.templates = try container.decodeIfPresent([String].self, forKey: .templates) ?? []
		self.forceParse = try container.decodeIfPresent([String].self, forKey: .forceParse) ?? []
		self.arguments = try container.decodeIfPresent([SourceryArgument].self, forKey: .arguments) ?? []
		self.output = try container.decodeIfPresent(String.self, forKey: .output)
	}

	init(path: Path) throws {
		guard let data = NSData(contentsOfFile: path.string) else { throw URLError(.badURL) }
		self = try JSONDecoder().decode(Self.self, from: data as Data)
	}

	// MARK: - Methods

	func makeBuildToolPluginArguments(configDirectory path: Path) throws -> [String] {
		let output = try makeOutputPath()
		var ressult = [Consts.output, output]
		ressult.append(contentsOf: try makeCommonArguments(configDirectory: path))
		ressult.append(Consts.disableCache)
		return ressult
	}

	func makeCommandPluginArguments(configDirectory path: Path) throws -> [String] {
		let output = try makeOutputPath()
		var ressult = [Consts.output, path.appending(output).string]
		ressult.append(Consts.disableCache)
		ressult.append(contentsOf: try makeCommonArguments(configDirectory: path))
		return ressult
	}

	// MARK: - Private methods

	private func makeCommonArguments(configDirectory path: Path) throws -> [String] {
		guard sources.isNotEmpty else { throw "[‼️] sources parameter is missing in \(Constants.configName)" }
		guard templates.isNotEmpty else { throw "[‼️] templates parameter is missing in \(Constants.configName)" }

		var result = [String]()

		sources.forEach {
			result.append(Consts.sources)
			result.append(path.appending($0).string)
		}
		templates.forEach {
			result.append(Consts.templates)
			result.append(path.appending($0).string)
		}
		forceParse.forEach {
			result.append(Consts.forceParse)
			result.append(path.appending($0).string)
		}

		if arguments.isNotEmpty {
			result.append(Consts.args)
			let args = arguments.map { "\($0.key)=\($0.value)" }.joined(separator: ",")
			result.append(args)
		}

		return result
	}

	private func makeOutputPath() throws -> String {
		guard let output else { throw "[‼️] output parameter is missing in \(Constants.configName)" }
		return output
	}

	// MARK: - Constants

	private enum Consts {
		static let sources = "--sources"
		static let templates = "--templates"
		static let forceParse = "--force-parse"
		static let output = "--output"
		static let args = "--args"
		static let disableCache = "--disableCache"
	}
}

struct SourceryArgument: Codable {
	let key: String
	let value: String
}
