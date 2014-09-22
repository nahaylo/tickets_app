class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can [:read, :update], Ticket

    if user.role?('admin')
      can :manage, User
      can :manage, Status
      can :manage, ActiveAdmin::Comment
    end
  end

end