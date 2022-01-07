//
//  CategoryDetail.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import SwiftUI

struct CategoryDetail: View {
    let category: Category
    @ObservedObject var model: Model = .init()
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: category.strCategoryThumb)!)
                                    .fixedSize()
            List(model.meals) { meal in
                NavigationLink(destination: MealDetail(mealId: meal.idMeal)) {
                    Text(meal.strMeal)
                }
            }
        }
        .navigationTitle(category.strCategory)
        .onAppear {
            Task {
                await model.feetch(for: category.strCategory)
            }
        }
    }
}

//struct CategoryDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryDetail(category: "")
//    }
//}
