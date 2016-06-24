//
//  PrismSpec.swift
//  Focus
//
//  Created by Robert Widmann on 7/4/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import SwiftCheck
import Focus

class PrismSpec : XCTestCase {
	func testPrismLaws() {
		property("modify-identity") <- forAll { (fs : IsoOf<Int, UInt>) in
			/// Cannot generate this in the forAll because we need this to be memoizing and consistent with the Iso.
			let tryGet : (UInt) -> OptionalOf<UInt> = { arc4random() % 4 == 0 ? OptionalOf(.none) : OptionalOf(.some($0)) }
			let prism = Prism(tryGet: { $0.getOptional } • tryGet • fs.getTo, inject: fs.getFrom)
			return forAll { (l : Int) in
				let m = prism.tryModify(l, { $0 })
				return m != nil ==> (m == l)
			}
		}
	}
}

class SimplePrismSpec : XCTestCase {
	func testPrismLaws() {
		property("modify-identity") <- forAll { (fs : IsoOf<Int, UInt>) in
			/// Cannot generate this in the forAll because we need this to be memoizing and consistent with the Iso.
			let tryGet : (UInt) -> OptionalOf<UInt> = { arc4random() % 4 == 0 ? OptionalOf(.none) : OptionalOf(.some($0)) }
			let prism = SimplePrism(tryGet: { $0.getOptional } • tryGet • fs.getTo, inject: fs.getFrom)
			return forAll { (l : Int) in
				let m = prism.tryModify(l, { $0 })
				return m != nil ==> (m == l)
			}
		}
	}
}
