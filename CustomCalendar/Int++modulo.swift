//
//  Int++modulo.swift
//  CustomCalendar
//
//  Created by Ярослав Ульяненков on 26.05.2023.
//

import Foundation

infix operator %%

extension Int {
    static  func %% (_ left: Int, _ right: Int) -> Int {
        if left >= 0 { return left % right }
        if left >= -right { return (left+right) }
        return ((left % right)+right)%right
    }
}
