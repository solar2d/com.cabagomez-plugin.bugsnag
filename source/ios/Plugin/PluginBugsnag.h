

#ifndef _PluginBugsnag_H__
#define _PluginBugsnag_H__

#include <CoronaLua.h>
#include <CoronaMacros.h>

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
// where the '.' is replaced with '_'
CORONA_EXPORT int luaopen_plugin_bugsnag( lua_State *L );

#endif // _PluginBugsnag_H__
