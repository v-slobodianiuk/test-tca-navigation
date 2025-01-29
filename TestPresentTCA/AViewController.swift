//
//  AViewController.swift
//  TestPresentTCA
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import ComposableArchitecture
import UIKit

@Reducer
struct AFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    @Reducer
    enum Destination {
        case bFeature(BFeature)
        case cFeature(CFeature)
    }

    enum Action {
        case showB
        case showC
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showB:
                state.destination = .bFeature(.init())
                return .none

            case .showC:
                state.destination = .cFeature(.init())
                return .none
                
            case .destination(.presented(.bFeature(.delegate(.closeAndShowC)))):
                return .send(.showC)

            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
        
}

extension AFeature.Destination.State: Equatable {}

final class AViewController: UIViewController {
    lazy var button = UIButton(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.store.send(.showB)
    }))

    @UIBindable private var store: StoreOf<AFeature>
    
    init(store: StoreOf<AFeature>) {
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
        button.configureTintedButton(withTitle: "Show B")
        button.center = view.center
        view.addSubview(button)
        
        present(item: $store.scope(state: \.destination?.bFeature, action: \.destination.bFeature)) { store in
            BViewController(store: store)
        }
        
        present(item: $store.scope(state: \.destination?.cFeature, action: \.destination.cFeature)) { store in
            CViewController(store: store)
        }
    }
}
