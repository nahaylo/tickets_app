class User < ActiveRecord::Base
  has_many :tickets

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # All privileges are inherited from left to right
  ROLES = %w(staff admin)

  # Privileges are inherited between roles in the order specified in the ROLES
  # array. E.g. A admin can do the same as an staff + more.
  #
  # This method understands that and will therefore return true for admin
  # users even if you call `role?('staff')`.
  def role?(base_role)
    return false unless role # A user have a role attribute. If not set, the user does not have any roles.
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
