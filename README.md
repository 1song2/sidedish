# 온라인 반찬 서비스

반찬 주문 앱 **배민찬** 클론 프로젝트



코드스쿼드 마스터즈 코스에서 진행했던 팀프로젝트를 과정 종료 후 리팩토링 했습니다.

- 팀 구성

- - Back-end: 2인 ([정](https://github.com/rla36), [연](https://github.com/kimnayeon0108))
  - Mobile iOS: 2인 ([쏭](https://github.com/1song2), [잭슨](https://github.com/JacksonPk))

- 개발 기간: 2021.4.19 ~ 2021.4.30 (2주)

- 리팩토링 기간: 2021.10.8 ~ 2021.10.18

## 기본 동작

### 메인 페이지

![sidedish-main](https://user-images.githubusercontent.com/56751259/137713735-4cbb3281-164e-40b4-9e49-9e1f8e1be0bc.gif)

* 메인 화면은 세 가지 섹션으로 구분 되어있다. (메인요리 / 국물요리 / 밑반찬)
* 섹션 헤더를 누르면 섹션에 포함된 상품 개수를 표시한다.
* 상품을 누르면 상세 페이지로 이동한다.

### 상품 상세 페이지

* 상품 이미지를 페이지처럼 가로로 넘겨 확인할 수 있다.
  ![sidedish-detail-paging2](https://user-images.githubusercontent.com/56751259/137716131-0c594e01-e6f3-408d-99eb-3e2fb1214534.gif)
* 기본 상품 정보와 상품 상세 설명 이미지를 확인할 수 있다. 정보가 많아 스크린 내에서 다 표현이 어려운 경우, 화면을 아래로 스크롤해서 전체 정보를 모두 확인할 수 있다.
  ![sidedish-detail-scroll](https://user-images.githubusercontent.com/56751259/137714651-7ba8fe0d-4966-4444-a6ce-b9739acbee73.gif)
* 수량 증가, 감소 버튼을 눌러 원하는 주문 수량을 선택할 수 있다.
  ![sidedish-detail-quantity](https://user-images.githubusercontent.com/56751259/137715743-b7e9bd4f-023d-489e-881f-8dda023ab1d0.gif)
  * 최소 주문 수량에서는 감소 버튼이 비활성화 된다.
  * 수량에 따라 총 주문 금액이 자동으로 업데이트 된다.

## 상세 구현 내용

### 1. Auto Layout 적용

| iPod touch (7th gen) - Portrait                              | iPhone 13 - Portrait                                         | iPad Air - Portrait                                          | iPhone 13 - Landscape                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![iPod touch (7th gen) - Portrait](https://user-images.githubusercontent.com/56751259/137702996-ec448346-aad6-41c5-8822-9ffc2b2d1b8c.png) | ![iPhone 13 - Portrait](https://user-images.githubusercontent.com/56751259/137703343-12ae7aa0-b0b6-418c-88e4-895140ca8a34.png) | ![iPad Air - Portrait](https://user-images.githubusercontent.com/56751259/137703535-3d0fdf0e-82cb-46ea-9fba-783c7bfc755c.png) | ![iPhone 13 - Landscape](https://user-images.githubusercontent.com/56751259/137704026-bfdd3e8b-fd3b-4b6d-8f3d-8b6e0780e698.png) |

* 다양한 종류의 기기, 방향 등에 대응하도록 Auto Layout을 적용했다.

### 2. MVVM

[MVVM 관련 예제 코드](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)를 학습하고 프로젝트에 적용해보았다.

* 레이어 계층
  * 도메인 레이어
    * 엔티티: 메인 페이지의 반찬 정보를 보여주는 데 사용하는 `Dish` 엔티티와 상세 페이지의 추가 정보를 보여주는 데 사용하는 `DishDetail` 엔티티를 구조체로 생성했다.
  * 데이터 레이어
    * 레포지토리: 내부에 `NetworkService` 객체를 가지고 반찬 목록, 반찬 상세 정보, 반찬 이미지를 가져올 수 있는 레포지토리 클래스를 각각 생성했다. 각 클래스가 프로토콜을 채택하도록 해 한번 더 추상화를 해주었다.
    * API (네트워크): `NetworkService` 객체를 생성해 네트워크 통신을 처리해주었다. 예제코드는 `URLSession`을 사용하는 반면 이 프로젝트에서는 `Alamofire` 라이브러리를 활용했다. 추후 테스트를 하기 위해 `Alamofire`에 의존성이 높은 부분은 따로 프로토콜로 작성해 추상화 해주었다.
  * 프레젠테이션 레이어 (MVVM)
    * 뷰모델: 세 가지 섹션을 가진 반찬 목록을 뷰모델로 구현하기 위해 많은 고민을 했다. 리팩토링을 통해 최상단 `DishesViewModel`이 `CategoryViewModel`을 배열로 가지고 있고 각 `CategoryViewModel`이 섹션 관련 정보와 반찬 아이템들을 내부 속성으로 가지고 있는 지금의 구조를 완성했다.
    * 뷰: 각 뷰컨트롤러에서는 바인딩을 통해 뷰가 뷰모델의 상태 변화를 옵저빙할 수 있게 해주었다. 이를 통해 뷰모델의 속성값이 변경되면 자동으로 뷰를 업데이트한다. 메인 페이지의 섹션 헤더와 셀은 Xib로 구현해 재사용했다.

### 3. Dependency Injection

[같은 예제 코드](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)를 참고하여 의존성 주입을 학습하고 프로젝트에 적용해보았다.

* `SceneDelegate`의 `scene(_:willConnectTo:options:)` 메서드에서 루트 뷰컨트롤러를 탐지해 뷰모델, 레포지토리 등을 주입할 수 있도록 해주었다.
* 기존에 작성해두었던 스토리보드를 활용하기 위해 코드 기반으로 작성된 예제 코드를 응용해 스토리보드를 사용하는 상태에서 의존성 주입을 할 수 있는 방법을 학습하고 적용해주었다.

### 4. `reloadSections(_:)`를 활용한 섹션별 데이터 갱신

개인적으로 구현과 트러블 슈팅에 가장 애를 먹은 부분이었다.

* 리팩토링 전

  * 컬렉션뷰 전체를 리로드하는 `reloadData()` 대신 `reloadSections(_:)`를 이용해 응답이 온 섹션만 리로드를 하고자 의도했다.

    ```swift
    private func updateSection(at index: Int) {
        self.dishCollectionView.reloadSections(IndexSet(integer: index))
    }
    ```

  * 하지만 Invalid update 에러가 발생하며 `reloadSections(_:)`이 아닌 `reloadData()`가 호출되는 문제가 발생함을 확인할 수 있었다.

    > [UICollectionView] **Invalid update**: invalid number of items in section 0. 
    > The number of items contained in an existing section after the update (11)
    > must be equal to the number of items contained in that section before the update (0),
    > plus or minus the number of items inserted or deleted from that section (0 inserted, 0 deleted)
    > and plus or minus the number of items moved into or out of that section (0 moved in, 0 moved out). - **will perform reloadData.**

    * 테이블뷰나 컬렉션뷰에서 `reloadSections(_:)` 메서드를 사용할 때 리로드를 시도하는 섹션 외 다른 섹션에는 변동사항이 있어선 안된다.
    * 리로드 섹션에 이르는 과정은 다음과 같다: `API 요청` - `응답 도착` - `모델 업데이트` - `리로드 섹션 시도`
    * 문제는 **세 가지 API**를 각각 **비동기적**으로 요청하고 처리하기 때문에 제일 먼저 온 응답에 대한 리로드 섹션을 시도하는 도중 다른 모델도 변경되며 충돌이 발생할 수 있는 것이다. 

* 리팩토링 과정

  * 코드 리뷰어분께 힌트를 받아 API 요청은 비동기적으로 하더라도 그 이후 모델 변경과 뷰 업데이트를 **동기적**으로 처리해 해결하고자 시도했다.

    * 뷰컨트롤러에서 시리얼큐를 만들고 그 안에서 동기적으로 모델을 업데이트 하도록 했다.

      ```swift
      let serialQueue = DispatchQueue(label: "com.song.sectionQueue")
      // ...
      override func viewDidLoad() {
          super.viewDidLoad()
          // ...
          viewModel.load { index, items in
              self.serialQueue.sync {
                  self.viewModel.update(index: index, items: items)
              }
          }
      }
      ```

    * 모델이 변경되면 리로드 섹션을 할 수 있도록 뷰모델을 바인딩한다. 이때 리로드 섹션 작업 역시 `DispatchQueue.main.sync` 블록 안에서 동기적으로 처리한다. 

      ```swift
      private func bind(to viewModel: DishesViewModel) {
          viewModel.categories.enumerated().forEach { index, categoryViewModel in
              categoryViewModel.items.observe(on: self) { [weak self] _ in
                  self?.updateSection(at: index)
              }
          }
      }
      
      private func updateSection(at index: Int) {
          DispatchQueue.main.sync {
              self.dishCollectionView.reloadSections(IndexSet(integer: index))
          }
      }
      ```

* 배운 점

  * DispatchQueue를 학습하다 보면 `DispatchQueue.main.sync`는 절대 사용해선 안된다는 글이 종종 보인다. 잘못 사용하는 경우 데드락이 발생할 수 있기 때문에 유의해서 사용해야 하는 것은 맞지만 무조건 쓰면 안되는 건 아니다. 이 경우와 같이 백그라운드 스레드에서 이루어지는 작업들 사이에 순서에 맞게 메인 스레드에서 어떤 작업이 이루어져야 할 때는 `DispatchQueue.main.sync`를 사용해야 한다.

## 학습 키워드

MVVM, Dependency Injection, Clean Architecture, DispatchQueue, Alamofire

## Roadmap

- [ ] Cache
- [ ] RxSwift
- [ ] OAuth
- [ ] Tests
  - [ ] 단위 테스트
- [ ] 시퀀스 다이어그램 작성
- [ ] Custom transition 효과 적용

## References

* [kudoleh / iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
* [야곰닷넷 질문모음 – 6 - DispatchQueue에서 main.sync는 언제 사용하나요?](https://yagom.net/forums/topic/야곰닷넷-질문모음-6/)
