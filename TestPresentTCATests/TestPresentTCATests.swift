//
//  TestPresentTCATests.swift
//  TestPresentTCATests
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import ComposableArchitecture
import Testing
@testable import TestPresentTCA

@MainActor
struct TestPresentTCATests {
    @Test func testPresentLogic() async throws {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        
        // Present AFeature on RootFeature
        await store.send(\.showA) {
            $0.aFeature = .init()
        }
        
        // Present BFeature on AFeature
        await store.send(\.aFeature.presented.showB) {
            $0.aFeature?.destination = .bFeature(.init())
        }
        
        // Close BFeature and try to show CFeature on AFeature
        await store.send(\.aFeature.presented.destination.presented.bFeature.delegate.closeAndShowC)
        
        await store.receive(\.aFeature) {
            $0.aFeature?.destination = .cFeature(.init())
        }
    }
}
