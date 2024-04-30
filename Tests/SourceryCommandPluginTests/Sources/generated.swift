// Generated using Sourcery 2.2.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
























class SomeProtocolMock: SomeProtocol {




    //MARK: - makeInt

    var makeIntIntCallsCount = 0
    var makeIntIntCalled: Bool {
        return makeIntIntCallsCount > 0
    }
    var makeIntIntReturnValue: Int!
    var makeIntIntClosure: (() -> Int)?

    func makeInt() -> Int {
        makeIntIntCallsCount += 1
        if let makeIntIntClosure = makeIntIntClosure {
            return makeIntIntClosure()
        } else {
            return makeIntIntReturnValue
        }
    }


}
