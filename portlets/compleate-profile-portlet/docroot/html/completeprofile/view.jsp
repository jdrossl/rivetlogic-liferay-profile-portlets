<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme"%>
<%@ taglib uri="http://liferay.com/tld/security"
	prefix="liferay-security"%>

<%@page import="javax.portlet.PortletURL"%>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ page import="com.liferay.portal.security.auth.AuthTokenUtil"%>
<%@ page import="com.liferay.portal.kernel.util.HttpUtil"%>
<%@ page import="com.liferay.portal.kernel.util.Constants"%>

<%-- <%@ page import="" %> --%>

<portlet:defineObjects />
<theme:defineObjects />

<%
	PortletURL customFieldsPortletUrl = themeDisplay.getURLMyAccount();
	
	// TODO: make this dynamically:
	String myAccountPlid = "2";
	
	String categorazationUrl = customFieldsPortletUrl.toString() + "#_" + myAccountPlid + "_tab=_" + myAccountPlid + "_categorization";
%>

<aui:container cssClass="complete-profile-container">
	<aui:row>
		<aui:col span="10">
			<p>
				<b><liferay-ui:message key="welcome-title" /></b>
			</p>
			<p>
				<liferay-ui:message key="welcome-message" />
			</p>
			<p>
				<liferay-ui:message key="aditional-fields" />
				<aui:a href='<%=categorazationUrl%>' title="my-account"
					cssClass="use-dialog">
					<liferay-ui:message key="skills-hobbies" />
				</aui:a>
			</p>
		</aui:col>
		<aui:col span="2">
			<aui:a href="<%=themeDisplay.getURLMyAccount().toString()%>"
				title="my-account" cssClass="btn btn-primary use-dialog go-right">
				&nbsp;&nbsp;<liferay-ui:message key="edit" />&nbsp;&nbsp;
			</aui:a>
			<br/><br/>

			<aui:button value="finish" href="<%=portletDisplay.getURLClose()%>" cssClass="go-right"></aui:button>
		</aui:col>
	</aui:row>
</aui:container>

<aui:script>
	AUI().ready(function() {
		AUI().all('.use-dialog').on('click', function(event) {
			var url = event.currentTarget.get('href');
			var title = event.currentTarget.get('title');
			event.preventDefault();
			Liferay.Util.openWindow({
				dialog : {
					align : {
						points : [ 'tc', 'tc' ]
					},
					width : '95%'
				},
				title : title,
				uri : url
			});
		});
	});

	
</aui:script>