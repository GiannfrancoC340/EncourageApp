//
//  AuthManager.swift
//  EncourageApp
//
//  Created by Giannfranco Crovetto on 12/17/24.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var user: User?
    var isMocked: Bool = false
    var isSignedIn: Bool { user != nil }
    var userEmail: String? { isMocked ? "kingsley@dog.com" : user?.email }

    private var handle: AuthStateDidChangeListenerHandle?

    init(isMocked: Bool = false) {
        self.isMocked = isMocked
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async { // Ensure UI updates happen on the main thread
                self?.user = user
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signUp(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                DispatchQueue.main.async { // Ensure updates happen on the main thread
                    self.user = authResult.user
                }
            } catch {
                print(error)
            }
        }
    }

    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                DispatchQueue.main.async { // Ensure updates happen on the main thread
                    self.user = authResult.user
                }
            } catch {
                print(error)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async { // Ensure updates happen on the main thread
                self.user = nil
            }
        } catch {
            print(error)
        }
    }
}
