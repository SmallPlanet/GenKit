GenKit is a framework that can be used to generate textual output from a Dictionary or YAML file using a templating engine and `gen` is a command line executable that leverages GenKit. The motivation for GenKit and gen is to automate code generation in cross-platform projects to ensure parity and type safety.

GenKit implements both Mustache and Stencil template engines.

## Building

GenKit is written in Swift 3.1 using Swift Package Manager. To build `gen` and GenKit, clone the repository and cd into the repo's top directory in a terminal window. Typing `swift build` in that directory will fetch all dependencies, build GenKit, it's dependencies, and `gen` in the directory `.build/debug`

## Usage

The `gen` command run without arguments will display the available arguments. To see this type

```asciidoc
.build/debug/gen
```

To generate a Swift enum from the sample input `dinos.yaml` using the Mustache template `dinos.swift.mustache` type:

```asciidoc
.build/debug/gen -i Samples/inputs/dinos.yaml -t Samples/templates/dinos.swift.mustache
```

The previous example usage prints the output to stdout. To output to a file, add the `-o output/file/path` argument.

To use a Stencil template instead of the default Mustache, add the `-s` argument.

## License

GenKit is free software distributed under the terms of the MIT license, reproduced below. GenKit may be used for any purpose, including commercial purposes, at absolutely no cost. No paperwork, no royalties, no GNU-like "copyleft" restrictions. Just download and enjoy.

Copyright (c) 2017 [Small Planet Digital, LLC](http://smallplanet.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
