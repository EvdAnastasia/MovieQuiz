import Foundation

final class StatisticService {
    
    private enum Keys: String {
        case correct
        case total
        case bestGame
        case gamesCount
    }
    
    private let storage: UserDefaults = .standard
}

extension StatisticService: StatisticServiceProtocol {
    
    var correct: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            storage.integer(forKey: Keys.total.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if total != 0 {
            return Double(correct) / (10 * Double(gamesCount)) * 100
        } else {
            return 0
        }
    }
    
    var bestGame: GameResult? {
        get {
            let correct = storage.integer(forKey: "bestGame.correct")
            let total = storage.integer(forKey: "bestGame.total")
            let date = UserDefaults.standard.object(forKey: "bestGame.date") as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        
        set {
            storage.set(newValue?.correct, forKey: "bestGame.correct")
            storage.set(newValue?.total, forKey: "bestGame.total")
            storage.set(newValue?.date, forKey: "bestGame.date")
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let currentBestGame = GameResult(correct: count, total: amount, date: Date())
        
        if let previousBestGame = bestGame {
            if currentBestGame.isBetterThan(previousBestGame) {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}

