import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    let isEnabled: Bool
    let color: Color

    init(
        title: String,
        icon: String,
        color: Color = .blue,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? color : .gray)
            .foregroundColor(.white)
            .cornerRadius(AppConstants.Layout.buttonCornerRadius)
        }
        .disabled(!isEnabled)
        .padding(.horizontal)
    }
}
