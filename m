Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824161A8137
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407240AbgDNPFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:05:21 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:39861 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407186AbgDNPFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:05:10 -0400
Received: from mail-qv1-f41.google.com ([209.85.219.41]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N5FxN-1jE1tk22j7-0119dA; Tue, 14 Apr 2020 17:05:05 +0200
Received: by mail-qv1-f41.google.com with SMTP id s18so6346431qvn.1;
        Tue, 14 Apr 2020 08:05:05 -0700 (PDT)
X-Gm-Message-State: AGi0PuYHrG6Y/RC1nTvdAEhTRv6LtJxtPzUGhWrBX519ff/Ytz9NERJD
        BDOMYoC2hAPE8M0YNnlFG3LDVF0TydT0BWeDy+E=
X-Google-Smtp-Source: APiQypLg53lbvwM7SS+vs6GZuu1V+f5ASJ1OTKDbmA6YwidcSTB5Gp26EmpzyTd2a0/A/WzgZ9UHn80nFHIsFLn9j2M=
X-Received: by 2002:a0c:9e2f:: with SMTP id p47mr355001qve.211.1586876703988;
 Tue, 14 Apr 2020 08:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <CGME20200408202802eucas1p13a369a5c584245a1affee35d2c8cad32@eucas1p1.samsung.com>
 <20200408202711.1198966-5-arnd@arndb.de> <ff7809b6-f566-9c93-1838-610be5d22431@samsung.com>
In-Reply-To: <ff7809b6-f566-9c93-1838-610be5d22431@samsung.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Apr 2020 17:04:47 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2BXZAiHh83RZJ-v9HvoE1gSED59j8k0ydJKCnHzwYz=w@mail.gmail.com>
Message-ID: <CAK8P3a2BXZAiHh83RZJ-v9HvoE1gSED59j8k0ydJKCnHzwYz=w@mail.gmail.com>
Subject: Re: [RFC 4/6] drm/bridge/sii8620: fix extcon dependency
To:     Andrzej Hajda <a.hajda@samsung.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Leon Romanovsky <leon@kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Networking <netdev@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:TZf60EAGSNVbxG8Ebo7CPWg5FOckWYVhjoT9Xj7S/35jyWVb6jX
 VqnP+fGk2LwQ7NXhEodQ4tL7G9yh2hVQvFLPtQW2Ev8RrzQjhtQcZWbdDTFjpmibzq1Y2Uf
 yI6D+SIgtO6SHF+UysDhdSu27gU9EH3z6JcIE6hHNep7gOavJYlCaX37C/klcU/3kcfemSV
 GK3BuRJFN99cFIrsfIo0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NgjUJ1WFxn8=:T0Mu8bRZJgEzxY1Opk5mD3
 pv/dgnF685Icz2N/M0AU5alrBSGDTBRCX4g5/t5DUku2lIjGefOggdh0D21ngzUMQH9PUdtc8
 WTBBoYxpwJ2Ev29fgaJr3pEvGIGCapiMY4Gh54ZXcR/+66tO/kd7RKCm1qpuAbt85WKrrhvM8
 qS26C+oIql4zcWLB1W/u4NyB5CPNXeGdIQBZJVeZj55wo0uqcXtfqBWsbWa1b9t+YR0NhG6OR
 ySXVWjr9yB5HQiATOU4fl5PmF5FshZG15a266IGbYTG4QEsXIGAIIbdeVj8s8bgNx62bxAPhv
 tirDAQlUz1f1jaCYdBbR2xSpUBcycfPeHC+7VU2bgNnfziybwdR++bCZpScRtQclWhctutDss
 +QKC2UK+or58AX3H7vRSq4DlzWvU9V2DN0RvhPAfY3ohnffJL8XOxOX2cI1FrgJN8exAq33Eb
 FO+eamAElQr0cNEkWzkS2bW9O561ovuR7MfjRtd3X5jd7ETWddDIfqWl5lyWXBsy1fvZ85Kvt
 LNBm7lnrsxr4B7C/i9RbYHljkxaxcZ3MNjvm/FWChNSOJaOfmDHeuOO0oVFCjBShTjndjK8Aa
 aLb+GqGqwn2VmNhh2fjlT2kbqNQce3YZhwpu0glUaZAXutZ/4S+THEkdgebVdsFuCj30EaBoR
 uKZLA+9JGiwzpvq94KWpP++h78rsHnKutLGBASTeiwo/6iol3OUw6bveDVbD7NeLF0LDFnu8u
 GQPylWp7G9SydhVeQFD8LMN9CEBxlfMjxGzhCdahF7X6NMK95v5BzJNJNeH21GeFrEmqNzgBs
 cmeP8nqqFrOjzxZXuGG+yepdhmVRh/NzfgGtuUT7tblPXOIkDU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 8:56 AM Andrzej Hajda <a.hajda@samsung.com> wrote:
>
>
> On 08.04.2020 22:27, Arnd Bergmann wrote:
> > Using 'imply' does not work here, it still cause the same build
> > failure:
> >
> > arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_remove':
> > sil-sii8620.c:(.text+0x1b8): undefined reference to `extcon_unregister_notifier'
> > arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_probe':
> > sil-sii8620.c:(.text+0x27e8): undefined reference to `extcon_find_edev_by_node'
> > arm-linux-gnueabi-ld: sil-sii8620.c:(.text+0x2870): undefined reference to `extcon_register_notifier'
> > arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_extcon_work':
> > sil-sii8620.c:(.text+0x2908): undefined reference to `extcon_get_state'
> >
> > I tried the usual 'depends on EXTCON || !EXTCON' logic, but that caused
> > a circular Kconfig dependency. Using IS_REACHABLE() is ugly but works.
>
> 'depends on EXTCON || !EXTCON' seems to be proper solution, maybe would be better to try to solve circular dependencies issue.

I agree that would be nice, but I failed to come to a proper solution
here. FWIW, there
is one circular dependency that I managed to avoid by changing all
drivers that select FB_DDC
to depend on I2C rather than selecting it:

drivers/i2c/Kconfig:8:error: recursive dependency detected!
drivers/i2c/Kconfig:8: symbol I2C is selected by FB_DDC
drivers/video/fbdev/Kconfig:63: symbol FB_DDC depends on FB
drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:80: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:74: symbol DRM_KMS_HELPER is selected by DRM_SIL_SII8620
drivers/gpu/drm/bridge/Kconfig:89: symbol DRM_SIL_SII8620 depends on EXTCON
drivers/extcon/Kconfig:2: symbol EXTCON is selected by CHARGER_MANAGER
drivers/power/supply/Kconfig:482: symbol CHARGER_MANAGER depends on POWER_SUPPLY
drivers/power/supply/Kconfig:2: symbol POWER_SUPPLY is selected by
HID_BATTERY_STRENGTH
drivers/hid/Kconfig:29: symbol HID_BATTERY_STRENGTH depends on HID
drivers/hid/Kconfig:8: symbol HID is selected by I2C_HID
drivers/hid/i2c-hid/Kconfig:5: symbol I2C_HID depends on I2C

After that, Kconfig crashes with a segfault:

drivers/video/fbdev/Kconfig:12:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:80: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:74: symbol DRM_KMS_HELPER is selected by DRM_SIL_SII8620
drivers/gpu/drm/bridge/Kconfig:89: symbol DRM_SIL_SII8620 depends on EXTCON
drivers/extcon/Kconfig:2: symbol EXTCON is selected by CHARGER_MANAGER
drivers/power/supply/Kconfig:482: symbol CHARGER_MANAGER depends on POWER_SUPPLY
drivers/power/supply/Kconfig:2: symbol POWER_SUPPLY is selected by HID_ASUS
drivers/hid/Kconfig:150: symbol HID_ASUS depends on LEDS_CLASS
drivers/leds/Kconfig:17: symbol LEDS_CLASS depends on NEW_LEDS
drivers/leds/Kconfig:9: symbol NEW_LEDS is selected by SENSORS_APPLESMC
drivers/hwmon/Kconfig:327: symbol SENSORS_APPLESMC depends on HWMON
drivers/hwmon/Kconfig:6: symbol HWMON is selected by EEEPC_LAPTOP
drivers/platform/x86/Kconfig:260: symbol EEEPC_LAPTOP depends on ACPI_VIDEO
make[3]: *** [/git/arm-soc/scripts/kconfig/Makefile:71: randconfig]
Segmentation fault (core dumped)

After changing EEEPC_LAPTOP and THINKPAD_ACPI to 'depends on HWMON' instead of
'select HWMON', I get this one:

drivers/video/fbdev/Kconfig:12:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:80: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:74: symbol DRM_KMS_HELPER is selected by DRM_SIL_SII8620
drivers/gpu/drm/bridge/Kconfig:89: symbol DRM_SIL_SII8620 depends on EXTCON
drivers/extcon/Kconfig:2: symbol EXTCON is selected by CHARGER_MANAGER
drivers/power/supply/Kconfig:482: symbol CHARGER_MANAGER depends on POWER_SUPPLY
drivers/power/supply/Kconfig:2: symbol POWER_SUPPLY is selected by HID_ASUS
drivers/hid/Kconfig:150: symbol HID_ASUS depends on LEDS_CLASS
drivers/leds/Kconfig:17: symbol LEDS_CLASS depends on NEW_LEDS
drivers/leds/Kconfig:9: symbol NEW_LEDS is selected by BACKLIGHT_ADP8860
drivers/video/backlight/Kconfig:316: symbol BACKLIGHT_ADP8860 depends
on BACKLIGHT_CLASS_DEVICE
drivers/video/backlight/Kconfig:143: symbol BACKLIGHT_CLASS_DEVICE is
selected by FB_BACKLIGHT
drivers/video/fbdev/Kconfig:187: symbol FB_BACKLIGHT depends on FB

Changing all drivers that select 'FB_BACKLIGHT' or 'BACKLIGHT_CLASS_DEVICE' to
'depends on BACKLIGHT_CLASS_DEVICE' gets it to build.

The steps each seem reasonable, in particular since they mostly clean
up the legacy
fbdev drivers to what they should have done anyway, but it is quite
invasive in the end.
Any other ideas?

       Arnd
