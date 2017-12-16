fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></th>
<th width="33%">Installer Script</th>
<th width="33%">RubyGems</th>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

# Available Actions
### test
```
fastlane test
```
Run all the tests
### beta
```
fastlane beta
```
Build and send the beta to TestFlight
### upload_build
```
fastlane upload_build
```
Build and upload to iTunes Connect
### build
```
fastlane build
```
Build and test
### refresh_dsyms
```
fastlane refresh_dsyms
```
Upload dsyms to Fabric
### metadata
```
fastlane metadata
```
Upload metadata
### screenshots
```
fastlane screenshots
```
Take all screenshots
### version_bump
```
fastlane version_bump
```
Increment and commit version bump
### changelog
```
fastlane changelog
```
Generate changelog

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
