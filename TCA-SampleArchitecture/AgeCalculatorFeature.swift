//
//  AgeCalculator.swift
//  TCA-SampleArchitecture
//
//  Created by Ramakrishnan, Balaji (Cognizant) on 11/07/24.
//

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct AgeCalculatorFeature {
    
    @ObservableState
    struct State : Equatable {
        var birthdate : Date?
        var ageInYears : Int!
        var ageInMonths : Int!
        var ageInDays : Int!
        var ageInHours : Int!
        var ageInMins : Int!
        var ageInSecs : Int!
    }
    
    enum Action : Equatable {
        case clearData
        case calculateAge
        case updateBirthdate(date: Date)
    }
    
    var body: some Reducer<AgeCalculatorFeature.State, AgeCalculatorFeature.Action> {
        Reduce { state, action in
            switch action {
            case .calculateAge:
                guard let birthdate = state.birthdate else {return .none}
                calculateAge(type: action, birthdate: birthdate, state: &state)
                return .none
            case .updateBirthdate(let date):
                state.birthdate = date
            case .clearData:
                state.birthdate = nil
                state.ageInYears = nil
                state.ageInMonths = nil
                state.ageInDays = nil
                state.ageInHours = nil
                state.ageInMins = nil
                state.ageInSecs = nil
            }
            return .none
        }
    }
    
    func calculateAge(type: Action, birthdate: Date, state: inout State) {
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: birthdate, to: Date())
        if let years = dateComponent.year, let months = dateComponent.month, let days = dateComponent.day, let hours = dateComponent.hour, let mins = dateComponent.minute, let secs = dateComponent.second {
            state.ageInYears = years
            state.ageInMonths = months
            state.ageInDays = days
            state.ageInHours = hours
            state.ageInMins = mins
            state.ageInSecs = secs
        }
    }
}
