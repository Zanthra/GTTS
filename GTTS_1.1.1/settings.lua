data:extend(
{
  {
    type = "bool-setting",
    name = "gtts-Adjust-GameSpeed",
    setting_type = "startup",
    default_value = true,
  },

  {
    type = "int-setting",
    name = "gtts-Target-FrameRate",
    setting_type = "startup",
    default_value = 120,
  },

  {
    type = "bool-setting",
    name = "gtts-fluid-speed",
    setting_type = "startup",
    default_value = true,
  },

  {
    type = "bool-setting",
    name = "gtts-Reset-GameSpeed",
    setting_type = "runtime-global",
    default_value = false,
  }
}
)