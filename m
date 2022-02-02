Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA234A7B0F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 23:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346157AbiBBWXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 17:23:31 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60067 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbiBBWX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 17:23:28 -0500
Received: from mail-ej1-f51.google.com ([209.85.218.51]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MnItm-1mYepm17R6-00jFOg; Wed, 02 Feb 2022 23:23:26 +0100
Received: by mail-ej1-f51.google.com with SMTP id ah7so1728899ejc.4;
        Wed, 02 Feb 2022 14:23:26 -0800 (PST)
X-Gm-Message-State: AOAM532G35q5il8XjWGIpZYJt2sFuru+4dhzT3lf99/ws3d5dB3ijosO
        Drh5+mwdNb7HxNk68qN/0BYjt63q19GzptWkr4U=
X-Google-Smtp-Source: ABdhPJyS0pXYjoI1KSj8v4HS5DRpiR5z8Z+MmivHV59Rfz0qHTXBAOHLhOORnhnqrVG7qMP59ls3cQTx3h8P+oStNX4=
X-Received: by 2002:a05:6000:3c6:: with SMTP id b6mr26662700wrg.12.1643836901999;
 Wed, 02 Feb 2022 13:21:41 -0800 (PST)
MIME-Version: 1.0
References: <nick.hawkins@hpe.com> <20220202165315.18282-1-nick.hawkins@hpe.com>
 <20220202175635.GC2091156@minyard.net> <3E9905F2-1576-4826-ADC2-85796DE0F4DB@hpe.com>
In-Reply-To: <3E9905F2-1576-4826-ADC2-85796DE0F4DB@hpe.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 2 Feb 2022 22:21:25 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3itj=nshdRCoFQQh5fg-RsEaqj1PdBxfeN2-TzqmoPpQ@mail.gmail.com>
Message-ID: <CAK8P3a3itj=nshdRCoFQQh5fg-RsEaqj1PdBxfeN2-TzqmoPpQ@mail.gmail.com>
Subject: Re: [PATCH] HPE BMC GXP SUPPORT
To:     "Verdun, Jean-Marie" <verdun@hpe.com>
Cc:     "minyard@acm.org" <minyard@acm.org>,
        "Hawkins, Nick" <nick.hawkins@hpe.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "soc@kernel.org" <soc@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Stanislav Jakubek <stano.jakubek@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hao Fang <fanghao11@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:eHZ+/p82ioH8uVkEKDxI8wmvf5/VFWaDWr4RRIk/y6sIysPpszd
 wGlRCsc9m/dJ0xxE9RWBvVW32bGcJ0diIECHUYZVFt4SH/TLkdohXbnOre3nFphAblpa2Ul
 Ui/0u4ekH1YnFaHpkAyNL7wltP2xNo8XYiCGi4RLRoEA58Om6p79KS3zzlxNy58H9MvN9E2
 o1pkdVW6gSK6OQiDScZoQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:X5EY0W3ufyQ=:DlIXCv0bRUN/weL9WzbSdm
 A+3vSRl8O1hLqdIb9jklxlxAMI8foeI5osuJByX0WoVIBj1iQq6vEjKqyGkO78ofeP3adxDn7
 xGbL9Nu7gg/uSY+eVir2/+RGiu44j7Sv6q8bIdx+bPAVx/GmW6oFKErWxFS5oaPMLpkwqzlbx
 d36PeXSrjJGxuPwIE4FPvfJsWGvx9yfs6nx9x7w+CWYzwHNZ2ZcJP3P80S0N2Ny9DxC51nlkj
 CmI0rKTDH1BusAllcB/OEJjUxL+1h9CM+B9SvyAKWLjTbUtVZy6kFZzg3tXa1KDbJLucZAcZd
 f2DPIOFqb4f1SaBDINsrRRYrgaBTt3O3x/HzcuxE5BGCi274TSy4GKFOYSRyqqwyLn+HhNd/M
 6UKUEzozHDRyumUe7OEL14vq7NqcyqD7Mvd+up+hCTjfToTNvztqFpPCgM6ir9Nt5ieGPuEWn
 q0wTv/5xlSvwMDM00hyzpBVw+/mcRVNLJG8hfO7C7Hp4xtlQ/j+3r3w33HZJA7tsh7wMr8iFz
 z4YKhWQ9L/LEuT0C+5PhOPYRMRyPkJ4vbhEQOoVc2FPgeh557jX1fJHqWBW1gLFdnCa10qOjj
 343uTyhDrDVi6F9q54OF/OUbb1OnKEl9iK0Lr94ovD0l/+cAfEIlQKor6v1yUQFUTNRd1qwDV
 AF8Vdib5YXTIx4jMQvOiHIsRucVFESPexorGwCmR/DyuOSdFKE6Nd9gtFqDob5Z8oloayj577
 swErGVWR/tZk2dU4EeEhqvLUHGwo1FU9aP6khQUWHV16YDRWGS6qSTeEux/rK+ycJWuv40Jzu
 GUZp0ajxVPRPdvTjvZY07gmDw8ILY3COlw6RpyE/PhfEs6SGl0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 7:14 PM Verdun, Jean-Marie <verdun@hpe.com> wrote:
>
> > This is far too big for a single patch.  It needs to be broken into
> > functional chunks that can be reviewed individually.  Each driver and
> > each device tree change along with it's accompanying code need to be
> > done in individual patches.  The way it is it can't be reviewed in any
> > sane manner.
>
> > -corey
>
> Thanks for your feedback. We are getting a little bit lost here, as our plan was to submit initial
>
> - bindings
> - dts for SoC and 1 board
> - initial platform init code
>
> Then drivers code avoiding to send many dts updates which might complexify the
> review. We wanted to send all drivers code to relevant reviewers by tomorrow.
>
> So, what you are asking ( do not worry I am not trying to negotiate, I just want
> to avoid English misunderstandings as I am French) is to send per driver
>
> - binding
> - dts update
> - driver code
>
> For each driver through different submission (with each of them containing the
> 3 associated parts) ?
>
> What shall be the initial one in our case as we are introducing a platform ?
> An empty dts infrastructure and then we make it grow one step at a time ?

Ideally, what I prefer to see is a series of patches for all "essential" drivers
and the platform code that includes:

- one patch for each new binding
- one patch for each new driver
- one patch that hooks up arch/arm/mach-hpe/, MAINTAINERS
  and any other changes to arch/arm/ other than dts
- one patch that adds the initial .dts and .dtsi files, with all the
  devices added that have a valid binding, no need to split this
  up any further

This should include everything you need to boot into an initramfs
shell, typically cpu, serial, timer, clk, pinctrl,  gpio, irqchip. We will
merge these as a git branch in the soc tree.

In parallel, you can work with subsystem maintainers for the
"non-essential" drivers to review any other driver and binding,
e.g. drm/kms, network, i2c, pci, usb, etc. The patches for
the corresponding .dts additions also go through the soc tree,
but to make things simpler, you can send those in for a later
release.

          Arnd
