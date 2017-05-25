//
//  Path+modification.swift
//  genstrings
//
//  Created by Quinn McHenry on 4/12/17.
//
//

import FileKit

extension Path {
    
    // Returns true if this Path has been modified since comparePath's modificationDate
    func modified(since comparePath: Path?) -> Bool {
        guard let modificationDate = modificationDate, let compareModificationDate = comparePath?.modificationDate else {
            return false
        }
        return modificationDate > compareModificationDate
    }
        
}
