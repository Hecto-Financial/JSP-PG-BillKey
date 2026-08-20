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
#STPG_delKeyForm, p				{font-family:굴림; font-size:10pt;}
#STPG_delKeyForm .required::after	{content:"* 필수 *";color:red;}
#STPG_delKeyForm .fixed::after	{content:"* 고정값 *";color:red;}
#STPG_delKeyForm h4				{background-color:#f1f1f1;padding:4px;margin:2px;}
#STPG_delKeyForm select			{width:287px;}
#STPG_delKeyForm input			{width:280px;}
	
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
    
    $('#STPG_delKeyForm [name="trdDt"]').val(year + month + day);  //요청일자 세팅
    $('#STPG_delKeyForm [name="trdTm"]').val(hours + mins + secs); //요청시간 세팅
    $('#STPG_delKeyForm [name="mchtTrdNo"]').val("BILLKEY_DEL" + year + month + day + hours + mins + secs);//주문번호 세팅

});


/** Submit버튼 동작 */
function doAction(){
	$('#STPG_delKeyForm').attr("action", "delKey_showResult.jsp");
	$('#STPG_delKeyForm').attr("method", "post");
	$('#STPG_delKeyForm').attr("target", "_self");
	$('#STPG_delKeyForm').submit();
}
</script>
</head>
<body>
<div id = "info">
	<div>
		<p><a href="authAPI_form.jsp" style="text-decoration:none;">[빌키 발급 API]</a></p>
		<p><a href="pay_form.jsp" style="text-decoration:none;">[결제 API(빌키 발급 포함)]</a><p></p>
		<p><a href="billKey_form.jsp" style="text-decoration:none;">[빌키 결제 API]</a></p>
		<p><a href="delKey_form.jsp" style="text-decoration:none;">[빌키 삭제 API]</a></p>
		<p><a href="cancel_form.jsp" style="text-decoration:none;">[취소 API]</a></p>
	</div>
	<div id = "infoChild">
		<p>:&nbsp;&nbsp;결제 하지 않고 빌키 발급</p>
		<p>:&nbsp;&nbsp;결제 후 상점 아이디 설정에 따라 빌키 발급</p>
		<p>:&nbsp;&nbsp;발급 받은 빌키로 정기 결제</p>
		<p>:&nbsp;&nbsp;발급 받은 빌키 삭제</p>
		<p>:&nbsp;&nbsp;결제된 거래 건 취소</p>
	</div>
</div>
<h3>전자결제(PG) 신용카드 빌키 삭제 API</h3>
<p>
<b>신용카드 빌키 삭제 API</b> : 발급받은 빌키를 삭제(해지)하는 API입니다.<br>
고객이 정기결제를 해지하면 빌키도 함께 삭제해 주십시오.<br>
</p>
<form id="STPG_delKeyForm" name="STPG_delKeyForm" >

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
    
    <!-- 결제수단(신용카드[CA] 고정)-->
    <tr class="fixed">
    	<td>method[결제수단]</td><td><input type="text" name="method" value="CA" readonly/></td>
    </tr>
    
    <!-- 업무구분(빌키 삭제[A1] 고정)-->
    <tr class="fixed">
    	<td>bizType[업무구분]</td><td><input type="text" name="bizType" value="A1" readonly/></td>
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
    
    <!-- 빌키(삭제할 자동결제키. 평문으로 전송하며 암호화 대상이 아닙니다.) -->
    <tr class="required">
        <td>billKey[빌키]</td><td><input type="text" name="billKey" value="SBILL_0123456789"  maxlength="50"/></td>
    </tr>

    <!-- 해지사유코드(선택) -->
    <tr>
        <td>etcInfo[해지사유코드]</td><td><input type="text" name="etcInfo" value="" maxlength="100"/></td>
    </tr>

    <tr>
		<td colspan="2" style="text-align: center;"><input style="margin-top:20px;" type="button" value="확인" onclick="doAction()"/></td>
    </tr>
    </table>
    
    <!-- 해쉬값(공백으로 둘 것. delKey_showResult.jsp 페이지에서 처리) -->
    <input type="hidden" name="pktHash" value="" />
</form>
</body>
</html>