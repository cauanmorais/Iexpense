//
//  ContentView.swift
//  Iexpense
//
//  Created by Cauan de Jesus Nascimento de Morais on 22/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpenses = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ItemType.allCases) { category in
                    Section(category.rawValue) {
                        ForEach(expenses.items.filter { $0.type == category}) { item in
                            ExpenseRow(item: item, color: backgroundColor(for: item.amount))
                        }
                        .onDelete { offsets in
                            removeItens(at: offsets, for: category)
                        }
                    }
                }
                Section {
                    Button("Clear list", action: clearItems)
                        .buttonStyle(.bordered)
                        .foregroundStyle(.primary)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add expense", systemImage: "plus") {
                        showingAddExpenses = true
                    }
                }
            }
            .sheet(isPresented: $showingAddExpenses) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItens(at offsets: IndexSet, for category: ItemType) {
        let categoryItems = expenses.items.filter { $0.type == category }
        
        for offset in offsets {
            let itemToRemove = categoryItems[offset]
            if let index = expenses.items.firstIndex(where: { $0.id == itemToRemove.id }) {
                expenses.items.remove(at: index)
            }
        }
        expenses.items.remove(atOffsets: offsets)
    }
    
    func backgroundColor(for price: Double) -> Color {
        if price > 500.00 && price < 1000.00  {
            return Color.yellow
        }
        
        if price > 1000.00 && price < 2000.00 {
            return Color.orange
        }
        
        if price > 2000.00 {
            return Color.red
        }
        
        return Color.green // default case
    }
    
    func clearItems() {
        expenses.items.removeAll()
    }
}

enum ItemType: String, CaseIterable, Identifiable, Codable {
    case personal = "Personal"
    case work = "Work"
    
    var id: UUID { UUID() }
}


struct ExpenseItem: Hashable, Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: ItemType
    let amount: Double
    
}


@Observable
class Expenses {
    var items: [ExpenseItem] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
   
}

struct ExpenseRow: View {
    let item: ExpenseItem
    let color: Color
    var body: some View {
        HStack {
            VStack {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(color)
                
                Text(item.type.rawValue)
                    .foregroundStyle(color)
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
        }
    }
}
    
#Preview {
    ContentView()
}
