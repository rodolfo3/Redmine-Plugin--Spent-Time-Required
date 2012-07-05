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
                    @closed = Setting.plugin_spent_time_required['restrict_to_closed']
                    if (params.has_key?(:time_entry) and params[:time_entry][:hours] == "")
                        msg = Setting.plugin_spent_time_required['required_msg']
                        if (@closed)
                            @status = IssueStatus.find(params[:issue][:status_id])
                            if (@status.is_closed)
                                flash[:error] = msg
                                find_issue
                                update_issue_from_params
                                render(:action => 'edit') and return
                            end
                        else
                            flash[:error] = msg
                            find_issue
                            update_issue_from_params
                            render(:action => 'edit') and return
                        end

                    end
                    update_without_check_spent_time
                end
            end
        end
    end
end
