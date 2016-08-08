# Using ObjectMapper with contexts.

### What is ObjectMapper

ObjectMapper is a framework written in Swift that makes it easy for you to convert your model objects (classes and structs) to and from JSON.

##### Features

- Mapping JSON to objects
- Mapping objects to JSON
- Nested Objects (stand alone, in arrays or in dictionaries)
- Custom transformations during mapping
- Struct support

### Example

```swift
class User: Mappable {
    var username: String?
    var age: Int?
    
    required init?(_ map: Map) {

    }

    // Mappable
    func mapping(map: Map) {
        username    <- map["username"]
        age         <- map["age"]
    }
}
```

Once your class implements `Mappable`, the Mapper class handles everything else for you:

Convert a JSON string to a model object:
```swift
let user = Mapper<User>().map(JSONString)
```

Convert a model object to a JSON string:
```swift
let JSONString = Mapper().toJSONString(user, prettyPrint: true)
```

### Mapping Context

The `Map` object which is passed around during mapping, has an optional `MapContext` object that is available for developers to use if they need to pass information around during mapping. 

To take advantage of this feature, simple create an object that implements `MapContext` (which is an empty protocol) and pass it into `Mapper` during initialization. 
```swift
struct Context: MapContext {
	var importantMappingInfo = "Info that I need during mapping"
}

class User: Mappable {
	var name: String?
	
	required init?(_ map: Map){
	
	}
	
	func mapping(map: Map){
		if let context = map.context as? Context {
			// use context to make decisions about mapping
		}
	}
}

let context = Context()
let user = Mapper<User>(context: context).map(JSONString)
```

