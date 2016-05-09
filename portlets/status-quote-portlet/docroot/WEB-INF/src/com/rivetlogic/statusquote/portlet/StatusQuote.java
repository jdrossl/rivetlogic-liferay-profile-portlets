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
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ValidatorException;

/**
 * Portlet implementation class StatusQuote
 */
public class StatusQuote extends MVCPortlet {

	public static final String USER_STATUS_ATRRIBUTE = "status";

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

		long userId = 0L;

		if (user2 != null) {
			userId = user2.getUserId();
		}

		renderRequest.setAttribute("userId", userId);
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

	public void saveStatusQuote(ActionRequest request, ActionResponse response) throws ReadOnlyException, ValidatorException, IOException {

		String status = ParamUtil.getString(request, USER_STATUS_ATRRIBUTE);

		PortletPreferences prefs = request.getPreferences();
		prefs.setValue(USER_STATUS_ATRRIBUTE, status);
		prefs.store();

		sendRedirect(request, response);
	}

	// https://github.com/limburgie/scoped-preferences-service

	private static final Log _log = LogFactoryUtil.getLog(StatusQuote.class);
}
