//
// genstrings
//
// Converts a YAML input file through a Stencil template to make shiny happy strings
//

import GenKit
import CommandLineKit
import FileKit
import Foundation


let inputPath = StringOption(shortFlag: "i", longFlag: "input", required: true, helpMessage: "Input yaml file")
let templatePath = StringOption(shortFlag: "t", longFlag: "template", required: true, helpMessage: "Stencil template file")
let stencilOption = BoolOption(shortFlag: "s", longFlag: "stencil", helpMessage: "Use Stencil instead of Mustache template")
let outputPath = StringOption(shortFlag: "o", longFlag: "output", helpMessage: "Output file (writes to stdout if not provided)")
let comparePaths = MultiStringOption(shortFlag: "c", longFlag: "compare", helpMessage: "Files to compare modification dates against (multiple values separated by space)")
let quietOption = BoolOption(shortFlag: "q", longFlag: "quiet", helpMessage: "Suppress non-error output")

let cli = CommandLine()
cli.setOptions(inputPath, templatePath, stencilOption, outputPath, comparePaths, quietOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

guard let inputFile = inputPath.value else {
    print("Error understanding input file path")
    exit(EX_USAGE)
}

guard let templateFile = templatePath.value else {
    print("Error understanding template file path")
    exit(EX_USAGE)
}


let input = Path(inputFile)
let output = outputPath.value.map{ Path($0) }
let template = Path(templateFile)
let useStencil = stencilOption.wasSet
let quiet = quietOption.wasSet


var performOperation: Bool {
    guard let output = output else { return true }

    // check if any of the optional compare files are newer than output file, if so, force the template generation

    let compareFilesNewer = comparePaths.value?.map{ Path($0) }
                                               .map{ $0.modified(since: output) }
                                               .reduce(false) { $0 || $1 } ?? false

    let inputNewer = input.modified(since: output)
    let templateNewer = template.modified(since: output)

    // Run through the template rendering if any
    // of the following conditions are met:
    //      1. Source file is newer than the output files  OR
    //      2. Template file is newer than output file     OR
    //      3. Optional compare files are newer than output file OR
    //      4. Output file doesn't exist.
    return inputNewer || templateNewer || compareFilesNewer || !output.exists
}

if output == nil || performOperation {

    do {
        guard let inputDictionary = try GenKit.loadYAML(fromFile: inputFile) as? [String: Any] else {
            print("Error reading input YAML file. Top level container of YAML file must be a dictionary.")
            exit(EX_DATAERR)
        }

        let rendered = try GenKit.generate(inputDictionary, templateFile: templateFile, template: useStencil ? .stencil : .mustache)

        if let output = output {
            if !quiet {
                print("\(output.exists ? "Regenerating" : "Creating") output file: \(output.fileName)")
            }
            try TextFile(path: output).write(rendered, atomically: true)
        } else {
            print(rendered)
        }
    } catch let error {
        print(error)
        exit(EX_DATAERR)
    }

} else if !quiet {
    print("Skipping \(output?.fileName ?? input.fileName)")
}

exit(EX_OK)
