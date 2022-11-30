Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B763D885
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiK3Ovb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Nov 2022 09:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiK3Ov2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:51:28 -0500
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B286573B83;
        Wed, 30 Nov 2022 06:51:24 -0800 (PST)
Received: by mail-qt1-f173.google.com with SMTP id a27so11229401qtw.10;
        Wed, 30 Nov 2022 06:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbewHNiIDPrh2vDJAS18QQyUgoqR1U2XFbW+RCOiyVY=;
        b=fCXuCOgUwLOoxJH49GdlHGzuXdGP3I5vqtKMQfw5p/zM1r4oBmwI25DVL2rJwh3AEm
         2MT2kuea8mUOjXqUTBz4OHAlI6cj3GPIYUor399iWhBHSMyTZbHscIOjg0vQjyw9/TKP
         hZS6NWMNxSV74chr9cNAJ3IYqBs3z1yKSWzsv8dd6Usp8rHqgbOw5BME2sOFlciLJHVF
         2gsgvGdnvdp8G4gwF1ibs9mvH5gMeBYfaFiGGWOL0rdIzdtFxbkQ2zT7WDbqiw26zikL
         uR9+g09vhUsfyhh/onuP5TIxIsSWkyoNxLmMMaDoHa8uQYJGSmUxE0rk2FmCGJLb97GO
         TwtA==
X-Gm-Message-State: ANoB5pnuGTT7RELZ7BhWRdGXJ8VlkfCavUzwlUiDK58G7HuexBWb2TZ/
        OQLy0BhEvyuLsDsdJV6nxkMzQOEQzK35CQ==
X-Google-Smtp-Source: AA0mqf5t9XxSny7wiMYJL+fC3x3d1hmg9pcxoc3fo7HwOxvscAyInELNzC7ZXHCOZNBIyrHqL5faMA==
X-Received: by 2002:a05:622a:488f:b0:3a6:328e:e7d1 with SMTP id fc15-20020a05622a488f00b003a6328ee7d1mr21723005qtb.272.1669819883617;
        Wed, 30 Nov 2022 06:51:23 -0800 (PST)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id y26-20020a37f61a000000b006bc192d277csm1262642qkj.10.2022.11.30.06.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 06:51:22 -0800 (PST)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-3c090251d59so117848417b3.4;
        Wed, 30 Nov 2022 06:51:22 -0800 (PST)
X-Received: by 2002:a81:f80f:0:b0:38e:e541:d8ca with SMTP id
 z15-20020a81f80f000000b0038ee541d8camr55824371ywm.283.1669819872327; Wed, 30
 Nov 2022 06:51:12 -0800 (PST)
MIME-Version: 1.0
References: <20221130141040.32447-1-arinc.unal@arinc9.com> <20221130141040.32447-3-arinc.unal@arinc9.com>
In-Reply-To: <20221130141040.32447-3-arinc.unal@arinc9.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 30 Nov 2022 15:51:00 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVBZiWxORfb2hd0hn_En6yFEwm8uJXr553YfB8gv1sOFw@mail.gmail.com>
Message-ID: <CAMuHMdVBZiWxORfb2hd0hn_En6yFEwm8uJXr553YfB8gv1sOFw@mail.gmail.com>
Subject: Re: [PATCH 2/5] arm: dts: remove label = "cpu" from DSA dt-binding
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        soc@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Stefan Agner <stefan@agner.ch>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tim Harvey <tharvey@gateworks.com>,
        Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-rockchip@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC cleger

On Wed, Nov 30, 2022 at 3:33 PM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
> This is not used by the DSA dt-binding, so remove it from all devicetrees.
>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

>  arch/arm/boot/dts/r9a06g032.dtsi                          | 1 -

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/arch/arm/boot/dts/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> @@ -401,7 +401,6 @@ switch_port3: port@3 {
>                                 switch_port4: port@4 {
>                                         reg = <4>;
>                                         ethernet = <&gmac2>;
> -                                       label = "cpu";
>                                         phy-mode = "internal";
>                                         status = "disabled";
>                                         fixed-link {

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
