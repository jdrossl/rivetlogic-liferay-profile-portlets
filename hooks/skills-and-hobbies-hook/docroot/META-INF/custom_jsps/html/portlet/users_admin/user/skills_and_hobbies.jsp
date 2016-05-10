
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="com.liferay.portal.util.comparator.GroupIdComparator"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="java.util.List" %>
<%@ page import="com.liferay.portal.kernel.util.Validator"%>
<%@ page import="com.liferay.portal.model.User" %>
<%@ page import="com.liferay.portlet.expando.model.ExpandoValue" %>
<%@ page import="com.liferay.portlet.expando.service.ExpandoValueLocalServiceUtil" %>
<%@ page import="com.liferay.portal.service.ClassNameLocalServiceUtil" %>
<%@ page import="com.liferay.portal.security.permission.ActionKeys"%>
<%@ page import="com.liferay.portlet.expando.service.permission.ExpandoColumnPermissionUtil"%>
<%@ page import="com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil"%>
<%@ page import="com.liferay.portlet.expando.model.ExpandoColumn"%>
<%@ page import="com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil"%>
<%@ page import="com.liferay.portlet.expando.model.ExpandoTable"%>

<portlet:defineObjects/>
<theme:defineObjects/>

<%
	long classNameId = ClassNameLocalServiceUtil.getClassNameId(User.class);
	long companyId = themeDisplay.getCompanyId();
	long groupId = themeDisplay.getScopeGroupId();
	
	ExpandoTable tableSkills = ExpandoTableLocalServiceUtil.getDefaultTable(companyId, classNameId);
	ExpandoColumn columnSkills = ExpandoColumnLocalServiceUtil.getColumn(tableSkills.getTableId(), "skills");
	ExpandoValue valueSkills = ExpandoValueLocalServiceUtil.getValue(classNameId, tableSkills.getName(), columnSkills.getName(), user.getUserId());
	if(Validator.isNotNull(valueSkills)) {
	    String selectedSkills = valueSkills.getData();
	}
	
	ExpandoTable tableHobbies = ExpandoTableLocalServiceUtil.getDefaultTable(companyId, classNameId);
	ExpandoColumn columnHobbies = ExpandoColumnLocalServiceUtil.getColumn(tableHobbies.getTableId(), "hobbies");
	ExpandoValue valueHobbies = ExpandoValueLocalServiceUtil.getValue(classNameId, tableHobbies.getName(), columnHobbies.getName(), user.getUserId());
	if(Validator.isNotNull(valueHobbies)) {
	    String selectedHobbies = valueHobbies.getData();
	}
	
	List<AssetVocabulary> vocabularies = AssetVocabularyLocalServiceUtil.getGroupVocabularies(groupId, false);
	AssetVocabulary skills = null;
	for(AssetVocabulary v : vocabularies) {
	    if(v.getName().equals("Skills")) skills = v;
	}
%>

<aui:container>
	<c:if test="<%= ExpandoColumnPermissionUtil.contains(permissionChecker, columnSkills, ActionKeys.UPDATE) %>">
	<h2>Skills</h2>
	<aui:row>
		<aui:col width="70" cssClass="well">
			Categories...<br/>
			<c:forEach items="<%= skills.getCategories() %>" var="category">
				<c:if test="${ category.rootCategory }">
					${ category.name }<br/>
				</c:if>
			</c:forEach>
		</aui:col>
		<aui:col width="30">
			<aui:fieldset>
				<aui:input name="hobby-name" />
				<aui:button icon="icon-add" name="add" />
			</aui:fieldset>
		</aui:col>
	</aui:row>
	<aui:input type="hidden" name="selected-skills" value="a,c,b,d" />
	</c:if>
	
	<c:if test="<%= ExpandoColumnPermissionUtil.contains(permissionChecker, columnSkills, ActionKeys.UPDATE) %>">
	<h2>Hobbies</h2>
	<aui:row>
		<aui:col width="70" cssClass="well">
			Categories...
		</aui:col>
		<aui:col width="30">
			<aui:fieldset>
				<aui:input name="hobby-name" />
				<aui:button icon="icon-add" name="add" />
			</aui:fieldset>
		</aui:col>
	</aui:row>
	</c:if>
</aui:container>