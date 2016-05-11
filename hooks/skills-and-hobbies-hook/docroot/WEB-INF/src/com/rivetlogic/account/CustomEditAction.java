package com.rivetlogic.account;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.struts.BaseStrutsPortletAction;
import com.liferay.portal.kernel.struts.StrutsPortletAction;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

public class CustomEditAction extends BaseStrutsPortletAction {
    
    private static final Log LOG = LogFactoryUtil.getLog(CustomEditAction.class);
    
    @Override
    public void processAction(StrutsPortletAction originalStrutsPortletAction, PortletConfig portletConfig,
            ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {
        
        LOG.debug("Running original user edit action");
        originalStrutsPortletAction.processAction(portletConfig, actionRequest, actionResponse);
        
        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        
        if(Validator.equals(cmd, Constants.UPDATE)) {
            LOG.debug("Running custom user edit action");
            User user = PortalUtil.getSelectedUser(actionRequest);
            String selectedSkills = ParamUtil.getString(actionRequest, "selected-skills-value");
            user.getExpandoBridge().setAttribute(WebKeys.FIELD_SKILLS, selectedSkills);
        }
    }
    
    @Override
    public String render(StrutsPortletAction originalStrutsPortletAction, PortletConfig portletConfig,
            RenderRequest renderRequest, RenderResponse renderResponse) throws Exception {
        return originalStrutsPortletAction.render(portletConfig, renderRequest, renderResponse);
    }
    
    @Override
    public void serveResource(StrutsPortletAction originalStrutsPortletAction, PortletConfig portletConfig,
            ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws Exception {
        originalStrutsPortletAction.serveResource(portletConfig, resourceRequest, resourceResponse);
    }
}
