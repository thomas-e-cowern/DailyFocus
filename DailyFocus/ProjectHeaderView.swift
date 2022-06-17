//
//  ProjectHeaderView.swift
//  DailyFocus
//
//  Created by Thomas Cowern New on 6/17/22.
//

import SwiftUI

struct ProjectHeaderView: View {
    
    @ObservedObject var project: Project
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                
                ProgressView(value: project.completionAmount)
            }
            
            Spacer()
            
            NavigationLink {
                EmptyView()
            } label: {
                Image(systemName: "square.and.pencil")
            }

        }
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
