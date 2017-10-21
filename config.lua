--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      width = aspectRatio > 1.5 and 1080 or math.floor(1620 / aspectRatio),
      height = aspectRatio < 1.5 and 1620 or math.floor(1080 * aspectRatio),
      scale = "letterBox",
      fps = 30,
      imageSuffix = { ["@2x"] = 1.3 },
   },
}
