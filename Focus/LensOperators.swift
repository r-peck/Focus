//
//  Operator.swift
//  Focus
//
//  Created by Robert Widmann on 7/2/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// The identity function.
internal func identity<A>(_ a : A) -> A {
	return a
}

/// Compose | Applies one function to the result of another function to produce a third function.
///
///     f : B -> C
///     g : A -> B
///     (f • g)(x) === f(g(x)) : A -> B -> C
internal func • <A, B, C>(f : (B) -> C, g : (A) -> B) -> (A) -> C {
	return { (a : A) -> C in
		return f(g(a))
	}
}
