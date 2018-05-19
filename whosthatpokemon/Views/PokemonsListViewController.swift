import UIKit

class PokemonsListViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!

    override func viewDidLoad() {
        collection.dataSource = self
    }
}

extension PokemonsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pokemonsListCell.identifier, for: indexPath)
    }
}
