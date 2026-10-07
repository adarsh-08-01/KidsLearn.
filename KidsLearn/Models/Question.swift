import Foundation
struct Question: Identifiable {
    let id = UUID()
    let prompt: String       
    let visual: String       
    let options: [String]    
    let answer: String       
}
enum QuestionFactory {
    private static let countingEmojis = ["🍎", "🐶", "⭐️", "🚗", "🎈", "🐟"]
    private static let letterPairs: [(emoji: String, letter: String)] = [
        ("🍎", "A"), ("🐱", "C"), ("🐶", "D"), ("🐘", "E"),
        ("🐟", "F"), ("🍇", "G"), ("🐴", "H"), ("🍦", "I"),
        ("🪁", "K"), ("🦁", "L"), ("🥭", "M"), ("🪹", "N")
    ]
    private static let shapePairs: [(emoji: String, name: String)] = [
        ("🔴", "Circle"), ("🟥", "Square"), ("🔺", "Triangle"), 
        ("⭐", "Star"), ("💙", "Heart")
    ]
    static func make(for subject: Subject) -> Question {
        switch subject {
        case .counting:
            return makeCounting()
        case .letters:
            return makeLetters()
        case .addition:
            return makeAddition()
        case .shapes:
            return makeShapes()
        }
    }
    private static func makeCounting() -> Question {
        let count = Int.random(in: 1...9)
        let emoji = countingEmojis.randomElement() ?? "⭐️"
        var choices: Set<Int> = [count]
        while choices.count < 4 { 
            choices.insert(Int.random(in: 1...10)) 
        }
        return Question(
            prompt: "How many?",
            visual: String(repeating: emoji, count: count),
            options: choices.shuffled().map(String.init),
            answer: String(count)
        )
    }
    private static func makeLetters() -> Question {
        let pick = letterPairs.randomElement() ?? letterPairs[0]
        var choices: Set<String> = [pick.letter]
        while choices.count < 4 {
            if let letter = letterPairs.randomElement()?.letter { 
                choices.insert(letter) 
            }
        }
        return Question(
            prompt: "Which letter starts it?",
            visual: pick.emoji,
            options: choices.shuffled(),
            answer: pick.letter
        )
    }
    private static func makeAddition() -> Question {
        
        let a = Int.random(in: 1...5)
        let b = Int.random(in: 1...5)
        let answer = a + b
        
        var choices: Set<Int> = [answer]
        
        while choices.count < 4 {
            let wrongAnswer = max(
                1,
                answer + Int.random(in: -3...3)
            )
            
            choices.insert(wrongAnswer)
        }
        
        let element = countingEmojis.randomElement() ?? "🍎"
        
        let visual = String(
            repeating: element,
            count: a
        ) + "  +  " +
        String(
            repeating: element,
            count: b
        )
        
        return Question(
            prompt: "What is \(a) + \(b)?",
            visual: visual,
            options: choices.shuffled().map(String.init),
            answer: String(answer)
        )
    }
    private static func makeShapes() -> Question {
        let pick = shapePairs.randomElement() ?? shapePairs[0]
        var choices: Set<String> = [pick.name]
        while choices.count < 4 {
            if let shape = shapePairs.randomElement()?.name { 
                choices.insert(shape) 
            }
        }
        return Question(
            prompt: "What shape is this?",
            visual: pick.emoji,
            options: choices.shuffled(),
            answer: pick.name
        )
    }
}
