module RailsDevelopmentBoost
  ActiveSupport.on_load(:after_initialize) do
    ReferencePatch.apply!
    DependenciesPatch.apply!
    DescendantsTrackerPatch.apply!
  end
  
  ActiveSupport.on_load(:action_controller) do
    ActiveSupport.on_load(:after_initialize) do
      ViewHelpersPatch.apply!
      
      if defined?(ActionDispatch::Reloader) # post 0f7c970
        ActionDispatch::Reloader.to_prepare { ActiveSupport::Dependencies.unload_modified_files! }
      else
        ActionDispatch::Callbacks.before    { ActiveSupport::Dependencies.unload_modified_files! }
      end
    end
  end
  
  autoload :DependenciesPatch,       'rails_development_boost/dependencies_patch'
  autoload :DescendantsTrackerPatch, 'rails_development_boost/descendants_tracker_patch'
  autoload :LoadedFile,              'rails_development_boost/loaded_file'
  autoload :ReferencePatch,          'rails_development_boost/reference_patch'
  autoload :ViewHelpersPatch,        'rails_development_boost/view_helpers_patch'
  
  def self.debug!
    DependenciesPatch.debug!
  end
end
