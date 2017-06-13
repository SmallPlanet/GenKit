<span style="font-size:2.0em">GenKit</span>
<br />
<span style="font-size:0.6em; color:gray">YAML -> Code</span> |
<span style="font-size:0.6em; color:gray">See <a href="https://github.com/SmallPlanetSwift/GenKit/" target="_blank">GenKit</a> on GitHub for details.</span>

---

<span style="font-size:2.0em">Why GenKit?</span>
<br />
<span style="color:#29B8EB">Safe</span> |
<span style="color:#29B8EB">Lazy</span>

We don't usually get to be lazy _and_ safe

+++

## Safe

* Define data in easily maintainable YAML files
* Single source of constants
* Parity between platforms
* Allow non-developers to make changes without touching code

+++

## Lazy

* Templates transform data into whatever
* Automate repetetive code generation
* Generate non-code -- wiki documentation, for example
* Finally replace someone with a tiny shell script

---

<span style="font-size:2.0em">Using GenKit</span>
<br />
Build | Run

+++

## Build

* Written in Swift 3.1
* Built with Swift Package Manager

</br>

```bash
swift build
```

+++

## Run

```asciidoc
> .build/debug/gen

Usage: .build/debug/gen [options]
  -i, --input:
      Input yaml file
  -t, --template:
      Stencil template file
  -s, --stencil:
      Use Stencil instead of Mustache template
  -o, --output:
      Output file (writes to stdout if not provided)
  -c, --compare:
      Files to compare modification dates against (multiple values separated by space)
      -q, --quiet:
          Suppress non-error output
```

<span style="font-size:0.8em; color:gray">Without options, gen prints usage</span>

+++

## Run

```asciidoc
gen -i input.yaml -t template.mustache
```

<span style="font-size:0.8em; color:gray">Processes data in **input.yaml** using the Mustache template **template.mustache**, sends output to stdout.</span>

+++

## Run

```asciidoc
gen -i input.yaml -t template.stencil -s
```

<span style="font-size:0.8em; color:gray">Considers **template.stencil** a Stencil template because of -s option.</span>

+++

## Run

```asciidoc
gen -i input.yaml -t template.stencil -s -o out.txt
```

<span style="font-size:0.8em; color:gray">Writes data to file out.txt instead of stdout.</span>

---

<span style="font-size:2.0em">Newness Checks</span>
<br />

* `gen` checks files to avoid uneccesary work
* Generates if at least one of these conditions is met:

  * output file does not exist
  * input newer than output
  * template newer than output

+++

## Compare Files

* Optional command line argument -c or --compare
* Accepts multiple files (space separated)
* Generates if any compare file is newer than output

+++

## Run

```asciidoc
gen -i input.yaml -t template.stencil -s -o out.txt \
    -c compare1.txt,compare2.txt
```

<span style="font-size:0.8em; color:gray">Does not generate out.txt if it is newer than compare1.txt and compare2.txt in addition to template.stencil and input.yaml.</span>

---

<span style="font-size:2.0em">Data</span>
<br />

* Stored in YAML format
* Top-level must be a dictionary
* Otherwise anything goes

+++

## Sample

```yaml
name: AnalyticsKeys
package: com.smallplanet.android.project.analytics
groups:

# Core Events

  - name: Screens
    strings:
      - var: day
        string: Day
      - var: calendar
        string: Calendar
      - var: settings
        string: Settings
      - var: resource
        string: Resource
```

+++
<span style="font-size:2.0em">YAML Benefits</span>
<br />

* Functionally equivalent to JSON
* Easier to read/write
* Comment: can add comments

---

<span style="font-size:2.0em">Template Choice</span>
<br />

<a href="https://github.com/IBM-Swift/GRMustache.swift" target="_blank">Mustache</a> |
<a href="https://github.com/kylef/Stencil" target="_blank">Stencil</a>

+++

## Mustache

* Default template engine
* Closely follows <a href="http://mustache.github.io" target="_blank">Mustache</a> standard
* Uses IBM's actively developed fork
* <a href="https://github.com/IBM-Swift/GRMustache.swift" target="_blank">github.com/IBM-Swift/GRMustache.swift</a>

+++

## Stencil

* Optional system accessed with -s or --stencil option
* <a href="https://github.com/kylef/Stencil.git" target="_blank">github.com/kylef/Stencil</a>

---

<span style="font-size:2.0em">GenKit Integration</span>

<math displaystyle="true">
  <munderover >
    <mo> &#x222B; <!--INTEGRAL--> </mo>
    <mn> 0 </mn>
    <mi> &nbsp;&nbsp;&nbsp;&#x1F355; <!--INFINITY--> </mi>
  </munderover>

  <mrow>
    <mo>(</mo>
    <mi>GenKit</mi>
    <mo>)</mo>
    <msub>
      <mi>dx</mi>
    	<mi>code</mi>
    </msub>
  </mrow>
</math>

+++

## Xcode Integration

* Xcode build phase script
* Automatically runs when target is built
* Builds `GenKit` and `gen`
* Uses `gen` to generate what you need

+++

## Sample integration

```bash
cd "$PROJECT_DIR/GenKit"
# build if needed
env -i swift build

PLIST_FILE="$PROJECT_DIR/things.yaml"
OUTPUT_FILE="$PROJECT_DIR/$PROJECT_NAME/Things.swift"
TEMPLATE_FILE="$PROJECT_DIR/enums.swift.mustache"

.build/debug/gen -i "${PLIST_FILE}" -o "${OUTPUT_FILE}" \
     -t "{$TEMPLATE_FILE}"
```

---

<span style="font-size:2.0em">GenKit Customization</span>
<br/>

* `gen` tool built with `GenKit` library
* `GenKit` library separate from `gen` tool
* Can use `GenKit` as a Package
* Build custom tools

+++

## Custom Tools

* `gen` sufficient in cases with simple YAML
* Custom tools help when data needs massaging
* See <a href="https://github.com/qmchenry/Lion" target="_blank">Lion</a> 🦁 for example
  * Generates typesafe structs from `Localizable.strings`

---

<span style="font-size:2.0em">Assembled with</span>
<br />

* <a href="https://github.com/jatoben/CommandLine" target="_blank">github.com/jatoben/CommandLine</a>
* <a href="https://github.com/behrang/YamlSwift" target="_blank">github.com/behrang/YamlSwift</a>
* <a href="https://github.com/IBM-Swift/GRMustache.swift" target="_blank">github.com/IBM-Swift/GRMustache.swift</a>
* <a href="https://github.com/kylef/Stencil" target="_blank">github.com/kylef/Stencil</a>
* <a href="https://github.com/nvzqz/FileKit" target="_blank">github.com/nvzqz/FileKit</a>
* <a href="https://github.com/apple/swift" target="_blank">github.com/apple/swift</a>

---

<span style="font-size:1.6em">Built with ❤️ & 🍕 in Brooklyn</span>
<br />

<br/>

<span style="font-size:1.6em">by <a href="https://smallplanet.com/" target="_blank">Small Planet</a></span>