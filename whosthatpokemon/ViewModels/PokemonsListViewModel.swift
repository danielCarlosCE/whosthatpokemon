import Foundation

typealias Pokemon = String

protocol PokemonsListViewModelType {
    var input: PokemonsListViewModelInput { get }
    var output: PokemonsListViewModelOutPut { get }
}

class PokemonsListViewModel: PokemonsListViewModelType, PokemonsListViewModelInputDelegate, PokemonsListViewModelOutPutDelegate {

    var input = PokemonsListViewModelInput()
    var output = PokemonsListViewModelOutPut()

    private var pokemons: [Pokemon] = []
    private var pokemonsListener: ( ([Pokemon]) -> Void )?

    init() {
        self.input.delegate = self
        self.output.delegate = self
    }

    // MARK: Private
    fileprivate func load() {
        DispatchQueue(label: "PokemonsListViewModel.DownloadData").async {
            sleep(3)
            self.pokemons = ["Pikachu", "dragonite","dragonair","snorlax","kabutops","omastar","flareon","jolteon","vaporeon","gyarados","magmar","electabuzz","jynx","mime","starmie","seaking","seadra","chansey","rhydon","weezing","hitmonchan","hitmonlee","marowak","exeggutor","electrode","kingler","hypno","gengar","haunter","cloyster","muk","dewgong","dodrio","magneton","slowbro","rapidash","golem","graveler","tentacruel","victreebel","weepinbell","machamp","machoke","alakazam","kadabra","poliwrath","poliwhirl","arcanine","primeape","golduck","persian","dugtrio","venomoth","parasect","vileplume","gloom","golbat","wigglytuff","jigglypuff","ninetales","clefable","clefairy","nidoking","nidorino","nidoqueen","nidorina","sandslash","raichu","pikachu","arbok","fearow","raticate","pidgeot","pidgeotto","beedrill","kakuna","butterfree","metapod","blastoise","wartortle","charizard","charmeleon","venusaur","ivysaur","mew","mewtwo","dratini","moltres","zapdos","articuno","aerodactyl","kabuto","omanyte","porygon","eevee","ditto","lapras","magikarp","tauros","pinsir","scyther","staryu","goldeen","horsea","kangaskhan","tangela","rhyhorn","koffing","lickitung","cubone","exeggcute","voltorb","krabby","drowzee","onix","gastly","shellder","grimer","seel","doduo","farfetchd","magnemite","slowpoke","ponyta","geodude","tentacool","bellsprout","machop","abra","poliwag","growlithe","mankey","psyduck","meowth","diglett","venonat","paras","oddish","zubat","vulpix","sandshrew","ekans","spearow","rattata","pidgey","weedle","caterpie","squirtle","charmander","bulbasaur"]
            self.pokemonsListener?(self.pokemons)
        }
    }

    fileprivate func addListener(_ pokemonsListener: @escaping ([Pokemon]) -> Void) {
        self.pokemonsListener = pokemonsListener
    }

}

// MARK: Input
class PokemonsListViewModelInput {
    fileprivate weak var delegate: PokemonsListViewModelInputDelegate?
    fileprivate init() { }

    func load() {
        delegate?.load()
    }
}

private protocol PokemonsListViewModelInputDelegate: class {
    func load()
}

// MARK: Output
class PokemonsListViewModelOutPut {
    fileprivate weak var delegate: PokemonsListViewModelOutPutDelegate?
    fileprivate init() { }

    func observePokemons( _ completion: @escaping ([Pokemon]) -> Void) {
        delegate?.addListener(completion)
    }
}

private protocol PokemonsListViewModelOutPutDelegate: class {
    func addListener(_ completion: @escaping ([Pokemon]) -> Void)
}
