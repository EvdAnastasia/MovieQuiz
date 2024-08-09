import Foundation

final class StatisticService {
    
    private enum Keys: String {
        case correct
        case total
        case bestGame
        case gamesCount
    }
    
    private let storage: UserDefaults = .standard
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    init(decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
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
            guard let data = storage.data(forKey: Keys.bestGame.rawValue),
                  let bestGame = try? decoder.decode(GameResult.self, from: data) else {
                return nil
            }
            
            return bestGame
        }
        
        set {
            let data = try? encoder.encode(newValue)
            storage.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let date = dateProvider()
        let currentBestGame = GameResult(correct: count, total: amount, date: date)
        
        if let previousBestGame = bestGame {
            if currentBestGame.isBetterThan(previousBestGame) {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
