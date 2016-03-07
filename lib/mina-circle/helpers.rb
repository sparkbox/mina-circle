module MinaCircle
  module Helpers
    def circle_ci
      @circle_ci ||= CircleCI.new circle_user, circle_project, branch
    end
  end
end
