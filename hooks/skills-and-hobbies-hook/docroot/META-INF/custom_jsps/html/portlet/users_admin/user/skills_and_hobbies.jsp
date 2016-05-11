
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Arrays"%>
<%@ page import="com.liferay.portal.kernel.util.StringPool"%>
<%@ page import="com.liferay.portal.kernel.util.StringUtil"%>
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
<%@ page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@ page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@ page import="com.liferay.portal.util.comparator.GroupIdComparator"%>
<%@ page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@ page import="com.liferay.portlet.asset.model.AssetVocabulary"%>

<portlet:defineObjects/>
<theme:defineObjects/>

<%
	long classNameId = ClassNameLocalServiceUtil.getClassNameId(User.class);
	long companyId = themeDisplay.getCompanyId();
	long groupId = themeDisplay.getScopeGroupId();
	
	String selectedSkills = StringPool.BLANK;
	
	ExpandoTable tableSkills = ExpandoTableLocalServiceUtil.getDefaultTable(companyId, classNameId);
	ExpandoColumn columnSkills = ExpandoColumnLocalServiceUtil.getColumn(tableSkills.getTableId(), "skills");
	ExpandoValue valueSkills = ExpandoValueLocalServiceUtil.getValue(classNameId, tableSkills.getName(), columnSkills.getName(), user.getUserId());
	if(Validator.isNotNull(valueSkills)) {
	    selectedSkills = valueSkills.getData();
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
	    //TODO: Make vocabulary configurable by Id?
	    if(v.getName().equals("Skills")) skills = v;
	}
	
	List<AssetCategory> rootCategories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(skills.getVocabularyId(), -1, -1, null);
	StringBuilder sb = new StringBuilder();
	buildTree(sb, rootCategories);
	
	List<String> selected = Arrays.asList(StringUtil.split(selectedSkills));
%>

<aui:container>
	<c:if test="<%= ExpandoColumnPermissionUtil.contains(permissionChecker, columnSkills, ActionKeys.UPDATE) %>">
	<h2>Skills</h2>
	<aui:row>
		<aui:col width="60" cssClass="well">
			<%= sb.toString() %>
		</aui:col>
		<aui:col width="40">
			<aui:field-wrapper>
				<aui:input name="skill-name" />
				<aui:button name="add-skill" value="add-skill" icon="icon-plus" />
			</aui:field-wrapper>
			<div class="well">
				<ul>
				<c:forEach items="<%= selected %>" var="skill">
					<li>${ skill }</li>
				</c:forEach>
				</ul>
			</div>
		</aui:col>
	</aui:row>
	<%-- TODO: Update field on click events --%>
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

<%!
	private void buildTree(StringBuilder sb, List<AssetCategory> cats) throws Exception {
    	sb.append("<ul>");
    	for(AssetCategory cat : cats) {
    	    sb.append("<li>");
        	sb.append(cat.getName());
        	List<AssetCategory> children = AssetCategoryLocalServiceUtil.getChildCategories(cat.getCategoryId());
        	if(!children.isEmpty()) {
        	    buildTree(sb, children);
        	}
        	sb.append("</li>");
    	}
    	sb.append("</ul>");
	}
%>