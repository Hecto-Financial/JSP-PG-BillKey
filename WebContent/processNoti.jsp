<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List"%>
<%@page import="org.slf4j.Logger"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%!
// 노티 처리 관련 로거
private Logger notiLogger = LoggerFactory.getLogger("notiTrans");

// 노티를 성공적으로 수신한 경우 처리할 로직을 작성하여 주세요.
boolean notiSuccess(List<String> noti){
       /* TODO : 관련 로직 추가 */
       
    return true;
}

   /** 노티 수신중 해시 체크 에러가 생긴 경우 처리할 로직을 작성하여 주세요. */
boolean notiHashError(List<String> noti){
       /* TODO : 관련 로직 추가 */
       
    return false;
}
%>