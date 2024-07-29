//
//  SurveyView.swift
//  CPDChat
//
//  Created by Fariseu, Teodora on 1/22/24.
//

import SwiftUI
import Firebase

enum IceCream: String, CaseIterable {
    case chocolate, vanilla, strawberry, bubblegum, hazlenut, pineapple, oreo
    
    var value: String {
        self.rawValue.uppercased()
    }
}

class IceCreamSurvey: ObservableObject {
    var name: String = ""
    var flavor: IceCream = .chocolate
    var subscribed: Bool = false
    
    var eventParameters: [String: Any] {
        [ "participant": name,
          "selected_flavor": flavor.value,
          "picked_subscription": subscribed
        ]
    }
}

struct SurveyView: View {
    @StateObject var surveyInfo = IceCreamSurvey()
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("name", text: $surveyInfo.name)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(30)
                    .padding(.vertical)
                Picker("Favorite ice cream", selection: $surveyInfo.flavor) {
                    ForEach(IceCream.allCases, id: \.self) { flavor in
                        Text(flavor.rawValue)
                    }
                }.padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .foregroundColor(.teal)
                    .cornerRadius(30)
                Toggle(isOn: $surveyInfo.subscribed) {
                    Text("Subscribe to our newsletter")
                }
                
                Button("Submit") {
                    Analytics.logEvent("survey_submitted", parameters: surveyInfo.eventParameters)
                }.padding()
                    .frame(maxWidth: .infinity)
                    .background(.teal)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
        }.navigationTitle("Survey")
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
