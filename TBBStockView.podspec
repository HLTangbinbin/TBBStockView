
Pod::Spec.new do |s|
  s.name         = "TBBStockView"
  s.version      = "1.0.4"
  s.summary      = "iOS股票证券走势图--分时图"

  s.description  = <<-DESC
                   * 分时图+K线图～完全用自己的思路封装的，绘制过程碰到一些坑
                   * 网上很多第3方库使用的方法都一样，比如在绘制走势图封闭的背景颜色那一块
                     使用了更简单的思路
                   *开源的很多，但是按照自己的思路完全写一遍收获更多
                   DESC
  s.homepage     = "https://github.com/HLTangbinbin"

  s.license      = "MIT"

  s.author             = { "HLTangbinbin" => "m18513848880@163.com" }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/HLTangbinbin/TBBStockView.git", :tag => "#{s.version}" }

  s.source_files  = 'TBBStockView/Source/*.{h,m}'
  s.resources = "TBBStockView/Resource/*.*"
  s.requires_arc = true

  s.dependency "Masonry"

end
