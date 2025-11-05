# MovieDiary
`TMDB API`를 활용하여 영화 정보를 탐색하고, 사진과 함께 감상평을 기록하는 iOS Native Application



## 주요 기능
- **영화 정보 탐색** </br>
  : '상영 중인 영화'와 '역대 인기 영화' 목록을 탭으로 전환

- **영화 검색** </br>
  : 네비게이션 바의 검색 기능을 통해 원하는 영화 검색
- **상세 정보** </br>
  : 포스터, 줄거리, 장르, 평점, 개봉일, 감독/배우, 시청 가능 플랫폼 정보 확인
- **예고편 재생** </br>
  : 앱 내에서 YouTube 예고편 재생
- **시청 가능 플랫폼** </br>
  : 해당 영화를 볼 수 있는 OTT 플랫폼(구독, 구매) 정보 제공
- **감상 기록 작성** </br>
  : 감상평, 별점, 날짜와 함께 위치, 사진을 첨부하여 일기 작성
- **로컬 저장** </br>
  : `SwiftData`를 사용하여 모든 기록을 기기에 저장
- **기록 관리** </br>
  : '기록' 탭에서 내가 작성한 일기 조회/수정/삭제, 월별/장르별 통계 제공


## 기술 스택 및 라이브러리

- **UI**: `SwiftUI`

- **Data Persistence**: `SwiftData`

- **Media**: `PhotosPicker`

- **Networking**: `Alamofire`

- **Dependency Injection**: `Swinject`

- **Asynchronous Image Loading**: `Kingfisher`

- **Video Player**: `YouTubePlayerKit`

- **Calendar**: `HorizonCalendar`

- **API**: `TMDB(The Movie Database)`, `Kakao Maps`


## 아키텍처

- **`MVVM(Model-View-ViewModel)`**

  - `ObservableObject`를 채택한 `InfoViewModel`이 뷰의 상태 관리

  - `ContentView`에서 `InfoViewModel`, `DiaryViewModel`, `LocationViewModel`을 `@StateObject`로 생성하고 `.environmentObject` 로 `environment`에 주입

  - 하위 뷰에서는 `@EnvironmentObject`로 의존성 공유

- **`Dependency Injection(Swinject)`**

  - `AppAssembly`에서 `MovieService`, `LocationService`, `InfoViewModel`, `DiaryViewModel`, `LocationViewModel`, `ContentView` 간의 의존성 정의/주입

  - `MovieDiaryApp` 진입점에서 `Assembler`와 `Container` 설정

- **`Service Layer`**

  - `MovieService`, `LocationService`를 통해 API 네트워킹 로직 추상화

  - `MovieServiceProtocol`, `LocationServiceProtocol을` 정의하여 `ViewModel`이 구체 타입이 아닌 프로토콜에 의존하도록 설계

- **`State Management`**

  - `ViewState`(idle, loading, success, failure) 열거형을 정의하여 API 요청 상태를 명확하게 관리

- **`Caching`**

  - `InfoViewModel` 내 `requestWithCache` 함수를 통해 '현재 상영작'과 '인기작' 목록을 메모리에 캐시하여, 불필요한 API 호출을 줄이도록 최적화
