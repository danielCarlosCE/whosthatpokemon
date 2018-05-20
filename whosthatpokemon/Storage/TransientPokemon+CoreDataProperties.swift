import Foundation
import CoreData

extension TransientPokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransientPokemon> {
        return NSFetchRequest<TransientPokemon>(entityName: "TransientPokemon")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String

}
