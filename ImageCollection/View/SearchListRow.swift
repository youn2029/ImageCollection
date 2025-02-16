//
//  SearchListRow.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import SwiftUI

struct SearchListRow: View {
    @Binding var searchData: SearchVO
    @State private var isPresentWebView: Bool = false
    let handler: (() -> Void)?
    
    var day: String { return Date.formatDateToDayString(date: searchData.datetime)}
    var time: String { return Date.formatDateToTimeString(date: searchData.datetime)}
    
    var body: some View {
        ZStack {
            thumbnailView
            .overlay {
                VStack(spacing: 2) {
                    favouritView
                    Spacer()
                    dateTimeView(text: day)
                    dateTimeView(text: time)
                }
                .padding(5)
            }
        }
        .onTapGesture {
            if searchData.isFavorite { return }
            searchData.isFavorite = true
            if searchData.isFavorite, let handler = handler { handler() }
        }
    }
}


// MARK: - view
private extension SearchListRow {
    var thumbnailView: some View {
        AsyncImage(url: URL(string: searchData.thumbnail)) { img in
            img
                .resizable()
                .scaledToFill()
                .frame(width: ComponentFrame.gridMaximumWidth, height: 140)
                .cornerRadius(5)
        } placeholder: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: .random(in: 0...1),
                            green: .random(in: 0...1),
                            blue: .random(in: 0...1),
                            opacity: 1
                           ))
                .frame(height: 140)
        }
    }
    
    var favouritView: some View {
        HStack {
            Spacer()
            Image(systemName: "heart.fill")
                .renderingMode(.template)
                .foregroundColor(searchData.isFavorite ? .pink : .black.opacity(0.7))
                .font(.system(size: 25))
        }
    }
    
    func dateTimeView(text: String) -> some View {
        HStack{
            Spacer()
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.white)
                .padding(.horizontal, 3)
                .background(Color.black.opacity(0.5).cornerRadius(5))
        }
    }
}

// MARK: - preview
struct SearchListRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchListRow(
            searchData: .constant(SearchVO(thumbnail: "https://search1.kakaocdn.net/argon/130x130_85_c/LUcYO9xSr96",
                                           doc_url: "https://yojumman.tistory.com/148")),
            handler: nil
        )
    }
}
