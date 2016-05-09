package com.rivetlogic.profilesummay;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.User;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetVocabulary;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil;
import com.liferay.portlet.social.model.SocialRelationConstants;
import com.liferay.portlet.social.service.SocialRelationLocalServiceUtil;
import com.liferay.portlet.social.service.SocialRequestLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ValidatorException;

/**
 * Portlet implementation class ProfileSummaryPortlet
 */
public class ProfileSummaryPortlet extends MVCPortlet {

	private static final String USER_ABOUT_ATRRIBUTE = "about";
	private static final String USER_QUOTE_ATRRIBUTE = "quote";
	private static final String USER_AUTHOR_ATRRIBUTE = "author";

	@Override
	protected void doDispatch(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

		try {
			setPreferences(renderRequest);

		} catch (PortalException | SystemException e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		}

		super.doDispatch(renderRequest, renderResponse);

	}

	@Override
	public void doView(RenderRequest renderRequest, RenderResponse response) throws IOException, PortletException {

		try {
			setPreferences(renderRequest);

			User user = this.getUser(renderRequest);

			List<AssetCategory> skills = new ArrayList<AssetCategory>();
			List<AssetCategory> hobbies = new ArrayList<AssetCategory>();

			if (user != null) {

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
			}

			renderRequest.setAttribute("skills", skills);
			renderRequest.setAttribute("hobbies", hobbies);

		} catch (PortalException | SystemException e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		}

		super.doView(renderRequest, response);
	}

	private User getUser(RenderRequest renderRequest) throws PortalException, SystemException {

		User user = null;

		ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
		Group group = themeDisplay.getScopeGroup();

		if (group.isUser()) {
			user = UserLocalServiceUtil.getUserById(group.getClassPK());
		}

		return user;
	}

	private void setPreferences(RenderRequest renderRequest) throws PortalException, SystemException {

		User user2 = this.getUser(renderRequest);
		PortletPreferences prefs = renderRequest.getPreferences();

		String quote = "";
		String author = "";
		String about = "";
		long userId = 0L;

		if (user2 != null) {

			quote = prefs.getValue(USER_QUOTE_ATRRIBUTE, StringPool.BLANK);
			author = prefs.getValue(USER_AUTHOR_ATRRIBUTE, StringPool.BLANK);
			about = prefs.getValue(USER_ABOUT_ATRRIBUTE, StringPool.BLANK);
			
			userId = user2.getUserId();
		}

		renderRequest.setAttribute(USER_QUOTE_ATRRIBUTE, quote);
		renderRequest.setAttribute(USER_AUTHOR_ATRRIBUTE, author);
		renderRequest.setAttribute(USER_ABOUT_ATRRIBUTE, about);
		renderRequest.setAttribute("userId", userId);
	}

	public void saveProfileQuote(ActionRequest request, ActionResponse response) throws ReadOnlyException, ValidatorException, IOException {

		String quote = ParamUtil.getString(request, USER_QUOTE_ATRRIBUTE);
		String author = ParamUtil.getString(request, USER_AUTHOR_ATRRIBUTE);

		PortletPreferences prefs = request.getPreferences();
        prefs.setValue(USER_QUOTE_ATRRIBUTE, quote);
        prefs.setValue(USER_AUTHOR_ATRRIBUTE, author);
        prefs.store();

		sendRedirect(request, response);

	}

	public void saveProfileAboutMe(ActionRequest request, ActionResponse response) throws ReadOnlyException, ValidatorException, IOException  {

		String about = ParamUtil.getString(request, USER_ABOUT_ATRRIBUTE);

		PortletPreferences prefs = request.getPreferences();
		prefs.setValue(USER_ABOUT_ATRRIBUTE, about);
		prefs.store();

		sendRedirect(request, response);

	}

	public void addFriend(ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {

		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

		Group group = GroupLocalServiceUtil.getGroup(themeDisplay.getScopeGroupId());

		User user = UserLocalServiceUtil.getUserById(group.getClassPK());

		SocialRequestLocalServiceUtil.addRequest(themeDisplay.getUserId(), 0, User.class.getName(), themeDisplay.getUserId(), 1, StringPool.BLANK,
				user.getUserId());
		
		sendRedirect(actionRequest, actionResponse);
	}

	public void deleteFriend(ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {

		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

		Group group = GroupLocalServiceUtil.getGroup(themeDisplay.getScopeGroupId());

		User user = UserLocalServiceUtil.getUserById(group.getClassPK());

		SocialRelationLocalServiceUtil.deleteRelation(themeDisplay.getUserId(), user.getUserId(), SocialRelationConstants.TYPE_BI_FRIEND);
		
		sendRedirect(actionRequest, actionResponse);
	}

	private static final Log _log = LogFactoryUtil.getLog(ProfileSummaryPortlet.class);

}
