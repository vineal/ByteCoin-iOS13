//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didGetCoinData(_ coinManager:CoinManager,coin:CoinModel)
    func didFailWithError(error:Error)
}
struct CoinManager {
    var delegate : CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "23E24665-1738-49CE-BB32-3847EA07EBB8"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency:String) {
        if let url = URL(string: "\(baseURL)/\(currency)?apikey=\(apiKey)"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    if let coinModel = self.parseJSON(safeData){
                        print("Json Parsed: Rate is \(coinModel.rate)")
                        self.delegate?.didGetCoinData(self,coin:coinModel)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ coinData:Data) -> CoinModel?{
        let decode = JSONDecoder()
        do{
            let decodedData = try decode.decode(CoinModel.self, from: coinData)
            let curr = decodedData.asset_id_quote
            let crypto = decodedData.asset_id_base
            let rate = decodedData.rate
            let coinModel = CoinModel(rate: rate, asset_id_quote: curr, asset_id_base: crypto)
            print("Curr:\(curr)\nCrypto:\(crypto)\nRate:\(rate)")
            return coinModel
        }
        catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
