<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme"%>
<%@ taglib uri="http://liferay.com/tld/security"
	prefix="liferay-security"%>

<%@ page import="javax.portlet.WindowState"%>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ page import="com.liferay.portal.kernel.util.UnicodeFormatter"%>
<%@ page import="com.liferay.portal.util.PortalUtil"%>
<%@ page
	import="com.liferay.portal.service.OrganizationLocalServiceUtil"%>
<%@ page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ page import="com.liferay.portal.model.Group"%>
<%@ page import="com.liferay.portal.model.Organization"%>
<%@ page import="com.liferay.portal.model.User"%>

<%@ page import="java.util.List"%>
<%@ page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@ page
	import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@ page
	import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@ page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@ page import="java.util.ArrayList"%>

<portlet:defineObjects />
<theme:defineObjects />
<%
	String redirect = PortalUtil.getCurrentURL(renderRequest);

	Group group = GroupLocalServiceUtil.getGroup(scopeGroupId);
	Organization organization = null;
	User user2 = null;
	if (group.isOrganization()) {
		organization = OrganizationLocalServiceUtil.getOrganization(group.getClassPK());
	} else if (group.isUser()) {
		user2 = UserLocalServiceUtil.getUserById(group.getClassPK());
	}
%>

<c:if test="<%=user2 != null%>">

	<portlet:renderURL var="editProfileSummary"
		windowState="<%=WindowState.MAXIMIZED.toString()%>">
		<portlet:param name="mvcPath" value="/html/profilesummary/edit.jsp" />
		<portlet:param name="userId" value="<%=String.valueOf(user2.getUserId())%>" />
		<portlet:param name="redirect" value="<%=redirect%>" />
	</portlet:renderURL>

	<%
		List<AssetCategory> skills = new ArrayList();
			List<AssetCategory> hobbies = new ArrayList();

			String skillsName = "Skills";
			String hobbiesName = "Hobbies";

			List<AssetCategory> categories = AssetCategoryLocalServiceUtil.getCategories(User.class.getName(), user.getPrimaryKey());

			for (AssetCategory category : categories) {
				AssetVocabulary vocabulary = AssetVocabularyLocalServiceUtil.getVocabulary(category.getVocabularyId());

				if (vocabulary.getName().equals(skillsName)) {
					skills.add(category);
				} else if (vocabulary.getName().equals(hobbiesName)) {
					hobbies.add(category);
				}
			}
	%>

	<b>About:</b>
	<div><%=user2.getExpandoBridge().getAttribute("about")%></div>

	<b>Hobbies:</b>

	<div>
		<%
			for (AssetCategory hobby : hobbies) {
		%>
		<span class="label"><%=hobby.getName()%></span>

		<%
			}
		%>

	</div>

	<b>Skills:</b>

	<div>
		<%
			for (AssetCategory skill : skills) {
		%>
		<span class="label"><%=skill.getName()%></span>

		<%
			}
		%>

	</div>

	<c:if test="<%=user2.getUserId() == user.getUserId()%>">
		<br />
		<a href="<%=editProfileSummary%>"> <i class="icon-edit"></i> Edit
		</a>

	</c:if>


</c:if>