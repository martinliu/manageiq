require "spec_helper"

describe VmInfraController do
  render_views
  before :each do
    set_user_privileges
    FactoryGirl.create(:vmdb_database)
    EvmSpecHelper.create_guid_miq_server_zone
    expect(MiqServer.my_guid).to be
    expect(MiqServer.my_server).to be

    session[:userid] = User.current_user.userid
  end

  context "VMs & Templates #tree_select" do
    it "renders VM and Template grid for vandt_tree root node" do
      vm = FactoryGirl.create(:vm_vmware)

      session[:settings] = {:views => { :vmortemplate => 'grid' }, :perpage => {:grid => 10}}
      session[:sandboxes] = {
        "vm_infra" => {
          :trees => {
            :vandt_tree => {
              :active_node => "v-#{vm.id}" # need this?
            }
          },
          :active_tree => :vandt_tree
        }
      }
      post :tree_select, :id => 'root', :format => :js

      response.should render_template('layouts/gtl/_grid')
      expect(response.status).to eq(200)
    end
  end

  context "VMs #tree_select" do
    it "renders grid with VMS for vms_filter_tree root node" do
      FactoryGirl.create(:vm_vmware)

      session[:settings] = {
        :views     => {:vminfra => 'grid'},
        :perpage   => {:grid => 10},
        :quadicons => {}
      }
      session[:sandboxes] = {
        "vm_infra" => {
          :trees => {
            :vms_filter_tree => {
              #:active_node => "v-#{vm.id}" # need this?
            }
          },
          :active_tree => :vms_filter_tree
        }
      }
      post :tree_select, :id => 'root', :format => :js

      response.should render_template('layouts/gtl/_grid')
      expect(response.status).to eq(200)
    end
  end

  context "Templates #tree_select" do
    it "renders grid with templates for templates_filter_tree root node" do
      FactoryGirl.create(:template_vmware)

      session[:settings] = {
        :views     => {:templateinfra => 'grid'},
        :perpage   => {:grid => 10},
        :quadicons => {}
      }
      session[:sandboxes] = {
        "vm_infra" => {
          :trees => {
            :templates_filter_tree => {
              #:active_node => "v-#{vm.id}" # need this?
            }
          },
          :active_tree => :templates_filter_tree
        }
      }
      post :tree_select, :id => 'root', :format => :js

      response.should render_template('layouts/gtl/_grid')
      expect(response.status).to eq(200)
    end
  end
end