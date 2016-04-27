<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>

<%@ page import="com.liferay.portal.util.PortalUtil"%>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ page
	import="com.liferay.portal.service.OrganizationLocalServiceUtil"%>
<%@ page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ page import="com.liferay.portal.model.Group"%>
<%@ page import="com.liferay.portal.model.Organization"%>
<%@ page import="com.liferay.portal.model.User"%>

<portlet:defineObjects />

<theme:defineObjects />

<%
	String redirect = PortalUtil.getCurrentURL(renderRequest);

	Long userId = (Long) renderRequest.getAttribute("userId");
	
	String status = (String) renderRequest.getAttribute("status");
%>
<c:if test="<%=userId > 0%>">

	<portlet:renderURL var="editStatusURL">
		<portlet:param name="mvcPath" value="/html/statusquote/edit.jsp" />
		<portlet:param name="userId" value="<%=String.valueOf(userId)%>" />
		<portlet:param name="redirect" value="<%=redirect%>" />
	</portlet:renderURL>

	<aui:container>
		<aui:row>

			<p><%=status%></p>

			<c:if test="<%=userId == user.getUserId()%>">
				<a href="<%=editStatusURL%>"> <i class="icon-edit"></i> Edit
				</a>
			</c:if>

		</aui:row>
	</aui:container>
</c:if>