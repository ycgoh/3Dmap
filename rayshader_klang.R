# From rayshader tutorial
# To install the latest version from Github:
# install.packages("devtools")
devtools::install_github("tylermorganwall/rayshader")


library(rayshader)

#Here, I load a map with the raster package.
localtif = raster::raster("C:/Users/User/Documents/GIS/3D/klang/SRTM_klang2_cr.tif")
#cannot use same map different resolution as matrix is different, xy coordinates different



#And convert it to a matrix:
elmat = raster_to_matrix(localtif)

##check matrix dimension
dim(elmat)


#We use another one of rayshader's built-in textures:
elmat %>%
  sphere_shade(texture = "desert") %>%
  plot_map()


#sphere_shade can shift the sun direction:
elmat %>%
  sphere_shade(sunangle = 45, texture = "desert") %>%
  plot_map()


#detect_water and add_water adds a water layer to the map:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  plot_map()



# Add image overlay

#import png
overlay_img <- png::readPNG("C:/Users/User/Documents/GIS/3D/klang/klang_layout2-7.png")


##check png dimensions
dim(overlay_img)


#plot map
elmat %>%
  #sphere_shade() %>%
  sphere_shade(texture = "imhof1", zscale = 50) %>%
  add_overlay(overlay_img, alphalayer = 1) %>% 
  add_shadow(ray_shade(elmat), 0.5) %>%
  plot_map()




#And here we add an ambient occlusion shadow layer, which models 
#lighting from atmospheric scattering:

elmat %>%
  #sphere_shade() %>%
  sphere_shade(texture = "imhof1", zscale = 20) %>%
  add_overlay(overlay_img, alphalayer = 1) %>% 
  add_shadow(ray_shade(elmat), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_map()


#passing a texture map (either external or one produced by 
#rayshader) into the plot_3d function.

elmat %>%
  #sphere_shade() %>% #no need this if use overlay
  sphere_shade(texture = "imhof1", zscale = 50) %>%  #must use this if use overlay
  add_overlay(overlay_img, alphalayer = 1, rescale_original = F) %>% 
  #add_shadow(ray_shade(elmat), 0.5) %>%
  #add_shadow(ambient_shade(elmat), 0) %>%
  add_shadow(ray_shade(elmat, sunaltitude = 10, zscale = 33, lambert = FALSE), 
             max_darken = 0.7) %>%  #max_darken higher value means brighter
  add_shadow(lamb_shade(elmat, sunaltitude = 10, zscale = 33), 
             max_darken = 0.9) %>%
  add_shadow(ambient_shade(elmat), max_darken = 0.1) %>%
  plot_3d(elmat, 
          zscale = 10, #Adjust the zscale down to exaggerate elevation features
          fov = 20,   #isometric. Field-of-view angle (tilt?)
          theta = 20, #Rotation around z-axis
          zoom = 0.3, 
          phi = 10, #Azimuth angle (z angle view)
          windowsize = c(1000, 800))
render_label(elmat, x = 250, y = 380, z = 800, zscale = 50,
             text = "Kg. Iboi", textsize = 2, linewidth = 3)
render_label(elmat, x = 140, y = 640, z = 4500, zscale = 50,
             textcolor = "darkgreen", linecolor = "darkgreen",
             text = "Gunung Inas", textsize = 2, linewidth = 3)
render_label(elmat, x = 182, y = 190, z = 500, zscale = 50,
             textcolor = "dodgerblue4", linecolor = "dodgerblue4",
             text = "Sg. Kupang", textsize = 2, linewidth = 3)
Sys.sleep(0.2)
render_snapshot("C:/Users/User/Documents/GIS/3D/rayshader/Klang3D_30m_7-2.png", 
                software_render = TRUE, width = 1000, height = 800,
                clear = TRUE)


#interactive map (set interactive)
render_highquality(samples = 256, 
                   interactive = FALSE,
                   lightdirection = 45, 
                   scale_text_size = 24, clear = TRUE)







# EXPERIMENTS

# scalebar, compass

render_camera(fov = 0, theta = 60, zoom = 0.75, phi = 45)
render_scalebar(limits=c(0, 5, 10),label_unit = "km",position = "W", y=50,
                scale_length = c(0.33,1))
render_compass(position = "E")
render_snapshot(clear=TRUE)






##trying
render_depth(focus = 0.5, focallength = 100, fstop = 4, 
             bokehintensity = 5, bokehshape = "hex", 
             rotation = 30)



render_snapshot(clear=TRUE)

# render high quality
render_highquality(samples=256, line_radius = 1, text_size = 18, text_offset = c(0,12,0),
                   clamp_value=10, clear = TRUE)




