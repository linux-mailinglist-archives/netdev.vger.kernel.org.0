Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7611868EC64
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjBHKJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjBHKJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:09:06 -0500
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA7293F3;
        Wed,  8 Feb 2023 02:09:05 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id h24so20055725qta.12;
        Wed, 08 Feb 2023 02:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Al90dbaVnMvp1zrarwIGYloHZEfuuu1TJgBG8XepFdE=;
        b=ODARmn87I0+wpt7STPuOcAeBBIeRkkY/k2hP75Qd4JOmZxio7IfcvQdWW9foKUFJVB
         Itxtl8SjNumukYOQra1ho0pXyAuPGXc5EKHwHc+/IhuF0oR4RLecpLvyVrWuLfjmme5e
         iQyJCsh85x9mH1QlC1Z0F2UPzE1dqJu+5ERGhRy0Fw4mSMG7RTes46DPLOndJAV2dwwJ
         iLtTO54zg1K1pmS9w8eufYCnb13IZ+aEnubUQSI9oHBh5suTCdUGjQXySiKv6kymRe1j
         nJsuIY0jQtB560gkm8r4dc131LxAylv8/D0ctnEypNhKfyks8bA5xc6sTGpo4Dv6N0AF
         ErXg==
X-Gm-Message-State: AO0yUKXsgEY8F3V3EFBVd8aLTRVnoEIVTxJ/SJYscTfqx5MSiwGzhJbo
        KqNXxWQiDHoWC2aPojWoUado5EWuuINBfS2S
X-Google-Smtp-Source: AK7set+z2q+GKKBVkMO9i5mvqn6izSiK+EF5MtJjRSaQhddI6zFY8709SiO4krMyjD9TKY81rsaDkg==
X-Received: by 2002:ac8:5fc1:0:b0:3b8:49a9:48c0 with SMTP id k1-20020ac85fc1000000b003b849a948c0mr11975248qta.13.1675850944267;
        Wed, 08 Feb 2023 02:09:04 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id x11-20020a05620a448b00b0072c01a3b6aasm11511525qkp.100.2023.02.08.02.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 02:09:03 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id o187so21579816ybg.3;
        Wed, 08 Feb 2023 02:09:02 -0800 (PST)
X-Received: by 2002:a5b:508:0:b0:8a3:59a4:340e with SMTP id
 o8-20020a5b0508000000b008a359a4340emr741320ybp.604.1675850942618; Wed, 08 Feb
 2023 02:09:02 -0800 (PST)
MIME-Version: 1.0
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com> <20230207142952.51844-9-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230207142952.51844-9-andriy.shevchenko@linux.intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 8 Feb 2023 11:08:51 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVkhymFCys_LnqKtpXLBT6sKURbVqBnp2wDUc63nhxvSw@mail.gmail.com>
Message-ID: <CAMuHMdVkhymFCys_LnqKtpXLBT6sKURbVqBnp2wDUc63nhxvSw@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] gpio: aggregator: Add missing header(s)
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Devarsh Thakkar <devarsht@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thanks for your patch!

On Tue, Feb 7, 2023 at 3:29 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Do not imply that some of the generic headers may be always included.
> Instead, include explicitly what we are direct user of.

That applies only to the addition of #include <linux/slab.h>...
Please also describe the other changes.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/gpio/gpio-aggregator.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
> index 6d17d262ad91..20a686f12df7 100644
> --- a/drivers/gpio/gpio-aggregator.c
> +++ b/drivers/gpio/gpio-aggregator.c
> @@ -10,19 +10,20 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/ctype.h>
> -#include <linux/gpio.h>
> -#include <linux/gpio/consumer.h>
> -#include <linux/gpio/driver.h>
> -#include <linux/gpio/machine.h>
>  #include <linux/idr.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/overflow.h>
>  #include <linux/platform_device.h>
> +#include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
>
> +#include <linux/gpio/consumer.h>
> +#include <linux/gpio/driver.h>
> +#include <linux/gpio/machine.h>
> +
>  #define AGGREGATOR_MAX_GPIOS 512

For the actual changes:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
