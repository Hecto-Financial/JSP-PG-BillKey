<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.settle.pg.EncryptUtil"%>
<%@ page import="com.settle.pg.StringUtil"%>
<%@ page import="java.security.MessageDigest"%>
<%@ include file="config.jsp" %>
<%@ include file="processNoti.jsp" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
/** 이 페이지는 수정시 주의가 필요합니다. 수정시 html태그나 자바스크립트가 들어가는 경우 동작을 보장할 수 없습니다 */

/** 설정 정보 저장 */
String licenseKey = LICENSE_KEY;

/** 노티 처리 결과 */
boolean resp=false;

/** 노티 수신 파라미터 */
String outStatCd        = request.getParameter("outStatCd"      ) == null ? "" : request.getParameter("outStatCd"); 
String trdNo            = request.getParameter("trdNo"          ) == null ? "" : request.getParameter("trdNo"); 
String method           = request.getParameter("method"         ) == null ? "" : request.getParameter("method"); 
String bizType          = request.getParameter("bizType"        ) == null ? "" : request.getParameter("bizType"); 
String mchtId           = request.getParameter("mchtId"         ) == null ? "" : request.getParameter("mchtId"); 
String mchtTrdNo        = request.getParameter("mchtTrdNo"      ) == null ? "" : request.getParameter("mchtTrdNo"); 
String mchtCustNm       = request.getParameter("mchtCustNm"     ) == null ? "" : request.getParameter("mchtCustNm"); 
String mchtName         = request.getParameter("mchtName"       ) == null ? "" : request.getParameter("mchtName"); 
String pmtprdNm         = request.getParameter("pmtprdNm"       ) == null ? "" : request.getParameter("pmtprdNm"); 
String trdDtm           = request.getParameter("trdDtm"         ) == null ? "" : request.getParameter("trdDtm"); 
String trdAmt           = request.getParameter("trdAmt"         ) == null ? "" : request.getParameter("trdAmt"); 
String billKey          = request.getParameter("billKey"        ) == null ? "" : request.getParameter("billKey"); 
String billKeyExpireDt  = request.getParameter("billKeyExpireDt") == null ? "" : request.getParameter("billKeyExpireDt"); 
String bankCd           = request.getParameter("bankCd"         ) == null ? "" : request.getParameter("bankCd"); 
String bankNm           = request.getParameter("bankNm"         ) == null ? "" : request.getParameter("bankNm"); 
String cardCd           = request.getParameter("cardCd"         ) == null ? "" : request.getParameter("cardCd"); 
String cardNm           = request.getParameter("cardNm"         ) == null ? "" : request.getParameter("cardNm"); 
String telecomCd        = request.getParameter("telecomCd"      ) == null ? "" : request.getParameter("telecomCd"); 
String telecomNm        = request.getParameter("telecomNm"      ) == null ? "" : request.getParameter("telecomNm"); 
String vAcntNo          = request.getParameter("vAcntNo"        ) == null ? "" : request.getParameter("vAcntNo"); 
String expireDt         = request.getParameter("expireDt"       ) == null ? "" : request.getParameter("expireDt"); 
String AcntPrintNm      = request.getParameter("AcntPrintNm"    ) == null ? "" : request.getParameter("AcntPrintNm"); 
String dpstrNm          = request.getParameter("dpstrNm"        ) == null ? "" : request.getParameter("dpstrNm"); 
String email            = request.getParameter("email"          ) == null ? "" : request.getParameter("email"); 
String mchtCustId       = request.getParameter("mchtCustId"     ) == null ? "" : request.getParameter("mchtCustId"); 
String cardNo           = request.getParameter("cardNo"         ) == null ? "" : request.getParameter("cardNo"); 
String cardApprNo       = request.getParameter("cardApprNo"     ) == null ? "" : request.getParameter("cardApprNo"); 
String instmtMon        = request.getParameter("instmtMon"      ) == null ? "" : request.getParameter("instmtMon"); 
String instmtType       = request.getParameter("instmtType"     ) == null ? "" : request.getParameter("instmtType"); 
String phoneNoEnc       = request.getParameter("phoneNoEnc"     ) == null ? "" : request.getParameter("phoneNoEnc"); 
String orgTrdNo         = request.getParameter("orgTrdNo"       ) == null ? "" : request.getParameter("orgTrdNo"); 
String orgTrdDt         = request.getParameter("orgTrdDt"       ) == null ? "" : request.getParameter("orgTrdDt"); 
String mixTrdNo         = request.getParameter("mixTrdNo"       ) == null ? "" : request.getParameter("mixTrdNo"); 
String mixTrdAmt        = request.getParameter("mixTrdAmt"      ) == null ? "" : request.getParameter("mixTrdAmt"); 
String payAmt           = request.getParameter("payAmt"         ) == null ? "" : request.getParameter("payAmt"); 
String csrcIssNo        = request.getParameter("csrcIssNo"      ) == null ? "" : request.getParameter("csrcIssNo"); 
String cnclType         = request.getParameter("cnclType"       ) == null ? "" : request.getParameter("cnclType"); 
String mchtParam        = request.getParameter("mchtParam"      ) == null ? "" : request.getParameter("mchtParam"); 
String pktHash          = request.getParameter("pktHash"        ) == null ? "" : request.getParameter("pktHash"); 

/* 응답 파라미터 List에 저장 */
ArrayList<String> noti = new ArrayList<String>();
noti.add("거래상태:"+ outStatCd);
noti.add("거래번호:"+ trdNo);
noti.add("결제수단:"+ method);
noti.add("업무구분:"+ bizType);
noti.add("상점아이디:"+ mchtId);
noti.add("상점거래번호:"+ mchtTrdNo);
noti.add("주문자명:"+ mchtCustNm);
noti.add("상점한글명:"+ mchtName);
noti.add("상품명:"+ pmtprdNm);
noti.add("거래일시:"+ trdDtm);
noti.add("거래금액:"+ trdAmt);
noti.add("자동결제키:"+ billKey);
noti.add("자동결제키 유효기간:"+ billKeyExpireDt);
noti.add("은행코드:"+ bankCd);
noti.add("은행명:"+ bankNm);
noti.add("카드사코드:"+ cardCd);
noti.add("카드명:"+ cardNm);
noti.add("이통사코드:"+ telecomCd);
noti.add("이통사명:"+ telecomNm);
noti.add("가상계좌번호:"+ vAcntNo);
noti.add("가상계좌 입금만료일자:"+ expireDt);
noti.add("통장인자명:"+ AcntPrintNm);
noti.add("입금자명:"+ dpstrNm);
noti.add("고객이메일:"+ email);
noti.add("상점고객아이디:"+ mchtCustId);
noti.add("카드번호:"+ cardNo);
noti.add("카드승인번호:"+ cardApprNo);
noti.add("할부개월수:"+ instmtMon);
noti.add("할부타입:"+ instmtType);
noti.add("휴대폰번호(암호화):"+ phoneNoEnc);
noti.add("원거래번호:"+ orgTrdNo);
noti.add("원거래일자:"+ orgTrdDt);
noti.add("복합결제 거래번호:"+ mixTrdNo);
noti.add("복합결제 금액:"+ mixTrdAmt);
noti.add("실결제금액:"+ payAmt);
noti.add("현금영수증 승인번호:"+ csrcIssNo);
noti.add("취소거래타입:"+ cnclType);
noti.add("기타주문정보:"+ mchtParam);
noti.add("해쉬값:"+ pktHash); //서버에서 전달된 해쉬 값

/** 해쉬 조합 필드 
 *  결과코드 + 거래일시 + 상점아이디 + 가맹점거래번호 + 거래금액 + 라이센스키 */
String hashPlain = String.format("%s%s%s%s%s%s", outStatCd, trdDtm, mchtId, mchtTrdNo, trdAmt, licenseKey);
String hashCipher ="";

/** SHA256 해쉬 처리 */
try{
    hashCipher = EncryptUtil.digestSHA256(hashPlain);//해쉬 값
}catch(Exception e){
    notiLogger.error("["+mchtTrdNo+"][SHA256 HASHING] Hashing Fail! : " + e.toString());
}finally{
    notiLogger.info("["+mchtTrdNo+"][SHA256 HASHING] Plain Text["+hashPlain+"] ---> Cipher Text["+hashCipher+"]");
}

/**
    hash데이타값이 맞는 지 확인 하는 루틴은 헥토파이낸셜에서 받은 데이타가 맞는지 확인하는 것이므로 꼭 사용하셔야 합니다
    정상적인 결제 건임에도 불구하고 노티 페이지의 오류나 네트웍 문제 등으로 인한 hash 값의 오류가 발생할 수도 있습니다.
    그러므로 hash 오류건에 대해서는 오류 발생시 원인을 파악하여 즉시 수정 및 대처해 주셔야 합니다. 
    그리고 정상적으로 데이터를 처리한 경우에도 헥토파이낸셜에서 응답을 받지 못한 경우는 결제결과가 중복해서 나갈 수 있으므로 관련한 처리도 고려되어야 합니다
*/
if (hashCipher.equals(pktHash)) {
    notiLogger.info("["+ mchtTrdNo + "][SHA256 Hash Check] hashCipher[" + hashCipher + "] pktHash[" + pktHash + "] equals?[TRUE]");
    if ("0021".equals(outStatCd)){
        notiLogger.info("["+ mchtTrdNo + "][Success] params:" + String.join("|", noti));
        resp = notiSuccess(noti); 
    }
    else{
        notiLogger.info("["+ mchtTrdNo + "][Undefined Code] outStatCd:"+ outStatCd );
        resp = false;
    }
}
else {
    notiLogger.info("["+ mchtTrdNo + "][SHA256 Hash Check] hashCipher[" + hashCipher + "] pktHash[" + pktHash + "] equals?[FALSE]");
    resp = notiHashError(noti);
} 

// OK, FAIL문자열은 헥토파이낸셜로 전송되어야 하는 값이므로 변경하거나 삭제하지마십시오.
if (resp){
    out.println("OK");
    notiLogger.info("["+ mchtTrdNo + "][Result] OK");
}
else{
    out.println("FAIL");
    notiLogger.info("["+ mchtTrdNo + "][Result] FAIL");
}

%>



