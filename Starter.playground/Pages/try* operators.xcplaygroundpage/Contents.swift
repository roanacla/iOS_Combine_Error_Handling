//: [Previous](@previous)
import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()
//: ## try* operators
example(of: "tryMap") {
  // 1
  enum NameError: Error {
    case tooShort(String)
    case unknown
  }

  // 2
  let names = ["Scott", "Marin", "Shai", "Florent"].publisher
  
  names
//    .map { value in //use map if there is no error to throw
//          return value.count
//    }
    .tryMap { value -> Int in //use tryMap if you want to throw an error. tryMap does not — it actually erases the error type to a plain Swift Error.
        // 1
        let length = value.count
        // 2
        guard length >= 5 else {
          throw NameError.tooShort(value)
        }
        // 3
        return value.count
    }
    .sink(receiveCompletion: { print("Completed with \($0)") },
          receiveValue: { print("Got value: \($0)") })
}
//——— Example of: tryMap ———
//Got value: 5
//Got value: 5
//Completed with failure(__lldb_expr_3.(unknown context at $1066f383c).(unknown context at $1066f3844).(unknown context at $1066f384c).NameError.tooShort("Shai"))

