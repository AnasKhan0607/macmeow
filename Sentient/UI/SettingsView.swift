import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @ObservedObject private var settings = SettingsManager.shared
    @State private var newGuiltyApp = ""
    
    var body: some View {
        TabView {
            // General tab
            Form {
                Section {
                    Toggle("Launch at Login", isOn: $settings.launchAtLogin)
                        .onChange(of: settings.launchAtLogin) { _, newValue in
                            setLaunchAtLogin(newValue)
                        }
                }
                
                Section("Volume") {
                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $settings.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }
            }
            .tabItem {
                Label("General", systemImage: "gear")
            }
            .padding()
            
            // Personalities tab
            Form {
                Section("Enabled Personalities") {
                    Toggle("🎭 Dramatic", isOn: $settings.dramaticEnabled)
                    Toggle("🍔 Hungry", isOn: $settings.hungryEnabled)
                    Toggle("😤 Judgmental", isOn: $settings.judgmentalEnabled)
                    Toggle("🥺 Needy", isOn: $settings.needyEnabled)
                    Toggle("😴 Sleepy", isOn: $settings.sleepyEnabled)
                    Toggle("🎲 Chaotic", isOn: $settings.chaoticEnabled)
                }
            }
            .tabItem {
                Label("Personalities", systemImage: "theatermasks")
            }
            .padding()
            
            // Judgmental settings tab
            Form {
                Section("Guilty Pleasure Apps") {
                    Text("Your Mac will judge you when you open these apps.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(settings.guiltyApps, id: \.self) { app in
                        HStack {
                            Text(app)
                            Spacer()
                            Button(action: {
                                settings.guiltyApps.removeAll { $0 == app }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    HStack {
                        TextField("Add app...", text: $newGuiltyApp)
                            .textFieldStyle(.roundedBorder)
                        Button("Add") {
                            if !newGuiltyApp.isEmpty {
                                settings.guiltyApps.append(newGuiltyApp)
                                newGuiltyApp = ""
                            }
                        }
                        .disabled(newGuiltyApp.isEmpty)
                    }
                }
            }
            .tabItem {
                Label("Judgmental", systemImage: "eye")
            }
            .padding()
            
            // About tab
            VStack(spacing: 16) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 64))
                    .foregroundColor(.accentColor)
                
                Text("Sentient")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your Mac is alive now.")
                    .foregroundColor(.secondary)
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Link("Made by Anas Khan", destination: URL(string: "https://twitter.com/AnasKhan0607")!)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
            .padding()
        }
        .frame(width: 450, height: 350)
    }
    
    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to set launch at login: \(error)")
        }
    }
}

#Preview {
    SettingsView()
}
