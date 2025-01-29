//
//  BViewController.swift
//  TestPresentTCA
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import ComposableArchitecture
import UIKit

@Reducer
struct BFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case delegate(Delegate)
    }
    
    @CasePathable
    enum Delegate {
        case closeAndShowC
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
}

final class BViewController: UIViewController {
    lazy var button = UIButton(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.store.send(.delegate(.closeAndShowC))
    }))

    private let store: StoreOf<BFeature>
    
    init(store: StoreOf<BFeature>) {
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

        button.configureTintedButton(withTitle: "Close and show C")
        button.center = view.center
        view.addSubview(button)
    }
}
