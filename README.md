# MovieDiary
`TMDB API`를 활용하여 영화 정보를 탐색하고, 감상평을 기록하는 iOS Native Application



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
  : 감상평, 별점, 날짜, 장소와 함께 사진을 첨부하여 일기 작성
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

  - `ObservableObject`를 채택한 `ViewModel`이 뷰의 상태 관리
  - `ContentView`에서 `ViewModel`을 `@StateObject`로 생성하고 `.environmentObject` 로 `environment`에 주입
  - 하위 뷰에서는 `@EnvironmentObject`로 의존성 공유

- **`Dependency Injection(Swinject)`**

  - `AppAssembly`에서 `Service`, `ViewModel` 간의 의존성 정의/주입
  - `MovieDiaryApp` 진입점에서 `Assembler`와 `ModelContainer` 설정
  - `ContentViewWrapper`에서 `Resolver`를 사용해 `ViewModel`을 생성하고 `ModelContext`를 `DiaryViewModel`에 인자로 전달
  - `ContentView`가 `ContentViewWrapper`로부터 받은 모든 `ViewModel`을 `.environmentObject`로 주입하여 하위 뷰 어디서든 접근하도록 세팅

- **`Data & Service Layer`**

  - `Service`, `Protocol`을 통해 API 네트워킹 로직 추상화
  - `DataStore`을 싱글톤으로 구현하여 앱 전역에서 단일 `ModelContainer`에 접근하도록 함

- **`State Management`**

  - `ViewState(idle, loading, success, failure)` 열거형을 정의하여 API 요청 상태를 명확하게 관리

## 스크린샷

- 감상평
<div align="left">
  <img width="15%" height="15%" src="https://github.com/user-attachments/assets/4e8c2c22-109e-4b9f-b441-ed8901913fa6" />
  <img width="15%" height="15%" src="https://github.com/user-attachments/assets/0d5f37b8-bb4a-4352-9822-492c60960734" />
  <img width="15%" height="15%" src="https://github.com/user-attachments/assets/9db8c8e9-49cb-4f32-b0d8-56a66461e58f" />
  <img width="15%" height="15%" src="https://github.com/user-attachments/assets/7e0d69e0-fac4-4a40-8393-3130e8961825" />
  <img width="15%" height="15%" src="https://github.com/user-attachments/assets/2e195aeb-1047-4009-9eea-f17ccc59e90c" />
  <img width="15%" height="15%" src="https://github.com/user-attachments/assets/0d92a25b-8d17-49a5-bdd0-29e3701482ba" />
</div>
</br>

- 영화 정보
<div align="left">
  <img width="17%" height="17%" src="https://github.com/user-attachments/assets/4ce97ee2-8769-4af5-b51a-f4784ae73d00" />
  <img width="17%" height="17%" src="https://github.com/user-attachments/assets/372c0057-9e13-4763-8eae-55e510a30330" />
  <img width="17%" height="17%" src="https://github.com/user-attachments/assets/096160dd-13e1-4e06-bf51-507f12c6199b" />
  <img width="17%" height="17%" src="https://github.com/user-attachments/assets/808b169a-bb27-4424-aa18-293b8d4b15f1" /> 
</div>
</br>

- 기타 차트들
<div align="left">
<img width="30%" height="30%" src="https://github.com/user-attachments/assets/9d96a0c8-75a4-448e-9325-be238b50425c" />
<img width="30%" height="30%" src="https://github.com/user-attachments/assets/fb3305e2-c0d4-4333-858f-4f99811999a0" />
</div>
