//
//  CViewController.swift
//  TestPresentTCA
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import ComposableArchitecture
import UIKit

@Reducer
struct CFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case close
    }
    
    @Dependency(\.dismiss)
    var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .close:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}

final class CViewController: UIViewController {
    lazy var button = UIButton(type: .system, primaryAction: .init(handler: { [weak self] _ in
        self?.store.send(.close)
    }))

    private let store: StoreOf<CFeature>
    
    init(store: StoreOf<CFeature>) {
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
        
        button.configureTintedButton(withTitle: "Close")
        button.center = view.center
        view.addSubview(button)
    }
}
