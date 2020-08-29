//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Vineal Viji Varghese on 14/07/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation
struct CoinModel : Codable{
    var rate : Double
    var asset_id_quote : String //Currency
    var asset_id_base : String  //Crypto
}
