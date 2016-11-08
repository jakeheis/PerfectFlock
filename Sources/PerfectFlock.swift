import Flock
import Foundation

public extension Flock {
    static let Perfect: [Task] = SystemdTasks(provider: PerfectSystemdProvder()).createTasks() + [EnvTask(), ToolsTask()]
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
let confFilePath = "/etc/perfect.conf"

public class PerfectSystemdProvder: SystemdProvider {
    
    static var argumentString = ""
    
    public let name = perfect
    public let serviceName = perfect
    
    public var serviceFileContents: String {
        return [
            "[Unit]",
            "Description=\"The \(name) server\"",
            "",
            "[Service]",
            "EnvironmentFile=\(confFilePath)",
            "ExecStart=\"\(Paths.executable)\" \(PerfectSystemdProvder.argumentString)",
            "Restart=on-failure",
            ""
        ].joined(separator: "\n")
    }
}

public class EnvTask: Task {
    public let name = "write-env"
    public let namespace = perfect
    public let hookTimes: [HookTime] = [.before("perfect:restart")]
    
    public func run(on server: Server) throws {        
        var lines: [String] = []
        var keys: [String] = []
        
        func add(_ key: String, _ value: String) {
            lines.append("\(key)=\(value)")
            keys.append(key)
        }
        
        if let ssl = Config.ssl {
            add("SSH", "--sslcert \(ssl.sslCert) --sslkey \(ssl.sslKey)")
        }
        if let port = Config.port {
            add("PORT", "--port \(port)")
        }
        if let address = Config.address {
            add("ADDRESS", "--address \(address)")
        }
        if let root = Config.root {
            add("ROOT", "--root \(root)")
        }
        if let serverName = Config.serverName {
            add("NAME", "--name \(serverName)")
        }
        if let runAs = Config.runAs {
            add("RUNAS", "--runas \(runAs)")
        }
        
        let config = lines.joined(separator: "\n")
        try server.execute("echo \"\(config)\" > \(confFilePath)")
        
        PerfectSystemdProvder.argumentString = keys.map({ "\\$" + $0 }).joined(separator: " ")
        
        try invoke("perfect:write-service") // Always rewrite service to update ExecStart
    }
    
}

public class ToolsTask: Task {
    public let name = "tools"
    public let namespace = perfect
    public let hookTimes: [HookTime] = [.after("tools:dependencies")]
    
    public func run(on server: Server) throws {
        print("Installing Perfect dependencies")
        try server.execute("sudo apt-get -qq install openssl libssl-dev uuid-dev")
    }
}
