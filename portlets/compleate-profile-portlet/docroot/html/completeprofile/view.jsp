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
	
	String customFieldsUrl = customFieldsPortletUrl.toString() + "#_" + myAccountPlid + "_tab=_" + myAccountPlid + "_customFields";
%>


<p>
	Welcome to <b>Rivet Logic Corp.</b>
</p>
<p>Take a moment to complete your profile:</p>

<ol>
	<li>Fill up your <aui:a
			href="<%=themeDisplay.getURLMyAccount().toString()%>"
			title="My Account" cssClass="use-dialog">account details</aui:a>.
	</li>
	<li>Do not forget selecting your <aui:a
			href='<%=categorazationUrl%>' title="Account Details"
			cssClass="use-dialog">skills and hobbies</aui:a> and fill up the <aui:a
			href='<%=customFieldsUrl%>' title="Account Details"
			cssClass="use-dialog">custom fields</aui:a>.
	</li>
</ol>


<aui:button value="Finish" href="<%=portletDisplay.getURLClose()%>"></aui:button>


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