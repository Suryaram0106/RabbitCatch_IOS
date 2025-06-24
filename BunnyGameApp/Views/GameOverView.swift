//
//  GameOverView.swift
//  BunnyGame
//
//  Created by Surya on 24/06/25.
//

import SwiftUI


struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea() // ✅ Fills the whole screen

            VStack(spacing: 20) {
                Text("Game Over")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)

                Text("Final Score: \(viewModel.score)")
                    .font(.title2)

                Button(action: {
                    viewModel.reset()
                }) {
                    Text("Tap to Restart")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


//struct GameOverView: View {
//    @ObservedObject var viewModel: GameViewModel
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Game Over")
//                .font(.largeTitle)
//                .bold()
//                .foregroundColor(.red)
//
//            Text("Final Score: \(viewModel.score)")
//                .font(.title2)
//
//            Button(action: {
//                viewModel.reset()
//            }) {
//                Text("Tap to Restart")
//                    .font(.title3)
//                    .bold()
//                    .foregroundColor(.blue)
//            }
//        }
//        .background(Color.teal)
//        .cornerRadius(12)
//    }
//}
