local ffi = require"ffi"
ffi.cdef([[
    void *malloc(size_t size);
    void free(void *ptr);
    void *memset(void *s, int c, size_t n);
    void *memcpy(void *dest, const void *src, size_t n);

    typedef struct _imlib_border {
       int left, right, top, bottom;
    };

    struct _imlib_color {
       int alpha, red, green, blue;
    };

    typedef unsigned long long DATA64;
    typedef unsigned int DATA32;
    typedef unsigned short DATA16;
    typedef unsigned char DATA8;

    /* opaque data types */
    typedef void *Imlib_Context;
    typedef void *Imlib_Image;
    typedef void *Imlib_Color_Modifier;
    typedef void *Imlib_Updates;
    typedef void *Imlib_Font;
    typedef void *Imlib_Color_Range;
    typedef void *Imlib_Filter;
    typedef struct _imlib_border Imlib_Border;
    typedef struct _imlib_color Imlib_Color;
    typedef void *ImlibPolygon;

    /* blending operations */
    enum _imlib_operation
    {
       IMLIB_OP_COPY,
       IMLIB_OP_ADD,
       IMLIB_OP_SUBTRACT,
       IMLIB_OP_RESHADE
    };

    enum _imlib_text_direction
    {
       IMLIB_TEXT_TO_RIGHT = 0,
       IMLIB_TEXT_TO_LEFT = 1,
       IMLIB_TEXT_TO_DOWN = 2,
       IMLIB_TEXT_TO_UP = 3,
       IMLIB_TEXT_TO_ANGLE = 4
    };

    enum _imlib_load_error
    {
       IMLIB_LOAD_ERROR_NONE,
       IMLIB_LOAD_ERROR_FILE_DOES_NOT_EXIST,
       IMLIB_LOAD_ERROR_FILE_IS_DIRECTORY,
       IMLIB_LOAD_ERROR_PERMISSION_DENIED_TO_READ,
       IMLIB_LOAD_ERROR_NO_LOADER_FOR_FILE_FORMAT,
       IMLIB_LOAD_ERROR_PATH_TOO_LONG,
       IMLIB_LOAD_ERROR_PATH_COMPONENT_NON_EXISTANT,
       IMLIB_LOAD_ERROR_PATH_COMPONENT_NOT_DIRECTORY,
       IMLIB_LOAD_ERROR_PATH_POINTS_OUTSIDE_ADDRESS_SPACE,
       IMLIB_LOAD_ERROR_TOO_MANY_SYMBOLIC_LINKS,
       IMLIB_LOAD_ERROR_OUT_OF_MEMORY,
       IMLIB_LOAD_ERROR_OUT_OF_FILE_DESCRIPTORS,
       IMLIB_LOAD_ERROR_PERMISSION_DENIED_TO_WRITE,
       IMLIB_LOAD_ERROR_OUT_OF_DISK_SPACE,
       IMLIB_LOAD_ERROR_UNKNOWN
    };

    /* Encodings known to Imlib2 (so far) */
    enum _imlib_TTF_encoding
    {
       IMLIB_TTF_ENCODING_ISO_8859_1,
       IMLIB_TTF_ENCODING_ISO_8859_2,
       IMLIB_TTF_ENCODING_ISO_8859_3,
       IMLIB_TTF_ENCODING_ISO_8859_4,
       IMLIB_TTF_ENCODING_ISO_8859_5
    };

    typedef enum _imlib_operation Imlib_Operation;
    typedef enum _imlib_load_error Imlib_Load_Error;
    typedef enum _imlib_load_error ImlibLoadError;
    typedef enum _imlib_text_direction Imlib_Text_Direction;
    typedef enum _imlib_TTF_encoding Imlib_TTF_Encoding;

    /* Progressive loading callbacks */
    typedef int (*Imlib_Progress_Function) (Imlib_Image im, char percent,
                                            int update_x, int update_y,
                                            int update_w, int update_h);
    typedef void (*Imlib_Data_Destructor_Function) (Imlib_Image im, void *data);

    /* context handling */
    Imlib_Context imlib_context_new(void);
    void imlib_context_free(Imlib_Context context);

    void imlib_context_push(Imlib_Context context);
    void imlib_context_pop(void);
    Imlib_Context imlib_context_get(void);

    void imlib_context_set_dither_mask(char dither_mask);
    void imlib_context_set_mask_alpha_threshold(int mask_alpha_threshold);
    void imlib_context_set_anti_alias(char anti_alias);
    void imlib_context_set_dither(char dither);
    void imlib_context_set_blend(char blend);
    void imlib_context_set_color_modifier(Imlib_Color_Modifier color_modifier);
    void imlib_context_set_operation(Imlib_Operation operation);
    void imlib_context_set_font(Imlib_Font font);
    void imlib_context_set_direction(Imlib_Text_Direction direction);
    void imlib_context_set_angle(double angle);
    void imlib_context_set_color(int red, int green, int blue, int alpha);
    void imlib_context_set_color_hsva(float hue, float saturation, float value, int alpha);
    void imlib_context_set_color_hlsa(float hue, float lightness, float saturation, int alpha);
    void imlib_context_set_color_cmya(int cyan, int magenta, int yellow, int alpha);
    void imlib_context_set_color_range(Imlib_Color_Range color_range);
    void imlib_context_set_progress_function(Imlib_Progress_Function
                                                    progress_function);
    void imlib_context_set_progress_granularity(char progress_granularity);
    void imlib_context_set_image(Imlib_Image image);
    void imlib_context_set_cliprect(int x, int y, int w, int h);
    void imlib_context_set_TTF_encoding(Imlib_TTF_Encoding encoding);

    /* context getting */
    char imlib_context_get_dither_mask(void);
    char imlib_context_get_anti_alias(void);
    int imlib_context_get_mask_alpha_threshold(void);
    char imlib_context_get_dither(void);
    char imlib_context_get_blend(void);
    Imlib_Color_Modifier imlib_context_get_color_modifier(void);
    Imlib_Operation imlib_context_get_operation(void);
    Imlib_Font imlib_context_get_font(void);
    double imlib_context_get_angle(void);
    Imlib_Text_Direction imlib_context_get_direction(void);
    void imlib_context_get_color(int *red, int *green, int *blue, int *alpha);
    void imlib_context_get_color_hsva(float *hue, float *saturation, float *value, int *alpha);
    void imlib_context_get_color_hlsa(float *hue, float *lightness, float *saturation, int *alpha);
    void imlib_context_get_color_cmya(int *cyan, int *magenta, int *yellow, int *alpha);
    Imlib_Color *imlib_context_get_imlib_color(void);
    Imlib_Color_Range imlib_context_get_color_range(void);
    Imlib_Progress_Function imlib_context_get_progress_function(void);
    char imlib_context_get_progress_granularity(void);
    Imlib_Image imlib_context_get_image(void);
    void imlib_context_get_cliprect(int *x, int *y, int *w, int *h);
    Imlib_TTF_Encoding imlib_context_get_TTF_encoding(void);

    int imlib_get_cache_size(void);
    void imlib_set_cache_size(int bytes);
    int imlib_get_color_usage(void);
    void imlib_set_color_usage(int max);
    void imlib_flush_loaders(void);

    Imlib_Image imlib_load_image(const char *file);
    Imlib_Image imlib_load_image_immediately(const char *file);
    Imlib_Image imlib_load_image_without_cache(const char *file);
    Imlib_Image imlib_load_image_immediately_without_cache(const char *file);
    Imlib_Image imlib_load_image_with_error_return(const char *file,
                                                           Imlib_Load_Error *
                                                           error_return);
    void imlib_free_image(void);
    void imlib_free_image_and_decache(void);

    /* query/modify image parameters */
    int imlib_image_get_width(void);
    int imlib_image_get_height(void);
    const char *imlib_image_get_filename(void);
    DATA32 *imlib_image_get_data(void);
    DATA32 *imlib_image_get_data_for_reading_only(void);
    void imlib_image_put_back_data(DATA32 * data);
    char imlib_image_has_alpha(void);
    void imlib_image_set_changes_on_disk(void);
    void imlib_image_get_border(Imlib_Border * border);
    void imlib_image_set_border(Imlib_Border * border);
    void imlib_image_set_format(const char *format);
    void imlib_image_set_irrelevant_format(char irrelevant);
    void imlib_image_set_irrelevant_border(char irrelevant);
    void imlib_image_set_irrelevant_alpha(char irrelevant);
    char *imlib_image_format(void);
    void imlib_image_set_has_alpha(char has_alpha);
    void imlib_image_query_pixel(int x, int y, Imlib_Color * color_return);
    void imlib_image_query_pixel_hsva(int x, int y, float *hue, float *saturation, float *value, int *alpha);
    void imlib_image_query_pixel_hlsa(int x, int y, float *hue, float *lightness, float *saturation, int *alpha);
    void imlib_image_query_pixel_cmya(int x, int y, int *cyan, int *magenta, int *yellow, int *alpha);

    /* rendering functions */
    void imlib_blend_image_onto_image(Imlib_Image source_image,
                                              char merge_alpha, int source_x,
                                              int source_y, int source_width,
                                              int source_height, int destination_x,
                                              int destination_y, int destination_width,
                                              int destination_height);

    /* creation functions */
    Imlib_Image imlib_create_image(int width, int height);
    Imlib_Image imlib_create_image_using_data(int width, int height,
                                                     DATA32 * data);
    Imlib_Image imlib_create_image_using_copied_data(int width, int height,
                                                            DATA32 * data);
    Imlib_Image imlib_clone_image(void);
    Imlib_Image imlib_create_cropped_image(int x, int y, int width,
                                                  int height);
    Imlib_Image imlib_create_cropped_scaled_image(int source_x, int source_y,
                                                          int source_width,
                                                          int source_height,
                                                          int destination_width,
                                                          int destination_height);

    /* imlib updates. lists of rectangles for storing required update draws */
    Imlib_Updates imlib_updates_clone(Imlib_Updates updates);
    Imlib_Updates imlib_update_append_rect(Imlib_Updates updates, int x, int y,
                                                  int w, int h);
    Imlib_Updates imlib_updates_merge(Imlib_Updates updates, int w, int h);
    Imlib_Updates imlib_updates_merge_for_rendering(Imlib_Updates updates,
                                                           int w, int h);
    void imlib_updates_free(Imlib_Updates updates);
    Imlib_Updates imlib_updates_get_next(Imlib_Updates updates);
    void imlib_updates_get_coordinates(Imlib_Updates updates, int *x_return,
                                              int *y_return, int *width_return,
                                              int *height_return);
    void imlib_updates_set_coordinates(Imlib_Updates updates, int x, int y,
                                              int width, int height);
    void imlib_render_image_updates_on_drawable(Imlib_Updates updates, int x,
                                                       int y);
    Imlib_Updates imlib_updates_init(void);
    Imlib_Updates imlib_updates_append_updates(Imlib_Updates updates,
                                                       Imlib_Updates appended_updates);

    /* image modification */
    void imlib_image_flip_horizontal(void);
    void imlib_image_flip_vertical(void);
    void imlib_image_flip_diagonal(void);
    void imlib_image_orientate(int orientation);
    void imlib_image_blur(int radius);
    void imlib_image_sharpen(int radius);
    void imlib_image_tile_horizontal(void);
    void imlib_image_tile_vertical(void);
    void imlib_image_tile(void);

    /* fonts and text */
    Imlib_Font imlib_load_font(const char *font_name);
    void imlib_free_font(void);
      /* NB! The four functions below are deprecated. */
    int imlib_insert_font_into_fallback_chain(Imlib_Font font, Imlib_Font fallback_font);
    void imlib_remove_font_from_fallback_chain(Imlib_Font fallback_font);
    Imlib_Font imlib_get_prev_font_in_fallback_chain(Imlib_Font fn);
    Imlib_Font imlib_get_next_font_in_fallback_chain(Imlib_Font fn);
      /* NB! The four functions above are deprecated. */
    void imlib_text_draw(int x, int y, const char *text);
    void imlib_text_draw_with_return_metrics(int x, int y, const char *text,
                                                    int *width_return,
                                                    int *height_return,
                                                    int *horizontal_advance_return,
                                                    int *vertical_advance_return);
    void imlib_get_text_size(const char *text, int *width_return,
                                    int *height_return);
    void imlib_get_text_advance(const char *text, 
                   int *horizontal_advance_return,
                   int *vertical_advance_return);
    int imlib_get_text_inset(const char *text);
    void imlib_add_path_to_font_path(const char *path);
    void imlib_remove_path_from_font_path(const char *path);
    char **imlib_list_font_path(int *number_return);
    int imlib_text_get_index_and_location(const char *text, int x, int y,
                                                  int *char_x_return,
                                                  int *char_y_return,
                                                  int *char_width_return,
                                                  int *char_height_return);
    void imlib_text_get_location_at_index(const char *text, int index,
                                                  int *char_x_return,
                                                  int *char_y_return,
                                                  int *char_width_return,
                                                  int *char_height_return);
    char **imlib_list_fonts(int *number_return);
    void imlib_free_font_list(char **font_list, int number);
    int imlib_get_font_cache_size(void);
    void imlib_set_font_cache_size(int bytes);
    void imlib_flush_font_cache(void);
    int imlib_get_font_ascent(void);
    int imlib_get_font_descent(void);
    int imlib_get_maximum_font_ascent(void);
    int imlib_get_maximum_font_descent(void);

    /* color modifiers */
    Imlib_Color_Modifier imlib_create_color_modifier(void);
    void imlib_free_color_modifier(void);
    void imlib_modify_color_modifier_gamma(double gamma_value);
    void imlib_modify_color_modifier_brightness(double brightness_value);
    void imlib_modify_color_modifier_contrast(double contrast_value);
    void imlib_set_color_modifier_tables(DATA8 * red_table,
                                                 DATA8 * green_table,
                                                 DATA8 * blue_table,
                                                 DATA8 * alpha_table);
    void imlib_get_color_modifier_tables(DATA8 * red_table,
                                                 DATA8 * green_table,
                                                 DATA8 * blue_table,
                                                 DATA8 * alpha_table);
    void imlib_reset_color_modifier(void);
    void imlib_apply_color_modifier(void);
    void imlib_apply_color_modifier_to_rectangle(int x, int y, int width,
                                                         int height);

    /* drawing on images */
    Imlib_Updates imlib_image_draw_pixel(int x, int y, char make_updates);
    Imlib_Updates imlib_image_draw_line(int x1, int y1, int x2, int y2,
                                                char make_updates);
    void imlib_image_draw_rectangle(int x, int y, int width, int height);
    void imlib_image_fill_rectangle(int x, int y, int width, int height);
    void imlib_image_copy_alpha_to_image(Imlib_Image image_source, int x,
                                                 int y);
    void imlib_image_copy_alpha_rectangle_to_image(Imlib_Image image_source,
                                                           int x, int y, int width,
                                                           int height,
                                                           int destination_x,
                                                           int destination_y);
    void imlib_image_scroll_rect(int x, int y, int width, int height,
                                         int delta_x, int delta_y);
    void imlib_image_copy_rect(int x, int y, int width, int height, int new_x,
                                       int new_y);

    /* polygons */
    ImlibPolygon imlib_polygon_new(void);
    void imlib_polygon_free(ImlibPolygon poly);
    void imlib_polygon_add_point(ImlibPolygon poly, int x, int y);
    void imlib_image_draw_polygon(ImlibPolygon poly, unsigned char closed);
    void imlib_image_fill_polygon(ImlibPolygon poly);
    void imlib_polygon_get_bounds(ImlibPolygon poly, int *px1, int *py1,
                                         int *px2, int *py2);
    unsigned char imlib_polygon_contains_point(ImlibPolygon poly, int x,
                                                       int y);

    /* ellipses */
    void imlib_image_draw_ellipse(int xc, int yc, int a, int b);
    void imlib_image_fill_ellipse(int xc, int yc, int a, int b);

    /* color ranges */
    Imlib_Color_Range imlib_create_color_range(void);
    void imlib_free_color_range(void);
    void imlib_add_color_to_color_range(int distance_away);
    void imlib_image_fill_color_range_rectangle(int x, int y, int width,
                                                       int height, double angle);
    void imlib_image_fill_hsva_color_range_rectangle(int x, int y, int width,
                                                             int height, double angle);

    /* image data */
    void imlib_image_attach_data_value(const char *key, void *data, int value,
                                               Imlib_Data_Destructor_Function
                                               destructor_function);
    void *imlib_image_get_attached_data(const char *key);
    int imlib_image_get_attached_value(const char *key);
    void imlib_image_remove_attached_data_value(const char *key);
    void imlib_image_remove_and_free_attached_data_value(const char *key);

    /* saving */
    void imlib_save_image(const char *filename);
    void imlib_save_image_with_error_return(const char *filename,
                                                    Imlib_Load_Error * error_return);

    /* rotation/skewing */
    Imlib_Image imlib_create_rotated_image(double angle);

    /* rotation from buffer to context (without copying)*/
    void imlib_rotate_image_from_buffer(double angle, 
                           Imlib_Image source_image);

    void imlib_blend_image_onto_image_at_angle(Imlib_Image source_image,
                                                       char merge_alpha, int source_x,
                                                       int source_y, int source_width,
                                                       int source_height,
                                                       int destination_x,
                                                       int destination_y, int angle_x,
                                                       int angle_y);
    void imlib_blend_image_onto_image_skewed(Imlib_Image source_image,
                                                     char merge_alpha, int source_x,
                                                     int source_y, int source_width,
                                                     int source_height,
                                                     int destination_x,
                                                     int destination_y, int h_angle_x,
                                                     int h_angle_y, int v_angle_x,
                                                     int v_angle_y);

    /* image filters */
    void imlib_image_filter(void);
    Imlib_Filter imlib_create_filter(int initsize);
    void imlib_context_set_filter(Imlib_Filter filter);
    Imlib_Filter imlib_context_get_filter(void);
    void imlib_free_filter(void);
    void imlib_filter_set(int xoff, int yoff, int a, int r, int g, int b);
    void imlib_filter_set_alpha(int xoff, int yoff, int a, int r, int g,
                                       int b);
    void imlib_filter_set_red(int xoff, int yoff, int a, int r, int g, int b);
    void imlib_filter_set_green(int xoff, int yoff, int a, int r, int g,
                                       int b);
    void imlib_filter_set_blue(int xoff, int yoff, int a, int r, int g, int b);
    void imlib_filter_constants(int a, int r, int g, int b);
    void imlib_filter_divisors(int a, int r, int g, int b);

    void imlib_apply_filter(char *script, ...);

    void imlib_image_clear(void);
    void imlib_image_clear_color(int r, int g, int b, int a);
]])

local function get_flags()
  local proc = io.popen("imlib2-config --cflags --libs", "r")
  local flags = proc:read("*a")
  proc:close()
  return flags
end
local function try_to_load()
    local r, out = pcall(ffi.load,'Imlib2')
    if r then return out end
    local lname = get_flags():match("-l(Imlib2[^%s]*)")
    local os = ffi.os
    local suffix = os=='OSX' and '.dylib' or os=='Windows' and '.dll' or '.so'
    local lib = lname and "lib"..lname..suffix
    local r, out = pcall(ffi.load,lib)
    if r then return out end
    return error("Failed to load ImageMagick ("..lib..")")
end
local imlib2 = try_to_load()
--local imlib2 = ffi.load('Imlib2')

return imlib2
