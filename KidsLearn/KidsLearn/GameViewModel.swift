import SwiftUI
import UIKit
enum ChoiceState {
    case idle     
    case correct  
    case wrong    
}
@MainActor
@Observable
final class GameViewModel {
    static let totalRounds = 8
    let subject: Subject
    private(set) var question: Question
    private(set) var round = 1
    private(set) var score = 0
    private(set) var selected: String?
    private(set) var isFinished = false
    init(subject: Subject) {
        self.subject = subject
        self.question = QuestionFactory.make(for: subject)
    }
    func state(for option: String) -> ChoiceState {
        guard let selected else { return .idle }
        if option == question.answer { return .correct }
        return option == selected ? .wrong : .idle
    }
    func choose(_ option: String) {
        guard selected == nil else { return }
        selected = option
        let isCorrect = option == question.answer
        if isCorrect { 
            score += 1 
        }
        UINotificationFeedbackGenerator()
            .notificationOccurred(isCorrect ? .success : .error)
    }
    func restart() {
        round = 1
        score = 0
        selected = nil
        isFinished = false
        question = QuestionFactory.make(for: subject)
    }
    func advance() {
        guard round < Self.totalRounds else {
            isFinished = true
            return
        }
        round += 1
        selected = nil
        question = QuestionFactory.make(for: subject)
    }
}
