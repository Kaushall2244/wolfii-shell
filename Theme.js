// Centralized Theme System for Wolfii Shell
// Apple & Caelestia-Inspired Liquid Glass + High Contrast Wallpaper-Aware Palette
// Note: per specifications, do NOT use .pragma library

// ============================================================================
// 1. DEFAULT / FALLBACK PALETTE (Solid & Controlled Glass Tokens)
// ============================================================================

// Base Solid Colors (Deep dark neutral fallback)
var background = "#0c0c11";
var backgroundSoft = "#121218";

// Liquid Glass Surfaces (0.84 - 0.95 opacity for controlled translucency)
// Never raw wallpaper transparency; surfaces look mostly solid at first glance
var glassStrong = "#f20d0d14";       // Level 3 (~95% deep charcoal) - Modals, Settings, Control Center
var glassStrongBg = "#0d0d14";

var glassMedium = "#eb0f0f18";       // Level 2 (~92% deep charcoal) - Floating panels (Audio, Wifi, Battery)
var glassMediumBg = "#0f0f18";

var glassSoft = "#e011111a";         // Level 1 (~88% deep charcoal) - TopBar surface
var glassSoftBg = "#11111a";

// Interactive / Layered Surfaces
var surface = "#161622";             // Button/chip default surface
var surfaceStrong = "#1e1e2d";       // Elevated controls
var surfaceHover = "#242436";        // Button hover
var surfacePressed = "#12121c";      // Pressed state
var surfaceElevated = "#1f1f2e";     // Floating cards
var surfaceCard = "#151520";         // Grouped card containers
var surfaceCardHover = "#1c1c2b";    // Card hover

// Glass Borders & Specular Highlights
var border = "#26ffffff";            // 15% white border
var borderStrong = "#3affffff";      // 23% white border for active/focused
var borderSubtle = "#14ffffff";      // 8% white border for dividers/cards

var glassBorder = border;
var glassBorderStrong = borderStrong;
var glassBorderSubtle = borderSubtle;
var glassHighlight = "#38ffffff";    // 22% specular top edge highlight
var glassShadow = "#66000000";       // Soft drop shadow

// Text Colors (High Contrast & High Readability over Dark Glass)
var text = "#ffffff";                // Pure white primary text
var textMuted = "#b0b0c4";           // Light gray readable secondary text
var textSubtle = "#78788e";          // Inactive/placeholder text
var textDim = "#78788e";

// Accent Colors (Tasteful accents, not full neon bricks)
var accent = "#f2bd6e";              // Wallpaper-derived or signature warm honey
var accentSoft = "#2cf2bd6e";        // ~17% accent tint for backdrops
var accentStrong = "#d49b45";        // Deeper accent for pressed
var accentGlow = "#55f2bd6e";        // ~33% accent for borders/glows
var accentHover = "#fed48e";         // Slightly brighter accent

// Workspaces
var activeWorkspace = "#f2bd6e";     // Accent-derived active indicator
var activeWorkspaceText = "#141008"; // High contrast text on active indicator
var activeText = "#141008";          // Legacy alias
var inactiveWorkspaceText = "#c4c4d6"; // High contrast light gray for inactive numbers

// Semantic Feedback
var success = "#4ade80";             // Green
var warning = "#fbbf24";             // Amber
var danger = "#f87171";              // Red / Error

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
var animFast = 150;
var animNormal = 180;
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

// Typography
var fontFamily = "Outfit, Inter, system-ui, -apple-system, sans-serif";
var monoFontFamily = "JetBrains Mono, monospace";

// ============================================================================
// 2. COLOR CALCULATION & HARMONIOUS PALETTE GENERATION
// ============================================================================

function parseHex(hexStr) {
    if (!hexStr || typeof hexStr !== "string") return [255, 255, 255];
    var h = hexStr.trim();
    if (h.indexOf("#") === 0) h = h.substring(1);
    if (h.length === 3) {
        return [
            parseInt(h.charAt(0) + h.charAt(0), 16),
            parseInt(h.charAt(1) + h.charAt(1), 16),
            parseInt(h.charAt(2) + h.charAt(2), 16)
        ];
    }
    if (h.length === 6) {
        return [
            parseInt(h.substring(0, 2), 16),
            parseInt(h.substring(2, 4), 16),
            parseInt(h.substring(4, 6), 16)
        ];
    }
    if (h.length === 8) {
        // Assume RRGGBBAA or AARRGGBB - take RGB portion
        return [
            parseInt(h.substring(0, 2), 16),
            parseInt(h.substring(2, 4), 16),
            parseInt(h.substring(4, 6), 16)
        ];
    }
    return [255, 255, 255];
}

function toHex2(val) {
    var clamped = Math.max(0, Math.min(255, Math.round(val)));
    var s = clamped.toString(16);
    return s.length === 1 ? "0" + s : s;
}

function rgbToHex(r, g, b) {
    return "#" + toHex2(r) + toHex2(g) + toHex2(b);
}

function rgbaToHex(r, g, b, a) {
    var alphaByte = Math.round(Math.max(0, Math.min(1, a)) * 255);
    return "#" + toHex2(alphaByte) + toHex2(r) + toHex2(g) + toHex2(b);
}

function getLuminance(r, g, b) {
    return (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
}

function mix(c1Hex, c2Hex, weight) {
    var rgb1 = parseHex(c1Hex);
    var rgb2 = parseHex(c2Hex);
    var w = Math.max(0, Math.min(1, weight));
    var r = rgb1[0] * (1 - w) + rgb2[0] * w;
    var g = rgb1[1] * (1 - w) + rgb2[1] * w;
    var b = rgb1[2] * (1 - w) + rgb2[2] * w;
    return rgbToHex(r, g, b);
}

function getContrastTextColor(bgHex) {
    var rgb = parseHex(bgHex);
    var lum = getLuminance(rgb[0], rgb[1], rgb[2]);
    return lum > 0.52 ? "#121218" : "#ffffff";
}

// Generate harmonious palette from Matugen JSON
function generatePaletteFromMatugen(colors) {
    if (!colors || typeof colors !== "object") return null;

    var primary = colors.primary || "#f2bd6e";
    var primaryRgb = parseHex(primary);
    var surfaceBase = colors.surface || "#14100b";
    var onSurface = colors.on_surface || "#ede1d4";
    var onSurfaceVariant = colors.on_surface_variant || "#d0c4b4";
    var errorColor = colors.error || "#ffb4ab";

    // Surface derivation: Controlled translucency dark glass
    // 88% - 95% opacity over a darkened wallpaper-tinted base
    var bgHex = mix(surfaceBase, "#08080c", 0.65);
    var surfHex = mix(surfaceBase, "#101018", 0.40);
    var surfStrongHex = colors.surface_container || mix(surfaceBase, "#1c1c28", 0.50);
    var surfElevatedHex = colors.surface_container_high || mix(surfaceBase, "#262636", 0.60);

    return {
        background: bgHex,
        backgroundSoft: mix(bgHex, "#161622", 0.35),
        surface: surfHex,
        surfaceStrong: surfStrongHex,
        surfaceHover: mix(surfHex, "#ffffff", 0.08),
        surfacePressed: mix(surfHex, "#000000", 0.25),
        surfaceElevated: surfElevatedHex,
        surfaceCard: surfStrongHex,
        surfaceCardHover: mix(surfStrongHex, "#ffffff", 0.06),

        glassStrong: rgbaToHex(parseHex(surfStrongHex)[0], parseHex(surfStrongHex)[1], parseHex(surfStrongHex)[2], 0.95),
        glassMedium: rgbaToHex(parseHex(surfHex)[0], parseHex(surfHex)[1], parseHex(surfHex)[2], 0.91),
        glassSoft: rgbaToHex(parseHex(bgHex)[0], parseHex(bgHex)[1], parseHex(bgHex)[2], 0.87),

        border: rgbaToHex(255, 255, 255, 0.13),
        borderStrong: rgbaToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2], 0.42),
        borderSubtle: rgbaToHex(255, 255, 255, 0.07),

        text: onSurface,
        textMuted: onSurfaceVariant,
        textSubtle: mix(onSurfaceVariant, "#000000", 0.35),

        accent: primary,
        accentSoft: rgbaToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2], 0.18),
        accentStrong: mix(primary, "#000000", 0.22),
        accentGlow: rgbaToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2], 0.35),
        accentHover: mix(primary, "#ffffff", 0.16),

        activeWorkspace: primary,
        activeWorkspaceText: getContrastTextColor(primary),

        success: colors.tertiary || "#b7cea2",
        warning: colors.secondary || "#dcc3a1",
        danger: errorColor
    };
}

// Generate harmonious palette from an arbitrary accent hex color
function generatePaletteFromAccent(accentHex) {
    if (!accentHex || typeof accentHex !== "string") return null;
    var primaryRgb = parseHex(accentHex);
    var primary = rgbToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2]);

    // Tint dark surfaces gently with the accent color (5% tint)
    var bgHex = mix("#0c0c11", primary, 0.04);
    var surfHex = mix("#14141e", primary, 0.06);
    var surfStrongHex = mix("#1a1a27", primary, 0.08);
    var surfElevatedHex = mix("#222232", primary, 0.10);

    return {
        background: bgHex,
        backgroundSoft: mix(bgHex, "#161622", 0.35),
        surface: surfHex,
        surfaceStrong: surfStrongHex,
        surfaceHover: mix(surfHex, "#ffffff", 0.08),
        surfacePressed: mix(surfHex, "#000000", 0.25),
        surfaceElevated: surfElevatedHex,
        surfaceCard: surfStrongHex,
        surfaceCardHover: mix(surfStrongHex, "#ffffff", 0.06),

        glassStrong: rgbaToHex(parseHex(surfStrongHex)[0], parseHex(surfStrongHex)[1], parseHex(surfStrongHex)[2], 0.95),
        glassMedium: rgbaToHex(parseHex(surfHex)[0], parseHex(surfHex)[1], parseHex(surfHex)[2], 0.91),
        glassSoft: rgbaToHex(parseHex(bgHex)[0], parseHex(bgHex)[1], parseHex(bgHex)[2], 0.87),

        border: rgbaToHex(255, 255, 255, 0.13),
        borderStrong: rgbaToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2], 0.42),
        borderSubtle: rgbaToHex(255, 255, 255, 0.07),

        text: "#ffffff",
        textMuted: "#b4b4c8",
        textSubtle: "#76768c",

        accent: primary,
        accentSoft: rgbaToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2], 0.18),
        accentStrong: mix(primary, "#000000", 0.22),
        accentGlow: rgbaToHex(primaryRgb[0], primaryRgb[1], primaryRgb[2], 0.35),
        accentHover: mix(primary, "#ffffff", 0.16),

        activeWorkspace: primary,
        activeWorkspaceText: getContrastTextColor(primary),

        success: "#4ade80",
        warning: "#fbbf24",
        danger: "#f87171"
    };
}
