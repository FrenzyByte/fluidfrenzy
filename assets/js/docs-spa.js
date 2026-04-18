/**
 * Docs: in-place navigation so the sidebar accordion stays as the user left it.
 * Full page loads still work (new tab, direct URL, no JS). History and shareable URLs unchanged.
 */
(function () {
  'use strict';

  var primary = document.getElementById('docs-primary');
  if (!primary) return;

  var baseMeta = document.querySelector('meta[name="site-baseurl"]');
  var baseUrl = (baseMeta && baseMeta.getAttribute('content')) || '';
  if (baseUrl.endsWith('/')) baseUrl = baseUrl.slice(0, -1);

  function normalizePath(pathname) {
    if (!pathname) return '';
    var p = pathname;
    if (p.length > 1 && p.endsWith('/')) p = p.slice(0, -1);
    return p;
  }

  function docsPrefixNorm() {
    return normalizePath(baseUrl + '/docs');
  }

  function isUnderDocs(url) {
    var p = normalizePath(url.pathname);
    var pre = docsPrefixNorm();
    return p === pre || p.indexOf(pre + '/') === 0;
  }

  function samePath(a, b) {
    return normalizePath(a) === normalizePath(b);
  }

  function scrollToHash(hash) {
    if (!hash || hash.length < 2) return;
    var id = decodeURIComponent(hash.slice(1));
    var el = document.getElementById(id);
    if (!el) {
      try {
        el = document.querySelector('[name="' + id.replace(/"/g, '\\"') + '"]');
      } catch (e) {
        el = null;
      }
    }
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function syncSidebarHighlight(pathname) {
    var norm = normalizePath(pathname);
    var panels = document.querySelectorAll('.doc-nav-panel');
    for (var i = 0; i < panels.length; i++) {
      var panel = panels[i];
      panel.classList.remove('doc-nav-panel-current');
      var link = panel.querySelector('.doc-nav-panel-page-link');
      if (!link) continue;
      var pnorm = normalizePath(new URL(link.href, window.location.href).pathname);
      if (pnorm === norm) panel.classList.add('doc-nav-panel-current');
    }
  }

  function fetchAndSwap(fullHref, options) {
    options = options || {};
    var urlObj = new URL(fullHref, window.location.href);
    var fetchUrl = urlObj.origin + urlObj.pathname + urlObj.search;

    fetch(fetchUrl, {
      credentials: 'same-origin',
      headers: { Accept: 'text/html' }
    })
      .then(function (res) {
        if (!res.ok) throw new Error('fetch failed');
        return res.text();
      })
      .then(function (html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var nextPrimary = doc.querySelector('#docs-primary');
        if (!nextPrimary) throw new Error('no #docs-primary');

        primary.innerHTML = nextPrimary.innerHTML;
        var mh1 = primary.querySelector('h1');
        if (mh1 && mh1.focus) {
          mh1.setAttribute('tabindex', '-1');
          try {
            mh1.focus({ preventScroll: true });
          } catch (err) {
            mh1.focus();
          }
        }
        var titleEl = doc.querySelector('title');
        if (titleEl && titleEl.textContent) document.title = titleEl.textContent.trim();

        if (!options.skipHistory) {
          history.pushState({ docsSpa: true }, '', urlObj.pathname + urlObj.search + urlObj.hash);
        }

        syncSidebarHighlight(urlObj.pathname);

        if (window.jQuery) window.jQuery(document).trigger('docsContentLoaded');

        if (urlObj.hash) scrollToHash(urlObj.hash);
        else window.scrollTo(0, 0);
      })
      .catch(function () {
        window.location.href = urlObj.href;
      });
  }

  document.addEventListener('click', function (e) {
    if (e.defaultPrevented) return;
    if (e.button !== 0) return;
    if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;

    var a = e.target.closest && e.target.closest('a[href]');
    if (!a) return;
    if (a.target === '_blank' || a.getAttribute('download')) return;

    var hrefAttr = a.getAttribute('href');
    if (!hrefAttr) return;

    if (hrefAttr.charAt(0) === '#') {
      e.preventDefault();
      history.pushState({ docsSpa: true }, '', window.location.pathname + window.location.search + hrefAttr);
      scrollToHash(hrefAttr);
      return;
    }

    var url;
    try {
      url = new URL(a.href, window.location.href);
    } catch (err) {
      return;
    }

    if (url.origin !== window.location.origin) return;
    if (!isUnderDocs(url)) return;

    var cur = new URL(window.location.href);

    if (samePath(url.pathname, cur.pathname)) {
      if (url.hash) {
        e.preventDefault();
        history.pushState({ docsSpa: true }, '', url.pathname + url.search + url.hash);
        scrollToHash(url.hash);
      }
      return;
    }

    e.preventDefault();
    fetchAndSwap(url.pathname + url.search + url.hash, { skipHistory: false });
  });

  window.addEventListener('popstate', function () {
    var u = new URL(window.location.href);
    fetchAndSwap(u.pathname + u.search + u.hash, { skipHistory: true });
  });
})();
