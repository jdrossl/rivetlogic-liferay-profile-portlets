package com.rivetlogic.statusquote.portlet;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.User;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.expando.model.ExpandoColumn;
import com.liferay.portlet.expando.model.ExpandoColumnConstants;
import com.liferay.portlet.expando.model.ExpandoTable;
import com.liferay.portlet.expando.model.ExpandoValue;
import com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoValueLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ValidatorException;

/**
 * Portlet implementation class StatusQuote
 */
public class StatusQuote extends MVCPortlet {

	private static final String USER_STATUS_ATRRIBUTE = "status";

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

		String status = "";
		long userId = 0L;

		if (user2 != null) {

			if (user2.getExpandoBridge().hasAttribute(USER_STATUS_ATRRIBUTE)) {
				status = getCustomAtrribute(user2, USER_STATUS_ATRRIBUTE);
			}

			userId = user2.getUserId();
		}
		renderRequest.setAttribute(USER_STATUS_ATRRIBUTE, status);
		renderRequest.setAttribute("userId", userId);
	}

	private String getCustomAtrribute(User user, String attribute) {
		String result = "";
		try {
			ExpandoTable table = ExpandoTableLocalServiceUtil.getDefaultTable(user.getCompanyId(), User.class.getName());
			ExpandoColumn column = ExpandoColumnLocalServiceUtil.getColumn(table.getTableId(), attribute);
			ExpandoValue expandoValue = ExpandoValueLocalServiceUtil.getValue(table.getTableId(), column.getColumnId(), user.getUserId());
			result = expandoValue.getString();
		} catch (Exception e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		}

		return result;

	}

	private void saveCustomAtrribute(User user, String attribute, String value) throws PortalException, SystemException {
		if (!user.getExpandoBridge().hasAttribute(attribute)) {
			user.getExpandoBridge().addAttribute(attribute, ExpandoColumnConstants.STRING, false);
		}
		user.getExpandoBridge().setAttribute(attribute, value);
	}

	@Override
	protected void doDispatch(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

		try {
			setPreferences(renderRequest);
		} catch (PortalException e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		} catch (SystemException e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		}

		super.doDispatch(renderRequest, renderResponse);

	}

	@Override
	public void doView(RenderRequest renderRequest, RenderResponse response) throws IOException, PortletException {

		try {
			setPreferences(renderRequest);
		} catch (PortalException e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		} catch (SystemException e) {
			_log.error(e.getMessage());
			e.printStackTrace();
		}

		super.doView(renderRequest, response);
	}

	public void saveStatusQuote(ActionRequest request, ActionResponse response) throws SystemException, ReadOnlyException, ValidatorException,
			IOException, PortalException {

		long userId = ParamUtil.getLong(request, "userId");

		User user = UserLocalServiceUtil.getUser(userId);

		String status = ParamUtil.getString(request, USER_STATUS_ATRRIBUTE);

		this.saveCustomAtrribute(user, USER_STATUS_ATRRIBUTE, status);

		sendRedirect(request, response);
	}

	// https://github.com/limburgie/scoped-preferences-service

	private static final Log _log = LogFactoryUtil.getLog(StatusQuote.class);
}
