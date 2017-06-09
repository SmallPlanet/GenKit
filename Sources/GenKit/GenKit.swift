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
        template: Template = .mustache,
        metaDictionary meta: [String: Any] = [:]
    ) throws -> String {
        let templateContent = try String(contentsOfFile: file, encoding: String.Encoding.utf8)
        var meta = meta
        meta["templatePath"] = file
        return try generate(input,
                            templateString: templateContent,
                            template: template,
                            metaDictionary: meta)
    }
    
    public static func generate(
        _ input: [String: Any],
        templateString templateContent: String,
        template: Template = .mustache,
        metaDictionary meta: [String: Any] = [:]
    ) throws -> String {
        var input = input
        var meta = meta
        
        // add a dictionary with meta information only if the key does not already exist
        if !input.contains(where: { $0.0 == "GenKit" }) {
            meta["datetime"] = Date().description
            input["GenKit"] = meta
        }
        
        let rendered: String
        
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
