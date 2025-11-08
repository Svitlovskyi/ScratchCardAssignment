import Foundation
import Combine

@MainActor
public protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var state: State { get set }
    func perform(_ action: Action)
}

@MainActor
open class BaseViewModel<Action, State>: ViewModelProtocol, ObservableObject {
    @Published public var state: State

    public init(initialState: State) {
        self.state = initialState
    }

    open func perform(_ action: Action) {
        fatalError("perform(_:) must be overridden in subclass")
    }
}
