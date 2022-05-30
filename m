Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB105378BA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiE3J22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiE3J20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:28:26 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B435A483A0;
        Mon, 30 May 2022 02:28:23 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id c8so328557qtj.1;
        Mon, 30 May 2022 02:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sRRIuRryzgFI8ELIIPROeVlwSt2lbuDu8QoygFjo9dY=;
        b=xhMCCryKaUgXAGzmfynEzov/h3DV+irDCkvwFk9FVpxAlBOi4uPlmyknBz8FLzpFYW
         PH9mPInVoUC8ItuT80REI7tW+d6JBOxhKJG7mYavsIch3AnDk8/tRsUYeBZ7yiYNq6k5
         P4rtoZM827yjMM+kx3ywjmxbcDrXgqFUgPmQzR+7rbAdFNFWUgcG1vjNXTlBxBmRri0B
         FWKKHUlDZ+h1RSqLJYXjK0qzxIAAyLyCgLDYkI7nknaF1HNLDphlCfuOIjt5p7nrQyFo
         fJL9jBKwWR/xmdkGtbwyLgiqrJvfDNum1iiFGO7B3XVnn7yRIQwSHpzskrkIo1+O6bx8
         Fz6g==
X-Gm-Message-State: AOAM531FC+aUCeLmfWAYJotLhhZco/K8UbFTDyAdYCa1kWz5MZwWdPh9
        gga1ELEi7USEQrdo7MGvmJDhz0DysWbIKw==
X-Google-Smtp-Source: ABdhPJx6LkWgelCyq4Tp9CBP0jVA4z6X2m6AeRjECc5lO8DzDztKPCLfny3veaAeZP8VfHM3QdPGKg==
X-Received: by 2002:ac8:5cd3:0:b0:2ff:5954:9a91 with SMTP id s19-20020ac85cd3000000b002ff59549a91mr7848167qta.433.1653902902666;
        Mon, 30 May 2022 02:28:22 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id ca20-20020a05622a1f1400b002f3ef928fbbsm6955038qtb.72.2022.05.30.02.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 02:28:22 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id l204so7377570ybf.10;
        Mon, 30 May 2022 02:28:22 -0700 (PDT)
X-Received: by 2002:a05:6902:389:b0:633:31c1:d0f7 with SMTP id
 f9-20020a056902038900b0063331c1d0f7mr50896098ybs.543.1653902534054; Mon, 30
 May 2022 02:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com> <20220526081550.1089805-3-saravanak@google.com>
In-Reply-To: <20220526081550.1089805-3-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 May 2022 11:22:03 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV4Uzfg8aBY=tKnRcig=Npebd158J7UK3zg5_DtHwAR5w@mail.gmail.com>
Message-ID: <CAMuHMdV4Uzfg8aBY=tKnRcig=Npebd158J7UK3zg5_DtHwAR5w@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/9] pinctrl: devicetree: Delete usage of driver_deferred_probe_check_state()
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

Thanks for your patch!

On Thu, May 26, 2022 at 10:16 AM Saravana Kannan <saravanak@google.com> wrote:
> Now that fw_devlink=on by default and fw_devlink supports
> "pinctrl-[0-8]" property, the execution will never get to the point

0-9?

oh, it's really 0-8:

    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl0, "pinctrl-0", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl1, "pinctrl-1", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl2, "pinctrl-2", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl3, "pinctrl-3", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl4, "pinctrl-4", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl5, "pinctrl-5", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
    drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)

Looks fragile, especially since we now have:

    arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi:
pinctrl-9 = <&i2cmux_9>;
    arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-10
= <&i2cmux_10>;
    arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-11
= <&i2cmux_11>;
    arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-12
= <&i2cmux_pins_i>;

> where driver_deferred_probe_check_state() is called before the supplier
> has probed successfully or before deferred probe timeout has expired.
>
> So, delete the call and replace it with -ENODEV.
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
