<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>

<%@ page import="com.liferay.portal.util.PortalUtil"%>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil"%>

<portlet:defineObjects />

<theme:defineObjects />

<%
	String redirect = PortalUtil.getCurrentURL(renderRequest);

	String status = (String) renderRequest.getAttribute("status");
	String quote = (String) renderRequest.getAttribute("quote");
	String author = (String) renderRequest.getAttribute("author");
%>

<portlet:renderURL var="editStatusAndQuote">
	<portlet:param name="mvcPath" value="/html/statusquote/edit.jsp" />
	<portlet:param name="redirect" value="<%=redirect%>" />
</portlet:renderURL>

<p><%=status%></p>

<c:if test='<%=quote != ""%>'>
	<hr> 
	<blockquote>
		<p style="font-size: 14px!important;"><%=quote%></p>
		<c:if test='<%=author != ""%>'>
			<footer><small><%=author%></small> </footer>
		</c:if>
	</blockquote>
</c:if>


<c:if
	test='<%=permissionChecker.isGroupOwner(themeDisplay.getScopeGroupId())%>'>
	<a href="<%=editStatusAndQuote%>"> <i class="icon-edit"></i> Edit
	</a>
</c:if>