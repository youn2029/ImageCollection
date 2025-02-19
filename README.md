# Image Collection
카카오 검색 API를 통해 사진과 동영상을 동시에 검색하여 내 보관함에 수집하는 프로젝트입니다.

<img src="https://github.com/user-attachments/assets/0cd81eaf-ffe6-4747-8ebd-120031e4328f" width="250">

<br>
<br>

## 🔎  요구사항
- 카카오 검색 API를 통새 사진 API와 동영상 API를 병합해서 출력
- 검색한 데이터는 최신순으로 정렬
- 스크롤을 내려서 데이터 가져오기 (페이징처리)
- 검색 결과를 클릭하면 '내 보관함'에 저장 (로컬 DB)
- 검색 결과는 캐시를 이용하여 5분 이내 동일 키워드를 검색하면 네트워크 통신없이 출력

<br>

## 💻 프로젝트
- Interface : SwiftUI
- Network : URLSession, Combine
- Design Pattern : Clean Architecture
- DataBase : CoreData

<br>

## 🎯 트러블슈팅
- 기존 CoreData 구현 방식이 디자인 패턴과 맞지 않는다고 판단되어 **클린 아키텍처에 맞게 개발**하였습니다. CoreData의 FatchRequest를 통해 리스트를 자동으로 조회하지 않고, 검색 화면에서 데이터를 저장하고 검색화면이 **disappear되었을 때 수동으로 CoreData를 호출**하여 갱신했습니다.
- CoreData의 Entity 설정 시 클래스 codegen이 Entity와 Attribute를 각각 클래스화, 프로퍼티화 시켜주기위해 Class를 자동/수동으로 만들지를 결정하는 항목입니다. 저는 다른 구조로 개발중이였기 때문에 CoreDataClass파일과 CoreDataProperties 파일을 커스텀하였는데 Codegen을 'Manual/None'으로 설정하지 않아 오류를 통해 알게되었습니다.

<br>

## 🧰 느낀 점
- 검색 걸과를 캐시에 저장을 하고 동일한 검색어가 나왔을 때 캐시에서 불러와서 출력하게 구현했지만 결과가 캐시에 저장은 되지만 같은 검색어여도 캐시에서 불러오지 않았습니다. 예상되는 원인은 Request값이 완벽하게 동일하지 않아 캐시에서 불러오지 못했습니다. 캐시를 저장할 때 key값이 request가 아닌 검색어로 수정하면 효율적으로 캐시를 활용할 수 있을거 같습니다.
- xcode 버전이 낮아 CoreData를 사용하였는데 버전을 올리고 나서 SwiftData를 적용도 해보고 싶었고, Combine에 대해 더 공부할 수 있었던 프로젝트였습니다. 완벽하게 이해하고 개발할 수 있도록 더 열심히 공부해야겠다고 느꼈습니다.

<br>

## 🔗 참조
- [카카오 검색 API Document](https://developers.kakao.com/product/search) <br>
- [Core Data](https://developer.apple.com/documentation/coredata) <br>
- [Generating code](https://developer.apple.com/documentation/coredata/modeling_data/generating_code) <br>
- [SwiftUI를 위한 클린 아키텍처](https://gon125.github.io/posts/SwiftUI%EB%A5%BC-%EC%9C%84%ED%95%9C-%ED%81%B4%EB%A6%B0-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98/) <br>
