local localLibs = "./libs/share/lua/5.4/?.lua;./libs/share/lua/5.4/?/init.lua;"
local localLibs_C = "./libs/lib/lua/5.4/?.so;"
local coreLib = "./core/components/primitives/?.lua;"
local utils = "./core/utils/?.lua;./core/hmr/?.lua;"

package.path = localLibs .. coreLib .. utils .. package.path
package.cpath = localLibs_C .. package.cpath

_G.RELEASE = false
_G.DEBUG = not RELEASE
_G.IS_PHONE = false

require("core.utils.printTable")

_G.InputManager = require("core.components.InputManager").new()

_G.GUI = {
    Rect = require("Rect_primitive"),
    View = require("View_primitive")
}

_G.Yoga = require("luyoga")
_G.RouterManager = require("core.router.manager").new()
_G.FileRoute = require("core.router.FileRoute")


_G.RouteList = {
    Root = require("routes.root"),
    Profile = require("routes.profile")
}
