<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
/**
 * 요청/응답 파라미터를 화면에 출력할 때 사용하는 이스케이프 유틸입니다.
 * 외부에서 전달된 값을 인코딩 없이 출력하면 XSS 취약점이 발생합니다.
 * 출력 위치가 HTML이면 escapeHtml을, 자바스크립트 문자열이면 escapeJs를 사용하십시오.
 */

/** HTML 출력용 이스케이프 */
private String escapeHtml(String value) {
    if (value == null || value.length() == 0) {
        return "";
    }
    StringBuilder result = new StringBuilder(value.length() + 16);
    for (int i = 0; i < value.length(); i++) {
        char c = value.charAt(i);
        switch (c) {
            case '&':  result.append("&amp;");  break;
            case '<':  result.append("&lt;");   break;
            case '>':  result.append("&gt;");   break;
            case '"':  result.append("&quot;"); break;
            case '\'': result.append("&#x27;"); break;
            default:   result.append(c);
        }
    }
    return result.toString();
}

/** 자바스크립트 문자열 리터럴 출력용 이스케이프 */
private String escapeJs(String value) {
    if (value == null || value.length() == 0) {
        return "";
    }
    StringBuilder result = new StringBuilder(value.length() + 16);
    for (int i = 0; i < value.length(); i++) {
        char c = value.charAt(i);
        switch (c) {
            case '\\':     result.append("\\\\");    break;
            case '"':      result.append("\\\"");    break;
            case '\'':     result.append("\\'");     break;
            case '<':      result.append("\\u003C"); break;
            case '>':      result.append("\\u003E"); break;
            case '\r':     result.append("\\r");     break;
            case '\n':     result.append("\\n");     break;
            case '\u2028': result.append("\\u2028"); break;
            case '\u2029': result.append("\\u2029"); break;
            default:       result.append(c);
        }
    }
    return result.toString();
}
%>
