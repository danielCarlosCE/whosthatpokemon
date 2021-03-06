import UIKit

class PokemonsListViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var viewModel: PokemonsListViewModelType!
    var didSelectItem: ((PokemonPayload) -> Void)?
    var willAppear: (() -> Void)?

    private var pokemons: [Pokemon] = []

    override func viewDidLoad() {
        guard viewModel != nil else { fatalError("\(String(describing: self)) initiated without ViewModel") }

        collection.dataSource = self
        collection.delegate = self

        bindOutput()
        bindInput()
    }
    override func viewWillAppear(_ animated: Bool) {
        willAppear?()
    }

    private func bindInput() {
        viewModel.input.load()
    }

    private func bindOutput() {
        viewModel.output.observePokemons { [weak self] (result) in
            self?.updateUI(with: result)
        }
    }

    private func updateUI(with result: PokemonsListViewModelOutPut.Result) {
        DispatchQueue.main.async {
            switch result {
            case .loading:
                self.loadingIndicator.startAnimating()
            case .loaded(let pokemons):
                self.loadingIndicator.stopAnimating()
                self.pokemons = pokemons
                self.collection.reloadData()
            }
        }
    }

}

extension PokemonsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueCell(collection: collection, indexPath: indexPath)
        let pokemon = self.pokemon(for: indexPath)

        cell.update(with: .init(id: pokemon.id, name: pokemon.name, downloadImage: viewModel.input.downloadImage))

        return cell
    }

    private func dequeueCell(collection: UICollectionView, indexPath: IndexPath) -> PokemonsListCollectionViewCell {
        let id = R.reuseIdentifier.pokemonsListCell
        let dequeuedCell = collection.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        guard let cell = dequeuedCell else { fatalError("Unable to dequeue pokemonsListCell") }
        return cell
    }

    private func pokemon(for indexPath: IndexPath) -> Pokemon {
        let row = indexPath.row

        guard row < pokemons.count else { fatalError("Unable to get pokemon for indexPath: \(indexPath)") }

        return pokemons[row]
    }

}

extension PokemonsListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PokemonsListCollectionViewCell else { return }
        let pokemon = self.pokemon(for: indexPath)

        var imageData: Data?
        if let image = cell.whosthat.image { imageData = UIImagePNGRepresentation(image) }

        didSelectItem?(PokemonPayload(pokemon: pokemon, image: imageData))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset: CGFloat = 56
        let dynamicWidth = collectionView.frame.width < 900 ? 450 : ( collectionView.frame.width / 2 ) - offset
        let maxWidth = min(collectionView.frame.width, dynamicWidth)
        return CGSize(width: maxWidth, height: 103)

    }
}
