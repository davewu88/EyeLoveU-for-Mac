import Foundation
import Combine

class RestTimerModel: ObservableObject {
    @Published var restSeconds: Int
    init(restSeconds: Int) {
        self.restSeconds = restSeconds
    }
}
