//: Please build the scheme 'ObjectMapperPlayground' first
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

import ObjectMapper

struct ReceivingContext: MapContext {  }

struct SendingContext: MapContext {  }

class Person: Mappable {
    var name: String?
    var age: Int?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        switch map.context {
            
        case is ReceivingContext:
            name <- map["name"]
            age <- map["age"]
            
        case is SendingContext:
            name <- map["userName"]
            name <- map["userAge"]
            
        default:
            break
        }
    }
}

let dic = ["name": "Fernando Heck", "age": 27]
let person = Mapper<Person>(context: ReceivingContext()).map(dic)
person?.name
person?.age
let dict = Mapper<Person>(context: SendingContext()).toJSON(person!)




protocol PersonContextProtocol {
    var nameKey: String { get }
    var ageKey: String { get }
}

struct ReceivingPersonContext: MapContext, PersonContextProtocol {
    let nameKey = "name"
    let ageKey = "age"
}

struct SendingPersonContext: MapContext, PersonContextProtocol {
    let nameKey = "userName"
    let ageKey = "userAge"
}

class Person2: Mappable {
    var name: String?
    var age: Int?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        if let context = map.context as? PersonContextProtocol {
            name <- map[context.nameKey]
            age <- map[context.ageKey]
        }
    }
}

let dic2 = ["name": "Fernando Heck", "age": 27]
let person2 = Mapper<Person2>(context: ReceivingPersonContext()).map(dic)
person2?.name
person2?.age
let dict2 = Mapper<Person2>(context: SendingPersonContext()).toJSON(person2!)





