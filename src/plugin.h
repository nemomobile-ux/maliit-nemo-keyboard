#ifndef PLUGIN_H
#define PLUGIN_H

#include <QQmlExtensionPlugin>

class GlacierPackageManagerPlugin : public QQmlExtensionPlugin {
public:
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid FILE "glacier.keyboard.json")
public:
    void registerTypes(const char* uri);
};

#endif // PLUGIN_H
