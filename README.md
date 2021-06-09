# Observable

A property wrapper type that creates an `ObservableObject` for just a single property.

This can have **enormous performance benefits** due to how SwiftUI recomputes views.

## SwiftUI + Performance

Views get called to update each time **any** of an object's properties change. Even if it's irrelevant to a given view.

Consider the following common pattern of a typical `ObservableObject` type with `@Published` properties.

````
class Bedroom: ObservableObject {
	@Published var numberOfPeople = 0
	@Published var areTheLightsOn = false
}

struct BedroomLabel: View {
	@ObservedObject var bedroom: Bedroom
	
	var body: some View {
		VStack {
			Text("This bedroom has \(bedroom.numberOfPeople) people in it.")
			
			Toggle("Lights On/Off", isOn: $bedroom.areTheLightsOn)
		}
	}
}
````

This is a very common pattern in SwiftUI, and it works alright, but the `BedroomLabel` will update in its entirety whenever any of the properties in the bedroom change. So the CPU spends unnecessary time checking the entire body whenever this happens.

*How can we do better?*

## One `ObservableObject` per Property

Here is that same example written using `Observable`.

````
class Bedroom {
	@Observable var numberOfPeople = 0
	@Observable var areTheLightsOn = false
}

struct BedroomLabel: View {
	var bedroom: Bedroom
	
	var body: some View {
		VStack {
			Observing(bedroom.$numberOfPeople) { $numberOfPeople in
				Text("This bedroom has \(numberOfPeople) people in it.")
			}
			
			Observing(bedroom.$areTheLightsOn) { areTheLightsOn in
				Toggle("Lights On/Off", isOn: areTheLightsOn)
			}
		}
	}
}
````

Notice the lack of `@ObservedObject` wrappers in our SwiftUI view. `Observing` takes care of that part for us, offering us a generic solution to observe `Observable` properties (and any `ObservableObject`) in-line within a view's body, reducing the number of separate view types you will have to create to build your app.

## Installation

Use Swift Package Manager with this GitHub URL.

## License

````
MIT License

Copyright (c) 2021 Nicolas Cook Leon

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
````
