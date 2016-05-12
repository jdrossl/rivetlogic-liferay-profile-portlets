AUI.add('rl-skills-hobbies', function (A) {

    A.RivetSkillsHobbies = A.Base.create('my-portlet', A.Base, [Liferay.PortletBase], {
        
        /**
        * Will be invoked after object is constructed using this class,
        * this function name is reserved
        *
        */
        initializer: function () {
            var instance = this;    
        },
        
        initSkills: function() {
            this.bindSkills();
        },
        
        bindSkills: function() {
            var self = this;
            this.one('.skills-list').delegate('click', function(e) {
                var skill = e.target.text();
                var input = self.one('.selected-skills-value');
                var value = input.attr('value');
                if(value != '') {
                    input.attr('value', value + ',' + skill);
                } else {
                    input.attr('value', skill);
                }
                self.one('.selected-skills-list').append('<span class="label label-info">' + 
                    '<i class="icon-tag"></i><span class="selected-skill-item">' + skill + '</span>' +
                    '<a class="delete js-delete" href="#"><i class="icon-remove-sign"></i></a></span> ');
            }, '.category-list-item');
            
            this.one('.selected-skills-list').delegate('click', function(e) {
                var skill = e.target.text();
                e.target.get('parentNode').remove();
                var input = self.one('.selected-skills-value');
                var value = input.attr('value').split(',');
                var index = value.indexOf(skill);
                value.splice(index, 1);
                input.attr('value', value.join(','));
            }, '.selected-skill-item');
            
            Liferay.provide(window, 'addSkill', function(){
                var skill = A.one('#<portlet:namespace/>skill-name').attr('value');
                self.one('.skill-name').attr('value', '');
                var input = self.one('.selected-skills-value');
                var value = input.attr('value');
                if(value != '') {
                    input.attr('value', value + ',' + skill);
                } else {
                    input.attr('value', skill);
                }
                self.one('.selected-skills-list').append('<span class="label label-info">' + 
                    '<i class="icon-tag"></i><span class="selected-skill-item">' + skill + '</span>' + 
                    '<a class="delete js-delete" href="#"><i class="icon-remove-sign"></i></a></span> ');
            });
            
            this.one('.selected-skills-list').delegate('click', function(e) {
                e.preventDefault();
                console.log(this);
            }, '.js-delete');
        }    
    }, {
        ATTRS: {
            
        }
    });
    
}, '1.0.0', {
    requires: ['liferay-portlet-base']
});
