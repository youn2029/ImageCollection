//
//  SearchListView.swift
//  ImageCollection
//
//  Created by 윤성호 on 2025/02/12.
//

import SwiftUI
import Combine

struct SearchListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.injected) private var injected: DIContainer
    @State private var cancelBag = Set<AnyCancellable>()
    
    @State private var isLoading: Bool = false
    @State private var inputText = ""
    @State private var page = 1
    @State private var searchList: [SearchVO] = []
    
    @FocusState private var isFocused: Bool
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            ScrollView(showsIndicators: false) {
                listView
                if isLoading { loadingView }
                GeometryReader { proxy in
                    Color.clear.preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .global).maxY)
                }
            }
            .padding(.horizontal, 16)
            .onPreferenceChange(ScrollOffsetKey.self) { maxY in
                let screenHeight = UIScreen.main.bounds.height
                if maxY < screenHeight + 100 && !isLoading && !inputText.isEmpty { // 바닥 근처 도달하면
                    self.page += 1
                    fetchSearch(parameter: SearchRequest(query: inputText, page: self.page))
                }
            }
        }
    }
}

// MARK: - view
private extension SearchListView {
    var searchBar: some View {
        ZStack(alignment: .center) {
            HStack(spacing: 0) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(10)
                }
                .padding(.trailing, 6)
                
                TextField("검색어를 입력해주세요.", text: $inputText)
                    .focused($isFocused)
                    .keyboardType(.default)
                    .onSubmit {
                        searchList.removeAll()
                        fetchSearch(parameter: SearchRequest(query: inputText))
                    }
                    .submitLabel(.search)
                    .accessibilityLabel("검색창")
            }
            .padding(.horizontal, 4)
        }
        .frame(height: 80)
    }
    
    var listView: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(searchList.indices, id: \.self) { index in
                SearchListRow(searchData: $searchList[index]) {
                    saveCollection(searchVO: searchList[index])
                }
            }
        }
    }
    
    var loadingView: some View {
        ProgressView("로딩 중...").padding()
    }
}

// MARK: - method
private extension SearchListView {
    func fetchSearch(parameter: SearchRequest) {
        guard !isLoading else { return } // ✅ 중복 요청 방지
        isLoading = true
        
        injected.interactors.searchInteractor.searchList(param: parameter)
            .sinkToResult { result in
                switch result {
                case .success(let list):
                    searchList.append(contentsOf: list.sorted{ $0.datetime > $1.datetime })
                case .failure(let error):
                    Console.error(error.localizedDescription + " --- \(#function)")
                }
                isLoading = false
            }
            .store(in: &cancelBag)
    }
    
    func saveCollection(searchVO: SearchVO) {
        injected.interactors.collectionInteractor.save(searchVo: searchVO)
            .sinkToResult { result in
                switch result {
                case .success():
                    Console.log("내 보관함에 저장했습니다.")
                case .failure(let error):
                    Console.error(error.localizedDescription + " --- \(#function)")
                }
            }
            .store(in: &cancelBag)
    }
}

// MARK: - preview
struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView()
    }
}
