import SwiftUI

struct ActivationView: View {
    @ObservedObject var viewModel: ScratchCardViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 40) {
            titleView

            Spacer()

            cardView

            Spacer()

            controlsView

            statusView

            Spacer()
        }
        .padding()
        .navigationTitle("Activation Screen")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var titleView: some View {
        Text("Activate Card")
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    private var cardView: some View {
        VStack(spacing: 20) {
            GradientCard(gradientColors: cardGradientColors) {
                cardContentView
            }
        }
    }

    private var cardContentView: some View {
        Group {
            if case .activated = viewModel.state.cardPhase {
                activatedView
            } else if viewModel.isActivating {
                activatingView
            } else {
                readyToActivateView
            }
        }
    }

    private var activatedView: some View {
        VStack(spacing: 15) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)

            Text("Activated!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }

    private var activatingView: some View {
        VStack(spacing: 15) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)

            Text("Activating...")
                .font(.headline)
                .foregroundColor(.white)

            Text("Please wait")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private var readyToActivateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.seal")
                .font(.system(size: 50))
                .foregroundColor(.white)

            Text("Ready to Activate")
                .font(.headline)
                .foregroundColor(.white)

            if let code = viewModel.state.code {
                VStack(spacing: 4) {
                    Text("Code:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))

                    Text(code)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 8)
            }
        }
    }

    private var controlsView: some View {
        PrimaryButton(
            title: viewModel.isActivating ? "Activating..." : "Activate Card",
            icon: viewModel.isActivating ? "hourglass" : "checkmark.seal.fill",
            color: .green,
            isEnabled: viewModel.state.canBeActivated && !viewModel.isActivating,
            action: { viewModel.perform(.activate) }
        )
    }

    @ViewBuilder
    private var statusView: some View {
        if case .activated = viewModel.state.cardPhase {
            Text("Card successfully activated!")
                .font(.subheadline)
                .foregroundColor(.green)
        } else if viewModel.isActivating {
            Text("Operation continues even if you navigate back")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private var cardGradientColors: [Color] {
        if case .activated = viewModel.state.cardPhase {
            return [Color.green.opacity(0.6), Color.teal.opacity(0.6)]
        }
        return [Color.orange.opacity(0.6), Color.red.opacity(0.6)]
    }
}

#Preview {
    NavigationStack {
        ActivationView(
            viewModel: ScratchCardViewModel(
                activateCardUseCase: ActivateCardUseCase(apiService: APIService())
            )
        )
    }
}
