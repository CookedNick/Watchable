import SwiftUI

/// A view that observes an `Watchable` property. The view recomputes its body whenever the value is changed.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Watching<Object: ObservableObject, Content: View>: View {
	/// A view that observes an `Watchable` property, passing down a SwiftUI `Binding` to the value. The view recomputes its body whenever the value is changed.
	/// - Parameter object: The `Watchable` to observe. You can use the `$` prefix on an `@Watchable` property to pass it here.
	/// - Parameter content: The content of the view.
	/// - Parameter binding: The binding to the value.
	public init<Value>(bindingOf object: Watchable<Value>, @ViewBuilder onChange content: @escaping (_ binding: Binding<Value>) -> Content) where Object == Watchable<Value> {
		self.content = { object in
			content(Binding { object.wrappedValue } set: { object.wrappedValue = $0 })
		}
		self.object = object
	}
	
	/// A view that observes an `Watchable` property, passing down the current value. The view recomputes its body whenever the value is changed.
	/// - Parameter object: The `Watchable` to observe. You can use the `$` prefix on an `@Watchable` property to pass it here.
	/// - Parameter content: The content of the view.
	/// - Parameter value: The current value.
	public init<Value>(valueOf object: Watchable<Value>, @ViewBuilder onChange content: @escaping (_ newValue: Value) -> Content) where Object == Watchable<Value> {
		self.content = { content($0.wrappedValue) }
		self.object = object
	}
	
	/// A view that observes an `ObservableObject`. The view recomputes its body whenever a value is changed.
	/// - Parameter object: The `ObservableObject` to observe. You can use the `$` prefix on an `@Watchable` property to pass it here.
	/// - Parameter content: The content of the view.
	public init(_ object: Object, @ViewBuilder content: @escaping () -> Content) {
		self.content = { _ in content() }
		self.object = object
	}
	
	
	@inline(__always) public var body: some View {
		content(object)
	}
	
	
	private let content: (Object) -> Content
	@ObservedObject private var object: Object // The part that tells SwiftUI to update.
}
