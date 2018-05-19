import UIKit

class PokemonsListCollectionViewCell: UICollectionViewCell {
    private var id: Int?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var whosthat: UIImageView!

    func update(with model: Model) {
        id = model.id

        name.text = formatTextToSolveFontPaddingIssue(model.name)
        whosthat.image = nil

        let downloadingId = model.id
        model.downloadImage(downloadingId) { [weak self] (data) in
            DispatchQueue.main.async {
                if downloadingId == self?.id { self?.whosthat.image = UIImage(data: data) }
            }
        }

    }

    struct Model {
        let id: Int
        var name: String
        var downloadImage: (Int, @escaping (Data) -> Void) -> Void
    }

    private func formatTextToSolveFontPaddingIssue(_ text: String) -> String {
        return " " + text
    }

}
