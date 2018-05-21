import UIKit

class PokemonDetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var whosthatpokemon: UIImageView!
    @IBOutlet weak var pokemonDescription: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var viewModel: PokemonDetailsViewModelType!
    var didSelectItem: ((Pokemon) -> Void)?

    private var pokemon: Pokemon?

    override func viewDidLoad() {
        guard viewModel != nil else { fatalError("\(String(describing: self)) initiated without ViewModel") }

        bindOutput()
        bindInput()
    }
    @IBAction func callPokeball() {
        guard let pokemon = pokemon else { return }
        didSelectItem?(pokemon)
    }

    private func bindInput() {
        viewModel.input.load()
    }

    private func bindOutput() {
        viewModel.output.observePokemonDetails { [weak self] (result) in
            self?.updateUI(with: result)
        }
    }

    private func updateUI(with result: PokemonDetailsViewModelOutput.Result) {
        DispatchQueue.main.async {
            switch result {
            case .loading(let payload):

                self.pokemon = payload.pokemon

                self.name.text = self.formatTextToSolveFontPaddingIssue(payload.pokemon.name)
                self.pokemonDescription.text = ""
                self.view.backgroundColor = .white
                self.whosthatpokemon.image = nil
                if  let image = payload.image  {
                    self.whosthatpokemon.image = UIImage(data: image)
                }

                self.loadingIndicator.startAnimating()

            case .loaded(let details):

                self.loadingIndicator.stopAnimating()
                self.pokemonDescription.text = details.description
                self.view.backgroundColor = details.color.uiColor

            }
        }
    }

    private func formatTextToSolveFontPaddingIssue(_ text: String) -> String {
        return " " + text
    }
}

private extension PokemonDetails.Color {
    var uiColor: UIColor {
        switch  self {
        case .black:
            return .black
        case .blue:
            return .blue
        case .brown:
            return .brown
        case .gray:
            return .gray
        case .green:
            return .green
        case .pink:
            return .init(red: 1, green: 192/255, blue: 203/255, alpha: 1)
        case .purple:
            return .purple
        case .red:
            return .red
        case .white:
            return .white
        case .yellow:
            return .yellow

        }
    }
}
