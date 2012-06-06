module SpentTimeRequired
    module Patches
        module IssuesControllerPatch
            def self.included(base)
                base.extend(ClassMethods)
                base.send(:include, InstanceMethods)
                base.class_eval do
                    unloadable
                    alias_method_chain :update, :check_spent_time
                end
            end

            module ClassMethods
            end

            module InstanceMethods
                def update_with_check_spent_time
                    msg = Setting.plugin_spent_time_required['required_msg']
                    if (params[:time_entry][:hours] == "")
                        flash[:error] = msg
                        find_issue
                        update_issue_from_params
                        render(:action => 'edit') and return
                    else
                        update_without_check_spent_time
                    end
                end
            end
        end
    end
end
