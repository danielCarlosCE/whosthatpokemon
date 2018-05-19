import UIKit

class PokemonsListViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    var viewModel: PokemonsListViewModelType!

    private var pokemons: [Pokemon] = []

    override func viewDidLoad() {
        guard viewModel != nil else { fatalError("\(String(describing: self)) initiated without ViewModel") }

        collection.dataSource = self

        bindInput()
        bindOutput()
    }

    // MARK: Private
    private func bindInput() {
        viewModel.input.load()
    }

    private func bindOutput() {
        viewModel.output.observePokemons { [weak self] (pokemons) in
            self?.pokemons = pokemons
            DispatchQueue.main.async { self?.collection.reloadData() }
        }
    }

}

extension PokemonsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pokemonsListCell, for: indexPath) else { fatalError("Unable to dequeue pokemonsListCell") }
        guard let pokemon = pokemon(for: indexPath) else { fatalError("Unable to get pokemon for indexPath: \(indexPath)") }

        cell.name.text = formatTextToSolveFontPaddingIssue(pokemon)
        return cell
    }

    private func pokemon(for indexPath: IndexPath) -> Pokemon? {
        let row = indexPath.row

        guard row < pokemons.count else { return nil }

        return pokemons[row]
    }

    private func formatTextToSolveFontPaddingIssue(_ text: String) -> String {
        return " " + text
    }
}
