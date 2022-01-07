//
//  CategoryDetail+Model.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import Foundation

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
                debugPrint("error while trying to fecth meals, error:", error.localizedDescription)
            }
        }
    }
}
