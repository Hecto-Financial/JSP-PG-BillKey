# JSP-PG-BillKey

헥토파이낸셜 신용카드 비/구인증(빌키) API 연동을 위한 JSP 샘플 코드입니다.

> 공식 개발자 문서: [https://developers.hectofinancial.co.kr/docs/api/pg/credit-card/06-card-billkey-issue](https://developers.hectofinancial.co.kr/docs/api/pg/credit-card/06-card-billkey-issue)

## 개요

본 샘플코드는 **API 직접 호출(Non-UI) 방식**이며, 결제창(UI) 방식이 아닙니다.

- 결제창(UI) 방식을 원하실 경우, 표준결제창 연동을 이용하시면 됩니다.
- 1회차는 Non-UI 또는 UI 방식으로 취사선택하여 결제하시면 됩니다.
- 2회차 결제는 발급받으신 빌키로 API 직접 호출하여 결제하시면 됩니다.

**보안 안내**: 첨부된 JSP 샘플소스는 Log4j 2에서 발생하는 원격코드 실행 취약점(CVE-2021-44228)에 영향이 없습니다.

## 파일 구조

```
/(Project Root Directory)
├── .classpath                          # Eclipse 프로젝트 정보
├── .project                            # Eclipse 프로젝트 정보
├── .settings/                          # Eclipse 프로젝트 설정
├── src/
│   ├── logback.xml                     # Logback 로그 설정파일 (* 자사에 맞게 변경 필요)
│   └── com/settle/pg/
│       ├── EncryptUtil.java            # AES256 암복호화 및 SHA256 해시 유틸
│       ├── HttpClientUtil.java         # HTTP 통신 유틸
│       └── StringUtil.java             # 문자열 유틸
└── WebContent/
    ├── index.html                      # 인덱스 페이지
    ├── config.jsp                      # 기본정보 설정파일 (* 자사에 맞게 변경 필요)
    ├── pay_form.jsp                    # 결제 API 양식 (빌키 발급 포함)
    ├── billKey_form.jsp                # 빌키 결제 API 양식
    ├── pay_showResult.jsp              # 결제 처리 및 결과 출력
    ├── authAPI_form.jsp                # 빌키 발급 API 양식 (결제 없이 빌키만 발급)
    ├── authAPI_showResult.jsp          # 빌키 발급 처리 및 결과 출력
    ├── cancel_form.jsp                 # 취소 요청 폼
    ├── cancel_showResult.jsp           # 취소 처리 및 결과 출력
    ├── receiveNoti.jsp                 # 결제/취소 완료 후 노티 수신 페이지
    ├── processNoti.jsp                 # 노티 수신 후 처리 로직
    └── WEB-INF/lib/                    # 의존성 JAR 패키지
```

## 파일 설명

### 공통 파일
- **config.jsp**: 상점아이디, 암복호화키, 서버 URL 등을 설정합니다. 운영 환경에서는 반드시 실제 값으로 교체해야 합니다.
- **EncryptUtil.java**: AES-256-ECB 암복호화(Base64 인코딩) 및 SHA-256 해시 생성 유틸 클래스입니다.
- **HttpClientUtil.java**: 헥토파이낸셜 서버와의 HTTP 통신을 처리하는 유틸 클래스입니다.
- **receiveNoti.jsp**: 결제 또는 취소 완료 후, 헥토파이낸셜 서버에서 가맹점으로 전달하는 노티(결과통보)를 수신하는 페이지입니다.
- **processNoti.jsp**: 노티 수신 후 성공/실패에 따라 가맹점 내부 로직을 처리하는 메소드를 정의한 파일입니다.

### 결제 관련 파일
- **pay_form.jsp**: 신용카드 결제 API 양식입니다. 빌키 서비스 상점의 경우 응답으로 빌키가 함께 발급됩니다.
- **billKey_form.jsp**: 기발급된 빌키로 결제하는 API 양식입니다.
- **pay_showResult.jsp**: 헥토파이낸셜과 Server to Server 통신으로 결제를 요청하고 결과를 출력합니다.
- **authAPI_form.jsp**: 결제 없이 빌키만 발급받는 API 양식입니다.
- **authAPI_showResult.jsp**: 헥토파이낸셜과 Server to Server 통신으로 빌키 발급을 요청하고 결과를 출력합니다.

### 취소 관련 파일
- **cancel_form.jsp**: 취소 요청 시 필요한 정보를 입력받는 폼 페이지입니다.
- **cancel_showResult.jsp**: 헥토파이낸셜과 Server to Server 통신으로 취소를 요청하고 결과를 출력합니다.

## 페이지 처리 순서

| 기능 | 순서 |
|------|------|
| 결제 API (빌키 발급 포함) | pay_form.jsp → pay_showResult.jsp |
| 빌키 결제 API | billKey_form.jsp → pay_showResult.jsp |
| 빌키 발급 API | authAPI_form.jsp → authAPI_showResult.jsp |
| 취소 처리 | cancel_form.jsp → cancel_showResult.jsp |
| 노티 처리 | receiveNoti.jsp → processNoti.jsp |

## config.jsp 설정 변수

| 변수명 | 설명 |
|--------|------|
| `PG_MID` | 상점아이디. 테스트용 MID는 소스에 기재되어 있습니다. 운영 시 헥토파이낸셜에서 발급한 MID로 교체하세요. **외부 노출 금지** |
| `LICENSE_KEY` | MID당 1개 발급되는 라이센스키. SHA256 해시 생성에 사용됩니다. **외부 노출 금지** |
| `AES256_KEY` | 개인정보/민감정보 AES256 암복호화에 사용되는 키. **외부 노출 금지** |
| `SERVER_URL` | 헥토파이낸셜 API 서버 URL. 테스트/운영 서버 주석을 전환하여 사용합니다. |
| `CONN_TIMEOUT` | HTTP 연결 타임아웃 (밀리초) |
| `READ_TIMEOUT` | HTTP 수신 타임아웃 (밀리초) |

## 노티(Noti) 수신

결제 또는 취소 완료 후 헥토파이낸셜 서버에서 가맹점의 `receiveNoti.jsp`를 콜백 호출합니다.

- 노티 수신 후 가맹점 내부 데이터/DB 처리를 완료한 경우 `"OK"`를 반환합니다.
- 처리 실패 시 `"FAIL"`을 반환하면 설정된 횟수만큼 노티가 재전송됩니다.

## 테스트 환경

- 테스트 서버: `https://tbgw.settlebank.co.kr`
- 테스트 MID 및 키 정보는 개발자 문서를 참고하세요.
- 테스트 환경에서는 **실제 카드번호 사용을 금지**합니다. 테스트용 가상 카드번호를 사용하세요.

## 문의

- 기술 문의: [헥토파이낸셜 개발자 센터](https://developers.hectofinancial.co.kr)
- 가맹점 문의: 1688-5130
