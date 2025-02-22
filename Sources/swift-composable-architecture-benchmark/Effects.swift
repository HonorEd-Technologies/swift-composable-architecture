import Benchmark
import Combine
import ComposableArchitecture
import Foundation

let effectSuite = BenchmarkSuite(name: "Effects") {
  $0.benchmark("Merged Effect.none (create, flat)") {
    doNotOptimizeAway(Effect<Int, Never>.merge((1...100).map { _ in .none }))
  }

  $0.benchmark("Merged Effect.none (create, nested)") {
    var effect = Effect<Int, Never>.none
    for _ in 1...100 {
      effect = effect.merge(with: .none)
    }
    doNotOptimizeAway(effect)
  }

  let effect = Effect<Int, Never>.merge((1...100).map { _ in .none })
  var didComplete = false
  $0.benchmark("Merged Effect.none (sink)") {
    doNotOptimizeAway(
      effect.sink(receiveCompletion: { _ in didComplete = true }, receiveValue: { _ in })
    )
  } tearDown: {
    precondition(didComplete)
  }
}
