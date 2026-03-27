import SwiftUI

struct MenuBarView: View {
    @ObservedObject private var settings = SettingsManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("🧠")
                    .font(.title)
                Text("Sentient")
                    .font(.headline)
                Spacer()
                Text("v1.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 4)
            
            Divider()
            
            // Personality toggles
            VStack(alignment: .leading, spacing: 8) {
                Text("Personalities")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                PersonalityToggle(
                    icon: "🎭",
                    name: "Dramatic",
                    description: "Reacts to tilts and impacts",
                    isEnabled: $settings.dramaticEnabled
                )
                
                PersonalityToggle(
                    icon: "🍔",
                    name: "Hungry",
                    description: "Complains about battery",
                    isEnabled: $settings.hungryEnabled
                )
                
                PersonalityToggle(
                    icon: "😤",
                    name: "Judgmental",
                    description: "Judges your app choices",
                    isEnabled: $settings.judgmentalEnabled
                )
                
                PersonalityToggle(
                    icon: "🥺",
                    name: "Needy",
                    description: "Misses you when idle",
                    isEnabled: $settings.needyEnabled
                )
            }
            
            Divider()
            
            // Volume slider
            VStack(alignment: .leading, spacing: 4) {
                Text("Volume")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "speaker.fill")
                        .foregroundColor(.secondary)
                    Slider(value: $settings.volume, in: 0...1)
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Footer buttons
            HStack {
                Button("Settings...") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                
                Spacer()
                
                Button("Quit") {
                    NSApp.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 260)
    }
}

#Preview {
    MenuBarView()
}
