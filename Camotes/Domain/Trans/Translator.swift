//
//  Translator.swift
//
//  Created by Tatsuo Ikeda on 2018/02/19.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//
import Foundation

protocol Translator {
    associatedtype Input
    associatedtype Output
    
    func translate(_:  Input) -> Output
    func translate(_: [Input]) -> [Output]
}
