package com.rivetlogic.account;

import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.events.SimpleAction;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.User;
import com.liferay.portal.security.auth.CompanyThreadLocal;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portlet.expando.DuplicateColumnNameException;
import com.liferay.portlet.expando.model.ExpandoColumn;
import com.liferay.portlet.expando.model.ExpandoColumnConstants;
import com.liferay.portlet.expando.model.ExpandoTable;
import com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;

public class CustomStartupAction extends SimpleAction {

    private static final Log LOG = LogFactoryUtil.getLog(CustomStartupAction.class);
    
    @Override
    public void run(String[] arg0) throws ActionException {
        
        LOG.debug("Checking custom fields");
        
        long companyId = CompanyThreadLocal.getCompanyId();
        long classNameId = ClassNameLocalServiceUtil.getClassNameId(User.class);
        
        ExpandoTable userTable = null;
        
        try {
            userTable = ExpandoTableLocalServiceUtil.getDefaultTable(companyId, classNameId);
            checkCustomField(userTable, WebKeys.FIELD_SKILLS);
            checkCustomField(userTable, WebKeys.FIELD_HOBBIES);
        } catch(Exception e) {
            LOG.error(e);
        }
        
    }
    
    private void checkCustomField(ExpandoTable table, String name) throws SystemException, PortalException {
        ExpandoColumn column = ExpandoColumnLocalServiceUtil.getColumn(table.getTableId(), name);
        if(Validator.isNotNull(column)) {
            LOG.debug("Custom field already exists: " + name);
        } else {
            LOG.debug("Creating custom field: " + name);
            column = ExpandoColumnLocalServiceUtil.addColumn(table.getTableId(), name, ExpandoColumnConstants.STRING);
            column.persist();
            LOG.debug("Custom field created: " + name);
        }
    }

}
