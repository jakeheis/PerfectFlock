# PerfectFlock

Automated deployment of your [Perfect](https://github.com/PerfectlySoft/Perfect) server using [Flock](https://github.com/jakeheis/Flock).

# Installation
Add these lines to `deploy/FlockDependencies.json`:
```
"dependencies" : [
       ...
       {
           "url" : "https://github.com/jakeheis/PerfectFlock",
           "version": "0.0.1"
       }
]
```
In your `Flockfile` add:
```swift
import Flock
import PerfectFlock

...

Flock.use(Flock.Perfect)
```
# Config
```swift
public extension Config {
    static var ssl: (sslCert: String, sslKey: String)? = nil
    static var port: UInt16? = nil
    static var address: String? = nil
    static var root: String? = nil
    static var serverName: String? = nil
    static var runAs: String? = nil
    
    static var outputLog = "/dev/null"
    static var errorLog = "/dev/null"
}
```
If you set the log variables to anything other than `/dev/null`, you'll likely want to turn off stdout bufferring to ensure log files are properly written to:
```swift
// Sources/main.swift

#if os(Linux)
import Glibc
#else
import Darwin
#endif
import PerfectLib

setbuf(stdout, nil)

let server = HTTPServer()
...
```
# Tasks
```
perfect:tools    # Hooks .after("tools:dependencies")
perfect:stop     # Hooks .before("deploy:link")
perfect:start    # Hooks .after("deploy:link")
perfect:ps
```
`PerfectFlock` hooks into the deploy process to automatically restart the server after the new release is built, and into the tools process to install `Perfect` tools, so you should never have to call these tasks directly.
