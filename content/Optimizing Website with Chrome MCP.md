### What is Website Performance Optimization?

Website performance optimization can be examined at three distinct levels:
#### Level 1: Strategic Assessment
- Ask if features are necessary
- Communicate hidden costs and trade-offs to stakeholders
- Prevent feature bloat that kills performance
- **Key insight:** Not every feature makes the product better; some make it slower and harder to maintain

#### Level 2: Architectural Decisions
- Choose the right rendering strategy (SSG, SSR, CSR) based on product type
- Plan for caching at multiple layers (CDN, Redis, server-side)
- Deploy to appropriate regions to minimize latency
- Decide on component sharing, monorepo structure, build caching
- **Key insight:** Architectural decisions multiply across all downstream work—they have exponential impact

#### Level 3: Technical Implementation
- Optimize individual code paths, reduce JavaScript bundle size
- Minimize layout thrashing and forced reflows
- Implement efficient asset delivery and compression
- Optimize rendering and execution performance

For deeper insights, refer to [[What Excellent Product Developers Know]] and [[How to Optimize Website Performance]].

This article focuses on using Chrome MCP to demonstrate practical performance optimization techniques at Level 3 and their measurable impact.

### What is Chrome MCP?

Chrome MCP (Model Context Protocol) is a powerful debugging tool that integrates with Claude Code to provide detailed performance analysis and insights. It allows developers to:

- Capture comprehensive performance traces with Core Web Vitals data
- Analyze resource loading waterfalls and dependency chains
- Identify bottlenecks in the critical rendering path
- Get actionable recommendations for performance improvements
- Measure the impact of optimizations in real-time

By combining Chrome DevTools data with AI-powered analysis, Chrome MCP makes performance debugging more accessible and efficient.

### Case Study: Analyzing Appier.com

Recently, I investigated [Appier](https://www.appier.com/en/)
Despite its prominence, the site has room for performance improvement.

#### Interactive Performance Issue
When rapidly hovering over menu items in the top navigation bar, users experience approximately 500ms of delay in hover response. This is a telltale sign of forced reflows and layout thrashing—a classic performance anti-pattern discussed in [Optimize Browser Reflow & Repaint].

**Asset Size Analysis:**
The initial page load requires 120 MB of resources—an enormous size that immediately signals optimization opportunities. The primary culprit: GIF files at 2400 × 1350 resolution.

By converting these GIFs to AVIF format, file sizes drop to **21 MB**
Further optimization comes from applying responsive image principles—using 1200px resolution instead of 2400px reduces the total to just **2.9 MB**!

Total page size reduced from 120 MB to approximately 50 MB—a 58% reduction that doubles download and rendering speed.
![[Pasted image 20251108162150.png]]


### Core Performance Metrics

Rather than relying solely on traditional Lighthouse audits, we use Chrome MCP and Claude Code to directly investigate the root causes of these performance issues.

| Metric                         | Value    | Status               |
| ------------------------------ | -------- | -------------------- |
| LCP (Largest Contentful Paint) | 1,288 ms | ⚠️ Needs Improvement |
| CLS (Cumulative Layout Shift)  | 0.00     | ✅ Excellent          |
| TTFB (Time to First Byte)      | 36 ms    | ✅ Excellent          |
| Critical Path Delay            | 609 ms   | ⚠️ Excessive         |

#### Key Performance Issues Discovered

**1. LCP Element Loading Delay (1,288 ms)**

The Largest Contentful Paint element is a video file (Header_EN_0909.mp4 - 3.2 MB) with a three-part delay breakdown:

- **Load Delay: 473 ms (36.7%)** - Time spent discovering and requesting the resource
- **Render Delay: 524 ms (40.7%)** - Waiting time before rendering begins (the longest contributor)
- **Load Duration: 256 ms (19.9%)** - Actual download time for the resource

**Optimization Recommendations:**
- ❌ Missing `fetchpriority="high"` attribute - should be added immediately
- Replace the video with an optimized static image (videos have higher loading overhead)
- Reduce the video file size from 3.2 MB to under 500 KB
- **Expected improvement: 200-300 ms reduction**

**2. Third-Party Script Overhead (288 kB + 159 ms Main Thread Time)**

The site loads several third-party dependencies:

- **Unpkg (Swiper):** 151.5 kB + 114 ms main thread time ⚠️ Most problematic
- **HubSpot:** 108.3 kB + 42 ms main thread time
- **Google Fonts:** 79.5 kB
- **YouTube Embed:** 31 kB + 3 ms

**Optimization Recommendations:**
- Defer HubSpot script loading (non-critical path)
- Self-host Swiper library instead of loading from Unpkg CDN
- Use `font-display: swap` for Google Fonts to prevent render blocking
- **Expected improvement: 100-150 ms total**

**3. Long Critical Path Chain (609 ms)**

The dependency chain is problematic:

```
Index HTML (140 ms) →
  template_global.min.js (609 ms) →
    Other JS files (serialized loading)
```

All JavaScript files are loaded serially rather than in parallel, creating an unnecessarily long critical path.

**Optimization Recommendations:**
- Break JavaScript into smaller chunks that can load in parallel
- Add `<link rel="preload">` for critical resources
- Implement `preconnect` for CDN resources
- **Expected improvement: 150-200 ms reduction**

**4. Forced Reflow Issues**

`template_global.min.js` causes 21 ms of forced reflows, with a total reflow time of 46 ms. This aligns with the navigation menu hover delay observed earlier.

**Optimization Recommendations:**
- Audit DOM query patterns in `template_global.js`
- Avoid reading layout properties immediately after DOM modifications
- Use `requestAnimationFrame` to batch layout updates
- **Expected improvement: 20-30 ms reduction**

#### Optimization Priority Framework

**Priority 1 - Immediate Actions**
1. Add `fetchpriority="high"` to LCP video
2. Defer non-critical third-party scripts (HubSpot)
3. Replace 3.2 MB video with optimized image

**Priority 2 - Short-Term Improvements**
1. Break JavaScript dependency chain into parallel loads
2. Fix forced reflows in `template_global.js`
3. Self-host Swiper library

**Priority 3 - Long-Term Strategy**
1. Implement aggressive code splitting
2. Migrate from HubSpot-generated template

#### Expected Results
By implementing Priority 1 and 2 optimizations:
- **LCP:** 1,288 ms → ~800-900 ms (30-40% improvement)
- **Critical Path:** 609 ms → ~450-500 ms
- **Overall User Experience:** Significantly faster content visibility

#### Current Strengths
Despite these issues, Appier.com has several positive aspects:
- ✅ Excellent TTFB (36 ms)
- ✅ Perfect CLS (0.00 - no layout shifts)
- ✅ Pre-configured preconnect to Google Fonts
- ✅ Well-configured CDN (CloudFront + Cloudflare)

### Conclusion

Using Chrome MCP and Claude Code, we can systematically identify performance bottlenecks and prioritize optimizations by their impact. Even for well-established companies, there are often significant opportunities to improve user experience through data-driven performance analysis.



