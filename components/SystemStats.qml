import QtQuick
import "../Theme.js" as Theme

Row {
    id: root

    property var themeConfig: null
    required property var systemData

    spacing: 4

    // CPU Metric (◉ 11)
    SystemMetric {
        themeConfig: root.themeConfig
        symbol: "◉"
        value: root.systemData ? root.systemData.cpuUsage.toString() : "0"
        indicatorColor: {
            var val = root.systemData ? root.systemData.cpuUsage : 0;
            if (val > 80) return root.themeConfig ? root.themeConfig.danger : Theme.danger;
            if (val > 50) return root.themeConfig ? root.themeConfig.warning : Theme.warning;
            return root.themeConfig ? root.themeConfig.accent : Theme.accent;
        }
        tooltipTitle: "CPU Usage"
        tooltipDetail: (root.systemData ? root.systemData.cpuUsage : 0) + "%"
    }

    // RAM Metric (◉ 42)
    SystemMetric {
        themeConfig: root.themeConfig
        symbol: "◉"
        value: root.systemData ? root.systemData.ramUsage.toString() : "0"
        indicatorColor: {
            var val = root.systemData ? root.systemData.ramUsage : 0;
            if (val > 85) return root.themeConfig ? root.themeConfig.danger : Theme.danger;
            if (val > 65) return root.themeConfig ? root.themeConfig.warning : Theme.warning;
            return root.themeConfig ? root.themeConfig.accent : Theme.accent;
        }
        tooltipTitle: "RAM Usage"
        tooltipDetail: (root.systemData ? root.systemData.ramUsage : 0) + "% (" + 
                       (root.systemData ? root.systemData.ramUsedGb : 0) + " / " + 
                       (root.systemData ? root.systemData.ramTotalGb : 0) + " GB)"
    }

    // Temperature Metric (◉ 48°) - Strictly hidden if not detected
    SystemMetric {
        themeConfig: root.themeConfig
        visible: root.systemData && root.systemData.hasTemp && root.systemData.tempCelsius > 0
        symbol: "◉"
        value: (root.systemData ? root.systemData.tempCelsius : 0) + "°"
        indicatorColor: {
            var val = root.systemData ? root.systemData.tempCelsius : 0;
            if (val > 80) return root.themeConfig ? root.themeConfig.danger : Theme.danger;
            if (val > 65) return root.themeConfig ? root.themeConfig.warning : Theme.warning;
            return root.themeConfig ? root.themeConfig.accent : Theme.accent;
        }
        tooltipTitle: "Temperature"
        tooltipDetail: (root.systemData ? root.systemData.tempCelsius : 0) + "°C"
    }
}
