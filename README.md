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

## Included tasks
```
perfect:tools
perfect:stop
perfect:start
perfect:list
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
