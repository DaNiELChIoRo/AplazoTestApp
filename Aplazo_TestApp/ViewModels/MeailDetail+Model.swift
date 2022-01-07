//
//  MeailDetail+Model.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import Foundation

extension MealDetail {
    class Model: ObservableObject {
        @Published var meal: Meal?
        
        @MainActor
        func fetch(for id: String) async {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.meal = try JSONDecoder().decode(MealResponse.self, from: data).meals.first!
            } catch {
                debugPrint("error while trying to fecth")
            }
        }
    }
}
