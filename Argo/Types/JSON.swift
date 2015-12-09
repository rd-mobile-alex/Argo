import Foundation

public enum JSON {
  case Object([Swift.String: JSON])
  case Array([JSON])
  case String(Swift.String)
  case Number(NSNumber)
  case Null
}

public extension JSON {
  static func parse(json: AnyObject) -> JSON {
    if let v = json as? [AnyObject] {
      return .Array(v.map(parse))
    } else if let v = json as? [Swift.String: AnyObject] {
      return .Object(v.map(parse))
    } else if let v = json as? Swift.String {
      return .String(v)
    } else if let v = json as? NSNumber {
      return .Number(v)
    } else {
      return .Null
    }
  }
}

extension JSON: Decodable {
  public static func decode(j: JSON) -> Decoded<JSON> {
    return pure(j)
  }
}

extension JSON: CustomStringConvertible {
  public var description: Swift.String {
    switch self {
    case let .String(v): return "String(\(v))"
    case let .Number(v): return "Number(\(v))"
    case let .Array(a): return "Array(\(a.description))"
    case let .Object(o): return "Object(\(o.description))"
    case .Null: return "Null"
    }
  }
}

extension JSON: Equatable { }

public func == (lhs: JSON, rhs: JSON) -> Bool {
  switch (lhs, rhs) {
  case let (.String(l), .String(r)): return l == r
  case let (.Number(l), .Number(r)): return l == r
  case let (.Array(l), .Array(r)): return l == r
  case let (.Object(l), .Object(r)): return l == r
  case (.Null, .Null): return true
  default: return false
  }
}

public extension JSON {
  func flatMap<T, U>(f: T -> U?) -> U? {
    switch self {
    case let .String(v): return (v as? T).flatMap(f)
    case let .Number(v): return (v as? T).flatMap(f)
    case let .Array(a): return (a as? T).flatMap(f)
    case let .Object(o): return (o as? T).flatMap(f)
    case .Null: return .None
    }
  }
}
