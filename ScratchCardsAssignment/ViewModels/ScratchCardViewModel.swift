import Foundation
import Combine

// MARK: - Card State Machine

public enum ScratchCardPhase: Equatable {
    case unscratched
    case scratched(code: String)
    case activated(code: String)

    var code: String? {
        if case let .scratched(code) = self { return code }
        if case let .activated(code) = self { return code }
        return nil
    }

    var canBeScratched: Bool {
        self == .unscratched
    }

    var canBeActivated: Bool {
        if case .scratched = self { return true }
        return false
    }
}

// MARK: - Loading States

public enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

// MARK: - View State (Exposed to the View)

public struct ScratchCardViewState: Equatable {
    var cardPhase: ScratchCardPhase
    var scratching: LoadingState
    var activation: LoadingState

    public init(
        cardPhase: ScratchCardPhase = .unscratched,
        scratching: LoadingState = .idle,
        activation: LoadingState = .idle
    ) {
        self.cardPhase = cardPhase
        self.scratching = scratching
        self.activation = activation
    }

    var errorMessage: String? {
        switch (scratching, activation) {
        case (.error(let msg), _), (_, .error(let msg)): return msg
        default: return nil
        }
    }

    var showError: Bool {
        errorMessage != nil
    }

    // Backwards-compatible helpers (previous `ScratchCardState` conveniences)
    var description: String {
        switch cardPhase {
        case .unscratched:
            return "Unscratched"
        case .scratched(let code):
            return "Scratched - Code: \(code)"
        case .activated(let code):
            return "Activated - Code: \(code)"
        }
    }

    var canBeScratched: Bool { cardPhase.canBeScratched }
    var canBeActivated: Bool { cardPhase.canBeActivated }
    var code: String? { cardPhase.code }
}

// MARK: - Actions

public enum ScratchCardAction {
    case scratch
    case cancelScratching
    case activate
    case reset
}

// MARK: - ViewModel Implementation

final class ScratchCardViewModel: BaseViewModel<ScratchCardAction, ScratchCardViewState> {
    private let activateCardUseCase: ActivateCardUseCaseProtocol
    private var scratchTask: Task<Void, Never>?

    init(activateCardUseCase: ActivateCardUseCaseProtocol) {
        self.activateCardUseCase = activateCardUseCase
        super.init(initialState: ScratchCardViewState())
    }

    var isScratching: Bool {
        state.scratching == .loading
    }

    var isActivating: Bool {
        state.activation == .loading
    }

    var errorMessage: String? {
        state.errorMessage
    }

    var showError: Bool {
        state.showError
    }

    override func perform(_ action: ScratchCardAction) {
        switch action {
        case .scratch:
            handleScratch()
        case .cancelScratching:
            handleCancelScratching()
        case .activate:
            Task { await handleActivate() }
        case .reset:
            handleReset()
        }
    }
    
    private func handleScratch() {
        guard state.cardPhase.canBeScratched else { return }
        
        state.scratching = .loading
        
        scratchTask = Task {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                guard !Task.isCancelled else {
                    state.scratching = .idle
                    return
                }
                
                let code = UUID().uuidString
                state.cardPhase = .scratched(code: code)
                state.scratching = .success
            } catch {
                state.scratching = .error(error.localizedDescription)
            }
        }
    }
    
    private func handleCancelScratching() {
        scratchTask?.cancel()
        scratchTask = nil
        state.scratching = .idle
    }
    
    private func handleReset() {
        handleCancelScratching()
        state = ScratchCardViewState()
    }
    
    private func handleActivate() async {
        guard state.cardPhase.canBeActivated, let code = state.cardPhase.code else { return }
        
        state.activation = .loading
        
        let result = await activateCardUseCase.execute(code: code)
        
        switch result {
        case .success:
            state.cardPhase = .activated(code: code)
            state.activation = .success
        case .failure(let error):
            state.activation = .error(error.localizedDescription)
        }
    }
}
