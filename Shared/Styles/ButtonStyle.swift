//
//  ButtonStyle.swift
//  SoraiOSDemo (iOS)
//
//  Created by Sora ID on 3/8/22.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
        Spacer()
        configuration.label.foregroundColor(.white)
        Spacer()
      }
      .padding()
      .background(Color.primary)
      .clipShape(Capsule())
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
        Spacer()
            configuration.label.foregroundColor(.primary)
        Spacer()
      }
      .padding()
      .clipShape(Capsule())
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
      .overlay(
        Capsule()
            .stroke(Color.primary, lineWidth: 2)
      )
    }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press Me") {
            print("Button pressed!")
        }
        .buttonStyle(PrimaryButton())
    }
}
