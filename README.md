# AppEvent
App Event fraemwork

``` swift
import AppEvent

let EventProvider = AppEventProvider<AppEvent>()

enum AppEvent {
    case trackAnalytic(category: String, name: String, params: [String])
}

extension AppEvent: AppEventType {
    var message: String? {
        switch self {
        case .trackAnalytic(let category, let name, let params):
            return "Category: \(category), Name: \(name), [\(params.joined(separator: ","))]"
        default:
            return nil
        }
    }
    
    var logLevel: String {
        switch self {
        case .trackAnalytic:
            return LogLevel.analytic.rawValue
        default:
            return LogLevel.verbose.rawValue
        }
    }
    
    var shouldPrint: Bool {
        switch self {
        default:
            return true
        }
    }
    var shouldWriteToLogFile: Bool {
        switch self {
        default:
            return true
        }
    }
    
    var shouldBroadcast: Bool {
        switch self {
        default:
            return false
        }
    }
}

extension AppEvent {
    private enum LogLevel: String {
        case verbose  = "📔 VERBOSE "
        case debug    = "📓 DEBUG   "
        case info     = "📘 INFO    "
        case warning  = "📙 WARNING "
        case error    = "📕 ERROR   "
        case success  = "📗 SUCCESS "
        case analytic = "📉 ANALYTIC"
    }
}

extension AppEvent: Equatable {
    static func == (lhs: AppEvent, rhs: AppEvent) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
```
