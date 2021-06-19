import SwiftUI

/// A view that observes an `Observable` property. The view recomputes its body whenever the value is changed.
@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
public struct Observing<Object: ObservableObject, Content: View>: View {
	/// A view that observes an `Observable` property, passing down a SwiftUI `Binding` to the value. The view recomputes its body whenever the value is changed.
	/// - Parameter object: The `Observable` to observe. You can use the `$` prefix on an `@Observable` property to pass it here.
	/// - Parameter content: The content of the view.
	/// - Parameter binding: The binding to the value.
	public init<Value>(_ object: Observable<Value>, @ViewBuilder content: @escaping (_ binding: Binding<Value>) -> Content) where Object == Observable<Value> {
		self.content = { object in
			content(Binding { object.wrappedValue } set: { object.wrappedValue = $0 })
		}
		self.object = object
	}
	
	/// A view that observes an `ObservableObject`. The view recomputes its body whenever a value is changed.
	/// - Parameter object: The `ObservableObject` to observe. You can use the `$` prefix on an `@Observable` property to pass it here.
	/// - Parameter content: The content of the view.
	public init(_ object: Object, @ViewBuilder content: @escaping () -> Content) {
		self.content = { _ in content() }
		self.object = object
	}
	
	
	public var body: some View {
		content(object)
	}
	
	
	private let content: (Object) -> Content
	@ObservedObject private var object: Object // The part that tells SwiftUI to update.
}
