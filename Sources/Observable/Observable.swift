import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Observable: Encodable where Value: Encodable { }

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Observable: Decodable where Value: Decodable { }

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Observable: Equatable where Value: Equatable {
	@inlinable @inline(__always) public static func == (lhs: Observable<Value>, rhs: Observable<Value>) -> Bool {
		lhs.wrappedValue == rhs.wrappedValue
	}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Observable: Hashable where Value: Hashable {
	@inlinable @inline(__always) public func hash(into hasher: inout Hasher) {
		wrappedValue.hash(into: &hasher)
	}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Observable: Identifiable where Value: Identifiable {
	@inlinable @inline(__always) public var id: Value.ID {
		wrappedValue.id
	}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Observable where Value: ExpressibleByNilLiteral {
	
	/// Creates an `Observable` without an initial value.
	@inlinable @inline(__always) public convenience init() {
		self.init(wrappedValue: nil)
	}
}

/// A property wrapper type that creates a SwiftUI `ObservableObject` for one property.
/// Access the `Observable` using the `$` prefix operator.
///
/// For SwiftUI, either observe the value directly using `@ObservedObject` or use this package's view `Observing` to observe changes locally within any view's body.
///
/// If the value is `Equatable`, new values won't be published unless they are different (`!=`) from before.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public final class Observable<Value>: ObservableObject {
	@inlinable @inline(__always) public convenience init(from decoder: Decoder) throws where Value: Decodable {
		self.init(wrappedValue: try Value(from: decoder))
	}
	
	@inlinable @inline(__always) public init(wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}
	
	@inlinable @inline(__always) public init(_ initialValue: Value) {
		self.wrappedValue = initialValue
	}
	
	
	@inlinable @inline(__always) public func encode(to encoder: Encoder) throws where Value: Encodable {
		try wrappedValue.encode(to: encoder)
	}
	
	
	@Published public var wrappedValue: Value
	
	
	@inlinable @inline(__always) public var projectedValue: Observable<Value> {
		self
	}
	
	@inlinable @inline(__always) public var publisher: Published<Value>.Publisher {
		$wrappedValue
	}
	
	@inlinable @inline(__always) public var binding: Binding<Value> {
		Binding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
	}
}
