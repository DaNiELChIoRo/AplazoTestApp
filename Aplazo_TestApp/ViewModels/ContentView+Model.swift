//
//  ContentView+Model.swift
//  Aplazo_TestApp
//
//  Created by Daniel Meneses León on 06/01/22.
//

import Foundation

extension ContentView {
    class Model: ObservableObject {
        @Published var categories = [Category]()
        @Published var meals = [Meal]()
        @Published var randomMeal: Meal?
        @Published var showRandom: Bool = false
        var time: DispatchWorkItem?
        
        var cancellableTask: Task<Void, Error>?
        @Published var searchText: String = "" {
            didSet {
                guard !searchText.isEmpty else {
                    time?.cancel()
                    cancellableTask?.cancel()
                    return
                }
                
                time?.cancel()
                time = DispatchWorkItem {
                    self.cancellableTask?.cancel()
                
                    Task {
                        await self.search(for: self.searchText)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: time!)
            }
        }
        
        @MainActor
        func fetch() async {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/categories.php")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                categories = try JSONDecoder().decode(CategoriesResponse.self, from: data).categories
                
            } catch {
                debugPrint("error while retreving", error.localizedDescription)
            }
        }
        
        @MainActor
        func getRandomMeal() async {
            let url = URL(string: "http://www.themealdb.com/api/json/v1/1/random.php")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                self.randomMeal = try JSONDecoder().decode(MealResponse.self, from: data).meals.first!
                self.showRandom = true
                
            } catch {
                debugPrint("error while retreving", error.localizedDescription)
            }
        }
        
        @MainActor
        func search(for filter: String) async {
            cancellableTask = Task {
                let url = URL(string: "http://www.themealdb.com/api/json/v1/1/search.php?f=\(filter)")!
                
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    self.meals = try JSONDecoder().decode(MealResponse.self, from: data).meals
                } catch {
                    debugPrint("error while retreving", error.localizedDescription)
                }
            }
        }
    }
}
