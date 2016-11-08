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

Flock.use(Flock.Deploy)
Flock.use(Flock.Perfect)
// Remove `Flock.use(Flock.Server)`
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
}
```
# Tasks
```
flock perfect:restart  # Hooks .after("deploy:link")
flock perfect:stop
flock perfect:start
flock perfect:status
flock perfect:tools    # Hooks .after("tools:dependencies")
```
`PerfectFlock` hooks into the deploy process to automatically restart the server after the new release is built, and into the tools process to install `Perfect` tools, so you should never have to call these tasks directly.
