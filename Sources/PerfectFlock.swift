import Flock
import Foundation

public extension Flock {
    static let Perfect: [Task] = SupervisordTasks(provider: PerfectSupervisorProvder()).createTasks() + [ToolsTask()]
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

class PerfectSupervisorProvder: SupervisordProvider {
    
    static var argumentString = ""
    
    let name = perfect
    let programName = perfect
    
    func confFileContents(for server: Server) -> String {
        var commandComponents = [Paths.executable]
        if let ssl = Config.ssl {
            commandComponents.append("--sslcert \(ssl.sslCert)")
            commandComponents.append("--sslkey \(ssl.sslKey)")
        }
        if let port = Config.port {
            commandComponents.append("--port \(port)")
        }
        if let address = Config.address {
            commandComponents.append("--address \(address)")
        }
        if let root = Config.root {
            commandComponents.append("--root \(root)")
        }
        if let serverName = Config.serverName {
            commandComponents.append("--name \(serverName)")
        }
        if let runAs = Config.runAs {
            commandComponents.append("--runas \(runAs)")
        }
        let command = commandComponents.joined(separator: " ")
        return [
            "[program:\(programName)]",
            "command=\(command)",
            "process_name=%(process_num)s",
            "autostart=false",
            "autorestart=unexpected",
            "stdout_logfile=\(Config.outputLog)",
            "stderr_logfile=\(Config.errorLog)",
            ""
        ].joined(separator: "\n")
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
