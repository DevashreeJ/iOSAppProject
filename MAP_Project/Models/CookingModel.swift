//
//  CookingModel.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/30/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import Foundation

struct SelectedRecipe: Decodable {
    let idMeal: String?
    let strMeal: String?
    let strMealThumb: String?
    let strCategory: String?
    let strInstructions: String?
}


struct RecipeList:Decodable{
    var meals : [SelectedRecipe]?
    }

/*private enum CodingKeys: String,CodingKey
{
    case page, numResults="total_results", numPages="total_pages", movies="results"
}*/

class CookingModel{
    
}
