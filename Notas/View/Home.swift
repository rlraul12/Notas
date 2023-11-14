//
//  Home.swift
//  Notas
//
//  Created by Raul Paneque on 11/13/23.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var selectedTag:String? = "All Notes"
    @Query(animation: .snappy) private var categories:[NoteCategory]
    
    @Environment(\.modelContext) private var context
    
    @State private var addCategory: Bool = false
    @State private var categoryTitle:String = ""
    @State private var requestedCategory: NoteCategory?
    @State private var deleteRequest: Bool = false
    @State private var renameRequest: Bool = false
    @State private var isDark: Bool = false
    
    var body: some View {
        NavigationSplitView{
            List(selection: $selectedTag){
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundStyle(selectedTag=="All Notes" ? Color.primary: .gray)
                
                Text("Favourites")
                    .tag("Favourites")
                    .foregroundStyle(selectedTag=="Favourites" ? Color.primary: .gray)
                
                Section{
                    ForEach(categories){ category in
                        Text(category.categoryTitle)
                            .tag(category.categoryTitle)
                            .foregroundStyle(selectedTag==category.categoryTitle ? Color.primary: .gray)
                            .contextMenu{
                                Button("Rename"){
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    renameRequest = true
                                }
                                Button("Delete"){
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    deleteRequest = true
                                }
                            }
                    }
                }header: {
                    HStack(spacing: 5){
                        Text("Categories")
                        
                        Button("", systemImage: "plus"){
                            addCategory.toggle()
                        }
                        .tint(.gray)
                        .buttonStyle(.plain)
                    }
                }
            }
        }detail: {
            NotesView(category: selectedTag, allCategories:categories)
        }
        .navigationTitle(selectedTag ?? "Notes")
        .alert("Add Category", isPresented:$addCategory){
            TextField("Work", text: $categoryTitle)
            
            Button("Cancel", role: .cancel){
                categoryTitle = ""
            }
            Button("Add"){
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
        }
        .alert("Rename Category", isPresented:$renameRequest){
            TextField("Work", text: $categoryTitle)
            
            Button("Cancel", role: .cancel){
                categoryTitle = ""
                requestedCategory = nil
            }
            Button("Rename"){
                if let requestedCategory{
                    requestedCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
                
            }
        }
        .alert("Are you sure to delete \(categoryTitle) category?", isPresented:$deleteRequest){
            Button("Cancel", role: .cancel){
                categoryTitle = ""
                requestedCategory = nil
            }
            Button("Delete", role: .destructive){
                if let requestedCategory{
                    context.delete(requestedCategory)
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
                
            }
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                HStack(spacing: 10){
                    Button("", systemImage: "plus"){
                        let note = Note(content: "")
                        context.insert(note)
                    }
                    Button("", systemImage: isDark ? "sun.min" : "moon"){
                        isDark.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
