import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()
//: ## Never
example(of: "Never sink") {
  Just("Hello") //Just always creates a failure of "NEVER"
    .sink(receiveValue: { print($0) }) //When using just, you can sink(receiveValue:) without specifying receiveCompletion.
    .store(in: &subscriptions)
}

//——— Example of: Never sink ———
//Hello

enum MyError: Error {
    case ohNo
}

example(of: "setFailureType") {
    Just("Hello")
        .setFailureType(to: MyError.self) //Changes the dafualt error type to a custom Error Type. However JUST NEVER throws and error. So this line is dumb.
    .sink(receiveCompletion: { completion in //In this example, you have to use sink(receiveCompletion: receiveValue:) due to the fact that an error has to be handled
        switch completion {
        case .failure(.ohNo):
            print("Finish with Oh No!")
        case .finished:
            print("Finish succesfully")
        }
    }, receiveValue:{ value in
        print("Got value: \(value)")
    })
    .store(in: &subscriptions)
}

//——— Example of: setFailureType ———
//Got value: Hello
//Finish succesfully

example(of: "assign") {
  // 1
  class Person {
    let id = UUID()
    var name = "Unknown"
  }

  // 2
  let person = Person()
  print("1", person.name)

  Just("Shai")
//    .setFailureType(to: Error.self)//if this line is added, the .assign method won't be available.
    .handleEvents( // 3
      receiveCompletion: { _ in print("2", person.name) }
    )
    .assign(to: \.name, on: person) // 4 If the publisher has an error type, the assign modifier is not availab.e
    .store(in: &subscriptions)
}

//——— Example of: assign ———
//1 Unknown
//2 Shai

example(of: "assertNoFailure") {
  // 1
  Just("Hello")
    .setFailureType(to: MyError.self)
//    .tryMap { _ in throw MyError.ohNo } //Use this line to test assertNoFailure
    .assertNoFailure() // 2 “Use assertNoFailure to crash with a fatalError if the publisher completes with a failure event. This turns the publisher's failure type back to Never.
    .sink(receiveValue: { print("Got value: \($0) ")}) // 3
    .store(in: &subscriptions)
}

//——— Example of: assertNoFailure ———
//Got value: Hello
//--- OR (uncommenting the line above ---

//Playground execution failed:
//
//error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).
//The process has been left at the point where it was interrupted, use "thread return -x" to return to the state before expression evaluation.

//: [Next](@next)

/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
