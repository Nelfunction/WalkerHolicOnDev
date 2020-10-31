# WALKERHOLIC_ondev

 pub get -> google-services.json 파일 android/app/에 추가
 
 iOS는 GoogleService-Info.plist 관련 내용이 /ios/Runner.xcodeproj/project.pbxproj 에 작성되어 있음. 또는 Xcode로 파일 추가 

## currently dependent plug-in
```
  flame: ^0.26.0
  pedometer: ^2.0.2
  cloud_firestore: ^0.14.0+2
  firebase_core: ^0.5.0
  firebase_auth: ^0.18.0
  charts_flutter: ^0.8.0               <-------- UNUSED
  percent_indicator: ^2.1.7+2
  shared_preferences: ^0.5.3+2
  google_sign_in: ^4.0.14
  permission_handler: ^5.0.1+1
  activity_recognition_flutter: ^1.2.4+1
  foreground_service: ^2.0.1+1
```
## VS Code
 ![image](https://user-images.githubusercontent.com/20199960/97769000-a8f45400-1b6a-11eb-8453-1102e75541d5.png)
 
 U: Untracked (새로운 파일)
 M: Modified (변경됨)
 
## Github Desktop
![image](https://user-images.githubusercontent.com/20199960/97769373-a47d6a80-1b6d-11eb-89eb-9d95ac15942f.png)

 좌측 리스트는 순서대로 {삭제됨, 새 파일, 변경됨, 변경됨} 을 의미함
 
 아래 Summary와 Description을 작성하고 commit 가능.
 사진과 같은 상황에서는 Github의 remote 저장소에서도 새 commit이 있었기 때문에 merge 과정 필요 
 
![image](https://user-images.githubusercontent.com/20199960/97769149-da215400-1b6b-11eb-97c1-f7455a96e3fe.png)

 ↑ 같은 파일을 두개의 commit에서 수정하여 conflict가 발생한 모습
 
![image](https://user-images.githubusercontent.com/20199960/97769189-194fa500-1b6c-11eb-978d-aa4f29f9f207.png)

 편집기를 열어 merge가 발생한 부분을 수정하면 commit merge 버튼이 활성화되며 Push origin 가능

**새 branch 생성, branch간 merge는 어려울 수 있으니 가급적 새 파일에 내용을 추가한 뒤 디스코드로 이야기하고 push하기**
