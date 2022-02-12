// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <QFont>
#include <QQmlEngine>
#include <QQmlContext>
#include <QScreen>
#include <QTranslator>

#include <QtCore/qmath.h>

#include <homewindow.h>
#include <homeapplication.h>
#include <lipstickqmlpath.h>

#include "cutiewindowmodel.h"

int main(int argc, char **argv)
{
	HomeApplication app(argc, argv, QString());

	QmlPath::append("/usr/share/lipstick-cutie-home-qt5/qml");
	QGuiApplication::setFont(QFont("Lato"));
	QIcon::setThemeName("Papirus-Maia"); // TODO: Don't hardcode theme name

	qmlRegisterType<CutieWindowModel>("org.cutieshell", 1, 0, "CutieWindowModel");

    app.setCompositorPath("/usr/share/lipstick-cutie-home-qt5/qml/Compositor.qml");
	app.engine()->addImportPath("/usr/lib/qt/qml");

	app.setQmlPath("/usr/share/lipstick-cutie-home-qt5/qml/MainScreen.qml");

	setenv("EGL_PLATFORM", "wayland", 1);
    setenv("QT_QPA_PLATFORM", "wayland", 1);
    setenv("QT_IM_MODULE", "Maliit", 1);

	app.mainWindowInstance()->showFullScreen();
	return app.exec();
}
