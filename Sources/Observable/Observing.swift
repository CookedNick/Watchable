import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observing: Equatable where Object: Equatable {
	public static func == (lhs: Observing<Object, Content>, rhs: Observing<Object, Content>) -> Bool {
		lhs.object == rhs.object
	}
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observing: Hashable where Object: Hashable {
	public func hash(into hasher: inout Hasher) {
		object.hash(into: &hasher)
	}
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension Observing: Identifiable where Object: Identifiable {
	public var id: Object.ID {
		object.id
	}
}

/// A view that observes an `Observable` property. The view recomputes its body whenever the value is changed.
@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
public struct Observing<Object: ObservableObject, Content: View>: View {
	/// A view that observes an `Observable` property, passing down a SwiftUI `Binding` to the value.
	/// - Parameter object: The `Observable` to observe. You can use `$` syntax on a wrapped property to retrieve its underlying `Observable`.
	/// - Parameter content: The content of the view.
	/// - Parameter binding: The binding to the value.
	public init<Value>(_ object: Observable<Value>, @ViewBuilder content: @escaping (_ binding: Binding<Value>) -> Content) where Object == Observable<Value> {
		let binding = Binding { object.wrappedValue } set: { object.wrappedValue = $0 }
		self.init(object) {
			content(binding)
		}
	}
	
	/// A view that observes an `ObservableObject`. The view recomputes its body whenever the value is changed.
	/// - Parameter object: The `ObservableObject` to observe.
	/// - Parameter content: The content of the view.
	public init(_ object: Object, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.object = object
	}
	
	
	public var body: some View {
		content()
	}
	
	
	private let content: () -> Content
	@ObservedObject private var object: Object // The part that tells SwiftUI to update.
}
