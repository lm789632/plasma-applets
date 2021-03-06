
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.extras 2.0 as PlasmaExtras

import ".."

Item {
    id: page
    property bool showDebug: false

    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    property alias cfg_weather_service: cfg_weather_serviceComboBox.value
    property alias cfg_weather_app_id: weather_app_id.text // OpenWeatherMap
    property alias cfg_weather_city_id: weather_city_id.text // OpenWeatherMap
    property alias cfg_weather_canada_city_id: weather_canada_city_id.text // WeatherCanada
    
    property string cfg_weather_units: 'metric'
    property alias cfg_events_pollinterval: weather_pollinterval.value // TODO
    property alias cfg_meteogram_hours: meteogram_hours.value
    

    SystemPalette {
        id: palette
    }

    Layout.fillWidth: true

    ColumnLayout {
        id: pageColumn
        Layout.fillWidth: true

        HeaderText {
            text: i18n("Data")
        }

        ComboBoxProperty {
            id: cfg_weather_serviceComboBox
            enabled: false
            // Layout.fillWidth: true
            model: [
                'OpenWeatherMap',
                'WeatherCanada',
            ]
            value: 'OpenWeatherMap'
        }

        GroupBox {
            Layout.fillWidth: true

            ColumnLayout {
                spacing: units.smallSpacing * 2
                Layout.fillWidth: true
                

                RowLayout {
                    visible: showDebug && page.cfg_weather_service === 'OpenWeatherMap'
                    Layout.fillWidth: true
                    Label {
                        text: i18n("API App Id:")
                    }
                    TextField {
                        id: weather_app_id
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    visible: page.cfg_weather_service === 'OpenWeatherMap'
                    Layout.fillWidth: true
                    Label {
                        text: i18n("City Id:")
                    }
                    TextField {
                        id: weather_city_id
                        Layout.fillWidth: true
                        placeholderText: i18n("Eg: 5983720")
                    }
                    Button {
                        text: i18n("Find City")
                        onClicked: openWeatherMapCityDialog.open()
                    }

                    OpenWeatherMapCityDialog {
                        id: openWeatherMapCityDialog
                        onAccepted: {
                            page.cfg_weather_city_id = selectedCityId
                        }
                    }
                }

                RowLayout {
                    visible: page.cfg_weather_service === 'WeatherCanada'
                    Layout.fillWidth: true
                    Label {
                        text: i18n("City Id:")
                    }
                    TextField {
                        id: weather_canada_city_id
                        Layout.fillWidth: true
                        placeholderText: i18n("Eg: on-14")
                    }
                    Button {
                        text: i18n("Find City")
                        onClicked: weatherCanadaCityDialog.open()
                    }

                    WeatherCanadaCityDialog {
                        id: weatherCanadaCityDialog
                        onAccepted: {
                            page.cfg_weather_canada_city_id = selectedCityId
                        }
                    }
                }
            }
        }

        HeaderText {
            text: i18n("Settings")
        }

        GroupBox {
            Layout.fillWidth: true
            ColumnLayout {
                RowLayout {
                    Label {
                        text: i18n("Update forecast every: ")
                    }
                    
                    SpinBox {
                        id: weather_pollinterval
                        enabled: false
                        
                        suffix: i18ncp("Polling interval in minutes", "min", "min", value)
                        minimumValue: 60
                        maximumValue: 90
                    }
                }
            }
        }

        HeaderText {
            text: i18n("Style")
        }

        GroupBox {
            Layout.fillWidth: true
            ColumnLayout {

                RowLayout {
                    Label {
                        text: i18n("Show next ")
                    }
                    
                    SpinBox {
                        id: meteogram_hours
                        enabled: true
                        
                        suffix: i18np(" hours", " hours", value)
                        minimumValue: 9
                        maximumValue: 48
                        stepSize: 3
                    }

                    Label {
                        text: i18n(" in the meteogram.")
                    }
                }

                
            }

        }
        GroupBox {
            Layout.fillWidth: true

            RowLayout {
                Label {
                    text: i18n("Units:")
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                }
                ColumnLayout {
                    ExclusiveGroup { id: weather_unitsGroup }
                    RadioButton {
                        text: i18n("Celsius")
                        checked: cfg_weather_units == 'metric'
                        exclusiveGroup: weather_unitsGroup
                        onClicked: {
                            cfg_weather_units = 'metric'
                        }
                    }
                    RadioButton {
                        text: i18n("Fahrenheit")
                        checked: cfg_weather_units == 'imperial'
                        exclusiveGroup: weather_unitsGroup
                        onClicked: {
                            cfg_weather_units = 'imperial'
                        }
                    }
                    RadioButton {
                        text: i18n("Kelvin")
                        checked: cfg_weather_units == 'kelvin'
                        exclusiveGroup: weather_unitsGroup
                        onClicked: {
                            cfg_weather_units = 'kelvin'
                        }
                    }
                }
            }
        }


    }
}
