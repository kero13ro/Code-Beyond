# Web Development Terms: A Developer's Visual Dictionary

## Why This Matters

As senior frontend developers, we work with designers, product managers, and international teams daily. Using precise English terminology isn't just about translation—it's about clear communication and efficient collaboration.

This guide focuses on terms you'll encounter in design handoffs, code reviews, and technical discussions. Each term includes contextual translations to help you understand not just what it means, but how it's used in practice.

## Animation Terms

| English Term         | Contextual | Explanation                                                                         |
| -------------------- | ---------- | ----------------------------------------------------------------------------------- |
| **Confetti**         | 彩帶動畫       | Celebratory animation with falling colored particles, often used for success states |
| **Blob**             | 泡泡動畫/流體動畫  | Organic, morphing shapes used in modern UI backgrounds                              |
| **Morph**            | 變形動畫       | Smooth transformation from one shape to another                                     |
| **Sprite**           | 影格動畫/圖片序列  | Animation using sequential images from a sprite sheet                               |
| **Tween**            | 補間動畫       | Short for "in-between", automated frames between keyframes                          |
| **Ken Burns Effect** | 平移和縮放      | Slow pan and zoom effect on static images                                           |
| **Parallax**         | 視差滾動       | Background moves slower than foreground, creating depth                             |
| **Easing**           | 緩動函數       | Animation timing functions (ease-in, ease-out, etc.)                                |
| **Keyframe**         | 關鍵影格       | Specific points in animation timeline                                               |
| **Ripple**           | 水波紋效果      | Material Design touch feedback animation                                            |
| **Skeleton**         | 骨架屏/加載佔位   | Loading placeholder showing content structure                                       |
| **Fade**             | 淡入淡出       | Opacity transition effect                                                           |
| **Slide**            | 滑入滑出       | Position-based transition                                                           |
| **Bounce**           | 彈跳效果       | Spring-like animation with overshoot                                                |
| **Stagger**          | 錯開動畫       | Sequential animation with delays                                                    |
| **Cubic Bezier**     | 貝茲曲線       | Custom easing curves defined by control points                                      |
| **Spring Animation** | 彈簧動畫       | Physics-based animation with natural momentum                                       |
| **FLIP**             | FLIP 動畫    | First, Last, Invert, Play - efficient animation technique                           |
| **Motion Path**      | 運動路徑       | Animation following a defined path or curve                                         |
| **Lottie**           | Lottie 動畫  | JSON-based animation format from After Effects                                      |
| **Inertia**          | 慣性滾動       | Continued motion after user stops dragging                                          |
| **Overshoot**        | 過沖效果       | Animation briefly exceeds target before settling                                    |

## 3D & WebGL Terms

| English Term              | Contextual | Explanation                                            |
| ------------------------- | ---------- | ------------------------------------------------------ |
| **Scene**                 | 場景         | Container for all 3D objects, lights, and cameras      |
| **Camera**                | 相機/視角      | Viewpoint for rendering 3D scene                       |
| **Renderer**              | 渲染器        | Engine that draws 3D scene to canvas                   |
| **Mesh**                  | 網格模型       | 3D object combining geometry and material              |
| **Geometry**              | 幾何體        | Shape and structure of 3D object                       |
| **Material**              | 材質         | Surface properties (color, texture, reflectivity)      |
| **Texture**               | 貼圖/紋理      | Image mapped onto 3D surface                           |
| **Light**                 | 光源         | Illumination in 3D scene (ambient, directional, point) |
| **Polygon**               | 多邊形        | Flat surface making up 3D model                        |
| **Vertex**                | 頂點         | Point in 3D space, corner of polygon                   |
| **Normal**                | 法線         | Vector perpendicular to surface, defines lighting      |
| **UV Mapping**            | UV 映射      | How 2D texture wraps onto 3D surface                   |
| **Shader**                | 著色器        | Program that calculates pixel colors                   |
| **Ray Casting**           | 射線投射       | Technique for detecting object intersections           |
| **Bounding Box**          | 包圍盒        | Invisible box around object for collision detection    |
| **LOD (Level of Detail)** | 細節層級       | Lower quality models for distant objects               |
| **Culling**               | 剔除         | Not rendering objects outside camera view              |
| **Frustum**               | 視錐體        | Camera's visible volume in 3D space                    |
| **Instancing**            | 實例化        | Efficiently rendering many copies of same object       |

## Game Animation Terms

| English Term                | Contextual | Explanation                                     |
| --------------------------- | ---------- | ----------------------------------------------- |
| **Rigging**                 | 骨架綁定       | Creating bone structure for character animation |
| **Bone**                    | 骨骼         | Individual joint in skeletal animation system   |
| **Joint**                   | 關節         | Connection point between bones                  |
| **IK (Inverse Kinematics)** | 反向動力學      | Calculate bone positions from target point      |
| **FK (Forward Kinematics)** | 正向動力學      | Calculate position from bone rotations          |
| **Skinning**                | 蒙皮         | Binding mesh to skeleton for deformation        |
| **Weight Painting**         | 權重繪製       | Define how bones influence mesh vertices        |
| **State Machine**           | 狀態機        | System managing animation transitions           |
| **Blend Tree**              | 混合樹        | Smooth blending between multiple animations     |
| **Animation Clip**          | 動畫片段       | Single animation sequence                       |
| **Loop**                    | 循環播放       | Animation repeats continuously                  |
| **Ping-Pong**               | 往返播放       | Animation plays forward then backward           |
| **Particle System**         | 粒子系統       | Simulating effects like fire, smoke, rain       |
| **Emitter**                 | 發射器        | Source point for particles                      |
| **Trail**                   | 拖尾效果       | Path following moving object                    |
| **Sprite Sheet**            | 精靈圖表       | Grid of animation frames in single image        |

## Layout Terms

| English Term       | Contextual | Explanation                               |
| ------------------ | ---------- | ----------------------------------------- |
| **Masonry**        | 瀑布流布局      | Pinterest-style grid with varying heights |
| **Grid**           | 網格布局       | CSS Grid layout system                    |
| **Flexbox**        | 彈性布局       | CSS Flexible Box layout                   |
| **Sticky**         | 吸頂/固定      | Element sticks when scrolling past it     |
| **Fixed**          | 固定定位       | Fixed to viewport, doesn't scroll         |
| **Absolute**       | 絕對定位       | Positioned relative to parent             |
| **Relative**       | 相對定位       | Positioned relative to normal position    |
| **Z-index**        | 層級/堆疊順序    | Stacking order of overlapping elements    |
| **Viewport**       | 可視區域       | Visible area of a web page                |
| **Gutter**         | 間距/欄間距     | Space between grid columns                |
| **Breakpoint**     | 響應式斷點      | Screen size where layout changes          |
| **Container**      | 容器/包裹器     | Wrapper element for content               |
| **Hero Section**   | 首屏大圖區      | Large prominent section at page top       |
| **Above the Fold** | 首屏可見區      | Content visible without scrolling         |
| **Sidebar**        | 側邊欄        | Side panel for navigation or content      |

## UI Components

| English Term   | Contextual | Explanation                               |
| -------------- | ---------- | ----------------------------------------- |
| **Carousel**   | 輪播/走馬燈     | Rotating content display                  |
| **Accordion**  | 手風琴/摺疊面板   | Expandable/collapsible content sections   |
| **Breadcrumb** | 麵包屑導航      | Navigation path showing current location  |
| **Tooltip**    | 提示框/氣泡提示   | Hover information box                     |
| **Modal**      | 模態框/彈窗     | Overlay dialog requiring interaction      |
| **Drawer**     | 抽屜/側滑菜單    | Sliding panel from screen edge            |
| **Toast**      | 消息提示/輕提示   | Brief notification message                |
| **Snackbar**   | 底部提示條      | Bottom notification bar (Material Design) |
| **Badge**      | 徽標/標記      | Small count or status indicator           |
| **Chip**       | 標籤/膠囊      | Compact element for tags or filters       |
| **Avatar**     | 頭像         | User profile picture                      |
| **Dropdown**   | 下拉選單       | Expandable selection menu                 |
| **Toggle**     | 開關/切換按鈕    | On/off switch control                     |
| **Slider**     | 滑動條        | Range input control                       |
| **Stepper**    | 步驟條/計數器    | Multi-step process indicator              |
| **Pagination** | 分頁器        | Page navigation control                   |
| **Tab**        | 標籤頁/選項卡    | Content organization tabs                 |
| **Divider**    | 分隔線        | Visual separator between content          |

## Visual Effects

| English Term          | Contextual | Explanation                                    |
| --------------------- | ---------- | ---------------------------------------------- |
| **Backdrop**          | 背景遮罩/模糊遮罩  | Blurred/dimmed background behind modals        |
| **Vignette**          | 暈影效果/邊緣暗角  | Darkened edges around image                    |
| **Blur**              | 模糊效果       | Gaussian or other blur effects                 |
| **Gradient**          | 漸層/漸變      | Color transition effect                        |
| **Shadow**            | 陰影/投影      | Drop shadow or box shadow                      |
| **Glassmorphism**     | 毛玻璃效果      | Frosted glass visual style                     |
| **Neumorphism**       | 新擬物風格      | Soft UI with subtle shadows                    |
| **Overlay**           | 遮罩層        | Semi-transparent layer over content            |
| **Mask**              | 遮罩/蒙版      | Shape that clips content                       |
| **Clip Path**         | 裁切路徑       | CSS property to clip elements                  |
| **Filter**            | 濾鏡         | CSS filters (brightness, contrast, etc.)       |
| **Opacity**           | 透明度        | Element transparency level                     |
| **Reflection**        | 倒影/鏡像      | Mirror effect of element                       |
| **Bloom**             | 泛光效果       | Glow effect around bright areas                |
| **Depth of Field**    | 景深效果       | Blur based on distance from focus point        |
| **Motion Blur**       | 動態模糊       | Blur on moving objects for realism             |
| **Ambient Occlusion** | 環境光遮蔽      | Shadows in crevices and corners                |
| **Post-processing**   | 後處理效果      | Effects applied after main render              |
| **Normal Map**        | 法線貼圖       | Texture adding surface detail without geometry |

## Canvas & Graphics Terms

| English Term            | Contextual | Explanation                           |
| ----------------------- | ---------- | ------------------------------------- |
| **Canvas**              | 畫布         | HTML element for 2D/3D graphics       |
| **Context**             | 上下文        | API for drawing on canvas (2d, webgl) |
| **Path**                | 路徑         | Series of connected points and curves |
| **Stroke**              | 描邊         | Outline of shape                      |
| **Fill**                | 填充         | Interior color of shape               |
| **Composite Operation** | 合成操作       | How overlapping shapes blend          |
| **Image Data**          | 圖像數據       | Raw pixel data from canvas            |
| **SVG**                 | 可縮放向量圖形    | XML-based vector image format         |
| **Viewbox**             | 視圖框        | SVG coordinate system definition      |
| **Path Data**           | 路徑數據       | Commands defining SVG shapes          |
| **Transform**           | 變換         | Translate, rotate, scale operations   |
| **Buffer**              | 緩衝區        | Data storage for WebGL                |
| **Attribute**           | 屬性         | Per-vertex data in shaders            |
| **Uniform**             | 統一變量       | Global shader variable                |
| **Fragment Shader**     | 片段著色器      | Shader calculating pixel colors       |
| **Vertex Shader**       | 頂點著色器      | Shader positioning vertices           |
| **Texture Unit**        | 紋理單元       | Slot for loading textures in shaders  |

## Interaction Terms

| English Term        | Contextual | Explanation                          |
| ------------------- | ---------- | ------------------------------------ |
| **Drag and Drop**   | 拖放/拖拽      | Mouse/touch gesture to move items    |
| **Swipe**           | 滑動/滑移      | Touch gesture across screen          |
| **Pinch**           | 捏合縮放       | Two-finger zoom gesture              |
| **Hover**           | 懸浮/滑過      | Mouse over element state             |
| **Focus**           | 焦點狀態       | Active input/keyboard navigation     |
| **Active**          | 激活/按下狀態    | Button pressed state                 |
| **Disabled**        | 禁用/不可用     | Non-interactive state                |
| **Loading**         | 加載中/載入中    | Content fetching state               |
| **Throttle**        | 節流         | Limit function execution frequency   |
| **Debounce**        | 防抖/去抖      | Delay function execution until pause |
| **Lazy Load**       | 延遲加載       | Load content when needed             |
| **Infinite Scroll** | 無限滾動       | Continuous content loading           |
| **Pull to Refresh** | 下拉刷新       | Mobile gesture to reload content     |
| **Click**           | 點擊         | Mouse click event                    |
| **Tap**             | 點按/輕觸      | Touch screen tap                     |

## Responsive Design

| English Term      | Contextual | Explanation                            |
| ----------------- | ---------- | -------------------------------------- |
| **Mobile-first**  | 移動優先       | Design for mobile, then scale up       |
| **Desktop-first** | 桌面優先       | Design for desktop, then scale down    |
| **Media Query**   | 媒體查詢       | CSS rule for different screen sizes    |
| **Fluid Layout**  | 流式布局       | Layout that scales proportionally      |
| **Adaptive**      | 自適應        | Fixed layouts for specific breakpoints |
| **Responsive**    | 響應式        | Flexible layouts for any screen size   |
| **Retina**        | 高清屏/視網膜屏   | High-DPI displays                      |

## Tips for Using Terms with AI Tools

### When Prompting Design AI (Figma AI, Midjourney, v0, etc.)

As senior developers, we increasingly work with AI design tools. Using precise English terms gets better results:

✅ **Good**: "Create a hero section with **parallax effect** and **glassmorphism** cards"
- AI understands exactly what visual style you want
- Results match modern design trends

❌ **Poor**: "做一個有那種滾動動畫和透明效果的區塊"
- Vague descriptions lead to inconsistent results
- May miss specific design patterns

✅ **Good**: "Add **neumorphism** style to buttons with **subtle shadow** and **backdrop blur**"
- Specific terms = predictable output
- Easier to iterate and refine

### When Prompting Code AI (Claude, ChatGPT, Copilot, Cursor, etc.)

Precise terminology helps AI generate better code:

✅ **Good**: "Implement a **carousel** with **lazy loading**, **swipe gestures**, and **throttled** scroll events"
- AI generates complete, production-ready code
- Includes performance optimizations

❌ **Poor**: "做一個圖片輪播可以滑動的"
- May get basic implementation without optimizations
- Missing accessibility features

✅ **Good**: "Add **debounced** search with **skeleton** loading state and **infinite scroll**"
- AI understands performance patterns
- Includes proper loading states

### When Searching Documentation

English terms unlock global resources:

✅ **Good**: "CSS **masonry layout** grid"
- Access MDN, CSS-Tricks, Codepen examples
- Latest techniques and browser support info

❌ **Limited**: "CSS 瀑布流"
- Mostly Chinese results
- May miss cutting-edge solutions

✅ **Good**: "React **virtualized list** with **lazy load**"
- Find react-window, react-virtualized libraries
- Performance best practices from core team

### Code Review Comments

Using standard terms improves team communication:

✅ **Professional**:
```
"Consider using **debounce** instead of **throttle** here—
we want to wait for user input to stop, not limit frequency"
```

✅ **Specific**:
```
"The **z-index** of this **modal** should be higher than
the **sticky** header (currently 1000)"
```

✅ **Clear**:
```
"Add **staggered** animation to list items for better
perceived performance during **lazy load**"
```

### Design Handoff Collaboration

When working with designers:

**Animation Specs:**
- "**Tween** opacity from 0 to 1 in 300ms with **ease-out**"
- "Add **parallax** with 0.5 speed ratio to background"
- "**Stagger** card animations by 50ms"

**Layout Requirements:**
- "Make header **sticky** at scroll position 100px"
- "Use **flexbox** with **gap** instead of margin"
- "Set **z-index** layering: modal (1000) > sticky nav (100)"

**Component Behavior:**
- "Add **ripple effect** on button tap with 300ms duration"
- "Implement **pull-to-refresh** with haptic feedback"
- "Use **skeleton** screen during initial load"

### Senior Developer Perspective

Why precise terminology matters at senior level:

1. **Architecture Discussions**: "We need **lazy loading** with **intersection observer** for performance" is clearer than describing the behavior

2. **Technical Debt**: "This uses **throttle** but should use **debounce**" immediately identifies the issue

3. **Performance Reviews**: "Replace **carousel** with **virtualized list** for 1000+ items" shows understanding of scale

4. **Mentoring Juniors**: Teaching correct terms helps them search docs and understand best practices

5. **Cross-functional Meetings**: PMs and designers understand "**mobile-first responsive**" better than technical explanations

## Summary

Learning these terms isn't just about translation—it's about understanding the concepts behind them. When you know both the English term and its practical meaning, you can:

1. **Communicate better** with international teams
2. **Search documentation** more effectively
3. **Use AI tools** more precisely
4. **Review code** and understand open-source projects faster
5. **Lead technical discussions** with clarity
6. **Mentor junior developers** more effectively

Remember: Knowing the English terms opens up global resources, better AI interactions, and clearer team communication.
