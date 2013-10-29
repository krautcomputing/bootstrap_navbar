require 'spec_helper'

shared_examples 'active menu item' do
  it 'generates the correct HTML' do
    with_all_2_dot_x_versions do
      paths_and_urls.each do |current_path_or_url|
        paths_and_urls.each do |menu_path_or_url|
          BootstrapNavbar.configuration.current_url_method = "'#{current_path_or_url}'"
          expect(renderer.menu_item('foo', menu_path_or_url)).to have_tag(:li, with: { class: 'active' })
        end
      end
    end
  end
end

describe BootstrapNavbar::Helpers::Bootstrap2 do
  before do
    BootstrapNavbar.configuration.current_url_method = '"/"'
  end

  it 'includes the correct module' do
    with_all_2_dot_x_versions do
      expect(renderer.class.ancestors).to include(BootstrapNavbar::Helpers::Bootstrap2)
      expect(renderer.class.ancestors).to_not include(BootstrapNavbar::Helpers::Bootstrap3)
    end
  end

  describe '#navbar' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar).to have_tag(:div, with: { class: 'navbar' }) do
            with_tag :div, with: { class: 'navbar-inner' } do
              with_tag :div, with: { class: 'container' }
            end
          end
        end
      end
    end

    context 'with a block' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar { 'foo' }).to have_tag(:div, with: { class: 'navbar' }, content: 'foo')
        end
      end
    end

    context 'with "static" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar(static: 'top')).to have_tag(:div, with: { class: 'navbar navbar-static-top' })
          expect(renderer.navbar(static: 'bottom')).to have_tag(:div, with: { class: 'navbar navbar-static-bottom' })
        end
      end
    end

    context 'with "fixed" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar(fixed: 'top')).to have_tag(:div, with: { class: 'navbar navbar-fixed-top' })
          expect(renderer.navbar(fixed: 'bottom')).to have_tag(:div, with: { class: 'navbar navbar-fixed-bottom' })
        end
      end
    end

    context 'with "inverse" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar(inverse: true)).to have_tag(:div, with: { class: 'navbar navbar-inverse' })
        end
      end
    end

    context 'with "brand" and "brank_link" parameters' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar(brand: 'foo')).to have_tag(:a, with: { href: '/', class: 'brand' }, content: 'foo')
          expect(renderer.navbar(brand: 'foo', brand_link: 'http://google.com')).to have_tag(:a, with: { href: 'http://google.com', class: 'brand' }, content: 'foo')
          expect(renderer.navbar(brand_link: 'http://google.com')).to have_tag(:a, with: { href: 'http://google.com', class: 'brand' })
        end
      end
    end

    context 'with "responsive" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar(responsive: true)).to have_tag(:a, with: { class: 'btn btn-navbar', :'data-toggle' => 'collapse', :'data-target' => '.nav-collapse' }) do
            3.times do
              with_tag :span, with: { class: 'icon-bar' }
            end
          end
        end
        with_versions '2.2.0'...'3' do
          expect(renderer.navbar(responsive: true)).to have_tag(:div, with: { class: 'nav-collapse collapse' })
        end
        with_versions '0'...'2.2.0' do
          expect(renderer.navbar(responsive: true)).to have_tag(:div, with: { class: 'nav-collapse' })
        end
      end
    end

    context 'with "fluid" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.navbar(fluid: true)).to have_tag(:div, with: { class: 'container-fluid' })
        end
      end
    end
  end

  describe '#menu_group' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.menu_group).to have_tag(:ul, with: { class: 'nav' })
          expect(renderer.menu_group { 'foo' }).to have_tag(:ul, with: { class: 'nav' }, content: 'foo')
        end
      end
    end

    context 'with "pull" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.menu_group(pull: 'right')).to have_tag(:ul, with: { class: 'nav pull-right' })
        end
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.menu_group(class: 'foo')).to have_tag(:ul, with: { class: 'nav foo' })
        end
      end
    end

    context 'with random parameters' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.menu_group(:'data-foo' => 'bar')).to have_tag(:ul, with: { class: 'nav', :'data-foo' => 'bar' })
        end
      end
    end

    context 'with many parameters' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.menu_group(pull: 'right', class: 'foo', :'data-foo' => 'bar')).to have_tag(:ul, with: { class: 'nav foo pull-right', :'data-foo' => 'bar' })
        end
      end
    end
  end

  describe '#menu_item' do
    context 'with current URL or path' do
      # With root URL or path
      it_behaves_like 'active menu item' do
        let(:paths_and_urls) do
          %w(
            http://www.foobar.com/
            http://www.foobar.com
            /
            http://www.foobar.com/?foo=bar
            http://www.foobar.com?foo=bar
            /?foo=bar
            http://www.foobar.com/#foo
            http://www.foobar.com#foo
            /#foo
            http://www.foobar.com/#foo?foo=bar
            http://www.foobar.com#foo?foo=bar
            /#foo?foo=bar
          )
        end
      end

      # With sub URL or path
      it_behaves_like 'active menu item' do
        let(:paths_and_urls) do
          %w(
            http://www.foobar.com/foo
            http://www.foobar.com/foo/
            /foo
            /foo/
            http://www.foobar.com/foo?foo=bar
            http://www.foobar.com/foo/?foo=bar
            /foo?foo=bar
            /foo/?foo=bar
            http://www.foobar.com/foo#foo
            http://www.foobar.com/foo/#foo
            /foo#foo
            /foo/#foo
            http://www.foobar.com/foo#foo?foo=bar
            http://www.foobar.com/foo/#foo?foo=bar
            /foo#foo?foo=bar
            /foo/#foo?foo=bar
          )
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            BootstrapNavbar.configuration.current_url_method = '"/"'
            expect(renderer.menu_item('foo', '/', class: 'bar', id: 'baz')).to have_tag(:li, with: { class: 'active bar', id: 'baz' })
          end
        end
      end

      context 'with link options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            BootstrapNavbar.configuration.current_url_method = '"/"'
            expect(renderer.menu_item('foo', '/', {}, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'active' }) do
              with_tag :a, with: { href: '/', class: 'pelle', id: 'fant' }, content: 'foo'
            end
          end
        end
      end

      context 'with list item options and link options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            BootstrapNavbar.configuration.current_url_method = '"/"'
            expect(renderer.menu_item('foo', '/', { class: 'bar', id: 'baz' }, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'active bar', id: 'baz' }) do
              with_tag :a, with: { href: '/', class: 'pelle', id: 'fant' }, content: 'foo'
            end
          end
        end
      end
    end

    context 'without current URL' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          BootstrapNavbar.configuration.current_url_method = '"/foo"'
          expect(renderer.menu_item('foo')).to have_tag(:li, without: { class: 'active' }) do
            with_tag :a, with: { href: '#' }, content: 'foo'
          end
          expect(renderer.menu_item('foo', '/')).to have_tag(:li, without: { class: 'active' }) do
            with_tag :a, with: { href: '/' }, content: 'foo'
          end
          expect(renderer.menu_item('foo', '/bar')).to have_tag(:li, without: { class: 'active' }) do
            with_tag :a, with: { href: '/bar' }, content: 'foo'
          end

          BootstrapNavbar.configuration.current_url_method = '"/"'
          expect(renderer.menu_item('foo', '/foo')).to have_tag(:li, without: { class: 'active' }) do
            with_tag :a, with: { href: '/foo' }, content: 'foo'
          end
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            BootstrapNavbar.configuration.current_url_method = '"/foo"'
            expect(renderer.menu_item('foo', '/', class: 'bar', id: 'baz')).to have_tag(:li, without: { class: 'active' }, with: { class: 'bar', id: 'baz' })
          end
        end
      end
    end

    context 'with a block' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.menu_item { 'bar' }).to have_tag(:li) do
            with_tag :a, with: { href: '#' }, content: 'bar'
          end
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            expect(renderer.menu_item('/foo', class: 'pelle', id: 'fant') { 'bar' }).to have_tag(:li, with: { class: 'pelle', id: 'fant' }) do
              with_tag :a, with: { href: '/foo' }, content: 'bar'
            end
          end
        end
      end

      context 'with link options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            expect(renderer.menu_item('/foo', {}, class: 'pelle', id: 'fant') { 'bar' }).to have_tag(:li) do
              with_tag :a, with: { href: '/foo', class: 'pelle', id: 'fant' }, content: 'bar'
            end
          end
        end
      end

      context 'with list item options and link options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            expect(renderer.menu_item('/foo', { class: 'bar', id: 'baz' }, class: 'pelle', id: 'fant') { 'shnoo' }).to have_tag(:li, with: { class: 'bar', id: 'baz' }) do
              with_tag :a, with: { href: '/foo', class: 'pelle', id: 'fant' }, content: 'shnoo'
            end
          end
        end
      end
    end
  end

  context 'drop downs' do
    def with_drop_down_menu(content = nil)
      options = { with: { class: 'dropdown-menu' } }
      options[:content] = content unless content.nil?
      with_tag :ul, options
    end

    describe '#drop_down' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.drop_down('foo')).to have_tag(:li, with: { class: 'dropdown' }) do
            with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
              with_text /foo/
              with_tag :b, with: { class: 'caret' }
            end
            with_drop_down_menu
          end

          expect(renderer.drop_down('foo') { 'bar' }).to have_tag(:li, with: { class: 'dropdown' }) do
            with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
              with_text /foo/
              with_tag :b, with: { class: 'caret' }
            end
            with_drop_down_menu('bar')
          end
        end
      end
    end

    describe '#sub_drop_down' do
      it 'generates the correct HTML' do
        with_all_2_dot_x_versions do
          expect(renderer.sub_drop_down('foo')).to have_tag(:li, with: { class: 'dropdown-submenu' }) do
            with_tag :a, with: { href: '#' }, content: 'foo'
            with_drop_down_menu
          end

          expect(renderer.sub_drop_down('foo') { 'bar' }).to have_tag(:li, with: { class: 'dropdown-submenu' }) do
            with_tag :a, with: { href: '#' }, content: 'foo'
            with_drop_down_menu('bar')
          end
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            expect(renderer.sub_drop_down('foo', class: 'bar', id: 'baz')).to have_tag(:li, with: { class: 'dropdown-submenu bar', id: 'baz' }) do
              with_tag :a, with: { href: '#' }, content: 'foo'
            end
          end
        end
      end

      context 'with link options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            expect(renderer.sub_drop_down('foo', {}, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'dropdown-submenu' }) do
              with_tag :a, with: { href: '#', class: 'pelle', id: 'fant' }, content: 'foo'
            end
          end
        end
      end

      context 'with list item options and link options' do
        it 'generates the correct HTML' do
          with_all_2_dot_x_versions do
            expect(renderer.sub_drop_down('foo', { class: 'bar', id: 'baz' }, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'dropdown-submenu bar', id: 'baz' }) do
              with_tag :a, with: { href: '#', class: 'pelle', id: 'fant' }, content: 'foo'
            end
          end
        end
      end
    end
  end

  describe '#drop_down_divider' do
    it 'generates the correct HTML' do
      with_all_2_dot_x_versions do
        expect(renderer.drop_down_divider).to have_tag(:li, with: { class: 'divider' }, content: '')
      end
    end
  end

  describe '#drop_down_header' do
    it 'generates the correct HTML' do
      with_all_2_dot_x_versions do
        expect(renderer.drop_down_header('foo')).to have_tag(:li, with: { class: 'nav-header' }, content: 'foo')
      end
    end
  end

  describe '#menu_divider' do
    it 'generates the correct HTML' do
      with_all_2_dot_x_versions do
        expect(renderer.menu_divider).to have_tag(:li, with: { class: 'divider-vertical' }, content: '')
      end
    end
  end

  describe '#menu_text' do
    it 'generates the correct HTML' do
      with_all_2_dot_x_versions do
        expect(renderer.menu_text('foo')).to have_tag(:p, with: { class: 'navbar-text' }, content: 'foo')
        expect(renderer.menu_text { 'foo' }).to have_tag(:p, with: { class: 'navbar-text' }, content: 'foo')
        expect(renderer.menu_text('foo', 'right')).to have_tag(:p, with: { class: 'navbar-text pull-right' }, content: 'foo')
        expect(renderer.menu_text(nil, 'left') { 'foo' }).to have_tag(:p, with: { class: 'navbar-text pull-left' }, content: 'foo')
      end
    end
  end

  describe '#brand_link' do
    it 'generates the correct HTML' do
      with_all_2_dot_x_versions do
        expect(renderer.brand_link('foo')).to have_tag(:a, with: { class: 'brand', href: '/' }, content: 'foo')
        expect(renderer.brand_link('foo', '/foo')).to have_tag(:a, with: { class: 'brand', href: '/foo' }, content: 'foo')
      end
    end
  end
end
