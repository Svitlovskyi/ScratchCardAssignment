import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ScratchCardViewModel(
        activateCardUseCase: ActivateCardUseCase(apiService: APIService())
    )
    @State private var showScratchView = false
    @State private var showActivationView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                titleView

                Spacer()

                stateDisplayView

                Spacer()

                navigationButtonsView

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showScratchView) {
                ScratchView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showActivationView) {
                ActivationView(viewModel: viewModel)
            }
            .alert("Error", isPresented: errorBinding) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }

    private var titleView: some View {
        Text("Scratch Card Manager")
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    private var stateDisplayView: some View {
        VStack(spacing: 15) {
            stateIconView

            Text("Current State")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(viewModel.state.description)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }

    private var stateIconView: some View {
        Image(systemName: stateIcon)
            .font(.system(size: 80))
            .foregroundColor(stateColor)
    }

    private var navigationButtonsView: some View {
        VStack(spacing: 20) {
            scratchButton
            activationButton
        }
        .padding(.horizontal)
    }

    private var scratchButton: some View {
        PrimaryButton(
            title: "Go to Scratch Screen",
            icon: "hand.draw",
            color: .blue,
            isEnabled: viewModel.state.canBeScratched || viewModel.state.cardPhase == .unscratched,
            action: { showScratchView = true }
        )
    }

    private var activationButton: some View {
        PrimaryButton(
            title: "Go to Activation Screen",
            icon: "checkmark.seal",
            color: .green,
            isEnabled: viewModel.state.canBeActivated,
            action: { showActivationView = true }
        )
    }

    private var stateIcon: String {
        switch viewModel.state.cardPhase {
        case .unscratched:
            return "rectangle.fill"
        case .scratched:
            return "qrcode"
        case .activated:
            return "checkmark.circle.fill"
        }
    }

    private var stateColor: Color {
        switch viewModel.state.cardPhase {
        case .unscratched:
            return .gray
        case .scratched:
            return .blue
        case .activated:
            return .green
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.showError },
            set: { _ in }
        )
    }
}

#Preview {
    HomeView()
}
