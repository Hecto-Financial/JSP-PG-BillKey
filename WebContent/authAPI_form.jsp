<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="config.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헥토파이낸셜</title>
<style>
#info	                				{display:flex; font-family:굴림; font-size:10pt; line-height: 20%;}
#info > div > p	                		{font-size:13pt;}
#infoChild 								{margin-left: 10px; font-size: 15pt}
#lightGray								{color: gray; font-size: 10pt;}
#lightGrayChild							{display: flex; font-size: 10pt;} 
b										{color: black;}
#STPG_auth_API_Form, p					{font-family:굴림; font-size:10pt;}
#STPG_auth_API_Form .required::after	{content:"* 필수 *";color:red;}
#STPG_auth_API_Form .fixed::after		{content:"* 고정값 *";color:red;}
#STPG_auth_API_Form h4					{background-color:#f1f1f1;padding:4px;margin:2px;}
#STPG_auth_API_Form select				{width:287px;}
#STPG_auth_API_Form input				{width:280px;}
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
    
    $('#STPG_auth_API_Form [name="trdDt"]').val(year + month + day);  //요청일자 세팅
    $('#STPG_auth_API_Form [name="trdTm"]').val(hours + mins + secs); //요청시간 세팅
    $('#STPG_auth_API_Form [name="mchtTrdNo"]').val("AUTH_API" + year + month + day + hours + mins + secs);//주문번호 세팅

});

/* 유효성 검사 함수    
    1. 카드 비밀번호 2자리 인지 체크
    2. 필수 요소 값  입력 했는지 체크
 */
function validationCheck(){
	 
	var requiredArr = document.getElementsByClassName('required'); 
	
	if (document.STPG_auth_API_Form.elements["cardPwd"].value.length != 2){ // cardPwd의 길이가 2가 아니면 false 반환
		alert("카드 비밀번호 앞 2자리는 필수값 입니다.");
	 	return false;
	}
	
	// 필수 값 input 태그의 value가 0이면 false가 포함된 배열 resultArr 생성
	var resultArr = Array.from(requiredArr).map((arr) => arr.querySelector('input').value.length == 0 ? false : true );
	var alertCheck = resultArr.indexOf(false);
	if(alertCheck != -1) alert( requiredArr[alertCheck].querySelector('input').name +" 값은 필수 입니다." );
	
	return !resultArr.includes(false) 
}

/** Submit버튼 동작 */
function doAction(){
	
	$('#STPG_auth_API_Form').attr("action", "authAPI_showResult.jsp");
	$('#STPG_auth_API_Form').attr("method", "post");
	$('#STPG_auth_API_Form').attr("target", "_self");
	if ( validationCheck() ) $('#STPG_auth_API_Form').submit();

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
<h3>전자결제(PG) 신용카드 빌키 발급 API</h3>
<p>
	<b>신용카드 빌키 발급 API</b> : 결제 하지 않고 빌키 발급<br>
	빌키가 발급되지 않을시 문의 주십시오. <b>settle_fintech@hecto.co.kr</b><br>
</p>

<div>
	서버정보 
<%=application.getServerInfo() %>

서블릿정보
<%=application.getMajorVersion()%>.<%= application.getMinorVersion() %>

JSP정보
<%= JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %>
</div>

<form id="STPG_auth_API_Form" name="STPG_auth_API_Form" >

    <table>
        <tr>
            <td colspan="2" style="text-align: center;"><h4>params</h4></td>
        </tr>
        
        <!-- 상점아이디(헥토파이낸셜에서 발급하는 고유 상점아이디) -->
        <tr class="required">
            <td>mchtId[상점아이디]</td><td><input type="text" name="mchtId" value="<%= PG_MID %>" maxlength="12"/></td>
        </tr>
        
        <!-- 전문버전 -->
        <tr class="fixed">
            <td>ver[전문버전]</td><td><input type="text" name="ver" value="0A19" readonly/></td>
        </tr>
        
        <!-- 결제수단 -->
        <tr class="fixed">
            <td>method[결제수단]</td><td><input type="text" name="method" value="CA" readonly/></td>
        </tr>
        
        <!-- 업무구분(빌키 발급[A4] 고정)-->
        <tr class="fixed">
            <td>bizType[업무구분]</td><td><input type="text" name="bizType" value="A4" readonly/></td>
        </tr>
        
        <!-- 암호화구분(AES-256-ECB[23] 고정)-->
        <tr class="fixed">
            <td>encCd[암호화구분]</td><td><input type="text" name="encCd" value="23" readonly/></td>
        </tr>
        
        <!-- 상점주문번호(상점에서 생성하는 유니크한 주문번호) -->
        <tr class="required">
            <td>mchtTrdNo[상점주문번호]</td><td><input type="text" name="mchtTrdNo" value="" maxlength="100"/></td>
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
    
        <tr>
            <td colspan="2" style="text-align: center;"><h4>data</h4></td>
        </tr>
        
        <!-- 해쉬값(공백으로 둘 것. authAPI_showResult.xxx 페이지에서 처리) -->
        <input type="hidden" name="pktHash" value="" />
        
        <!-- 카드번호 -->
        <tr class="required">
            <td>cardNo[카드번호]</td><td><input type="text" name="cardNo" value="" placeholder="카드번호 입력" maxlength="20"/></td>
        </tr>
        
        <!-- 식별번호(생년월일6자리 or 사업자번호10자리)  -->
        <tr class="required">
            <td>idntNo[식별번호]</td><td><input type="text" name="idntNo" value="" placeholder="생년월일 6자리  사업자번호 10자리" maxlength="10"/></td>
        </tr>
        
        <!-- 카드 유효기간(월) -->
        <tr class="required">
            <td>vldDtMon[유효기간(월)]</td><td><input type="text" name="vldDtMon" value="" placeholder="카드 유효기간(월), 숫자만" maxlength="2"/></td>
        </tr>
        
        <!-- 카드 유효기간(년) -->
        <tr class="required">
            <td>vldDtYear[유효기간(년)]</td><td><input type="text" name="vldDtYear" value="" placeholder="카드 유효기간(년), 숫자만" maxlength="2"/></td>
        </tr>
        
        <!-- 카드 비밀번호 앞 2자리 -->
        <tr class="required">
            <td>cardPwd[카드비밀번호]</td><td><input type="text" name="cardPwd" value="" placeholder="카드 비밀번호 앞 2자리" maxlength="2"/></td>
        </tr>    				
        
        <!-- 고객명(한글포함가능) -->
        <tr>
            <td>mchtCustNm[고객명]</td><td><input type="text" name="mchtCustNm" value="" placeholder="고객명(한글포함가능)" maxlength="30"/></td>
        </tr>    				
       
        <!-- 고객아이디(한글포함불가) -->
        <tr>
            <td>mchtCustId[고객아이디]</td><td><input type="text" name="mchtCustId" value="" placeholder="고객아이디(한글포함불가)" maxlength="50"/></td>
        </tr>    				
       
        
        <!-- 인증후 빌키발급여부(Y, N) -->
        <tr class="required">
            <td>keyRegYn[빌키발급요청여부]</td><td><input type="text" name="keyRegYn" value="Y" placeholder="빌키발급요청여부" maxlength="1"/></td>
        </tr>
    <tr>
		<td colspan="2" style="text-align: center;"><input style="margin-top:20px;" type="button" value="확인" onclick="doAction()"/></td>
    </tr>
    </table>

</form>
</body>
</html>