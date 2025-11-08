import SwiftUI

struct ScratchView: View {
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
        .navigationTitle("Scratch Screen")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if viewModel.isScratching {
                viewModel.perform(.cancelScratching)
            }
        }
    }

    private var titleView: some View {
        Text("Scratch Card")
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
            if case .scratched(let code) = viewModel.state.cardPhase {
                revealedCodeView(code: code)
            } else if viewModel.isScratching {
                scratchingView
            } else {
                unscatchedView
            }
        }
    }

    private func revealedCodeView(code: String) -> some View {
        VStack(spacing: 10) {
            Text("Revealed Code")
                .font(.headline)
                .foregroundColor(.white)

            Text(code)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 8)
    }

    private var scratchingView: some View {
        VStack(spacing: 15) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)

            Text("Scratching...")
                .font(.headline)
                .foregroundColor(.white)
        }
    }

    private var unscatchedView: some View {
        VStack(spacing: 10) {
            Image(systemName: "hand.draw")
                .font(.system(size: 50))
                .foregroundColor(.white)

            Text("Scratch to Reveal")
                .font(.headline)
                .foregroundColor(.white)
        }
    }

    private var controlsView: some View {
        Button(action: {
            viewModel.perform(.scratch)
        }) {
            HStack {
                Image(systemName: viewModel.isScratching ? "hourglass" : "hand.tap")
                Text(viewModel.isScratching ? "Scratching..." : "Scratch Card")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(!viewModel.state.canBeScratched || viewModel.isScratching)
        .padding(.horizontal)
    }

    @ViewBuilder
    private var statusView: some View {
        if case .scratched = viewModel.state.cardPhase {
            Text("Card successfully scratched!")
                .font(.subheadline)
                .foregroundColor(.green)
        }
    }

    private var cardGradientColors: [Color] {
        [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]
    }

    private var buttonColor: Color {
        if !viewModel.state.canBeScratched || viewModel.isScratching {
            return .gray
        }
        return .blue
    }
}

#Preview {
    NavigationStack {
        ScratchView(
            viewModel: ScratchCardViewModel(
                activateCardUseCase: ActivateCardUseCase(apiService: APIService())
            )
        )
    }
}
