<%@page import="com.rivetlogic.statusquote.portlet.StatusQuote"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme"%>
<%@ taglib uri="http://liferay.com/tld/security"
	prefix="liferay-security"%>

<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ page import="com.liferay.portal.kernel.util.UnicodeFormatter" %>

<portlet:defineObjects />
<theme:defineObjects />

<%
	String redirect = ParamUtil.getString(request, "redirect");

	String status = portletPreferences.getValue(StatusQuote.USER_STATUS_ATRRIBUTE, StringPool.BLANK);
	
	long userId = ParamUtil.getLong(request, "userId");
%>


<liferay-ui:header backURL="<%=redirect%>" localizeTitle="true"
	showBackURL="true" title="profile-status" />

<portlet:actionURL var="saveStatusQuoteURL" name="saveStatusQuote" />

<aui:form action="<%=saveStatusQuoteURL%>" method="POST"
	name="<portlet:namespace />fm">

	<aui:fieldset>

		<aui:input name="redirect" type="hidden" value="<%=redirect%>" />
		
		<aui:input name="userId" type="hidden" value="<%=String.valueOf(userId)%>" />

		<aui:input name="status" type="textarea" value="<%= status %>"/>

	</aui:fieldset>

	<aui:button-row>

		<aui:button type="submit"></aui:button>

		<aui:button type="cancel" onClick="<%= redirect %>"></aui:button>

	</aui:button-row>

</aui:form>
