# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'Surfies' do
    
pod 'Alamofire', '~> 2.0'
pod 'VBFPopFlatButton'
pod 'AKPickerView-Swift'
pod 'DOFavoriteButton'
pod 'SDWebImage'
pod 'APAvatarImageView'
pod 'JDFTooltips'
pod 'FBSDKCoreKit', '~> 4.6'
pod 'Parse'
pod 'ParseFacebookUtilsV4', '~> 1.8'
pod 'Koloda', '2.0.4'
pod 'Fabric', '~> 1.6'
pod 'Crashlytics', '~> 3.5'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

end

target 'SurfiesTests' do

end




