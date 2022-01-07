//
//  Category.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import Foundation

struct Category: Decodable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

extension Category: Identifiable {
    var id: String {
        return idCategory
    }
}

struct CategoriesResponse: Decodable {
    let categories: [Category]
}
