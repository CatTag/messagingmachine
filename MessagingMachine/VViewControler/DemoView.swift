//
//  DemoView.swift
//  MessagingMachine
//
//  Created by Jordan Davis on 22/4/2024.
//

import SwiftUI


struct DemoView: View {
    @State var the: Float = 0.0
    @State var switcher: Bool = false
    var body: some View {
        VStack {
            Image(systemName: "square.and.arrow.down.on.square")
                .imageScale(.large)
                .foregroundStyle(.red)
            Image(systemName: "square.and.arrow.down.on.square.fill")
                .imageScale(.large)
                .foregroundStyle(.red)
            Text("scince").foregroundStyle(.red)
            Toggle("Instant ->", isOn: $switcher)
            HStack {
                Button("down") {
                    if the  > 0 && switcher {
                        the = 0
                    } else if the > 0 {
                        the -= 0.1
                    }
                }
            
                
                Spacer()
                
                Button("up") {
                    if the  < 1 && switcher {
                        the = 1
                    } else if the < 1 {
                        the += 0.1
                    }
                }
            }
            ProgressView("", value: the, total: 1)

        }
        .padding()
    }
}
#Preview {
    DemoView()
}
