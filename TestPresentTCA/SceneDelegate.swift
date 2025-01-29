//
//  SceneDelegate.swift
//  TestPresentTCA
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import ComposableArchitecture
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = RootViewController(
            store: Store(initialState: RootFeature.State(), reducer: RootFeature.init)
        )
        window?.makeKeyAndVisible()
    }
}

