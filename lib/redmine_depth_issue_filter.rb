module RedmineDepthIssueFilter
    module PrependInstanceMethods
        def initialize_available_filters 
            super
            add_available_filter "depth", :type => :integer, :label => "depth"
        end
    end

    module AddedInstanceMethods
        # Wrapper around the +available_filters+ to add a new Deliverable filter
        def sql_for_depth_field(field, operator, value)
            # TODO manage operator 'entre', 'aucun' et 'tous'
            "(select count(*) + 1 from issues as i2 where i2.lft < issues.lft and i2.rgt > issues.rgt) #{operator} #{value.first.to_i}"
        end

    end

    def self.included(base) # :nodoc:
        base.send(:include, AddedInstanceMethods)
        IssueQuery.prepend(PrependInstanceMethods)
    end
end

IssueQuery.send(:include, RedmineDepthIssueFilter)
