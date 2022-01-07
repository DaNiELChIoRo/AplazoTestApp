//
//  MealDetail.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import SwiftUI

struct MealDetail: View {
    let mealId: String
    @ObservedObject var model: Model = .init()
    var body: some View {
        ScrollView {
            if let meal = model.meal {
                AsyncImage(url: URL(string: meal.strMealThumb)!)
                    .fixedSize()
                    .frame(maxHeight: .leastNormalMagnitude)
            
                Text(meal.strInstructions)
            }
        }
        .navigationTitle(model.meal?.strMeal ?? "")
        .onAppear {
            Task {
                await model.fetch(for: mealId)
            }
        }
    }
}

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

