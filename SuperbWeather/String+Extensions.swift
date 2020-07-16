//
//  Date+Extensions.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

extension String {
    
    func dayOfTheWeek() -> String? {
      let formatter  = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let todayDate = formatter.date(from: self) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE HH:mm"
        return dateFormatter.string(from: todayDate)
    }
}
