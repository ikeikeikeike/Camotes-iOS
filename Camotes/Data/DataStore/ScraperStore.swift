import Moya
import RxMoya
import RxSwift

protocol ScraperStore {
   func info(url: String, handler: @escaping (SingleEvent<InfoEntity>) -> Void)
}

struct ScraperStoreImpl: ScraperStore {

    let provider: MoyaProvider<ScraperAPI> = {
        let logger = NetworkLoggerPlugin(cURL: true)

        let stub = { (target: ScraperAPI) -> StubBehavior in .never }
        return MoyaProvider<ScraperAPI>(stubClosure: stub, plugins: [logger])
    }()

    public func info(url: String, handler: @escaping (SingleEvent<InfoEntity>) -> Void) {
        _ = provider.rx.request(.info(url: url))
            .filterSuccessfulStatusCodes()
            .map(InfoEntity.self, atKeyPath: "root")
            .subscribe(handler)
    }

}
