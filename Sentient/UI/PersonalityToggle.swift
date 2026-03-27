import SwiftUI

struct PersonalityToggle: View {
    let icon: String
    let name: String
    let description: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PersonalityToggle(
        icon: "🎭",
        name: "Dramatic",
        description: "Reacts to tilts and impacts",
        isEnabled: .constant(true)
    )
    .padding()
}
