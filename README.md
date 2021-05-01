# Observable

A generic `ObservableObject` for every property!

## SwiftUI & Performance

Eliminate stutter and relieve the user's battery by reducing body code size.

If adding a string to an object's array triggers a new row in your `List`, you only need the list to be told to update. Not, for example, the navigation title.

More importantly, views get called to update each time **any** of an object's properties change. Even if it's **irrelevant** to a given view.

For example, a `TextField` for a Contact's name string does not need to update whenever a Contact's birthday is set.

To try and solve this elegantly, I created `Observable`.

## One Property per `ObservableObject`

Here is how you could write a Contact class that had `Observable` properties.

````
class Contact {
  let firstName = Observable("John"),
      lastName = Observable("Doe"),
      birthday = Observable(Date())
}
````

You can even make a generic text field view that accepts any `Observable<String>` instance.

````
struct GenericTextField {
  @ObservedObject var string: Observable<String>
  
  var body: some View {
    TextField("", $string.value)
  }
}
````

Increase performance today!
