// Centralized Theme System for Wolfii Shell
// Apple-Inspired Liquid Glass + High Contrast Wallpaper-Aware Palette
// Note: per specifications, do NOT use .pragma library

// Base Colors
var background = "#0e0e12";
var backgroundSoft = "#14141a";

// Glass Surfaces (Neutral Adaptive Liquid Glass)
// Base colors use high alpha so background is never washed out,
// preventing any desktop/editor text from bleeding through.
var glassStrong = "#fa101015";       // Level 3 (~98% deep charcoal)
var glassStrongBg = "#101015";

var glassMedium = "#f7131319";       // Level 2 (~97% deep charcoal)
var glassMediumBg = "#131319";

var glassSoft = "#f216161f";         // Level 1 (~95% deep charcoal)
var glassSoftBg = "#16161f";

// Interactive / Layered Surfaces
var surface = "#1e1e27";             // Secondary surface
var surfaceHover = "#2b2b38";        // Hover state
var surfaceActive = "#38384a";       // Pressed state
var surfaceCard = "#171721";         // Grouped card containers
var surfaceCardHover = "#222230";    // Card hover

// Glass Borders & Specular Highlights
var glassBorder = "#28ffffff";       // Crisp 16% white border
var glassBorderStrong = "#44ffffff"; // 27% white border for active/focused
var glassBorderSubtle = "#18ffffff"; // 9% white border for dividers/cards
var glassHighlight = "#38ffffff";    // Specular top edge highlight
var glassShadow = "#000000cc";       // Ambient depth drop shadow

// Text Colors (High Contrast & High Readability)
var text = "#f8f8fc";                // Primary near-white text
var textMuted = "#9494a4";           // Secondary muted text
var textDim = "#626272";             // Inactive/placeholder text

// Wolfii Identity & Accent
var accent = "#ccff00";              // Signature Wolfii lime accent
var accentSoft = "#28ccff00";        // 16% accent tint for backgrounds
var accentGlow = "#50ccff00";        // 31% accent for borders/glows
var accentHover = "#d8ff33";         // Slightly brighter accent

// Workspaces
var activeWorkspace = "#d6d3b8";     // Elegant cream active indicator
var activeText = "#16161c";          // Deep dark text on active indicator

// Radii
var radius = 16;
var smallRadius = 10;
var cardRadius = 12;
var largeRadius = 22;
var pillRadius = 999;

// Consistent Spacing System (4, 6, 8, 12, 16, 20, 24)
var spaceXs = 4;
var spaceSm = 6;
var spaceMd = 8;
var spaceLg = 12;
var spaceXl = 16;
var space2Xl = 20;
var space3Xl = 24;

// Animation Durations (ms)
var animMicro = 120;
var animFast = 150;
var animNormal = 180;
var animPopup = 220;
var animLarge = 280;

// Legacy / Component Compatibility Aliases
var glassL1Bg = glassSoft;
var glassL1Opacity = 1.0;
var glassL1Border = glassBorder;
var glassL1Highlight = glassHighlight;

var glassL2Bg = glassMedium;
var glassL2Opacity = 1.0;
var glassL2Border = glassBorder;
var glassL2Highlight = glassHighlight;

var glassL3Bg = glassStrong;
var glassL3Opacity = 1.0;
var glassL3Border = glassBorder;
var glassL3Highlight = glassHighlight;

var border = glassBorder;

// Typography
var fontFamily = "Outfit, Inter, system-ui, -apple-system, sans-serif";
var monoFontFamily = "JetBrains Mono, monospace";
