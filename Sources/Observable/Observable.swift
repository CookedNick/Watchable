import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class Observable<Value>: ObservableObject {
	/// Initialize an `Observable` property with a given initial value.
	public init(_ initialValue: Value) {
		value = initialValue
	}
	
	/// The current value of the `Observable`. This is the `@Published` property that affects SwiftUI views.
	@Published public var value: Value
	
	/// A `Combine` publisher for the value. You can use this to subscribe to changes in UIKit views and other non-SwiftUI situations.
	var publisher: Published<Value>.Publisher { _value.projectedValue }
}
