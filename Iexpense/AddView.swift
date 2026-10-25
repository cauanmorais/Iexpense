//
//  AddView.swift
//  Iexpense
//
//  Created by Cauan de Jesus Nascimento de Morais on 23/10/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    @State private var amount = 0.0
    @State private var name = ""
    @State private var type = ItemType.personal
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(ItemType.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                    .keyboardType(.decimalPad)
                    .labelsHidden()
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
