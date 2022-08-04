//
//  EditProjectView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/17/22.
//

import SwiftUI
import CoreHaptics

struct EditProjectView: View {

    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    @State private var engine = try? CHHapticEngine()
    @State private var showingNotificationsError = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init (project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetails)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }

    var body: some View {
        Form {
            // Section 1
            Section(header: Text("Basic Settings")) {
                TextField("Project Name", text: $title.onChange(update))
                    .accessibilityLabel("Project Name")
                TextField("Description of this project", text: $detail.onChange(update))
            }
            // Section 2
            Section(header: Text("Custom Project Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            Section(header: Text("Project Reminders")) {
                Toggle("Show Reminders", isOn: $remindMe.animation().onChange {
                    update()
                })
                .alert(isPresented: $showingNotificationsError) {
                    Alert(
                        title: Text("Uh oh..."),
                        message: Text("There was a problem, please check you have notification enabled"),
                        primaryButton: .default(Text("Check settings"),
                                                action: showAppSettings),
                        secondaryButton: .cancel()
                    )
                }

                if remindMe {
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            // Section 3
            // swiftlint:disable:next line_length
            Section(header: Text("Closing a project moves it from the Open to Closed tab; deleting if removes the project completely")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    toggleClosed()
                }

                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .tint(Color.red)
            }
        }
        .navigationBarTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project?"),
                // swiftlint:disable:next line_length
                message: Text("Are you sure you want to delete this project?  You will also delete all the items it contains."),
                primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel()
            )
        }
    }

    // MARK: Methods
    func toggleClosed() {
        project.closed.toggle()

        if project.closed {
            // Custom haptic effects
            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)

            } catch {
                // Haptics didn't work
                print("🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬 Haptics failed to work")
            }
        }
    }

    func update () {
        project.title = title
        project.detail = detail
        project .color = color

        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false

                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete () {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(

            item == color ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    // Show failure to set notification and link to app settings
    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
