import Foundation

protocol MainActorProto: MainActor {}
extension Auth.Business {
    // IMPORTANT! conform your UIState or HybridState to corresponding Relux State protocol in class declaration
    // Relux applies @MainActor global actor isolation to UIState and HybridState state protocol definitions
    // it's related to specific non-obvious behaviour for this conformance
    @Observable
    final class State: Relux.HybridState {
        typealias Model = Auth.Business.Model

        var availableBiometryType: Model.BiometryType?
        var loggedIn: Bool = false


        func reduce(with action: any Relux.Action) async {
            switch action as? Auth.Business.Action {
                case .none: break
                case let .some(action): internalReduce(with: action)
            }
        }

        func cleanup() async {
            self.loggedIn = false
            self.availableBiometryType = .none
        }
    }
}
