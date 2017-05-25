//
// genstrings
//
// Converts a YAML input file through a Stencil template to make shiny happy strings
//

//    Usage: genstrings [options]
//    -i, --input:
//        Input yaml file
//    -t, --template:
//        Stencil template file
//    -o, --output:
//        Output file
//    -c, --compare:
//        Files to compare modification dates against (multiple values separated by space)

import CommandLineKit
import FileKit
import Foundation
import Mustache
import Yaml


let cli = CommandLine()
let inputPath = StringOption(shortFlag: "i", longFlag: "input", required: true,
                             helpMessage: "Input yaml file")
let templatePath = StringOption(shortFlag: "t", longFlag: "template", required: true,
                             helpMessage: "Stencil template file")
let outputPath = StringOption(shortFlag: "o", longFlag: "output", required: true,
                             helpMessage: "Output file")
let comparePaths = MultiStringOption(shortFlag: "c", longFlag: "compare", required: false,
                             helpMessage: "Files to compare modification dates against (multiple values separated by space)")

cli.setOptions(inputPath, templatePath, outputPath, comparePaths)

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

guard let outputFile = outputPath.value else {
  print("Error understanding output file path")
  exit(EX_USAGE)
}

guard let yaml = CodeGen.loadYAML(fromFile: inputFile)  else {
  print("Error reading input YAML file")
  exit(EX_DATAERR)
}


let input = Path(inputFile)
let output = Path(outputFile)
let template = Path(templateFile)


// check if any of the optional compare files are newer than output file, if so, force the template generation

let compareFilesNewer = comparePaths.value?.map{ Path($0) }
                                           .map{ $0.modified(since: output) }
                                           .reduce(false) { $0 || $1 }

let inputNewer = input.modified(since: output)
let templateNewer = template.modified(since: output)

// Run through the template rendering if any
// of the following conditions are met:
//      1. Source file is newer than the output files  OR
//      2. Template file is newer than output file     OR
//      3. Optional compare files are newer than output file OR
//      4. Output file doesn't exist.

if !output.exists || inputNewer || templateNewer || compareFilesNewer ?? false {


  // Convert YAML data into standard Swift types Array/Dictionary/String/...
  guard let dataDictionary = yaml.convert() as? [String: Any] else {
    print("Error: top level container of YAML file must be a dictionary.")
    exit(EX_DATAERR)
  }

  do {
    // Read Template file into strings
    let templateContent = try String(contentsOfFile: templateFile, encoding: String.Encoding.utf8)
    let template = try Template(string: templateContent)
    let rendered = try template.render(with: Box(dataDictionary))
    print("\(output.exists ? "Regenerating" : "Creating") output file: \(output.fileName)")
    try TextFile(path: output).write(rendered, atomically: true)
  } catch let error as MustacheError {
    print(error.description)
    exit(EX_DATAERR)
  }

} else {
  print("Skipping \(output.fileName)")
}

exit(EX_OK)
