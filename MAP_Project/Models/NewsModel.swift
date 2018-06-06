//
//  NewsModel.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/2/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

struct SelectedNews:Decodable {
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let url: String?
}


struct NewsList:Decodable{
    var articles : [SelectedNews]?
    var status: String?
    var totalResults: Int?
    
}

/*private enum CodingKeys: String,CodingKey
 {
 case page, numResults="total_results", numPages="total_pages", movies="results"
 }*/

class NewsModel{
    
}

