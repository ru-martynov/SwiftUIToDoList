//
//  ContentView.swift
//  ToDoList
//
//  Created by Руслан Мартынов on 03.04.2020.
//  Copyright © 2020 Руслан Мартынов. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var manageObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems: FetchedResults<ToDoItem>
    
    @State private var newTodoItem = ""
    // MARK: - To Do List
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Next step?")) {
                    HStack {
                        TextField("New Item", text: self.$newTodoItem)
                        Button(action: {
                            let toDoItem = ToDoItem(context: self.manageObjectContext)
                            toDoItem.title = self.newTodoItem
                            toDoItem.createdAt = Date()
                            
                            do {
                                try self.manageObjectContext.save()
                            } catch {
                                print(error)
                            }
                            
                            self.newTodoItem = ""
                            
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header: Text("To Do's")) {
                    ForEach(self.toDoItems) {todoItems in
                        ToDoItemView(title: todoItems.title!, createdAt: "\(todoItems.createdAt!)")
                    }.onDelete {indexSet in
                        let deleteItem = self.toDoItems[indexSet.first!]
                        self.manageObjectContext.delete(deleteItem)
                        
                        do {
                            try self.manageObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("To-Do List"))
            .navigationBarItems(leading: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
