<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="config.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헥토파이낸셜</title>
<style>
#info	                		{display:flex; font-family:굴림; font-size:10pt; line-height: 20%;}
#info > div > p	                {font-size:13pt;}
#infoChild 						{margin-left: 10px; font-size: 15pt}
#lightGray						{color: gray; font-size: 10pt;}
#lightGrayChild					{display: flex; font-size: 10pt;} 
b								{color: black;}
#STPG_billForm, p				{font-family:굴림; font-size:10pt;}
#STPG_billForm .required::after	{content:"* 필수 *";color:red;}
#STPG_billForm .fixed::after	{content:"* 고정값 *";color:red;}
#STPG_billForm h4				{background-color:#f1f1f1;padding:4px;margin:2px;}
#STPG_billForm select			{width:287px;}
#STPG_billForm input			{width:280px;}
	
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(function(){
    var curr_date = new Date();
    var year = curr_date.getFullYear().toString();
    var month = ("0" + (curr_date.getMonth() + 1)).slice(-2).toString();
    var day = ("0" + (curr_date.getDate())).slice(-2).toString();
    var hours = ("0" + curr_date.getHours()).slice(-2).toString();
    var mins = ("0" + curr_date.getMinutes()).slice(-2).toString();
    var secs = ("0" + curr_date.getSeconds()).slice(-2).toString();
    
    $('#STPG_billForm [name="trdDt"]').val(year + month + day);  //요청일자 세팅
    $('#STPG_billForm [name="trdTm"]').val(hours + mins + secs); //요청시간 세팅
    $('#STPG_billForm [name="mchtTrdNo"]').val("NOAUTH_BILL" + year + month + day + hours + mins + secs);//주문번호 세팅

});


/** Submit버튼 동작 */
function doAction(){
	$('#STPG_billForm').attr("action", "pay_showResult.jsp");
	$('#STPG_billForm').attr("method", "post");
	$('#STPG_billForm').attr("target", "_self");
	$('#STPG_billForm').submit();
}
</script>
</head>
<body>
<div id = "info">
	<div>
		<p><a href="authAPI_form.jsp" style="text-decoration:none;">[빌키 발급 API]</a></p>
		<p><a href="pay_form.jsp" style="text-decoration:none;">[결제 API(빌키 발급 포함)]</a><p></p>
		<p><a href="billKey_form.jsp" style="text-decoration:none;">[빌키 결제 API]</a></p>
		<p><a href="cancel_form.jsp" style="text-decoration:none;">[취소 API]</a></p>
	</div>
	<div id = "infoChild">
		<p>:&nbsp;&nbsp;결제 하지 않고 빌키 발급</p>
		<p>:&nbsp;&nbsp;결제 후 상점 아이디 설정에 따라 빌키 발급</p>
		<p>:&nbsp;&nbsp;발급 받은 빌키로 정기 결제</p>
		<p>:&nbsp;&nbsp;결제된 거래 건 취소</p>
	</div>
</div>
<h3>전자결제(PG) 신용카드 빌키 결제 API</h3>
<p>
<b>신용카드 빌키 결제 API</b> : 신용카드 결제 API 또는 빌키 발급 API를 통해 전달받은 빌키로 결제를 하는 API입니다.<br>
</p>
<form id="STPG_billForm" name="STPG_billForm" >

    <table>
    <!---------------------------------------------------------------------------------------------------------->
    <!---------------------------------------------------------------------------------------------------------->
    <!---------------------------------- Request Parameter Header ---------------------------------------------->
    <!---------------------------------------------------------------------------------------------------------->
    <!---------------------------------------------------------------------------------------------------------->
    <tr>
    	<td colspan="2" style="text-align: center;"><h4>params</h4></td>
    </tr>
    
    <!-- 상점아이디(헥토파이낸셜에서 발급하는 고유 상점아이디) -->
    <tr class="required">
    	<td>mchtId[상점아이디]</td><td><input type="text" name="mchtId" value="<%= PG_MID %>" maxlength="10"/></td>
    </tr>
    
    <!-- 전문버전(1st[0] 고정 /2nd[A] 고정/ 3,4th:연동규격서버전. v1.7 => [17]) -->
    <tr class="required">
    	<td>ver[전문버전]</td><td><input type="text" name="ver" value="0A19" maxlength="4"/></td>
    </tr>
    
    <!-- 결제수단(가상계좌[CA] 고정)-->
    <tr class="fixed">
    	<td>method[결제수단]</td><td><input type="text" name="method" value="CA" readonly/></td>
    </tr>
    
    <!-- 업무구분(채번[B0] 고정)-->
    <tr class="fixed">
    	<td>bizType[업무구분]</td><td><input type="text" name="bizType" value="B0" readonly/></td>
    </tr>
    
    <!-- 암호화구분(AES-256-ECB[23] 고정)-->
    <tr class="fixed">
    	<td>encCd[암호화구분]</td><td><input type="text" name="encCd" value="23" readonly/></td>
    </tr>
    
    <!-- 상점주문번호(상점에서 생성하는 유니크한 주문번호) -->
    <tr class="required">
    	<td>mchtTrdNo[상점주문번호]</td><td><input type="text" name="mchtTrdNo" value="" maxlength="50"/></td>
    </tr>
    
    <!-- 요청일자(현재 전문을 요청하는 일자[yyyyMMdd]) -->
    <tr class="required">
    	<td>trdDt[요청일자]</td><td><input type="text" name="trdDt" value="" maxlength="8"/></td>
    </tr>
    
    <!-- 요청시간(현재 전문을 요청하는 시간[HHmmss] -->
    <tr class="required">
    	<td>trdTm[요청시간]</td><td><input type="text" name="trdTm" value="" maxlength="6"/></td>
    </tr>
    
    <!-- 모바일여부(모바일[Y] / PC[N]) -->
    <tr >
    	<td>mobileYn[모바일여부]</td>
    	<td>
    	<select name="mobileYn">
             <option value="N">PC</option>
             <option value="Y">모바일</option>
         </select>
    	</td>
    </tr>
    
    <!-- OS구분(Android[A]/ iOS[I] / Windows[W] / Mac[M] / others[E]) -->
    <tr>
    	<td>osType[OS구분]</td>
    	<td>
    	<select name="osType">
             <option value="W">Windows</option>
             <option value="A">Android</option>
             <option value="I">iOS</option>
             <option value="M">Mac</option>
             <option value="E">others</option>
         </select>
    	</td>
    </tr>
    
	<!---------------------------------------------------------------------------------------------------------->
    <!---------------------------------------------------------------------------------------------------------->
    <!---------------------------------- Request Parameter Body ------------------------------------------------>
    <!---------------------------------------------------------------------------------------------------------->
	<!---------------------------------------------------------------------------------------------------------->
    <tr>
    	<td colspan="2" style="text-align: center;"><h4>data</h4></td>
    </tr>
    
    <!-- 거래금액 -->
    <tr class="required">
        <td>trdAmt[거래금액]</td><td><input type="text" name="trdAmt" value="1000"  maxlength="12"/></td>
    </tr>
    
    <!-- 빌키(자동결제키) -->
    <tr class="required">
        <td>billKey[빌키]</td><td><input type="text" name="billKey" value="SBILL_0123456789"  maxlength="50"/></td>
    </tr>
    
    <!-- 상품명 -->
    <tr class="required">
        <td>pmtprdNm[상품명]</td><td><input type="text" name="pmtprdNm" value="테스트상품" maxlength="42"/></td>
    </tr>
    
    <!-- 상점고객명 -->
    <tr>
        <td>mchtCustNm[상점고객명]</td><td><input type="text" name="mchtCustNm" value="홍길동" maxlength="10"/></td>
    </tr>
    
    <!-- 상점고객아이디 -->
    <tr>
        <td>mchtCustId[상점고객아이디]</td><td><input type="text" name="mchtCustId" value="HongGilDong" maxlength="50"/></td>
    </tr>
    
    <!-- 이메일(상점 고객의 이메일주소) -->
    <tr>
    	<td>email[이메일]</td><td><input type="text" name="email" value="HongGilDong@example.com" maxlength="60"/></td>
    </tr>    				
    
    <!-- 할부개월수(MM) -->
    <tr>
        <td>instmtMon[할부개월수]</td><td><input type="text" name="instmtMon" value="00" maxlength="2"/></td>
    </tr>
    
    <!-- 통화구분([KRW] 고정) -->
    <tr class="fixed">
    	<td>crcCd[통화구분]</td><td><input type="text" name="crcCd" value="KRW" readonly/></td>
    </tr>
    
    <!-- 과세구분코드(과세[N] / 면세[Y] / 복합과세[G]) -->
    <tr class="required">
    	<td>taxTypeCd[과세구분코드]</td>
    	<td>
    	<select name="taxTypeCd">
             <option value="N">과세</option>
             <option value="Y">면세</option>
             <option value="G">복합과세</option>
         </select>
    	</td>
    </tr>
    
    <!-- 과세금액(복합과세인경우 필수. 거래금액 = 과세금액 + 부가세금액 + 비과세금액) -->
    <tr>
    	<td>taxAmt[과세금액]</td><td><input type="text" name="taxAmt" value="" maxlength="12"/></td>
    </tr>
    
    <!-- 부가세금액(복합과세인경우 필수. 거래금액 = 과세금액 + 부가세금액 + 비과세금액) -->
    <tr>
    	<td>vatAmt[부가세금액]</td><td><input type="text" name="vatAmt" value="" maxlength="12"/></td>
    </tr>
    
    <!-- 비과세금액(복합과세인경우 필수. 거래금액 = 과세금액 + 부가세금액 + 비과세금액) -->
    <tr>
    	<td>taxFreeAmt[비과세금액]</td><td><input type="text" name="taxFreeAmt" value="" maxlength="12"/></td>
    </tr>
    
   	<!-- 봉사료 -->
    <tr>
    	<td>svcAmt[봉사료]</td><td><input type="text" name="svcAmt" value="" maxlength="12"/></td>
    </tr>
    
    <!-- 결과처리URL(헥토파이낸셜측에서 거래처리가 성공적으로 완료되면 호출하는 상점측 callback URL) -->
    <tr>
        <td>notiUrl[결과처리URL]</td><td><input type="text" name="notiUrl" value="http://localhost/receiveNoti.jsp" maxlength="250"/></td>
    </tr>
    
    <!-- 기타주문정보(상점에서 자유롭게 사용할 수 있는 상점 예약 필드) -->
    <tr>
        <td>mchtParam[기타주문정보]</td><td><input type="text" name="mchtParam" value="기타주문정보" /></td>
    </tr>
    
    <tr>
		<td colspan="2" style="text-align: center;"><input style="margin-top:20px;" type="button" value="확인" onclick="doAction()"/></td>
    </tr>
    </table>
    
    <!-- 해쉬값(공백으로 둘 것. pay_showResult.xxx 페이지에서 처리) -->
    <input type="hidden" name="pktHash" value="" />
</form>
</body>
</html>