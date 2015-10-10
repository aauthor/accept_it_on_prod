module AcceptItOnProd

  class Feature < ActiveRecord::Base

    def [](name)
      where(name: name).first || DisabledFeature.new
    end

    def generally_available?
      availability == 'general'
    end

    def pivately_available?
      generally_available? || availability == 'private'
    end

    class DisabledFeature
      def generally_available?; false; end
      def privately_available?; false; end
    end

  end

  def feature_switch(name, enabled: lambda {}, disabled: lambda {}, enable_privately_if: lambda {})
    feature = Feature[name]
    if feature.generally_available? || feature.privately_available? && enable_privately_if.call
      enable.call
    else
      disabled.call
    end
  end

  #TODO:
  # - throw all this code away and TDD it
  # - API for turning on and off GA / Private / Off
  # - automatic testing for all configurations of features that are enabled
end



