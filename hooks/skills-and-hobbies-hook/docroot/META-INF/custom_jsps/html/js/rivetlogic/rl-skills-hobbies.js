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
        
        bindAddFromList: function(type) {
        	var self = this;
        	this.one('.' + type + '-list').delegate('click', function(e) {
                var skill = e.target.text();
                var input = self.one('.selected-' + type + '-value');
                var value = input.attr('value');
                if(value != '') {
                    input.attr('value', value + ',' + skill);
                } else {
                    input.attr('value', skill);
                }
                self.one('.selected-' + type + '-list').append('<span class="label label-info">' + 
                    '<i class="icon-tag"></i><span class="selected-' + type + '-item">' + skill + '</span>' +
                    '<a class="delete js-delete" href="#"><i class="icon-remove-sign"></i></a></span> ');
            }, '.' + type + '-list-item');
        },
        
        bindRemoveSelected: function(type) {
        	var self = this;
        	this.one('.selected-' + type + '-list').delegate('click', function(e) {
                var skill = e.target.text();
                e.target.get('parentNode').remove();
                var input = self.one('.selected-' + type + '-value');
                var value = input.attr('value').split(',');
                var index = value.indexOf(skill);
                value.splice(index, 1);
                input.attr('value', value.join(','));
            }, '.selected-' + type + '-item');
        },
        
        bindAddFromButton: function(type)  {
        	var self = this;
        	Liferay.provide(window, 'add'+ type, function(){
                var skill = self.one('.' + type + '-name').attr('value');
                self.one('.' + type + '-name').attr('value', '');
                var input = self.one('.selected-' + type + '-value');
                var value = input.attr('value');
                if(value != '') {
                    input.attr('value', value + ',' + skill);
                } else {
                    input.attr('value', skill);
                }
                self.one('.selected-' + type + '-list').append('<span class="label label-info">' + 
                    '<i class="icon-tag"></i><span class="selected-' + type + '-item">' + skill + '</span>' + 
                    '<a class="delete js-delete" href="#"><i class="icon-remove-sign"></i></a></span> ');
            });
        },
        
        preventDefaults: function(type) {
        	var self = this;
        	this.one('.selected-' + type + '-list').delegate('click', function(e) {
                e.preventDefault();
                console.log(this);
            }, '.js-delete');
        },
        
        bindSkills: function() {
            var self = this;
            
            this.bindAddFromList('skills');
            this.bindRemoveSelected('skills');
            this.bindAddFromButton('skills');
            this.preventDefaults('skills');
            
            this.bindAddFromList('hobbies');
            this.bindRemoveSelected('hobbies');
            this.bindAddFromButton('hobbies');
            this.preventDefaults('hobbies');
            
        }    
    }, {
        ATTRS: {
            
        }
    });
    
}, '1.0.0', {
    requires: ['liferay-portlet-base']
});
