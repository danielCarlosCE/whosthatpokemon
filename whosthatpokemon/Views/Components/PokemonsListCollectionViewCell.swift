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
        model.downloadImage(downloadingId) { [weak self] (result) in
            guard downloadingId == self?.id else { return }
            DispatchQueue.main.async {
                switch result {
                case .single(let data):
                    self?.whosthat.image = UIImage(data: data)
                case .multiple(let datas):
                    self?.whosthat.image = UIImage.animatedImage(with: datas.flatMap { UIImage(data: $0) }, duration: 1)
                }
            }

        }

    }

    struct Model {
        let id: Int
        var name: String
        var downloadImage: (Int, @escaping (FetchImageResult) -> Void) -> Void
    }

    private func formatTextToSolveFontPaddingIssue(_ text: String) -> String {
        return " " + text
    }

}
