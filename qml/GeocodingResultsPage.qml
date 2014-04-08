/* -*- coding: utf-8-unix -*-
 *
 * Copyright (C) 2014 Osmo Salomaa
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "."

Page {
    id: page
    property string title: "Results"
    SilicaListView {
        anchors.fill: parent
        delegate: ListItem {
            id: listItem
            contentHeight: titleLabel.height + descriptionLabel.height +
                distanceLabel.height
            ListItemLabel {
                id: titleLabel
                color: listItem.highlighted ?
                    Theme.highlightColor : Theme.primaryColor;
                height: implicitHeight + Theme.paddingMedium
                text: title
                verticalAlignment: Text.AlignBottom
            }
            ListItemText {
                id: descriptionLabel
                anchors.top: titleLabel.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                height: implicitHeight
                text: description
                verticalAlignment: Text.AlignVCenter
            }
            ListItemLabel {
                id: distanceLabel
                anchors.top: descriptionLabel.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                height: implicitHeight + Theme.paddingMedium
                text: distance
                verticalAlignment: Text.AlignTop
            }
            onClicked: {
                console.log("Clicked: " + title);
            }
        }
        header: PageHeader { title: page.title }
        model: ListModel { id: listModel }
        VerticalScrollDecorator {}
    }
    onStatusChanged: {
        if (page.status == PageStatus.Active) {
            var previousPage = app.pageStack.previousPage();
            page.populate(previousPage.query);
            page.title = listModel.count + " Results"
        } else if (page.status == PageStatus.Inactive) {
            listModel.clear();
            page.title = "Results"
        }
    }
    function populate(query) {
        // Load geocoding results from the Python backend.
        listModel.clear();
        var bbox = map.getBoundingBox();
        var x = map.position.coordinate.longitude || 0;
        var y = map.position.coordinate.latitude || 0;
        var results = py.call_sync("poor.app.geocoder.geocode",
                                   [query,
                                    x,
                                    y,
                                    bbox[0],
                                    bbox[1],
                                    bbox[2],
                                    bbox[3]]);

        for (var i = 0; i < results.length; i++) {
            listModel.append(results[i]);
        }
    }
}
