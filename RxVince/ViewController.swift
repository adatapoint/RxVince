//
//  ViewController.swift
//  RxVince
//
//  Created by Vincent Restrepo on 5/22/19.
//  Copyright © 2019 Vincent Restrepo. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import SwiftyJSON
import RxCocoa
import RxGesture

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textFieldRepos: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var urlToExecute = URL(string : "https://api.github.com/users/adatapoint/repos")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        button.rx.longPressGesture().flatMap{ [unowned self] _ in
//            return RxAlamofire.requestJSON(.get, self.urlToExecute).map { (arg) -> String in
//                let (_, response) = arg
//                let json = JSON(response).arrayValue.map{ $0.description }
//                print(json)
//                return json.joined(separator: ", ")
//            }
//        }
        
        textFieldRepos.rx.controlEvent([.editingDidBegin,.editingDidEnd])
            .asObservable()
            .subscribe(onNext: {
                print("editing state changed")
            }).disposed(by: disposeBag)
        
        textFieldRepos.rx.tapGesture().when(.began).map{ [unowned self] _ in
            print("hola")
        }
        
        textFieldRepos.rx.text.distinctUntilChanged().bind(to: label.rx.text).disposed(by: disposeBag)
        
        button.rx.tap.throttle(0.8, scheduler: MainScheduler.instance).do(onNext: { [unowned self] in
            self.textFieldRepos.resignFirstResponder()
        })
            .flatMapLatest{ [unowned self] _ in
                return RxAlamofire.requestJSON(.get, self.urlToExecute).map{ (arg) -> String in
                    let (_, response) = arg
                    print(JSON(response))
                    let json = JSON(response).map{ $0 }
                    print(json)
                    return "\(json)"
                }
        }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)

    }

}
