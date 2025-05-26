local cmd = chatcmdbuilder.register("prop_hunt", {
    description = "Commands for the Prop Hunt mod.",
    privs = {prop_hunt = true},
    params = "(enter <nodename>) | exit | snap",
})

cmd:sub("enter :node:itemname", function(name, node)
    prop_hunt.enter(core.get_player_by_name(name), node)
end)

cmd:sub("exit", function(name)
    prop_hunt.exit(core.get_player_by_name(name))
end)

cmd:sub("snap", function(name)
    prop_hunt.snap(core.get_player_by_name(name))
end)