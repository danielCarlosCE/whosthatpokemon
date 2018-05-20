import CoreData

protocol PokemonsStorageManagerType {
    func fetchAll() -> [Pokemon]
    func save(pokemon: Pokemon)
    func delete(pokemon: Pokemon)
}

class PokemonsStorageManager: PokemonsStorageManagerType {

    static let shared = PokemonsStorageManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "whosthatpokemon")

        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext { return persistentContainer.viewContext }

    func save(pokemon: Pokemon) {
        let savingPokemon = TransientPokemon(context: context)
        savingPokemon.id = Int64(pokemon.id)
        savingPokemon.name = pokemon.name
        try? context.save()
    }

    func delete(pokemon: Pokemon) {

        let request = TransientPokemon.fetchRequest() as NSFetchRequest<TransientPokemon>
        request.predicate = NSPredicate(format: "id==\(pokemon.id)")

        guard let foundPokemons = try? context.fetch(request),
            let deletingPokemon = foundPokemons.first else { return }

        context.delete(deletingPokemon)
        try? context.save()
    }

    func fetchAll() -> [Pokemon] {
        let request = TransientPokemon.fetchRequest() as NSFetchRequest<TransientPokemon>
        let pokemons = (try? context.fetch(request)) ?? []

        return pokemons.map { Pokemon(id: Int($0.id), name: $0.name) }
    }

}
