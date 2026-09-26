import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Item {
    id: root

    // Volume 0.0 to 1.0
    readonly property real volume: {
        if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
            return Pipewire.defaultAudioSink.audio.volume;
        }
        return _fallbackVolume;
    }

    readonly property int volumePercent: Math.round(volume * 100)

    readonly property bool muted: {
        if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
            return Pipewire.defaultAudioSink.audio.muted;
        }
        return _fallbackMuted;
    }

    readonly property string deviceName: {
        if (Pipewire.defaultAudioSink) {
            return Pipewire.defaultAudioSink.description || Pipewire.defaultAudioSink.nickname || Pipewire.defaultAudioSink.name || "Default Output";
        }
        return _fallbackDevice;
    }

    property real _fallbackVolume: 0.5
    property bool _fallbackMuted: false
    property string _fallbackDevice: "Built-in Audio"

    function setVolume(val) {
        var clamped = Math.max(0.0, Math.min(1.0, val));
        if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
            Pipewire.defaultAudioSink.audio.volume = clamped;
        }
        // Also apply via wpctl for system consistency
        setVolProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", clamped.toFixed(2)];
        setVolProc.running = false;
        setVolProc.running = true;
    }

    function toggleMute() {
        if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
        }
        toggleMuteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
        toggleMuteProc.running = false;
        toggleMuteProc.running = true;
    }

    Process { id: setVolProc }
    Process { id: toggleMuteProc }
}
