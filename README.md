# PerfectFlock

Automated deployment of your [Perfect](https://github.com/PerfectlySoft/Perfect) server using [Flock](https://github.com/jakeheis/Flock).

## Installation
Add these lines to `deploy/FlockDependencies.json`:
```
"dependencies" : [
  ...
  {
    "name" : "https://github.com/jakeheis/PerfectFlock",
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
Run `flock tools` again before deploying to install Perfect's tools on your server.
## Included tasks
```
perfect:tools    # Hooks .after("tools:dependencies")
perfect:stop     # Hooks .before("deploy:link")
perfect:start    # Hooks .after("deploy:link")
perfect:ps
```
## Configuration
```
public extension Config {
    static var ssl: (sslCert: String, sslKey: String)? = nil
    static var port: UInt16? = nil
    static var address: String? = nil
    static var root: String? = nil
    static var serverName: String? = nil
    static var runAs: String? = nil
}
```
