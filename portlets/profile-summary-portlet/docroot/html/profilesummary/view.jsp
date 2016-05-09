<%@page import="com.liferay.portal.kernel.util.DateUtil"%>
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
<%@ page
	import="com.liferay.portlet.social.service.SocialRelationLocalServiceUtil"%>
<%@ page import="javax.portlet.PortletURL"%>
<%@ page import="javax.portlet.ActionRequest"%>
<%@ page
	import="com.liferay.portlet.social.model.SocialRelationConstants"%>
<%@ page
	import="com.liferay.portlet.social.service.SocialRequestLocalServiceUtil"%>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ page
	import="com.liferay.portlet.social.model.SocialRequestConstants"%>
<%@ page import="com.liferay.portal.model.Contact"%>


<portlet:defineObjects />
<theme:defineObjects />

<%
	String currentURL = PortalUtil.getCurrentURL(request);

	String redirect = PortalUtil.getCurrentURL(renderRequest);

	Long userId = (Long) renderRequest.getAttribute("userId");
%>
<c:choose>
	<c:when test="<%=userId > 0%>">

		<portlet:renderURL var="editProfileQuote"
			windowState="<%=WindowState.MAXIMIZED.toString()%>">
			<portlet:param name="mvcPath"
				value="/html/profilesummary/edit_quote.jsp" />
			<portlet:param name="userId" value="<%=String.valueOf(userId)%>" />
			<portlet:param name="redirect" value="<%=redirect%>" />
		</portlet:renderURL>

		<portlet:renderURL var="editProfileAboutMe"
			windowState="<%=WindowState.MAXIMIZED.toString()%>">
			<portlet:param name="mvcPath"
				value="/html/profilesummary/edit_about_me.jsp" />
			<portlet:param name="userId" value="<%=String.valueOf(userId)%>" />
			<portlet:param name="redirect" value="<%=redirect%>" />
		</portlet:renderURL>

		<%
			List<AssetCategory> skills = (List<AssetCategory>) renderRequest.getAttribute("skills");
					List<AssetCategory> hobbies = (List<AssetCategory>) renderRequest.getAttribute("hobbies");
					String quote = (String) renderRequest.getAttribute("quote");
					String author = (String) renderRequest.getAttribute("author");
					String about = (String) renderRequest.getAttribute("about");

					User user2 = UserLocalServiceUtil.getUser(userId);
					boolean isUserProfileOwner = userId == user.getUserId();
		%>



		<aui:container cssClass="summary-container">
			<aui:row>

				<aui:col>
					<div class="user-img-container">
						<div class="user-img-overlay"></div>
						<img class="user-img-container-img" src="<%=user2.getPortraitURL(themeDisplay)%>" alt="" />
						<div class="user-profile-img-box" style="background-image: url(<%=user2.getPortraitURL(themeDisplay)%>);"></div>
					</div>
				</aui:col>

			</aui:row>

			<aui:row cssClass="user-info">
				<aui:col>
					<h3>
						<c:choose>
							<c:when test="<%=isUserProfileOwner%>">
							    <liferay-ui:message key="welcome-user" arguments="<%=user2.getFirstName()%>" />
							</c:when>
							<c:otherwise>
								<%=user2.getFullName()%>
							</c:otherwise>
						</c:choose>
					</h3>
					<div class="job-title"><%=user2.getJobTitle()%></div>

					<div class="about-me">
						<b><liferay-ui:message key="about-me"/></b>
						<div><%=about%></div>
						<c:if test="<%=isUserProfileOwner%>">
							&nbsp;<a href="<%=editProfileAboutMe%>"><i class="icon-edit"></i>
								<liferay-ui:message key="edit"/> </a>
						</c:if>
					</div>

					<div>
						<b><liferay-ui:message key="birtdate"/></b>
						<%=DateUtil.getDate(user2.getBirthday(), "MMMMM d", themeDisplay.getLocale())%>
					</div>

					<div>
						<b><liferay-ui:message key="email"/></b> <a href="mailto:<%=user2.getEmailAddress()%>"><%=user2.getEmailAddress()%></a>
					</div>

					<%
						Contact contact2 = user2.getContact();
					%>

					<div>
						<b><liferay-ui:message key="skype"/></b> <a href="skype:<%=contact2.getSkypeSn()%>"><%=contact2.getSkypeSn()%></a>
					</div>

					<%-- <div>
						<b>Twitter:</b>
						<%=contact2.getTwitterSn()%>
					</div> --%>

					<div class="quote-container">
						<div class="quote">
							<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" width="20px" height="16px" style="enable-background:new 0 0 45.9 35.3;" xml:space="preserve"><g class="shape" style="-webkit-transform: matrix(0.355556, 0, 0, 0.355556, 0, 1);-moz-transform: matrix(0.355556, 0, 0, 0.355556, 0, 1);transform: matrix(0.355556, 0, 0, 0.355556, 0, 1);"><path fill="#f89406" xmlns:default="http://www.w3.org/2000/svg" d="M35.3,35.3c-3.1,0-5.7-1.2-7.7-3.5c-2-2.3-3-5.2-3-8.7c0-5.4,1.7-10.1,5-14.1c3.3-4,8-6.9,13.8-8.6L44.6,0l1.3,6.4l-0.8,0.3  c-2.9,1.2-5.3,2.7-7.1,4.5c-1.6,1.6-2.5,3-2.6,4c0.1,0.1,0.7,0.6,2.7,1.3c0.7,0.2,1.2,0.4,1.6,0.6c1.6,0.6,2.9,1.6,3.8,3  c0.9,1.4,1.3,3.1,1.3,5c0,3-0.9,5.5-2.6,7.4C40.4,34.3,38.1,35.3,35.3,35.3z M42.9,2.7c-4.9,1.6-8.8,4.2-11.7,7.6  c-3,3.6-4.5,7.9-4.5,12.8c0,3,0.8,5.4,2.5,7.3c1.6,1.9,3.6,2.8,6.1,2.8c2.2,0,4-0.7,5.3-2.2c1.4-1.5,2.1-3.4,2.1-5.9  c0-1.5-0.3-2.8-1-3.8c-0.7-1-1.5-1.7-2.7-2.1c-0.4-0.1-0.9-0.3-1.6-0.6c-2-0.7-4.1-1.6-4.1-3.1c0-1.7,1.1-3.6,3.2-5.7  c1.8-1.8,4.2-3.3,7-4.6L42.9,2.7z M10.6,35.3c-3.1,0-5.6-1.2-7.7-3.5c-2-2.3-3-5.2-3-8.7c0-5.4,1.7-10.1,5-14.1  C8.3,4.9,13,2,18.8,0.3L19.9,0l1.4,6.4l-0.8,0.3c-2.9,1.2-5.3,2.7-7.1,4.5c-1.6,1.6-2.5,3-2.6,4.1c0.1,0.1,0.7,0.6,2.6,1.2  c0.7,0.2,1.3,0.4,1.7,0.6c1.6,0.6,2.8,1.6,3.7,3c0.9,1.4,1.3,3.1,1.3,5c0,3-0.9,5.5-2.6,7.4C15.8,34.3,13.5,35.3,10.6,35.3z   M18.3,2.7c-4.9,1.6-8.8,4.2-11.6,7.6c-3,3.6-4.5,7.9-4.5,12.8c0,3,0.8,5.4,2.5,7.3c1.6,1.9,3.6,2.8,6,2.8c2.3,0,4-0.7,5.4-2.2  c1.4-1.5,2-3.4,2-5.9c0-1.5-0.3-2.8-1-3.8c-0.7-1-1.5-1.7-2.7-2.1c-0.4-0.1-0.9-0.3-1.6-0.6c-2-0.7-4.1-1.6-4.1-3.2  c0-1.7,1.1-3.6,3.2-5.7c1.8-1.8,4.2-3.3,6.9-4.5L18.3,2.7z"></path></g></svg>
							<%=quote%>
							<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" width="20px" height="16px" style="enable-background:new 0 0 45.9 35.3;" xml:space="preserve"><g class="shape" style="-webkit-transform: matrix(0.355556, 0, 0, 0.355556, 0, 1);-moz-transform: matrix(0.355556, 0, 0, 0.355556, 0, 1);transform: matrix(0.355556, 0, 0, 0.355556, 0, 1);"><path fill="#f89406" xmlns:default="http://www.w3.org/2000/svg" d="M10.6,0c3.1,0,5.7,1.2,7.7,3.5c2,2.3,3,5.2,3,8.7c0,5.4-1.7,10.1-5,14.1c-3.3,4-8,6.9-13.8,8.6l-1.1,0.3L0,28.9l0.8-0.3  c2.9-1.2,5.3-2.7,7.1-4.5c1.6-1.6,2.5-3,2.6-4c-0.1-0.1-0.7-0.6-2.7-1.3c-0.7-0.2-1.2-0.4-1.6-0.6c-1.6-0.6-2.9-1.6-3.8-3  c-0.9-1.4-1.3-3.1-1.3-5c0-3,0.9-5.5,2.6-7.4C5.5,1,7.8,0,10.6,0z M2.9,32.6c4.9-1.6,8.8-4.2,11.7-7.6c3-3.6,4.5-7.9,4.5-12.8  c0-3-0.8-5.4-2.5-7.3c-1.6-1.9-3.6-2.8-6.1-2.8c-2.2,0-4,0.7-5.3,2.2c-1.4,1.5-2.1,3.4-2.1,5.9c0,1.5,0.3,2.8,1,3.8  c0.7,1,1.5,1.7,2.7,2.1c0.4,0.1,0.9,0.3,1.6,0.6c2,0.7,4.1,1.6,4.1,3.1c0,1.7-1.1,3.6-3.2,5.7c-1.8,1.8-4.2,3.3-7,4.6L2.9,32.6z   M35.2,0c3.1,0,5.6,1.2,7.7,3.5c2,2.3,3,5.2,3,8.7c0,5.4-1.7,10.1-5,14.1c-3.3,4-7.9,6.9-13.8,8.6L26,35.3l-1.4-6.4l0.8-0.3  c2.9-1.2,5.3-2.7,7.1-4.5c1.6-1.6,2.5-3,2.6-4.1c-0.1-0.1-0.7-0.6-2.6-1.2c-0.7-0.2-1.3-0.4-1.7-0.6c-1.6-0.6-2.8-1.6-3.7-3  c-0.9-1.4-1.3-3.1-1.3-5c0-3,0.9-5.5,2.6-7.4C30.1,1,32.4,0,35.2,0z M27.6,32.6c4.9-1.6,8.8-4.2,11.6-7.6c3-3.6,4.5-7.9,4.5-12.8  c0-3-0.8-5.4-2.5-7.3c-1.6-1.9-3.6-2.8-6-2.8c-2.3,0-4,0.7-5.4,2.2c-1.4,1.5-2,3.4-2,5.9c0,1.5,0.3,2.8,1,3.8c0.7,1,1.5,1.7,2.7,2.1  c0.4,0.1,0.9,0.3,1.6,0.6c2,0.7,4.1,1.6,4.1,3.2c0,1.7-1.1,3.6-3.2,5.7c-1.8,1.8-4.2,3.3-6.9,4.5L27.6,32.6z"></path></g></svg>
						</div>
						<div class="quote-author"><%= author %></div>
						<c:if test="<%=isUserProfileOwner%>">
							&nbsp;<a href="<%=editProfileQuote%>"><i class="icon-edit"></i>
								<liferay-ui:message key="edit"/> </a>
						</c:if>
					</div>

				</aui:col>
				<div css="user-skills-hobbies">

					<c:choose>
						<c:when
							test="<%=SocialRelationLocalServiceUtil.hasRelation(user.getUserId(), user2.getUserId(),
												SocialRelationConstants.TYPE_BI_FRIEND)%>">

							<%
								PortletURL removeFriendURL = renderResponse.createActionURL();

															removeFriendURL.setParameter(ActionRequest.ACTION_NAME, "deleteFriend");
															removeFriendURL.setParameter("redirect", currentURL);

															String removeFriendHREF = "javascript:if (confirm('"
																	+ LanguageUtil.format(pageContext,
																			"are-you-sure-you-want-to-remove-x-as-a-friend-x-will-not-be-notified", user2.getFullName(),
																			false) + "')) { submitForm(document.hrefFm, '" + removeFriendURL + "'); }";
							%>

							<p class="remove-friend">
								<liferay-ui:icon image="join" label="<%=true%>"
									message="remove-friend" url="<%=removeFriendHREF%>" />
							</p>
						</c:when>
						<c:when
							test="<%=SocialRequestLocalServiceUtil.hasRequest(user.getUserId(), User.class.getName(), user.getUserId(),
												1, user2.getUserId(), SocialRequestConstants.STATUS_PENDING)%>">
							<div class="add-as-friend alert alert-info pending">
								<aui:icon image="time" />

								<liferay-ui:message key="friend-requested" />
							</div>
						</c:when>
						<c:when
							test="<%=SocialRequestLocalServiceUtil.hasRequest(user2.getUserId(), User.class.getName(),
												user2.getUserId(), 1, user.getUserId(), SocialRequestConstants.STATUS_PENDING)%>">
							<div class="alert alert-info friend-requests pending">
								<aui:icon image="time" />

								<liferay-ui:message key="pending-friend-requests" />
							</div>
						</c:when>
						<c:when
							test="<%=SocialRelationLocalServiceUtil.isRelatable(user.getUserId(), user2.getUserId(),
												SocialRelationConstants.TYPE_BI_FRIEND)%>">

							<%
								PortletURL addAsFriendURL = renderResponse.createActionURL();

															addAsFriendURL.setParameter(ActionRequest.ACTION_NAME, "addFriend");
															addAsFriendURL.setParameter("redirect", currentURL);
							%>

							<aui:form action="<%=addAsFriendURL.toString()%>" method="post"
								name="fm">
								<div class="add-as-friend">
									<aui:input label="send-a-message" name="addFriendMessage"
										type="textarea" />

									<aui:button type="submit" value="add-as-friend" />
								</div>
							</aui:form>
						</c:when>
					</c:choose>

					<div class="skills-container">
						<b><liferay-ui:message key="skills"/></b>

						<div class="tag-container">
							<%
								for (AssetCategory skill : skills) {
							%>
							<span class="label"><%=skill.getName()%></span>

							<%
								}
							%>

						</div>
					</div>
					<div class="hobbies-container">
						<b><liferay-ui:message key="hobbies"/></b>

						<div class="tag-container">
							<%
								for (AssetCategory hobby : hobbies) {
							%>
							<span class="label"><%=hobby.getName()%></span>

							<%
								}
							%>

						</div>
					</div>
				</div>
			</aui:row>
		</aui:container>

	</c:when>
	<c:otherwise>
		<liferay-ui:message key="no-profile-summary"/>
	</c:otherwise>
</c:choose>
