//
//  Monomorphic.swift
//  Focus
//
//  Created by Robert Widmann on 8/23/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// A `SimpleLens` is a `Lens` where the sources and targets a
public struct SimpleLens<S, A> : LensType {
	public typealias Source = S
	public typealias Target = A
	public typealias AltSource = S
	public typealias AltTarget = A

	/// Gets the Indexed Costate Comonad Coalgebroid underlying the receiver.
	private let _run : (S) -> IxStore<A, A, S>

	public func run(_ v : S) -> IxStore<A, A, S> {
		return _run(v)
	}

	/// Produces a lens from an Indexed Costate Comonad Coalgebroid.
	public init(_ f : (S) -> IxStore<A, A, S>) {
		_run = f
	}

	/// Creates a lens from a getter/setter pair.
	public init(get : (S) -> A, set : (S, A) -> S) {
		self.init({ v in IxStore(get(v)) { set(v, $0) } })
	}

	/// Creates a lens that transforms set values by a given function before they are returned.
	public init(get : (S) -> A, modify : (S, (A) -> A) -> S) {
		self.init(get: get, set: { v, x in modify(v) { _ in x } })
	}
}

extension SimpleLens {
	public init<Other : LensType where
		S == Other.Source, A == Other.Target, S == Other.AltSource, A == Other.AltTarget>
		(_ other : Other)
	{
		self.init(other.run)
	}
}

extension SimpleLens : SetterType {
	public func over(_ f: (A) -> A) -> (S) -> S {
		return { s in self.modify(s, f) }
	}
}

public struct SimpleIso<S, A> : IsoType {
	public typealias Source = S
	public typealias Target = A
	public typealias AltSource = S
	public typealias AltTarget = A

	private let _get : (S) -> A
	private let _inject : (A) -> S

	/// Builds a monomorphic `Iso` from a pair of inverse functions.
	public init(get f : (S) -> A, inject g : (A) -> S) {
		_get = f
		_inject = g
	}

	public func get(_ v : S) -> A {
		return _get(v)
	}

	public func inject(_ x : A) -> S {
		return _inject(x)
	}
}

extension SimpleIso {
	public init<Other : IsoType where
		S == Other.Source, A == Other.Target, S == Other.AltSource, A == Other.AltTarget>
		(_ other : Other)
	{
		self.init(get: other.get, inject: other.inject)
	}
}

public struct SimplePrism<S, A> : PrismType {
	public typealias Source = S
	public typealias Target = A
	public typealias AltSource = S
	public typealias AltTarget = A

	private let _tryGet : (S) -> A?
	private let _inject : (A) -> S

	public init(tryGet f : (S) -> A?, inject g : (A) -> S) {
		_tryGet = f
		_inject = g
	}

	public func tryGet(_ v : Source) -> Target? {
		return _tryGet(v)
	}

	public func inject(_ x : AltTarget) -> AltSource {
		return _inject(x)
	}
}

extension SimplePrism {
	public init<Other : PrismType where
		S == Other.Source, A == Other.Target, S == Other.AltSource, A == Other.AltTarget>
		(_ other : Other)
	{
		self.init(tryGet: other.tryGet, inject: other.inject)
	}
}

extension SimplePrism : SetterType {
	public func over(_ f: (A) -> A) -> (S) -> S {
		return { s in self.tryModify(s, f) ?? s }
	}
}

public struct SimpleSetter<S, A> : SetterType {
	public typealias Source = S
	public typealias Target = A
	public typealias AltSource = S
	public typealias AltTarget = A

	private let _over : ((A) -> A) -> (S) -> S

	public init(over: ((A) -> A) -> (S) -> S) {
		self._over = over
	}

	public func over(_ f : (A) -> A) -> (S) -> S {
		return _over(f)
	}
}

extension SimpleSetter {
	public init<Other : SetterType where
		S == Other.Source, A == Other.Target, S == Other.AltSource, A == Other.AltTarget>
		(_ other : Other)
	{
		self.init(over: other.over)
	}
}
