import SwiftUI
import AudioToolbox
struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    init(subject: Subject) {
        _viewModel = StateObject(wrappedValue: GameViewModel(subject: subject))
    }
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isFinished {
                ResultView(
                    score: viewModel.score,
                    total: GameViewModel.totalRounds,
                    tint: viewModel.subject.tint,
                    onRestart: { viewModel.restart() }
                )
            } else {
                gameContent
            }
        }
        .navigationBarHidden(true)
        .background(
            Image("AppBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .overlay(Color.white.opacity(0.4).ignoresSafeArea())
        )
    }
    private var gameContent: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(.white.opacity(0.9)))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.8))
                        Capsule()
                            .fill(viewModel.subject.tint)
                            .frame(width: geometry.size.width * CGFloat(viewModel.round - 1) / CGFloat(GameViewModel.totalRounds))
                            .animation(.spring, value: viewModel.round)
                    }
                }
                .frame(height: 12)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(viewModel.score)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(.white.opacity(0.9)))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            VStack(spacing: 6) {
                Text("Lesson \(viewModel.round) of \(GameViewModel.totalRounds)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.subject.tint)
                    .textCase(.uppercase)
                Text(viewModel.question.prompt)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.center)
                Text("Tap the correct answer below")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.top, 4)
            Spacer(minLength: 10)
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(.white.opacity(0.85))
                    .shadow(color: viewModel.subject.tint.opacity(0.15), radius: 15, x: 0, y: 8)
                Text(viewModel.question.visual)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.1)
                    .multilineTextAlignment(.center)
                    .padding(20)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .frame(maxWidth: 220, maxHeight: 220)
            .aspectRatio(1, contentMode: .fit)
            .id(viewModel.question.id)
            .transition(.scale.combined(with: .opacity))
            Spacer(minLength: 10)
            if let selected = viewModel.selected {
                let isCorrect = selected == viewModel.question.answer
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "hand.raised.fill")
                            .font(.title2)
                        Text(isCorrect ? "Awesome Job!" : "Oops, let's keep going.")
                            .font(.title3.bold())
                        if isCorrect {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }
                    }
                    .foregroundColor(isCorrect ? .green : .orange)
                    Button {
                        viewModel.advance()
                    } label: {
                        Text("Next Question")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 20).fill(isCorrect ? Color.green : Color.orange))
                            .shadow(color: (isCorrect ? Color.green : Color.orange).opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 28).fill(.white.opacity(0.95)))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.question.options, id: \.self) { option in
                    ChoiceButton(
                        title: option,
                        state: viewModel.state(for: option),
                        tint: viewModel.subject.tint,
                        action: {
                            if option == viewModel.question.answer {
                                AudioServicesPlaySystemSound(1057)
                            }
                            viewModel.choose(option)
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.round)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.selected)
    }
}
