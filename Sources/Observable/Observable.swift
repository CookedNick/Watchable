import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observable: Encodable where Value: Encodable { }

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observable: Decodable where Value: Decodable { }

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observable: Equatable where Value: Equatable {
	public static func == (lhs: Observable<Value>, rhs: Observable<Value>) -> Bool {
		lhs.internalValue == rhs.internalValue
	}
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observable: Hashable where Value: Hashable {
	public func hash(into hasher: inout Hasher) {
		internalValue.hash(into: &hasher)
	}
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observable: Identifiable where Value: Identifiable {
	public var id: Value.ID {
		internalValue.id
	}
}

/// A property wrapper type that creates a SwiftUI `ObservableObject` for one property.
/// Access the `Observable` using the `$` prefix operator.
///
/// For SwiftUI, either observe the value directly using `@ObservedObject` or use this package's view `Observing` to observe changes locally within any view's body.
///
/// If the value is `Equatable`, new values won't be published unless they are different (`!=`) from before.
@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
@propertyWrapper
public final class Observable<Value>: ObservableObject {
	public convenience init(from decoder: Decoder) throws where Value: Decodable {
		self.init(wrappedValue: try Value(from: decoder))
	}
	
	public convenience init(from decoder: Decoder) throws where Value: Decodable & Equatable {
		self.init(wrappedValue: try Value(from: decoder))
	}
	
	public init(wrappedValue: Value) {
		internalValue = wrappedValue
		set = { _ in }
		set = { [unowned self] newValue in
			internalValue = newValue
		}
	}
	
	public init(wrappedValue: Value) where Value: Equatable {
		internalValue = wrappedValue
		set = { _ in }
		set = { [unowned self] newValue in
			guard internalValue != newValue else { return }
			internalValue = newValue
		}
	}
	
	
	public func encode(to encoder: Encoder) throws where Value: Encodable {
		try wrappedValue.encode(to: encoder)
	}
	
	
	public var wrappedValue: Value {
		get { internalValue }
		set { set(newValue) }
	}
	
	public var projectedValue: Observable<Value> {
		self
	}
	
	
	@Published private var internalValue: Value
	private var set: (Value) -> ()
}
