//
//  AuthService.swift
//  Socially-UIKit
//
//  Created by 박지혜 on 7/26/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    fileprivate var currentNonce: String?
    
    // MARK: - Apple login
    func performAppleSignIn(on viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email, .email]
        request.nonce = sha256(nonce)
        
        // 인증
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewController as? ASAuthorizationControllerDelegate
//        authorizationController.presentationContextProvider = viewController as? ASWebAuthenticationPresentationContextProviding
        authorizationController.performRequests()
    }
    
    // Firebase로 애플 인증 정보 전송
    func signInWithApple(idToken: String, rawNonce: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let nonce = currentNonce else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "Invalid state: A login callback was received, but no login request was sent."])))
            return
        }
        
        // Nonce를 통해 삼자 확인
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: rawNonce)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }}
    }
    // MARK: - Private Methods
    // 난수 생성
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    // 해시 함수(암호화)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
