//
//  RootViewController.swift
//  TestPresentTCA
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import ComposableArchitecture
import OSLog
import UIKit

let logger = Logger()

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var aFeature: AFeature.State?
    }
    
    enum Action {
        case showA
        case aFeature(PresentationAction<AFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showA:
                state.aFeature = .init()
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$aFeature, action: \.aFeature) {
            AFeature()
        }
        // ._printChanges()
    }
}

final class RootViewController: UIViewController {
    lazy var button = UIButton(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.store.send(.showA)
    }))
    
    @UIBindable private var store: StoreOf<RootFeature>
    
    init(store: StoreOf<RootFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        logger.info("✅ Deinit: \(String(describing: Self.self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        button.configureTintedButton(withTitle: "Show A")
        button.center = view.center
        view.addSubview(button)
        
        present(item: $store.scope(state: \.aFeature, action: \.aFeature)) { store in
            AViewController(store: store)
        }
    }
}

extension UIButton {
    func configureTintedButton(withTitle title: String) {
        var config = UIButton.Configuration.borderedTinted()
        config.title = title
        self.configuration = config
        self.sizeToFit()
    }
}
