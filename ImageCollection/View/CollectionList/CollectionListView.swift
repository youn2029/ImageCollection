//
//  CollectionListView.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import SwiftUI
import Combine

struct CollectionListView: View {
    @Environment(\.injected) private var injected: DIContainer
    @State private var cancelBag = Set<AnyCancellable>()
    @State var isPresent: Bool = false
    
    @State var collectionList: [CollectionVO] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            headerView
            ScrollView(showsIndicators: false) {
                listView
            }
        }
        .sheet(isPresented: $isPresent) {
            SearchListView().inject(injected)
                .onDisappear() { fetchCollectionList() }
        }
        .onAppear() {
            fetchCollectionList()
        }
    }
}

private extension CollectionListView {
    private var headerView: some View {
        HStack {
            Text("내 보관함")
                .font(.title2)
                .bold()
            Spacer()
            Button {
                self.isPresent = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .font(.system(size: 25))
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 16)
    }
    
    private var listView: some View {
        LazyVGrid(columns: columns, spacing: 9) {
            ForEach(collectionList.indices, id: \.self) { index in
                CollectionListRow(collectionVO: collectionList[index])
            }
        }
        .padding(.horizontal, 16)
    }
}

private extension CollectionListView {
    func fetchCollectionList() {
        injected.interactors.collectionInteractor
            .fetchCollection()
            .sinkToResult { result in
                switch result {
                case .success(let list):
                    collectionList.removeAll()
                    collectionList.append(contentsOf: list)
                case .failure(let error):
                    Console.error(error.localizedDescription + " --- \(#function)")
                }
            }
            .store(in: &cancelBag)
    }
}

struct CollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionListView()
    }
}
