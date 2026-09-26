// Centralized Theme System for Wolfii Shell
// Apple-Inspired Liquid Glass + High Contrast Wallpaper-Aware Palette
// Note: per specifications, do NOT use .pragma library

// Base Solid Colors
var background = "#0a0a0e";
var backgroundSoft = "#101015";

// Liquid Glass Surfaces (0.84 - 0.95 opacity for strong wallpaper awareness without bleed-through)
var glassStrong = "#f20c0c10";       // Level 3 (~95% deep charcoal) - Modals, Settings, Control Center
var glassStrongBg = "#0c0c10";

var glassMedium = "#eb0e0e13";       // Level 2 (~92% deep charcoal) - Floating panels (Audio, Wifi, Battery)
var glassMediumBg = "#0e0e13";

var glassSoft = "#e00d0d12";         // Level 1 (~88% deep charcoal) - TopBar surface
var glassSoftBg = "#0d0d12";

// Interactive / Layered Surfaces
var surface = "#181822";             // Button/chip surface
var surfaceHover = "#242432";        // Button hover
var surfaceActive = "#303042";       // Pressed state
var surfaceCard = "#16161f";         // Grouped card containers
var surfaceCardHover = "#1f1f2b";    // Card hover

// Glass Borders & Specular Highlights
var glassBorder = "#24ffffff";       // 14% white border
var glassBorderStrong = "#3affffff"; // 23% white border for active/focused
var glassBorderSubtle = "#16ffffff"; // 8% white border for dividers/cards
var glassHighlight = "#38ffffff";    // 22% specular top edge highlight
var glassShadow = "#66000000";       // Soft drop shadow

// Text Colors (High Contrast & High Readability over Dark Glass)
var text = "#ffffff";                // Pure white primary text
var textMuted = "#b0b0c2";           // Light gray readable secondary text
var textDim = "#78788c";             // Inactive/placeholder text

// Wolfii Identity & Accent (Used tastefully for highlights, not entire bricks)
var accent = "#ccff00";              // Signature Wolfii lime accent
var accentSoft = "#24ccff00";        // 14% accent tint for backdrops
var accentGlow = "#48ccff00";        // 28% accent for borders/glows
var accentHover = "#d8ff33";         // Slightly brighter accent

// Workspaces
var activeWorkspace = "#eae7d2";     // Refined cream active indicator
var activeText = "#0e0e12";          // Deep dark text on active indicator
var inactiveWorkspaceText = "#c4c4d6"; // High contrast light gray for inactive numbers

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

// Animation Durations (ms) - Snappy & Smooth (Easing.OutCubic)
var animMicro = 100;
var animFast = 140;
var animNormal = 160;
var animPopup = 200;
var animLarge = 240;

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
