# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
$LOCAL_REPO = '~/aws-amplify/amplify-ios'

target 'datastoreList' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for datastoreList
  pod 'Amplify', :path => $LOCAL_REPO
  pod 'AmplifyPlugins', :path => $LOCAL_REPO
  pod 'AWSPluginsCore', :path => $LOCAL_REPO
  pod 'AmplifyPlugins/AWSDataStorePlugin', :path => $LOCAL_REPO
  pod 'AmplifyPlugins/AWSAPIPlugin', :path => $LOCAL_REPO

  target 'datastoreListTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'datastoreListUITests' do
    # Pods for testing
  end

end
