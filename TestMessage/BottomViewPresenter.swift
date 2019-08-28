//
//  BottomViewPresenter.swift
//  TestMessage
//
//  Created by ilya on 28/08/2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import UIKit

protocol BottomViewPresenterProtocol: class {
    func clickSend()
    func changeLang()
    func clickAudionRecord()
}

class BottomViewPresenter {
    weak var view: BottomViewProtocol?
}

extension BottomViewPresenter: BottomViewPresenterProtocol {
    func clickSend() {
    }
    
    func changeLang() {
    }
    
    func clickAudionRecord() {
    }
}
