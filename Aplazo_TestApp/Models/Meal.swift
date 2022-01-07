//
//  Meal.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import Foundation

struct Meal: Decodable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var strInstructions: String = ""
    var strArea: String = ""
    var strYoutube: String = ""
    var strCategory: String = ""
}

extension Meal: Identifiable {
    var id: String{
        return idMeal
    }
}

struct MealResponse: Decodable {
    let meals: [Meal]
}
