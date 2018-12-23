module RedmineDepthIssueFilter
    module PrependInstanceMethods
        def initialize_available_filters 
            super
            add_available_filter "depth", :type => :integer, :label => :depth_filter
            # TODO limits operator
            add_available_filter "root_task", :type => :integer, :label => :root_task_filter
        end
    end

    module AddedInstanceMethods
        # Wrapper around the +available_filters+ to add a new Deliverable filter
        def sql_for_depth_field(field, operator, value)
            # TODO manage operator 'entre', 'aucun' et 'tous'
            "(select count(*) + 1 from issues as i2 where i2.lft < issues.lft and i2.rgt > issues.rgt) #{operator} #{value.first.to_i}"
        end

        # copy from parent_id filter but include the root task.
        def sql_for_root_task_field(field, operator, value)
            root_id, lft, rgt = Issue.where(:id => value.first.to_i).pluck(:root_id, :lft, :rgt).first
            if root_id && lft && rgt
                "#{Issue.table_name}.root_id = #{root_id} AND #{Issue.table_name}.lft >= #{lft} AND #{Issue.table_name}.rgt <= #{rgt}"
            else
                "1=0"
            end
        end

    end

    def self.included(base) # :nodoc:
        base.send(:include, AddedInstanceMethods)
        IssueQuery.prepend(PrependInstanceMethods)
    end
end

IssueQuery.send(:include, RedmineDepthIssueFilter)
