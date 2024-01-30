**Note (2024):** I still use this package, but I had to rename it as of iOS 17 to "Watchable". The old name conflicts with Apple's new "Observable" macro. I am too lazy to update the repository, but I'll put this note here in case anyone is still trying to use it.

# Observable

A property wrapper type that creates an `ObservableObject` for just a single property.

This can have **enormous performance benefits** due to how SwiftUI recomputes views.

## SwiftUI + Performance

Views get called to update each time **any** of an object's properties change. Even if it's irrelevant to a given view.

Consider the following common pattern of a typical custom view with one `@State` property.

```swift
struct BedroomLabel: View {
	@State var areTheLightsOn = false
	var numberOfPeople = 0
	
	var body: some View {
		VStack {
			Text("This bedroom has \(numberOfPeople) people in it.")
			
			Toggle("Lights On/Off", isOn: $areTheLightsOn)
		}
	}
}
```

This is a very common pattern in SwiftUI, and it works alright, but the `BedroomLabel` will update in its entirety whenever the lights get toggled. This means the CPU spends *unnecessary* time checking the entire body whenever this happens.

**How can we do better?**

## One `ObservableObject` per Property

Here is that same example written using `Observable`.

```swift
struct BedroomLabel: View {
	@Observable var areTheLightsOn = false
	var numberOfPeople = 0
	
	var body: some View {
		VStack {
			Text("This bedroom has \(numberOfPeople) people in it.")
			
			Observing(bindingOf: $areTheLightsOn) { isOn in
				Toggle("Lights On/Off", isOn: isOn)
			}
		}
	}
}
```

`@Observable` writes just like `@State`, except it stores the value in an implicit generic `ObservableObject` type. `Observing` takes care of unwrapping that and recomputing a view closure whenever its changed.

This means `BedroomLabel` won't be computed on changes. Only the `Toggle` will be.

[ObservableSample is a sample app](https://github.com/cookednick/ObservableSample) that demonstrates, side-by-side, the performance gains of using `@Observable` instead of `@State`.

## Installation

Use Swift Package Manager with this GitHub URL.

## License

````
MIT License

Copyright © 2021-2022 Nicolas Cook Leon

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
````
