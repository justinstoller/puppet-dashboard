require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Instance do
  describe 'attributes' do
    before :each do
      @instance = Instance.new
    end

    it 'can have a name' do
      @instance.should respond_to(:name)
    end
    
    it 'should allow setting and retrieving the name' do
      @instance.name = 'Test Instance'
      @instance.name.should == 'Test Instance'
    end
    
    it 'can be active' do
      @instance.should respond_to(:is_active)
    end
    
    it 'should allow setting and retrieving the active status' do
      @instance.is_active = true
      @instance.is_active.should be_true
    end
    
    it 'should have an app id' do
      @instance.should respond_to(:app_id)
    end
    
    it 'should allow setting and retrieving the app id' do
      @instance.app_id = 1
      @instance.app_id.should == 1
    end

    it 'should have a service id' do
      @instance.should respond_to(:service_id)
    end
    
    it 'should allow setting and retrieving the service id' do
      @instance.service_id = 1
      @instance.service_id.should == 1
    end
  end
  
  describe 'validations' do
    before :each do
      @instance = Instance.new
    end
    
    it 'should not be valid without an app' do
      @instance.app = nil
      @instance.valid?
      @instance.errors.should be_invalid(:app)
    end

    it 'should be valid with an app' do
      @instance.app = App.generate!
      @instance.valid?
      @instance.errors.should_not be_invalid(:app)
    end
    
    it 'should not be valid without a service' do
      @instance.service = nil
      @instance.valid?
      @instance.errors.should be_invalid(:service)
    end

    it 'should be valid with a service' do
      @instance.service = Service.generate!
      @instance.valid?
      @instance.errors.should_not be_invalid(:service)
    end
  end
  
  describe 'relationships' do
    before :each do
      @instance = Instance.new
    end
    
    it 'should belong to an app' do
      @instance.should respond_to(:app)
    end

    it 'should allow assigning the app' do
      @app = App.generate!
      @instance.app = @app
      @instance.app.should == @app
    end
    
    it 'should belong to a service' do
      @instance.should respond_to(:service)
    end
    
    it 'should allow assigning the service' do
      @service = Service.generate!
      @instance.service = @service
      @instance.service.should == @service
    end
    
    it 'should have a customer' do
      @instance.should respond_to(:customer)
    end
    
    it 'should return the app customer' do
      @instance = Instance.generate!
      @instance.customer.should == @instance.app.customer
    end
    
    it 'should have a deployment' do
      @instance.should respond_to(:deployment)
    end
    
    it 'should allow assigning deployment' do
      @deployment = Deployment.generate!
      @instance.deployment = @deployment
      @instance.deployment.should == @deployment
    end
    
    it 'should have a host' do
      @instance.should respond_to(:host)
    end
    
    it 'should return the host for the deployment' do
      @deployment = Deployment.generate!
      @instance.deployment = @deployment
      @instance.host.should == @deployment.host 
    end
    
    it 'should have a set of required services' do
      @instance.should respond_to(:required_services)
    end
    
    it 'should return its service then computing required services' do
      @service = Service.generate!
      @child = Service.generate!
      @service.depends_on << @child
      @instance.service = @service
      @instance.required_services.should include(@service)
    end
    
    it 'should return all services that its service depends on when computing required services' do
      @service = Service.generate!
      @child = Service.generate!
      @service.depends_on << @child
      @instance.service = @service
      @instance.required_services.should include(@child)
    end
  end
end