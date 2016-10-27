import Flock
import Foundation

public extension Flock {
    static let Perfect: [Task] = [
        ToolsTask(),
        StopTask(),
        StartTask(),
        ProcessTask()
    ]
}

public extension Config {
    static var ssl: (sslCert: String, sslKey: String)? = nil
    static var port: UInt16? = nil
    static var address: String? = nil
    static var root: String? = nil
    static var serverName: String? = nil
    static var runAs: String? = nil
}

let perfect = "perfect"

public class ToolsTask: Task {
    public let name = "tools"
    public let namespace = perfect
    public let hookTimes: [HookTime] = [.after("tools:dependencies")]
    
    public func run(on server: Server) throws {
        print("Installing Perfect dependencies")
        try server.execute("sudo apt-get -qq install openssl libssl-dev uuid-dev")
    }
}

public class StopTask: Task {
    public let name = "stop"
    public let namespace = perfect
    public let hookTimes: [HookTime] = [.before("deploy:link")]
    
    public func run(on server: Server) throws {
        if let pid = try findServerPid(on: server) {
            try server.execute("kill -9 \(pid)")
        } else {
            print("Perfect not running")
        }
    }
}

public class StartTask: Task {
    public let name = "start"
    public let namespace = perfect
    public let hookTimes: [HookTime] = [.after("deploy:link")]
    
    public func run(on server: Server) throws {
        print("Starting Perfect")
        var execComponents = [Paths.executable]
        if let ssl = Config.ssl {
            execComponents += ["--sslcert \(ssl.sslCert)"]
            execComponents += ["--sslkey \(ssl.sslKey)"]
        }
        if let port = Config.port {
            execComponents += ["--port \(port)"]
        }
        if let address = Config.address {
            execComponents += ["--address \(address)"]
        }
        if let root = Config.root {
            execComponents += ["--root \(root)"]
        }
        if let serverName = Config.serverName {
            execComponents += ["--name \(serverName)"]
        }
        if let runAs = Config.runAs {
            execComponents += ["--runas \(runAs)"]
        }
        let execString = execComponents.joined(separator: " ")
        try server.execute("nohup \(execString) > /dev/null 2>&1 &")
        try invoke("perfect:list")
    }
}

public class ProcessTask: Task {
    public let name = "process"
    public let namespace = perfect
    
    public func run(on server: Server) throws {
        if let pid = try findServerPid(on: server) {
            print("Perfect running as process \(pid)")
        } else {
            print("Perfect not running")
        }
    }
}

private func findServerPid(on server: Server) throws -> String? {
    guard let processes = try server.capture("ps aux | grep \".build\"") else {
        return nil
    }
    
    let lines = processes.components(separatedBy: "\n")
    for line in lines where !line.contains("grep") {
        let segments = line.components(separatedBy: " ").filter { !$0.isEmpty }
        if segments.count > 1 {
            return segments[1]
        }
        return segments.count > 1 ? segments[1] : nil
    }
    return nil
}
