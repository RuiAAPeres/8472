import Overture

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

precedencegroup BackwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return pipe(f, g)
}

infix operator <<<: BackwardComposition

public func <<< <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return pipe(g, f)
}

infix operator |> : ForwardApplication
infix operator ?|> : ForwardApplication

public func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

public func |> <T, U>(x: T, keyPath: KeyPath<T, U>) -> U {
    return x[keyPath: keyPath]
}

public func ?|> <T, U>(x: T?, f: (T) -> U) -> U? {
    return x.map(f)
}

public func ?|> <T, U>(x: T?, keyPath: KeyPath<T, U>) -> U? {
    return x?[keyPath: keyPath]
}

public func ?|> <T, U>(x: T?, f: (T) -> U?) -> U? {
    return x.flatMap(f)
}

public func ?|> <T, U>(x: T?, keyPath: KeyPath<T, U?>) -> U? {
    return x?[keyPath: keyPath]
}

prefix operator ^
public prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return get(kp)
}

public prefix func ^ <Root, Value>(kp: WritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> Value)
    -> (Root) -> Root {
        return prop(kp)
}

public func set<Root, Value>(_ kp: WritableKeyPath<Root, Value>, _ newValue: Value) -> (inout Root) -> Void {
    return { root in
        root[keyPath: kp] = newValue
    }
}

public func equals<Root, Value>(_ kp: KeyPath<Root, Value>, _ value: Value) -> (Root) -> Bool
    where Value: Equatable {
    return { root in
        return root[keyPath: kp] == value
    }
}
