source "https://rubygems.org"
ruby RUBY_VERSION

# The `github-pages` meta-gem hooks into Jekyll and forces `safe: true`, which
# skips all custom code in `_plugins/`. This site relies on `_plugins` for the
# docs sidebar, so we depend on Jekyll and the same-style plugins directly.
gem "jekyll", "~> 3.9.0"
gem "jekyll-feed", "~> 0.15"
gem "jekyll-redirect-from", "~> 0.16"
gem "jekyll-seo-tag", "~> 2.7"
gem "jekyll-sitemap", "~> 1.4"
gem "kramdown-parser-gfm", "~> 1.1"
gem "nokogiri", "~> 1.13"
gem "webrick", "~> 1.8"

group :jekyll_plugins do
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "livereload", '~> 1.6', '>= 1.6.1'
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?
