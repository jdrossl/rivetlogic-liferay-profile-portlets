package com.rivetlogic.statusquote.portlet;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.ResourceConstants;
import com.liferay.portal.service.PortletPreferencesLocalService;
import com.liferay.portal.service.PortletPreferencesLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.Portal;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ValidatorException;

/**
 * Portlet implementation class StatusQuote
 */
public class StatusQuote extends MVCPortlet {

	private PortletPreferencesLocalService portletPreferencesService;
	private Portal portal;

	public StatusQuote() {
		portletPreferencesService = PortletPreferencesLocalServiceUtil.getService();
		portal = PortalUtil.getPortal();
	}

	@Override
	protected void doDispatch(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

		setPreferences(renderRequest);

		super.doDispatch(renderRequest, renderResponse);

	}

	@Override
	public void doView(RenderRequest renderRequest, RenderResponse response) throws IOException, PortletException {

		setPreferences(renderRequest);

		super.doView(renderRequest, response);
	}

	private void setPreferences(RenderRequest renderRequest) {
		String status = "";
		String quote = "";
		String author = "";
		try {
			status = this.getUserSpecificPreferences(renderRequest).getValue("status", "hola");
			quote = this.getUserSpecificPreferences(renderRequest).getValue("quote", "hola");
			author = this.getUserSpecificPreferences(renderRequest).getValue("author", "hola");

		} catch (SystemException e) {
			e.printStackTrace();
		}

		renderRequest.setAttribute("status", status);
		renderRequest.setAttribute("quote", quote);
		renderRequest.setAttribute("author", author);
	}

	public void saveStatusQuote(ActionRequest request, ActionResponse response) throws SystemException, ReadOnlyException, ValidatorException,
			IOException {

		String status = request.getParameter("status");
		String quote = request.getParameter("quote");
		String author = request.getParameter("author");

		PortletPreferences prefs = this.getUserSpecificPreferences(request);

		prefs.setValue("status", status);
		prefs.setValue("quote", quote);
		prefs.setValue("author", author);

		prefs.store();

		sendRedirect(request, response);
	}

	// https://github.com/limburgie/scoped-preferences-service

	public PortletPreferences getUserSpecificPreferences(PortletRequest portletRequest) throws SystemException {
		int ownerType = ResourceConstants.SCOPE_INDIVIDUAL;
		long ownerId = themeDisplay(portletRequest).getScopeGroupId();
		long plid = 0;

		return getPreferences(portletRequest, ownerType, ownerId, plid);
	}

	private PortletPreferences getPreferences(PortletRequest portletRequest, int ownerType, long ownerId, long plid) throws SystemException {
		long companyId = portal.getCompanyId(portletRequest);
		String portletId = (String) portletRequest.getAttribute(WebKeys.PORTLET_ID);
		return portletPreferencesService.getPreferences(companyId, ownerId, ownerType, plid, portletId);
	}

	private ThemeDisplay themeDisplay(PortletRequest portletRequest) {
		return ((ThemeDisplay) portletRequest.getAttribute("LIFERAY_SHARED_THEME_DISPLAY"));
	}

}
