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
                Text(meal.strMeal)
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

extension CategoryDetail {
    class Model: ObservableObject {
        @Published var meals = [Meal]()
        
        @MainActor
        func feetch(for category: String) async {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.meals = try JSONDecoder().decode(MealResponse.self, from: data).meals
            } catch {
                debugPrint("error while trying to fecth")
            }
        }
    }
}

//struct CategoryDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryDetail(category: "")
//    }
//}
