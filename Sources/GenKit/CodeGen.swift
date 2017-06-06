import Foundation
import Mustache
import Stencil
import Yaml

public struct GenKit {

    public enum Template {
        case mustache
        case stencil
    }

    public static func loadYAML(fromFile file: String) throws -> Any {
        let yamlString = try String(contentsOf: URL(fileURLWithPath: file), encoding: .utf8)
        let yaml = try Yaml.load(yamlString)
        return yaml.toAny()
    }

    public static func generate(
        _ input: [String: Any],
        templateFile file: String,
        template: Template = .mustache
    ) throws -> String {
        var dataDictionary = input

        // add a dictionary with meta information only if the key does not already exist
        if !dataDictionary.contains(where: { $0.0 == "GenKit" }) {
            let meta: [String:Any] = [
                "datetime": Date().description,
                "templatePath": file
            ]
            dataDictionary["GenKit"] = meta
        }

        let rendered: String
        let templateContent = try String(contentsOfFile: file, encoding: String.Encoding.utf8)

        switch template {
        case .mustache(_):
            let template = try Mustache.Template(string: templateContent)
            rendered = try template.render(with: Box(input))
        case .stencil(_):
            rendered = try Environment().renderTemplate(string: templateContent, context: input)
        }

        return rendered
    }

}
