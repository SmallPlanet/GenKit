import Yaml
import Foundation

public struct CodeGen {

    public static func loadYAML(fromFile file: String) -> Yaml? {
        do {
            let yamlString = try String(contentsOf: URL(fileURLWithPath: file), encoding: .utf8)
            return try Yaml.load(yamlString)
        } catch {
            print(error)
            return nil
        }
    }

}
