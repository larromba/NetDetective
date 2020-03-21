# NetDetective [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity) [![Open Source Love png1](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)

| master  | dev |
| ------------- | ------------- |
| [![Build Status](https://travis-ci.com/larromba/NetDetective.svg?branch=master)](https://travis-ci.com/larromba/NetDetective) | [![Build Status](https://travis-ci.com/larromba/NetDetective.svg?branch=dev)](https://travis-ci.com/larromba/NetDetective) |

## About
NetDetective is a simple Mac command line app that generates a snapshot of any processes sending data from your computer. This helps you to quickly identify any potential Spyware.

## Installation

1. The code uses `nettop`, which should come with most macOS installations. If it doesn't, maybe you can try:

```bash
brew install nettop
```

2. Clone the repository

```bash
git clone https://github.com/larromba/NetDetective.git
```

3. Open XCode and build (`cmd+b`) the `NetDetectiveBundle` item on the drop down list. This will install the program to: `usr/local/bin`

## Uninstallation

```bash
rm /usr/local/bin/net-detective
rm /usr/local/bin/NetDetective.bundle/
```

## Usage

```bash
net-detective
```

## Example output

```bash
PROCESS              SENT           MORE INFO...
mDNSResponder        2.5 MB         https://www.google.com/search?q=what+is+mDNSResponder
netbiosd             154 KB         https://www.google.com/search?q=what+is+netbiosd
Dropbox              90 KB          https://www.google.com/search?q=what+is+Dropbox
firefox              34 KB          https://www.google.com/search?q=what+is+firefox
apsd                 27 KB          https://www.google.com/search?q=what+is+apsd
Backup and Sync      10 KB          https://www.google.com/search?q=what+is+Backup and Sync
thunderbird          6 KB           https://www.google.com/search?q=what+is+thunderbird
syslogd              3 KB           https://www.google.com/search?q=what+is+syslogd
SystemUIServer       2 KB           https://www.google.com/search?q=what+is+SystemUIServer
identityservice      2 KB           https://www.google.com/search?q=what+is+identityservice
syspolicyd           2 KB           https://www.google.com/search?q=what+is+syspolicyd
ZenMate VPN          912 bytes      https://www.google.com/search?q=what+is+ZenMate VPN
rapportd             447 bytes      https://www.google.com/search?q=what+is+rapportd
```

## Licence
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

## Contact
larromba@gmail.com

## Future work
* unit tests
* add input parameters to customise functionality
