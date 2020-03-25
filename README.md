# NetDetective [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity) [![Open Source Love png1](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)

| master  | dev |
| ------------- | ------------- |
| [![Build Status](https://travis-ci.com/larromba/NetDetective.svg?branch=master)](https://travis-ci.com/larromba/NetDetective) | [![Build Status](https://travis-ci.com/larromba/NetDetective.svg?branch=dev)](https://travis-ci.com/larromba/NetDetective) |

## About

NetDetective is a simple Mac command line app that generates a snapshot of any processes sending / receiving data from your computer. This helps you to quickly identify any potential Spyware.

## Installation from Source

**SwiftLint**

`brew install swiftlint`

**Sourcery** *(testing only)*

`brew install sourcery`

**nettop**

bundled with `macOS`

### Build Instructions

1. Clone the repository

```bash
git clone https://github.com/larromba/NetDetective.git
```

2. Open XCode and build (`cmd+b`) the `NetDetectiveBundle` item, found on the drop down list. This will install the program to: 

```
usr/local/bin
```

## Uninstallation

```bash
rm /usr/local/bin/net-detective
```

## Usage

```bash
net-detective
```

### Example output

```bash
PROCESS              IN             OUT            MORE INFO...
mDNSResponder        4.6 MB         2.7 MB         https://www.google.com/search?q=what+is+mDNSResponder
netbiosd             618 KB         159 KB         https://www.google.com/search?q=what+is+netbiosd
Dropbox              90 KB          80 KB          https://www.google.com/search?q=what+is+Dropbox
apsd                 10 KB          75 KB          https://www.google.com/search?q=what+is+apsd
Backup and Sync      65 KB          13 KB          https://www.google.com/search?q=what+is+Backup and Sync
thunderbird          14 KB          7 KB           https://www.google.com/search?q=what+is+thunderbird
GitHub Desktop       5 KB           1 KB           https://www.google.com/search?q=what+is+GitHub Desktop
firefox              4 KB           2 KB           https://www.google.com/search?q=what+is+firefox
SystemUIServer       -              3 KB           https://www.google.com/search?q=what+is+SystemUIServer
identityservice      2 KB           2 KB           https://www.google.com/search?q=what+is+identityservice
rapportd             2 KB           1 KB           https://www.google.com/search?q=what+is+rapportd
ZenMate VPN          961 bytes      912 bytes      https://www.google.com/search?q=what+is+ZenMate VPN
```

The idea is to bring whichever process is sending or receiving the most data to the top, *agnostic of the column name*. As such, column ordering is sorted: 

```
top         ->      bottom
max bytes   ->      min bytes
```

## Known issues

1. `error code -9`


When rebuilding to `usr/local/bin`, sometimes an XCode clean (`cmd+shift+K`) and uninstall *(see Uninstallation section above)* is first needed.

## Licence
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

## Contact
larromba@gmail.com

## Future work
1. accept input parameters to customise functionality
