//
//  CollectionListRow.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/15.
//

import SwiftUI

struct CollectionListRow: View {
    @State var collectionVO: CollectionVO
    
    var day: String { return Date.formatDateToDayString(date: collectionVO.datetime)}
    var time: String { return Date.formatDateToTimeString(date: collectionVO.datetime)}
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: collectionVO.thumbnail)) { img in
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
            .overlay {
                VStack(spacing: 2) {
                    Spacer()
                    dateTimeView(text: day)
                    dateTimeView(text: time)
                }
                .padding(5)
            }
        }
        .onTapGesture {
            if let url = URL(string: collectionVO.doc_url) {
                UIApplication.shared.open(url)
            }
        }
    }
}


// MARK: - view
private extension CollectionListRow {
    
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

private extension CollectionListRow {
    
}

struct CollectionListRow_Previews: PreviewProvider {
    static var previews: some View {
        CollectionListRow(collectionVO: .stub())
    }
}
