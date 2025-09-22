<%
/**
    ===== MID(상점아이디) =====
    상점아이디는 헥토파이낸셜에서 상점으로 발급하는 상점의 고유한 식별자입니다.
    테스트환경에서의 MID는 다음과 같습니다.
        nxca_jt_gu : 구인증 결제(카드번호, 유효기간, 생년월일, 카드비번)
        nxca_jt_bi : 비인증 결제(카드번호, 유효기간)
    상용서비스시에는 헥토파이낸셜에서 발급한 상점 고유 MID를 설정하십시오.
*/
// final String PG_MID = "nxca_jt_bi";
final String PG_MID = "nxca_ks_gu";
final String PG_CANCEL_MID = "nxca_jt_il";



/**
    ===== 라이센스키 =====  
    회원사 mid당 하나의 라이센스키가 발급되며 SHA256 해시체크 용도로 사용됩니다. 이 값은 외부에 노출되어서는 안 됩니다.
    테스트환경에서는 ST1009281328226982205 값을 사용하시면 되며,
    상용서비스시에는 헥토파이낸셜에서 발급한 상점 고유 라이센스키를 설정하십시오.
*/
final String LICENSE_KEY = "ST1009281328226982205";



/**
    ===== AES256 암호화 키 =====    
    파라미터 AES256암/복호화에 사용되는 키 입니다. 이 값은 외부에 노출되어서는 안 됩니다.
    테스트환경에서는 pgSettle30y739r82jtd709yOfZ2yK5K를 사용하시면 됩니다.
    상용서비스시에는 헥토파이낸셜에서 발급한 상점 고유 암호화키를 설정하십시오.
*/
final String AES256_KEY = "pgSettle30y739r82jtd709yOfZ2yK5K";



/**
*   ===== 결제/취소 서버 URL =====
*   헥토파이낸셜 결제/취소 서버 URL입니다. 이 값은 변경하지 마십시오. 
*   필요에 따라 주석 on/off 하여 사용하십시오.
*/
final String SERVER_URL = "https://tbgw.settlebank.co.kr";//테스트서버 url
//final String SERVER_URL = "https://gw.settlebank.co.kr";//운영서버 url




/** 헥토파이낸셜 API통신 Connect Timeout 설정(ms) */
final int CONN_TIMEOUT = 5000;

/** 헥토파이낸셜 API통신 Read Timeout 설정(ms) */
final int READ_TIMEOUT = 25000;

%>
