//
//  NoteCategory.swift
//  Notas
//
//  Created by Raul Paneque on 11/13/23.
//

import SwiftUI
import SwiftData

@Model
class NoteCategory {
    var categoryTitle:String
    
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
        
    }
}
