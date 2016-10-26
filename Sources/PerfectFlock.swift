import Foundation
import Flock

extension Flock {
    public static let Perfect: [Task] = [
        StopTask(),
        StartTask(),
        ListTask()
    ]
}

extension Config {
    static var port = 80
}

let perfect = "perfect"

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
        try server.execute("nohup \(Paths.executable) --port \(Config.port) > /dev/null 2>&1 &")
        try invoke("perfect:list")
    }
}

public class ListTask: Task {
    public let name = "list"
    public let namespace = perfect
    
    public func run(on server: Server) throws {
        if let pid = try findServerPid(on: server) {
            print("Perfect running on \(pid)")
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
