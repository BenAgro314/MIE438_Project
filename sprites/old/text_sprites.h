#ifndef TEST_SPRITES_H
#define TEST_SPRITES_H

#ifdef __cplusplus
extern "C"
{
#endif

    //  0-9 A-Z    Size 34
    //const unsigned char nima[] =
        //{
            //0x1c, 0x1c, 0x62, 0x7e, 0xc2, 0xf3, 0xc2, 0xe3,
            //0xc6, 0xe7, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0xc, 0xc, 0x5e, 0x5e, 0x6c, 0x6f, 0xc, 0x3e,
            //0x18, 0x1e, 0x38, 0x3c, 0x38, 0x3c, 0x0, 0x1c,
            //0xbc, 0xbc, 0xe6, 0xfe, 0x46, 0x77, 0xc, 0x2f,
            //0x70, 0x76, 0xcc, 0xfc, 0xfe, 0xfe, 0x0, 0x7f,
            //0xbc, 0xbc, 0x66, 0x7e, 0xe, 0x3f, 0x4, 0x7,
            //0x86, 0x86, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0x30, 0x30, 0x18, 0x18, 0x32, 0x3e, 0x64, 0x7d,
            //0xfe, 0xfe, 0xc, 0x7f, 0x1c, 0x1e, 0x0, 0xe,
            //0x6c, 0x6c, 0x3e, 0x3e, 0x60, 0x7f, 0x7c, 0x7c,
            //0x86, 0xbe, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0x3c, 0x3c, 0x72, 0x7e, 0xe0, 0xf9, 0xfc, 0xfc,
            //0xc6, 0xfe, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0x7e, 0x7e, 0xce, 0xff, 0xcc, 0xef, 0x18, 0x7e,
            //0x38, 0x3c, 0x38, 0x3c, 0x30, 0x3c, 0x0, 0x18,
            //0x3c, 0x3c, 0x66, 0x7e, 0x3e, 0x3f, 0x7c, 0x7f,
            //0xc6, 0xfe, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0x7c, 0x7c, 0xe2, 0xfe, 0xe6, 0xf7, 0x7c, 0x7f,
            //0xc, 0x3e, 0x1c, 0x1e, 0x18, 0x1e, 0x0, 0xc,
            //0x18, 0x18, 0x8, 0xc, 0x2c, 0x2c, 0x6c, 0x7e,
            //0x7e, 0x7e, 0xce, 0xff, 0xc6, 0xe7, 0x0, 0x63,
            //0xdc, 0xdc, 0x66, 0x7e, 0x66, 0x77, 0x7c, 0x7f,
            //0xe6, 0xfe, 0xe6, 0xf7, 0xf8, 0xff, 0x0, 0x7c,
            //0x1c, 0x1c, 0x66, 0x7e, 0xc0, 0xf3, 0xc6, 0xe6,
            //0xce, 0xef, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0xdc, 0xdc, 0x62, 0x7e, 0x62, 0x73, 0x66, 0x77,
            //0xe6, 0xf7, 0xee, 0xff, 0xfc, 0xff, 0x0, 0x7e,
            //0xfc, 0xfc, 0x62, 0x7e, 0x78, 0x79, 0x60, 0x7c,
            //0xce, 0xfe, 0xfe, 0xff, 0xf2, 0xff, 0x0, 0x79,
            //0xfc, 0xfc, 0x62, 0x7e, 0x60, 0x71, 0x78, 0x78,
            //0xe0, 0xfc, 0xe0, 0xf0, 0xc0, 0xf0, 0x0, 0x60,
            //0x1c, 0x1c, 0x66, 0x7e, 0xc0, 0xf3, 0xde, 0xfe,
            //0xce, 0xef, 0xfe, 0xff, 0x74, 0x7f, 0x0, 0x3a,
            //0xcc, 0xcc, 0x66, 0x66, 0x7e, 0x7f, 0x66, 0x7f,
            //0x6e, 0x7f, 0xce, 0xff, 0x86, 0xe7, 0x0, 0x43,
            //0x30, 0x30, 0x18, 0x18, 0x18, 0x1c, 0x18, 0x1c,
            //0x38, 0x3c, 0x38, 0x3c, 0x30, 0x3c, 0x0, 0x18,
            //0x78, 0x78, 0x3c, 0x3c, 0x18, 0x1e, 0x18, 0x1c,
            //0x38, 0x3c, 0xf8, 0xfc, 0x70, 0x7c, 0x0, 0x38,
            //0xe6, 0xe6, 0x6e, 0x7f, 0x78, 0x7f, 0x68, 0x7c,
            //0x64, 0x74, 0xc6, 0xf6, 0x86, 0xe7, 0x0, 0x43,
            //0x60, 0x60, 0x30, 0x30, 0x30, 0x38, 0x60, 0x78,
            //0x60, 0x70, 0xfc, 0xfc, 0x8e, 0xfe, 0x0, 0x47,
            //0xc4, 0xc4, 0x46, 0x66, 0x6e, 0x6f, 0xfe, 0xff,
            //0xb6, 0xff, 0xb6, 0xff, 0xa4, 0xff, 0x0, 0x52,
            //0xcc, 0xcc, 0x66, 0x66, 0x76, 0x77, 0x6e, 0x7f,
            //0x6e, 0x7f, 0xce, 0xff, 0x86, 0xe7, 0x0, 0x43,
            //0x1c, 0x1c, 0x66, 0x7e, 0xc6, 0xf7, 0xc6, 0xe7,
            //0xce, 0xef, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0xdc, 0xdc, 0x66, 0x7e, 0x66, 0x77, 0x7c, 0x7f,
            //0xe0, 0xfe, 0xe0, 0xf0, 0xc0, 0xf0, 0x0, 0x60,
            //0x1c, 0x1c, 0x66, 0x7e, 0xc6, 0xf7, 0xf6, 0xf7,
            //0xcc, 0xff, 0xfe, 0xfe, 0x76, 0x7f, 0x0, 0x3b,
            //0xdc, 0xdc, 0x66, 0x7e, 0x66, 0x77, 0x78, 0x7f,
            //0xec, 0xfc, 0xee, 0xfe, 0xc6, 0xf7, 0x0, 0x63,
            //0x3c, 0x3c, 0x66, 0x7e, 0x30, 0x33, 0xc, 0x1c,
            //0xc6, 0xce, 0xfe, 0xff, 0x7c, 0x7f, 0x0, 0x3e,
            //0xfc, 0xfc, 0x7e, 0x7e, 0x10, 0x3f, 0x30, 0x38,
            //0x70, 0x78, 0x70, 0x78, 0x60, 0x78, 0x0, 0x30,
            //0x24, 0x24, 0x66, 0x76, 0x4e, 0x7f, 0xce, 0xef,
            //0xdc, 0xff, 0xfc, 0xfe, 0x78, 0x7e, 0x0, 0x3c,
            //0x86, 0x86, 0xce, 0xcf, 0x5c, 0x7f, 0x78, 0x7e,
            //0x78, 0x7c, 0x30, 0x3c, 0x20, 0x38, 0x0, 0x10,
            //0x92, 0x92, 0xb6, 0xff, 0xb6, 0xff, 0xfe, 0xff,
            //0xfc, 0xff, 0xdc, 0xfe, 0x98, 0xfe, 0x0, 0x4c,
            //0xcc, 0xcc, 0xee, 0xee, 0x7c, 0x7f, 0x38, 0x3e,
            //0x7c, 0x7c, 0x4e, 0x7e, 0x82, 0xe7, 0x0, 0x41,
            //0xc6, 0xc6, 0x6e, 0x6f, 0x1c, 0x3f, 0x18, 0x1e,
            //0x38, 0x3c, 0x30, 0x3c, 0x30, 0x38, 0x0, 0x18,
            //0x9c, 0x9c, 0xfe, 0xfe, 0x4c, 0x7f, 0x10, 0x3e,
            //0x2c, 0x3c, 0xfe, 0xfe, 0x72, 0x7f, 0x0, 0x39};

    const unsigned char aero[] =
        {0x0, 0x0, 0x3e, 0x3e, 0x7f, 0x7f, 0x63, 0x63,
         0x63, 0x63, 0x63, 0x63, 0x7f, 0x7f, 0x3e, 0x3e,
         0x0, 0x0, 0x1c, 0x1c, 0x7c, 0x7c, 0x7c, 0x7c,
         0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c,
         0x0, 0x0, 0x7e, 0x7e, 0x7f, 0x7f, 0x3, 0x3,
         0x3f, 0x3f, 0x70, 0x70, 0x7f, 0x7f, 0x7f, 0x7f,
         0x0, 0x0, 0x7e, 0x7e, 0x7f, 0x7f, 0x7, 0x7,
         0x3e, 0x3e, 0x7, 0x7, 0x7f, 0x7f, 0x7e, 0x7e,
         0x0, 0x0, 0xe, 0xe, 0x1e, 0x1e, 0x36, 0x36,
         0x66, 0x66, 0x7f, 0x7f, 0x7f, 0x7f, 0xe, 0xe,
         0x0, 0x0, 0x7f, 0x7f, 0x7f, 0x7f, 0x70, 0x70,
         0x7e, 0x7e, 0x7, 0x7, 0x7f, 0x7f, 0x7e, 0x7e,
         0x0, 0x0, 0x1f, 0x1f, 0x3f, 0x3f, 0x70, 0x70,
         0x7e, 0x7e, 0x63, 0x63, 0x7f, 0x7f, 0x3e, 0x3e,
         0x0, 0x0, 0x7f, 0x7f, 0x7f, 0x7f, 0x7, 0x7,
         0xe, 0xe, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c,
         0x0, 0x0, 0x3e, 0x3e, 0x7f, 0x7f, 0x63, 0x63,
         0x3e, 0x3e, 0x63, 0x63, 0x7f, 0x7f, 0x3e, 0x3e,
         0x0, 0x0, 0x3e, 0x3e, 0x7f, 0x7f, 0x63, 0x63,
         0x3f, 0x3f, 0x7, 0x7, 0x3f, 0x3f, 0x3e, 0x3e,
         0x0, 0x0, 0x1e, 0x1e, 0x3f, 0x3f, 0x63, 0x63,
         0x7f, 0x7f, 0x7f, 0x7f, 0x63, 0x63, 0x63, 0x63,
         0x0, 0x0, 0x7e, 0x7e, 0x7f, 0x7f, 0x63, 0x63,
         0x7e, 0x7e, 0x63, 0x63, 0x7f, 0x7f, 0x7e, 0x7e,
         0x0, 0x0, 0x1f, 0x1f, 0x3f, 0x3f, 0x60, 0x60,
         0x60, 0x60, 0x60, 0x60, 0x7f, 0x7f, 0x3f, 0x3f,
         0x0, 0x0, 0x7c, 0x7c, 0x7e, 0x7e, 0x63, 0x63,
         0x63, 0x63, 0x63, 0x63, 0x7f, 0x7f, 0x7e, 0x7e,
         0x0, 0x0, 0x3f, 0x3f, 0x7f, 0x7f, 0x60, 0x60,
         0x7e, 0x7e, 0x60, 0x60, 0x7f, 0x7f, 0x3f, 0x3f,
         0x0, 0x0, 0x3f, 0x3f, 0x7f, 0x7f, 0x60, 0x60,
         0x7e, 0x7e, 0x7e, 0x7e, 0x60, 0x60, 0x60, 0x60,
         0x0, 0x0, 0x3f, 0x3f, 0x7f, 0x7f, 0x60, 0x60,
         0x6f, 0x6f, 0x63, 0x63, 0x7f, 0x7f, 0x3f, 0x3f,
         0x0, 0x0, 0x63, 0x63, 0x63, 0x63, 0x7f, 0x7f,
         0x7f, 0x7f, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
         0x0, 0x0, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c,
         0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c,
         0x0, 0x0, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3,
         0x63, 0x63, 0x63, 0x63, 0x7f, 0x7f, 0x3e, 0x3e,
         0x0, 0x0, 0x63, 0x63, 0x67, 0x67, 0x6e, 0x6e,
         0x7c, 0x7c, 0x6e, 0x6e, 0x67, 0x67, 0x63, 0x63,
         0x0, 0x0, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60,
         0x60, 0x60, 0x60, 0x60, 0x7f, 0x7f, 0x7f, 0x7f,
         0x0, 0x0, 0x63, 0x63, 0x77, 0x77, 0x7f, 0x7f,
         0x7f, 0x7f, 0x6b, 0x6b, 0x63, 0x63, 0x63, 0x63,
         0x0, 0x0, 0x73, 0x73, 0x7b, 0x7b, 0x7f, 0x7f,
         0x6f, 0x6f, 0x67, 0x67, 0x63, 0x63, 0x63, 0x63,
         0x0, 0x0, 0x3e, 0x3e, 0x7f, 0x7f, 0x63, 0x63,
         0x63, 0x63, 0x63, 0x63, 0x7f, 0x7f, 0x3e, 0x3e,
         0x0, 0x0, 0x7e, 0x7e, 0x7f, 0x7f, 0x63, 0x63,
         0x7f, 0x7f, 0x7e, 0x7e, 0x60, 0x60, 0x60, 0x60,
         0x0, 0x0, 0x3e, 0x3e, 0x7f, 0x7f, 0x63, 0x63,
         0x63, 0x63, 0x7e, 0x7e, 0x73, 0x73, 0x3d, 0x3d,
         0x0, 0x0, 0x7e, 0x7e, 0x7f, 0x7f, 0x63, 0x63,
         0x7f, 0x7f, 0x7e, 0x7e, 0x67, 0x67, 0x63, 0x63,
         0x0, 0x0, 0x3e, 0x3e, 0x7e, 0x7e, 0x70, 0x70,
         0x3e, 0x3e, 0x7, 0x7, 0x7f, 0x7f, 0x7e, 0x7e,
         0x0, 0x0, 0x7f, 0x7f, 0x7f, 0x7f, 0x1c, 0x1c,
         0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c,
         0x0, 0x0, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
         0x63, 0x63, 0x63, 0x63, 0x7f, 0x7f, 0x3e, 0x3e,
         0x0, 0x0, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
         0x77, 0x77, 0x7e, 0x7e, 0x3c, 0x3c, 0x18, 0x18,
         0x0, 0x0, 0x6b, 0x6b, 0x6b, 0x6b, 0x6b, 0x6b,
         0x6b, 0x6b, 0x6b, 0x6b, 0x7f, 0x7f, 0x3f, 0x3f,
         0x0, 0x0, 0x63, 0x63, 0x77, 0x77, 0x3e, 0x3e,
         0x1c, 0x1c, 0x3e, 0x3e, 0x77, 0x77, 0x63, 0x63,
         0x0, 0x0, 0x63, 0x63, 0x63, 0x63, 0x77, 0x77,
         0x3e, 0x3e, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c,
         0x0, 0x0, 0x7f, 0x7f, 0x7f, 0x7f, 0xe, 0xe,
         0x1c, 0x1c, 0x38, 0x38, 0x7f, 0x7f, 0x7f, 0x7f};

#ifdef __cplusplus
}
#endif

#endif // TEST_SPRITES_H