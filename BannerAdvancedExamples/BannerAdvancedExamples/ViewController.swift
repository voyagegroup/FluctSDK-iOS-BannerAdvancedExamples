//
//  ViewController.swift
//  BannerAdvancedExamples
//

import UIKit
import FluctSDK

private let margin = 10.0
private let adAspectRatio = 18.0/32

class ViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var scrollView: UIView!
    private var adView: FSSAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label1.text = "We are about to study the idea of a computational process. Computational processes are abstract beings that inhabit computers. As they evolve, processes manipulate other abstract things called data. The evolution of a process is directed by a pattern of rules called a program. People create programs to direct processes. In effect, we conjure the spirits of the computer with our spells."
        
        // 前もってサイズを計算する
        // autolayoutでは広告のサイズは拡大縮小しない
        let width = UIScreen.main.bounds.size.width - margin * 2
        let height = width * adAspectRatio
        
        // Viewの生成
        let adView = FSSAdView(
            groupId: "1000149547",
            unitId: "1000245601",
            size: CGSize(width: width, height: height)
        )
        adView.backgroundColor = UIColor.blue
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(adView)
        
        // ターゲティング設定
        let targeting = FSSAdRequestTargeting()
        
        //ユーザーのIDを設定してください
        targeting.publisherProvidedID = "c6c506f327740abe750e05cd8d0dc22414d173c43814409c70e722ef2d124806360aaf3146c63226a4e2c862ebdd11b83d37b7b6e144ab4619bca8a0b22d054e"
        
        // 広告の読み込み
        // addSubviewした後にloadAd()を実行してください
        adView.loadAd(with: targeting)
        
        self.adView = adView
        
        adView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: margin).isActive = true
        adView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        adView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: margin).isActive = true
        adView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -margin).isActive = true
        adView.heightAnchor.constraint(equalTo: adView.widthAnchor, multiplier: adAspectRatio).isActive = true
    }
}

// MARK: - FSSAdViewDelegate
extension ViewController: FSSAdViewDelegate {
    func adViewDidStoreAd(_ adView: FSSAdView) {
        print("広告表示が完了しました")
    }
    
    func adView(_ adView: FSSAdView, didFailToStoreAdWithError error: Error) {
        print(error.localizedDescription)
        let fluctError = FSSAdViewError(rawValue: (error as NSError).code) ?? .unknown
        switch fluctError {
        case .unknown:
            print("Unkown Error")
        case .notConnectedToInternet:
            print("ネットワークエラー")
        case .serverError:
            print("サーバーエラー")
        case .noAds:
            print("表示する広告がありません")
        case .badRequest:
            print("groupId / unitId / 登録されているbundleのどれかが間違っています")
        @unknown default:
            fatalError()
        }
    }
    
    func willLeaveApplicationForAdView(_ adView: FSSAdView) {
        print("広告へ遷移します")
    }
}
