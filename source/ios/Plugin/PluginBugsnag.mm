
#import "PluginBugsnag.h"

#include <CoronaRuntime.h>
#import <UIKit/UIKit.h>
#import <Bugsnag/Bugsnag.h>

// ----------------------------------------------------------------------------

class PluginBugsnag
{
	public:
		typedef PluginBugsnag Self;

	public:
		static const char kName[];
		static const char kEvent[];

	protected:
    PluginBugsnag();

	public:
		bool Initialize( CoronaLuaRef listener );

	public:
		CoronaLuaRef GetListener() const { return fListener; }

	public:
		static int Open( lua_State *L );

	protected:
		static int Finalizer( lua_State *L );

	public:
		static Self *ToLibrary( lua_State *L );

	public:
		static int init( lua_State *L );
        static int leaveBreadcrumb( lua_State *L );
        static int crash( lua_State *L );
	private:
		CoronaLuaRef fListener;
        static bool isDebug;
        
};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "plugin.bugsnag"
const char PluginBugsnag::kName[] = "plugin.bugsnag";

// This corresponds to the event name, e.g. [Lua] event.name
const char PluginBugsnag::kEvent[] = "pluginbugsnagevent";
bool PluginBugsnag::isDebug = NO;

PluginBugsnag::PluginBugsnag()
:	fListener( NULL )
{
}

bool
PluginBugsnag::Initialize( CoronaLuaRef listener )
{
	// Can only initialize listener once
	bool result = ( NULL == fListener );

	if ( result )
	{
		fListener = listener;
	}

	return result;
}

int
PluginBugsnag::Open( lua_State *L )
{
	// Register __gc callback
	const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
	CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );

	// Functions in library
	const luaL_Reg kVTable[] =
	{
		{ "init", init },
        { "leaveBreadcrumb", leaveBreadcrumb },
        { "crash", crash },

		{ NULL, NULL }
	};

	// Set library as upvalue for each library function
	Self *library = new Self;
	CoronaLuaPushUserdata( L, library, kMetatableName );

	luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack

	return 1;
}

int
PluginBugsnag::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );

	CoronaLuaDeleteRef( L, library->GetListener() );

	delete library;

	return 0;
}

PluginBugsnag *
PluginBugsnag::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}


int
PluginBugsnag::leaveBreadcrumb( lua_State *L )
{
    if ( lua_type( L, 1 ) == LUA_TSTRING )
    {
        const char *breadcrumb = lua_tostring( L, 1 );
        if (isDebug == true) {
            NSLog(@"**** Bugsnag Plugin will leave breadcrumb %s .", breadcrumb);
        }
        
        [Bugsnag leaveBreadcrumbWithMessage:[NSString stringWithUTF8String:breadcrumb]];
    }
    
	return 0;
}

int
PluginBugsnag::crash( lua_State *L )
{
    NSLog(@"**** Bugsnag Plugin will report error. ONLY CALL bugsnag.crash() DURING TESTING");
    [Bugsnag notifyError:[NSError errorWithDomain:@"errortest.com" code:408 userInfo:nil]];
    
    return 0;
}


int
PluginBugsnag::init( lua_State *L )
{
    int listenerIndex = 1;
    const char* userId = NULL;
    const char* email = NULL;
    const char* name = NULL;
    isDebug = NO;
    
    

    if ( CoronaLuaIsListener( L, listenerIndex, kEvent ) )
    {
        Self *library = ToLibrary( L );

        CoronaLuaRef listener = CoronaLuaNewRef( L, listenerIndex );
        library->Initialize( listener );
    }
    
    if ( lua_type( L, -1 ) == LUA_TTABLE )
    {
        lua_getfield( L, -1, "id" );
        if ( lua_type( L, -1 ) == LUA_TSTRING )
        {
            userId = lua_tostring( L, -1 );
        }
        
        lua_pop( L, 1 );
        
        lua_getfield( L, -1, "email" );
        if ( lua_type( L, -1 ) == LUA_TSTRING )
        {
            email = lua_tostring( L, -1 );
        }
        
        lua_pop( L, 1 );
        
        
        lua_getfield( L, -1, "name" );
        if ( lua_type( L, -1 ) == LUA_TSTRING )
        {
            name = lua_tostring( L, -1 );
        }
        
        lua_pop( L, 1 );
        
        lua_getfield( L, -1, "isDebug" );
        if ( lua_type( L, -1 ) == LUA_TBOOLEAN )
        {
            isDebug = lua_toboolean(L, -1);
        }
        
        lua_pop( L, 1 );
    }
    
    if (isDebug == YES) {
        NSLog(@"**** Bugsnag Plugin Will Start");
    }
    try {
        
        BugsnagConfiguration *config = [BugsnagConfiguration loadConfig];
        if (userId != NULL && email != NULL && name != NULL) {
            
            if (isDebug == YES) {
                NSLog(@"**** Bugsnag start with email: %s, userId: %s, and name: %s.", email, userId, name);
            }
            
            [config setUser:[NSString stringWithUTF8String:userId] withEmail:[NSString stringWithUTF8String:email] andName:[NSString stringWithUTF8String:name]];
            [Bugsnag startWithConfiguration:config];
        }else {
            if (isDebug == YES) {
                NSLog(@"**** Bugsnag start");
            }
            
            [Bugsnag start];
        }
        
        
        
    } catch (NSException* ex) {
        NSLog(@"**** Bugsnag Plugin Start Exception: %@, %@", ex.name, ex.description);
    }
    
    return 0;
}

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_plugin_bugsnag( lua_State *L )
{
	return PluginBugsnag::Open( L );
}
