local module = require("module")
local resUtils = require("res.resUtils")
local ASyncGameObject = require("obj.ASyncGameObject")
local Player = require("player.Player")
local Stream = require("common.Stream")

local test = {}

function test.f5()
    --local s = resUtils.loadAssetByPath("Assets/Res/TestGO.prefab", function(asset, f)
    --    CS.UnityEngine.GameObject.Instantiate(asset)
    --    f()
    --end)
    --local player = Player:new()
    --player:setAssetInfo("Assets/Res/TestGO.prefab")
    --player:show()

    local monster = Monster:new()
    monster:setAssetInfo("Assets/Res/TestGO.prefab")
    monster:show()

    module.event.onUpdate:dump()
end

function test.f6()
    --module.scenes.lv1.player.evt_attack:trigger()
    module.event.onSendTip:trigger("hello world")
    --package.loaded["player.PlayerInfo"] = nil
    --goObj2 = ASyncGameObject:new()
    --goObj2:setAssetInfo("Assets/Res/TestGO.prefab")
    --goObj2:show()
    --module.sceneMgr.switch("s1", "s1")
end

function test.f7()
    module.scenes.lv1.player:hide()
end

function test.f8()
    module.scenes.lv1.player:show()
    --resUtils.dump()
end

return test