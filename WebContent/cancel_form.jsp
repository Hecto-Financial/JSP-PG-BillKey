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
#STPG_cnclForm, p				{font-family:굴림; font-size:10pt;}
#STPG_cnclForm .required::after	{content:"* 필수 *";color:red;}
#STPG_cnclForm .fixed::after	{content:"* 고정값 *";color:red;}
#STPG_cnclForm h4				{background-color:#f1f1f1;padding:4px;margin:2px;}
#STPG_cnclForm select			{width:287px;}
#STPG_cnclForm input			{width:280px;}
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
    
    $('#STPG_cnclForm [name="trdDt"]').val(year + month + day);  //요청일자 세팅
    $('#STPG_cnclForm [name="trdTm"]').val(hours + mins + secs); //요청시간 세팅
    $('#STPG_cnclForm [name="mchtTrdNo"]').val("NOAUTH_CANCEL" + year + month + day + hours + mins + secs);//주문번호 세팅

});


/** Submit버튼 동작 */
function doAction(){
	$('#STPG_cnclForm').attr("action", "cancel_showResult.jsp");
	$('#STPG_cnclForm').attr("method", "post");
	$('#STPG_cnclForm').attr("target", "_self");
	$('#STPG_cnclForm').submit();
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
<h3>전자결제(PG) 신용카드 취소 API</h3>
<p>
	<b>신용카드 취소 API</b> : 결제 취소 API<br>
	빌키가 발급되지 않을시 문의 주십시오. <b>settle_fintech@hecto.co.kr</b><br>
</p>
<form id="STPG_cnclForm" name="STPG_cnclForm">
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
    
    <!-- 업무구분(채번취소[C0] 고정)-->
    <tr class="fixed">
    	<td>bizType[업무구분]</td><td><input type="text" name="bizType" value="C0" readonly/></td>
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

    <!-- 원거래번호(채번시 헥토파이낸셜에서 생성하는 유일한 거래번호) -->
    <tr class="required">
    	<td>orgTrdNo[원거래번호]</td><td><input type="text" name="orgTrdNo" value="STFP_PGVAnx_mid_il0000000000000000000000000" maxlength="40"/></td>
    </tr>
    
    <!-- 통화구분([KRW] 고정) -->
    <tr class="fixed">
    	<td>crcCd[통화구분]</td><td><input type="text" name="crcCd" value="KRW" readonly/></td>
    </tr>
    
    <!-- 취소회차(부분취소시 사용되는 회차. 공백으로 넘기면 자동설정. 최근 취소회차는 전에 입력한 취소회차보다 커야함) -->
    <tr class="required">
    	<td>cnclOrd[취소회차]</td><td><input type="text" name="cnclOrd" value="001" maxlength="3"/></td>
    </tr>
    
    <!-- 취소금액 -->
    <tr class="required">
    	<td>cnclAmt[취소금액]</td><td><input type="text" name="cnclAmt" value="1000" maxlength="12"/></td>
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
   
    <!-- 취소사유내용 -->
    <tr>
    	<td>cnclRsn[취소사유내용]</td><td><input type="text" name="cnclRsn" value="상품이 마음에 들지 않습니다." maxlength="35"/></td>
    </tr>

      
    <tr>
		<td colspan="2" style="text-align: center;"><input style="margin-top:20px;" type="button" value="확인" onclick="doAction()"/></td>
    </tr>
    </table>
    
    <!-- 해쉬값(공백으로 둘 것. cancel_showResult.xxx 페이지에서 처리) -->
    <input type="hidden" name="pktHash" value="" />
    
</form>
</body>
</html>