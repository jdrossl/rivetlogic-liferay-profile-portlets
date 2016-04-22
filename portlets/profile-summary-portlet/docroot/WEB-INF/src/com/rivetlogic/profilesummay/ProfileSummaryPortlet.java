package com.rivetlogic.profilesummay;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.User;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetVocabulary;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil;
import com.liferay.portlet.expando.model.ExpandoColumn;
import com.liferay.portlet.expando.model.ExpandoColumnConstants;
import com.liferay.portlet.expando.model.ExpandoTable;
import com.liferay.portlet.expando.model.ExpandoValue;
import com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoValueLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

/**
 * Portlet implementation class ProfileSummaryPortlet
 */
public class ProfileSummaryPortlet extends MVCPortlet {

	private static final String USER_ABOUT_ATRRIBUTE = "about";

	@Override
	protected void doDispatch(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

		try {
			setPreferences(renderRequest);

		} catch (PortalException | SystemException e) {
			// TODO Auto-generated catch block
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
			// TODO Auto-generated catch block
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

		String about = "";
		long userId = 0L;

		if (user2 != null) {
			ExpandoTable table = ExpandoTableLocalServiceUtil.getDefaultTable(user2.getCompanyId(), User.class.getName());
			ExpandoColumn column = ExpandoColumnLocalServiceUtil.getColumn(table.getTableId(), USER_ABOUT_ATRRIBUTE);
			ExpandoValue expandoValue = ExpandoValueLocalServiceUtil.getValue(table.getTableId(), column.getColumnId(), user2.getUserId());
			userId = user2.getUserId();
			about = expandoValue.getString();
		}
		
		renderRequest.setAttribute(USER_ABOUT_ATRRIBUTE, about);
		renderRequest.setAttribute("userId", userId);
	}

	public void saveStatusQuote(ActionRequest request, ActionResponse response) throws PortalException, SystemException, IOException {

		long userId = ParamUtil.getLong(request, "userId");

		User user = UserLocalServiceUtil.getUser(userId);

		String about = ParamUtil.getString(request, USER_ABOUT_ATRRIBUTE);

		if (!user.getExpandoBridge().hasAttribute(USER_ABOUT_ATRRIBUTE)) {
			user.getExpandoBridge().addAttribute(USER_ABOUT_ATRRIBUTE, ExpandoColumnConstants.STRING, false);
		}
		user.getExpandoBridge().setAttribute(USER_ABOUT_ATRRIBUTE, about);

		sendRedirect(request, response);

	}

}
