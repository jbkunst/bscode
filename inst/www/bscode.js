(function () {
  "use strict";

  function oppositePlacement(position) {
    return position === "right" ? "left" : "right";
  }

  function directLabel(link) {
    const text = Array.from(link.childNodes)
      .filter(function (node) { return node.nodeType === Node.TEXT_NODE; })
      .map(function (node) { return node.textContent.trim(); })
      .filter(Boolean)
      .join(" ");

    return text || link.textContent.trim() || link.dataset.value || "Panel";
  }

  function containsIcon(element) {
    return element.matches("svg, i, img, .bscode-letter-icon") ||
      Boolean(element.querySelector("svg, i, img, .bscode-letter-icon"));
  }

  function hideLabel(link) {
    Array.from(link.childNodes).forEach(function (node) {
      if (node.nodeType === Node.TEXT_NODE && node.textContent.trim()) {
        const label = document.createElement("span");
        label.className = "bscode-nav-label visually-hidden";
        label.textContent = node.textContent.trim();
        node.replaceWith(label);
      }
    });

    Array.from(link.children).forEach(function (child) {
      if (!containsIcon(child)) {
        child.classList.add("bscode-nav-label", "visually-hidden");
      }
    });
  }

  function hasIcon(link) {
    return Boolean(link.querySelector("svg, i, img, .bscode-letter-icon"));
  }

  function addLetterFallback(link, label) {
    if (hasIcon(link)) return;

    const letter = Array.from(label.trim())[0] || "?";
    const icon = document.createElement("span");
    icon.className = "bscode-letter-icon";
    icon.setAttribute("aria-hidden", "true");
    icon.textContent = letter.toUpperCase();
    link.prepend(icon);
  }

  function initLink(link) {
    if (link.dataset.bscodeReady === "true") return;

    const label = directLabel(link);
    addLetterFallback(link, label);
    hideLabel(link);

    link.setAttribute("aria-label", label);
    link.setAttribute("data-bs-title", label);
    link.removeAttribute("title");
    link.dataset.bscodeReady = "true";
  }

  function initTooltip(shell) {
    if (shell.dataset.bscodeTooltipReady === "true") return;

    const requested = shell.dataset.bscodeTooltipPlacement || "auto";
    if (requested === "none") {
      shell.dataset.bscodeTooltipReady = "true";
      return;
    }

    if (!window.bootstrap || !bootstrap.Tooltip) return;

    const placement = requested === "auto"
      ? oppositePlacement(shell.dataset.bscodePosition || "left")
      : requested;

    bootstrap.Tooltip.getOrCreateInstance(shell, {
      selector: ".bscode-nav .nav-link",
      placement: placement,
      trigger: "hover focus",
      container: "body",
      customClass: "bscode-tooltip-light"
    });

    shell.dataset.bscodeTooltipReady = "true";
  }

  function initShell(shell) {
    shell.querySelectorAll(".bscode-nav .nav-link").forEach(initLink);
    initTooltip(shell);
  }

  function initAll() {
    document.querySelectorAll(".bscode-shell").forEach(initShell);
  }

  function resizeWidgets(shell) {
    window.dispatchEvent(new Event("resize"));

    if (window.Highcharts && Array.isArray(window.Highcharts.charts)) {
      window.Highcharts.charts.forEach(function (chart) {
        if (chart && chart.renderTo && shell.contains(chart.renderTo)) {
          chart.reflow();
        }
      });
    }

    if (window.Plotly && window.Plotly.Plots) {
      shell.querySelectorAll(".js-plotly-plot").forEach(function (plot) {
        window.Plotly.Plots.resize(plot);
      });
    }

    if (window.HTMLWidgets) {
      shell.querySelectorAll(".html-widget[id]").forEach(function (element) {
        try {
          const escaped = window.CSS && CSS.escape
            ? CSS.escape(element.id)
            : element.id;
          const widget = window.HTMLWidgets.find("#" + escaped);

          if (widget && typeof widget.getMap === "function") {
            const map = widget.getMap();
            if (map && typeof map.resize === "function") map.resize();
          }
        } catch (error) {
          // Other htmlwidgets respond to the window resize event above.
        }
      });
    }
  }

  document.addEventListener("DOMContentLoaded", initAll);
  document.addEventListener("shiny:connected", initAll);

  document.addEventListener("shown.bs.tab", function (event) {
    const shell = event.target.closest(".bscode-shell");
    if (!shell) return;

    window.requestAnimationFrame(function () {
      resizeWidgets(shell);
    });
  });

  new MutationObserver(initAll).observe(document.documentElement, {
    childList: true,
    subtree: true
  });
})();
