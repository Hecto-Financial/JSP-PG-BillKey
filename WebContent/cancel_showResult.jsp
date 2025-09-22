<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.settle.pg.HttpClientUtil"%>
<%@ page import="com.settle.pg.EncryptUtil"%>
<%@ page import="com.settle.pg.StringUtil"%>
<%@page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@page import="org.slf4j.Logger"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="config.jsp" %>
<% request.setCharacterEncoding("UTF-8");%>
<%
//로거 얻기
Logger logger = LoggerFactory.getLogger("trans");

//설정 정보 가져오기
String aesKey = AES256_KEY;         //AES256 암복호화 키
String licenseKey = LICENSE_KEY;    //라이센스 키
String serverURL = SERVER_URL;      //타겟URL
int connTimeout = CONN_TIMEOUT;     //connect timeout
int readTimeout = READ_TIMEOUT;     //read timeout

//요청 파라미터(헤더)
Map<String,String> REQ_HEADER = new LinkedHashMap<String,String>();
REQ_HEADER.put("mchtId",    StringUtil.isNull(request.getParameter("mchtId")));     //상점아이디
REQ_HEADER.put("ver",       StringUtil.isNull(request.getParameter("ver")));        //버전
REQ_HEADER.put("method",    StringUtil.isNull(request.getParameter("method")));     //결제수단
REQ_HEADER.put("bizType",   StringUtil.isNull(request.getParameter("bizType")));    //업무구분
REQ_HEADER.put("encCd",     StringUtil.isNull(request.getParameter("encCd")));      //암호화구분
REQ_HEADER.put("mchtTrdNo", StringUtil.isNull(request.getParameter("mchtTrdNo")));  //상점주문번호
REQ_HEADER.put("trdDt",     StringUtil.isNull(request.getParameter("trdDt")));      //요청일자
REQ_HEADER.put("trdTm",     StringUtil.isNull(request.getParameter("trdTm")));      //요청시간
REQ_HEADER.put("mobileYn",  StringUtil.isNull(request.getParameter("mobileYn")));   //모바일여부
REQ_HEADER.put("osType",    StringUtil.isNull(request.getParameter("osType")));     //운영체제구분


//요청 파라미터(바디)
Map<String,String> REQ_BODY = new LinkedHashMap<String,String>();
REQ_BODY.put("orgTrdNo",    StringUtil.isNull(request.getParameter("orgTrdNo")));   //원거래번호
REQ_BODY.put("cnclAmt",     StringUtil.isNull(request.getParameter("cnclAmt")));    //취소금액
REQ_BODY.put("crcCd",       StringUtil.isNull(request.getParameter("crcCd")));      //통화구분
REQ_BODY.put("cnclOrd",     StringUtil.isNull(request.getParameter("cnclOrd")));    //부분취소차수
REQ_BODY.put("cnclRsn",     StringUtil.isNull(request.getParameter("cnclRsn")));    //취소사유
REQ_BODY.put("taxTypeCd",   StringUtil.isNull(request.getParameter("taxTypeCd")));  //면세유형
REQ_BODY.put("taxAmt",      StringUtil.isNull(request.getParameter("taxAmt")));     //과세금액
REQ_BODY.put("vatAmt",      StringUtil.isNull(request.getParameter("vatAmt")));     //부가세금액
REQ_BODY.put("taxFreeAmt",  StringUtil.isNull(request.getParameter("taxFreeAmt"))); //비과세금액(면세금액)
REQ_BODY.put("svcAmt",      StringUtil.isNull(request.getParameter("svcAmt")));     //봉사료

//응답 파라미터(헤더)
Map<String,String> RES_HEADER = new LinkedHashMap<String,String>();
RES_HEADER.put("mchtId", "");       //상점아이디
RES_HEADER.put("ver", "");          //버전
RES_HEADER.put("method", "");       //결제수단
RES_HEADER.put("bizType", "");      //업무구분
RES_HEADER.put("encCd", "");        //암호화구분
RES_HEADER.put("mchtTrdNo", "");    //상점주문번호
RES_HEADER.put("trdNo", "");        //헥토파이낸셜거래번호
RES_HEADER.put("trdDt", "");        //요청일자
RES_HEADER.put("trdTm", "");        //요청시간
RES_HEADER.put("outStatCd", "");    //결과코드
RES_HEADER.put("outRsltCd", "");    //거절코드
RES_HEADER.put("outRsltMsg", "");   //결과메세지
    
//응답 파라미터(바디)
Map<String,String> RES_BODY = new LinkedHashMap<String,String>();
RES_BODY.put("pktHash", "");        //해쉬값
RES_BODY.put("orgTrdNo", "");       //원거래번호
RES_BODY.put("cnclAmt", "");        //취소금액
RES_BODY.put("blcAmt", "");         //취소가능잔액



//AES256 암호화 필요 파라미터
String[] ENCRYPT_PARAMS = {"cnclAmt","taxAmt","vatAmt","taxFreeAmt", "svcAmt"};

//AES256 복호화 필요 파라미터
String[] DECRYPT_PARAMS = {"cnclAmt", "blcAmt"};



/** ====================================================================================================
 *                          SHA256 해쉬 처리
 *  조합필드 : 요청일자 + 요청시간 + 상점아이디 + 상점주문번호 + 취소금액 + 라이센스키
 *  ====================================================================================================   */
String hashPlain="";
String hashCipher="";
try{
    hashPlain = String.format("%s%s%s%s%s%s"
              ,REQ_HEADER.get("trdDt")
              ,REQ_HEADER.get("trdTm")
              ,REQ_HEADER.get("mchtId")
              ,REQ_HEADER.get("mchtTrdNo")
              ,REQ_BODY.get("cnclAmt")
              ,licenseKey);
    hashCipher = EncryptUtil.digestSHA256(hashPlain);
}catch(Exception e){
    logger.error("["+REQ_HEADER.get("mchtTrdNo")+"][SHA256 HASHING] Hashing Fail! : " + e.toString());
}finally{
    logger.info("["+REQ_HEADER.get("mchtTrdNo")+"][SHA256 HASHING] Plain Text["+hashPlain+"] ---> Cipher Text["+hashCipher+"]");
    REQ_BODY.put("pktHash", hashCipher); //해쉬 결과 값 세팅
}

/** ======================================================================
 *                          AES256 암호화 처리
 *  ======================================================================   */
try{
    for(int i=0; i< ENCRYPT_PARAMS.length; i++){
        String aesPlain = REQ_BODY.get(ENCRYPT_PARAMS[i]);
        if( !("".equals(aesPlain))){
            byte[] aesCipherRaw = EncryptUtil.aes256EncryptEcb(aesKey, aesPlain);
            String aesCipher = EncryptUtil.encodeBase64(aesCipherRaw);
            
            REQ_BODY.put(ENCRYPT_PARAMS[i], aesCipher); //암호화 결과 값 세팅
            logger.info("["+REQ_HEADER.get("mchtTrdNo")+"][AES256 Encrypt] "+ENCRYPT_PARAMS[i]+"["+aesPlain+"] ---> ["+aesCipher+"]");
        }
    }
}catch(Exception e){
    logger.error("[" + REQ_HEADER.get("mchtTrdNo") + "][AES256 Encrypt] AES256 Encrypt Fail! : " + e.toString());
}



//URL설정
String requestUrl = serverURL + "/spay/APICancel.do";


//요청파라미터 세팅
//params, data 이름은 헥토파이낸셜로 전달되야 하는 값이니 변경하지 마십시오.
Map<String,Object> reqParam = new HashMap<String,Object>();
reqParam.put("params", REQ_HEADER );
reqParam.put("data", REQ_BODY);


/** ======================================================================
 *                          API호출(가맹점->헥토파이낸셜) 및 응답 처리
 *  ======================================================================   */
Map<String, String> respParam = new HashMap<String, String>();
try{
    HttpClientUtil httpClientUtil = new HttpClientUtil();
    //send_api ( API호출 URL, 전송될데이터, 연결 타임아웃, 수신 타임아웃 )
    String resData = httpClientUtil.sendApi(requestUrl, reqParam, connTimeout, readTimeout); 


    //응답 파라미터 파싱
    JSONObject resp = JSONObject.fromObject(resData);
    JSONObject respHeader = resp.has("params")? resp.getJSONObject("params") : null; 
    JSONObject respBody =  resp.has("data")? resp.getJSONObject("data") : null;
    
    //응답 파라미터 세팅(헤더)
    if( respHeader != null ){
        for (String key : RES_HEADER.keySet()) {
            respParam.put(key, StringUtil.isNull( respHeader.has(key)? respHeader.getString(key) : ""));
        }
    }else{
        for (String key : RES_HEADER.keySet()) {
            respParam.put(key, "");
        }
    }
    
    //응답 파라미터 세팅(바디)
    if( respBody != null){
        for (String key : RES_BODY.keySet()) {
            respParam.put(key, StringUtil.isNull( respBody.has(key)? respBody.getString(key) : ""));
        }
    }else{
        for (String key : RES_BODY.keySet()) {
            respParam.put(key, "");
        }
    }
    
    
}catch (Exception e){
    respParam.put("outStatCd", "0031");
    respParam.put("outRsltCd", "9999");
    respParam.put("outRsltMsg", "[Response Parsing Error]" + e.toString());
    logger.error("["+REQ_HEADER.get("mchtTrdNo")+"][Response Parsing Error]" + e.toString());
}
    
/** ======================================================================
                            AES256 복호화 처리
    ======================================================================   */
try{
    for(int i=0; i < DECRYPT_PARAMS.length; i++){
        if( respParam.containsKey(DECRYPT_PARAMS[i]) ){
            String aesCipher = (respParam.get(DECRYPT_PARAMS[i])).trim();
            if( !("".equals(aesCipher))){
                byte[] aesCipherRaw = EncryptUtil.decodeBase64(aesCipher);
                String aesPlain = new String(EncryptUtil.aes256DecryptEcb(aesKey, aesCipherRaw), "UTF-8");
                
                respParam.put(DECRYPT_PARAMS[i], aesPlain);//복호화된 데이터로 세팅
                logger.info("["+REQ_HEADER.get("mchtTrdNo")+"][AES256 Decrypt] "+DECRYPT_PARAMS[i]+"["+aesCipher+"] ---> ["+aesPlain+"]");
            }
        }
    }
}catch(Exception e){
    logger.error("[" + REQ_HEADER.get("mchtTrdNo") + "][AES256 Decrypt] AES256 Decrypt Fail! : " + e.toString());
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>S'Pay</title>
<style type="text/css">
#STPG_RSLT		{font-family:굴림; font-size:10pt;}
#STPG_RSLT h4	{background-color:#f1f1f1;padding:4px;margin:2px;}
</style>
</head>
<body>
<h3>응답 결과</h3>
<div id="STPG_RSLT">
    <table>
    <tr>
		<td colspan="2" style="text-align: center;"><h4>params</h4></td>
	</tr>
    <tr>
        <td>mchtId[상점아이디]</td>
        <td><%= respParam.get("mchtId") %></td>
    </tr>
    <tr>
        <td>ver[버전]</td>
        <td><%= respParam.get("ver") %></td>
    </tr>
    <tr>
        <td>method[결제수단]</td>
        <td><%= respParam.get("method") %></td>
    </tr>
    <tr>
        <td>bizType[업무구분]</td>
        <td><%= respParam.get("bizType") %></td>
    </tr>
    <tr>
        <td>encCd[암호화구분]</td>
        <td><%= respParam.get("encCd") %></td>
    </tr>
    <tr>
        <td>mchtTrdNo[상점주문번호]</td>
        <td><%= respParam.get("mchtTrdNo") %></td>
    </tr>
    <tr>
        <td>trdNo[헥토파이낸셜 거래번호]</td>
        <td><%= respParam.get("trdNo") %></td>
    </tr>
    <tr>
        <td>trdDt[취소요청일자]</td>
        <td><%= respParam.get("trdDt") %></td>
    </tr>
    <tr>
        <td>trdTm[취소요청시간]</td>
        <td><%= respParam.get("trdTm") %></td>
    </tr>
    <tr>
        <td>outStatCd[거래상태코드]</td>
        <td><%= respParam.get("outStatCd") %></td>
    </tr>
    <tr>
        <td>outRsltCd[거래결과코드]</td>
        <td><%= respParam.get("outRsltCd") %></td>
    </tr>
    <tr>
        <td>outRsltMsg[결과메세지]</td>
        <td><%= respParam.get("outRsltMsg") %></td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;"><h4>data</h4></td>
    </tr>
    <tr>
        <td>pktHash[해쉬값]</td>
        <td><%= respParam.get("pktHash") %></td>
    </tr>
    <tr>
        <td>orgTrdNo[원거래번호]</td>
        <td><%= respParam.get("orgTrdNo") %></td>
    </tr>
    <tr>
        <td>cnclAmt[취소금액]</td>
        <td><%= respParam.get("cnclAmt") %></td>
    </tr>
    <tr>
        <td>blcAmt[취소가능잔액]</td> 
        <td><%= respParam.get("blcAmt") %></td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;"><input style="margin-top:20px;" type="button" value="돌아가기" onclick="location.href='cancel_form.jsp'"></td>
    </tr>
    </table>
</div>
</body>
</html>