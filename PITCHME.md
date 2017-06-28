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
* Automate repetitive code generation
* Generate non-code -- wiki documentation, for example
* Finally replace someone with a tiny shell script

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
package: com.smallplanet.android.genkit.test
groups:
## Core Events
  - name: ApplicationForegrounded
    strings:
      - var: eventName
        string: Application Foregrounded
      - var: dynamicTextSize
        string: dynamicTextSize
      - var: source
        string: source
      - var: voiceOverEnabled
        string: voiceOverEnabled

  - name: ApplicationBackgrounded
    strings:
      - var: eventName
        string: Application Backgrounded
```

+++

<span style="font-size:2.0em">YAML Benefits</span>
<br />

* Functionally equivalent to JSON
* Easier to read/write/debug
* Comment: can add comments

+++

<span style="font-size:2.0em">GenKit Meta Dictionary</span>
<br />

* Adds dictionary with key "GenKit" unless it exists
* Useful for header comments in code
* Contains:
  * `datetime`
  * `templatePath`

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
      Files to compare modification dates against (multiple values separated by comma)
  -q, --quiet:
      Suppress non-error output
```

<span style="font-size:0.8em; color:gray">Without options, `gen` prints usage</span>

+++

## Run

```asciidoc
gen -i input.yaml -t template.mustache
```

<span style="font-size:0.8em; color:gray">Processes data in `input.yaml` using the Mustache template `template.mustache`, sends output to stdout.</span>

+++

## Run

```asciidoc
gen -i input.yaml -t template.mustache -o out.txt
```

<span style="font-size:0.8em; color:gray">Writes data to file `out.txt` instead of stdout.</span>

+++

## Run

```asciidoc
gen -i input.yaml -t template.stencil -s
```

<span style="font-size:0.8em; color:gray">`-s` option treats `template.stencil` a Stencil template.</span>

---

<span style="font-size:2.0em">Newness Checks</span>
<br />

* `gen` checks files to avoid unnecessary work
* Generates if at least one of these conditions is met:

  * output file does not exist
  * input newer than output
  * template newer than output

+++

## Compare Files

* Optional command line argument `-c` or `--compare`
* Accepts multiple files (comma separated)
* Generates if any compare file is newer than output

+++

## Run

```asciidoc
gen -i input.yaml -t template.stencil -s -o out.txt \
    -c compare1.txt,compare2.txt
```

<span style="font-size:0.8em; color:gray">Does not generate `out.txt` if it is newer than `compare1.txt` and `compare2.txt` in addition to `template.stencil` and `input.yaml`.</span>

---

<span style="font-size:2.0em">Samples</span>

```asciidoc
Samples/inputs
Samples/templates
```

+++

<span style="font-size:1.2em">Input: analyticsKeys.yaml</span>

```yaml
# Analytics Keys
#
# Defines string literals to be used across platforms

name: AnalyticsKeys
package: com.smallplanet.android.genkit.test

groups:

## Core Events

  - name: ApplicationForegrounded
    strings:
      - var: eventName
        string: Application Foregrounded
      - var: dynamicTextSize
        string: dynamicTextSize
      - var: source
        string: source
      - var: voiceOverEnabled
        string: voiceOverEnabled

  - name: ApplicationBackgrounded
    strings:
      - var: eventName
        string: Application Backgrounded

  - name: Screens
    strings:
      - var: onboarding
        string: onboarding
      - var: main
        string: Main View
      - var: secondary
        string: Secondary View
      - var: help
        string: helpView
      - var: categorySelector
        string: Customization Category
```

+++

<span style="font-size:1.2em">Template: StaticStrings.swift.stencil</span>

```asciidoc
// Autogenerated file - Do Not Edit!
//
// To change values, edit the associated yaml file
//
// {{ name }}.swift
//

struct {{ name }} {
{% for group in groups %}
  struct {{ group.name }} { {% for string in group.strings %}
    static let {{ string.var }} = "{{ string.string }}" {% endfor %}
  }
{% endfor %}
}
```

+++

<span style="font-size:1.5em">Swift Output</span>

```swift
// Autogenerated file - Do Not Edit!
//
// To change values, edit the associated yaml file
//
// AnalyticsKeys.swift
//

struct AnalyticsKeys {

  struct ApplicationForegrounded {
    static let eventName = "Application Foregrounded"
    static let dynamicTextSize = "dynamicTextSize"
    static let source = "source"
    static let voiceOverEnabled = "voiceOverEnabled"
  }

  struct ApplicationBackgrounded {
    static let eventName = "Application Backgrounded"
  }

  struct Screens {
    static let onboarding = "onboarding"
    static let main = "Main View"
    static let secondary = "Secondary View"
    static let help = "helpView"
    static let categorySelector = "Customization Category"
  }

}
```

+++

<span style="font-size:1.5em">C++ Header Output</span>

```cpp
// Autogenerated file - Do Not Edit!
//
// To change values, edit the associated yaml file
//
// AnalyticsKeys.hpp
//

#ifndef AnalyticsKeys_hpp
#define AnalyticsKeys_hpp

#include <stdio.h>
#include <string>

struct AnalyticsKeys {

  struct ApplicationForegrounded {
    static std::string eventName;
    static std::string dynamicTextSize;
    static std::string source;
    static std::string voiceOverEnabled;
  };

  struct ApplicationBackgrounded {
    static std::string eventName;
  };

  struct Screens {
    static std::string onboarding;
    static std::string main;
    static std::string secondary;
    static std::string help;
    static std::string categorySelector;
  };

};

#endif
```
+++

<span style="font-size:1.5em">Java Output</span>

```java
package com.smallplanet.android.genkit.test;
import org.intellij.lang.annotations.MagicConstant;

/*
    Autogenerated file - Do Not Edit!
    To change values, edit the associated yaml file

    AnalyticsKeys.java
*/

public final class  AnalyticsKeys {

    @MagicConstant(valuesFromClass = ApplicationForegrounded.class)
    public @interface ApplicationForegrounded {
        String eventName = "Application Foregrounded";
        String dynamicTextSize = "dynamicTextSize";
        String source = "source";
        String voiceOverEnabled = "voiceOverEnabled";
    }

    @MagicConstant(valuesFromClass = ApplicationBackgrounded.class)
    public @interface ApplicationBackgrounded {
        String eventName = "Application Backgrounded";
    }

    @MagicConstant(valuesFromClass = Screens.class)
    public @interface Screens {
        String onboarding = "onboarding";
        String main = "Main View";
        String secondary = "Secondary View";
        String help = "helpView";
        String categorySelector = "Customization Category";
    }

}
```

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
