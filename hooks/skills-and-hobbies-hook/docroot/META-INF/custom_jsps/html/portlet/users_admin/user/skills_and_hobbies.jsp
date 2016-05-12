
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
<%@ page import="com.liferay.portal.service.CompanyLocalServiceUtil"%>
<%@ page import="com.liferay.portal.util.PortalUtil"%>

<portlet:defineObjects/>
<theme:defineObjects/>

<%
	long classNameId = ClassNameLocalServiceUtil.getClassNameId(User.class);
	long companyId = PortalUtil.getDefaultCompanyId();
	long groupId = CompanyLocalServiceUtil.fetchCompany(companyId).getGroupId();
	
	String selectedSkills = StringPool.BLANK;
	String selectedHobbies = StringPool.BLANK;
	
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
	    selectedHobbies = valueHobbies.getData();
	}
	
	String skillsList = getCategoriesTree(groupId, "Skills");
	String hobbiesList = getCategoriesTree(groupId, "Hobbies");
	
	List<String> selectedSkillsList = Arrays.asList(StringUtil.split(selectedSkills));
	List<String> selectedHobbiesList = Arrays.asList(StringUtil.split(selectedHobbies));
%>


<aui:script>
<%-- 
  update rlcacheid everytime new version is build for distribution, this 
  because hooks does not handle well cache and scss processing
--%>
<% String rlcacheid = "?build=3"; %>              
YUI().applyConfig({
    groups : {
        'rivet-custom' : {
            base : Liferay.AUI.getJavaScriptRootPath() + '/rivetlogic/',
            async : false,
            modules : {
                'rl-skills-hobbies-css': {
                        path: 'rl-skills-hobbies.css<%=rlcacheid %>',
                        type: 'css'
                }
            }
        }
    }
});
</aui:script>

<aui:container>
	<c:if test="<%= ExpandoColumnPermissionUtil.contains(permissionChecker, columnSkills, ActionKeys.UPDATE) %>">
	<h2>Skills</h2>
	<hr>
	<aui:row>
		<aui:col width="60" cssClass="well">
			<div class="skills-list sh-list">
				<p>Please select your skills:</p>
				<%= skillsList %>
			</div>
		</aui:col>
		<aui:col width="40">
			<aui:field-wrapper>
				<aui:input cssClass="input-inline" name="skill-name" label="" placeholder="skill-name" />
				<aui:button name="add-skill" value="add-skill" icon="icon-plus" onClick="addSkill()" />
			</aui:field-wrapper>
			<div class="well sh-list">
				<p>Selected skills:</p>
				<ul class="selected-skills-list">
				<c:forEach items="<%= selectedSkillsList %>" var="skill">
					<li><i class="icon-tag"></i><span class="selected-skill-item">${ skill }</span></li>
				</c:forEach>
				</ul>
			</div>
		</aui:col>
	</aui:row>
	<%-- TODO: Update field on click events --%>
	<aui:input type="hidden" name="selected-skills-value" value="<%= selectedSkills %>" />
	</c:if>
	
	<c:if test="<%= ExpandoColumnPermissionUtil.contains(permissionChecker, columnHobbies, ActionKeys.UPDATE) %>">
	<h2>Hobbies</h2>
	<hr>
	<aui:row>
		<aui:col width="60" cssClass="well">
			<div class="sh-list">
				<p>Please select your hobbies:</p>
				<%= hobbiesList %>
			</div>
		</aui:col>
		<aui:col width="40">
			<aui:field-wrapper>
				<aui:input name="hobby-name" />
				<aui:button name="add-hobby" value="add-hobby" icon="icon-plus" />
			</aui:field-wrapper>
			<div class="well sh-list">
				<p>Selected hobbies:</p>
				<ul>
				<c:forEach items="<%= selectedHobbiesList %>" var="hobby">
					<li>${ hobby }</li>
				</c:forEach>
				</ul>
			</div>
		</aui:col>
	</aui:row>
	<%-- TODO: Update field on click events --%>
	<aui:input type="hidden" name="selected-hobbies" value="a,c,b,d" />
	</c:if>
</aui:container>

<%!
	private void buildTree(StringBuilder sb, List<AssetCategory> cats) throws Exception {
    	sb.append("<ul>");
    	for(AssetCategory cat : cats) {
    	    sb.append("<li>");
        	sb.append("<i class=\"icon-tag\"></i><a href=\"javascript:void(0);\" class=\"category-list-item\">").append(cat.getName()).append("</a>");
        	List<AssetCategory> children = AssetCategoryLocalServiceUtil.getChildCategories(cat.getCategoryId());
        	if(!children.isEmpty()) {
        	    buildTree(sb, children);
        	}
        	sb.append("</li>");
    	}
    	sb.append("</ul>");
	}

	private String getCategoriesTree(long groupId, String name) throws Exception {
	    List<AssetVocabulary> vocabularies = AssetVocabularyLocalServiceUtil.getGroupVocabularies(groupId, false);
	    StringBuilder tree = new StringBuilder();
		AssetVocabulary vocabulary = null;
		
		for(AssetVocabulary v : vocabularies) {
		    //TODO: Make vocabulary configurable by Id?
		    if(Validator.equals(name, v.getName())) vocabulary = v;
		}
		
		if(Validator.isNotNull(vocabulary)) {
		    List<AssetCategory> rootCats = AssetCategoryLocalServiceUtil
			        .getVocabularyRootCategories(vocabulary.getVocabularyId(), -1, -1, null);
			buildTree(tree, rootCats);
		}
		
		return tree.toString();
	}
%>
<aui:script use="base">
	YUI().use('rl-skills-hobbies-css', function(Y) {
	});
	A.one('.skills-list').delegate('click', function(e) {
		var skill = e.target.text();
		var input = A.one('#<portlet:namespace/>selected-skills-value');
		var value = input.attr('value');
		if(value != '') {
			input.attr('value', value + ',' + skill);
		} else {
			input.attr('value', skill);
		}
		A.one('.selected-skills-list').append('<li><i class="icon-tag"></i><span class="selected-skill-item">' + skill + '</span></li>');
	}, '.category-list-item');
	
	A.one('.selected-skills-list').delegate('click', function(e) {
		var skill = e.target.text();
		e.target.get('parentNode').remove();
		var input = A.one('#<portlet:namespace/>selected-skills-value');
		var value = input.attr('value').split(',');
		var index = value.indexOf(skill);
		value.splice(index, 1);
		input.attr('value', value.join(','));
	}, '.selected-skill-item');
	
	Liferay.provide(window, 'addSkill', function(){
		var skill = A.one('#<portlet:namespace/>skill-name').attr('value');
		A.one('#<portlet:namespace/>skill-name').attr('value', '');
		var input = A.one('#<portlet:namespace/>selected-skills-value');
		var value = input.attr('value');
		if(value != '') {
			input.attr('value', value + ',' + skill);
		} else {
			input.attr('value', skill);
		}
		A.one('.selected-skills-list').append('<li><i class="icon-tag"></i><span class="selected-skill-item">' + skill + '</span></li>');
	});
</aui:script>
