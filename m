Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5985852E610
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346257AbiETHTT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 03:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiETHTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:19:13 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA8F30557;
        Fri, 20 May 2022 00:19:13 -0700 (PDT)
Received: by mail-qk1-f174.google.com with SMTP id m1so6353681qkn.10;
        Fri, 20 May 2022 00:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+GCCZN6JxXJvyJ+kgBCmMkSmKyGomtPqZqdNh5AEW+Q=;
        b=bqiRjY8ozS6DBYmjXxJS6IG8/lrTGIdAdgQAiGlNYDsUmWt+EhBizLy40kgQ3pWMAl
         l30iZjljYonB0fkx3o9mHue2QsoslTVH+fzjuReNV+GlM4/p0bz0SpmC/OL4GguojygD
         yYgdcoa0fsX9VG/at20rodMydPkYUJ6VyxmSShEoaeFeyvQq3iaf3DjTRLSrPksM5jiJ
         rmC5fs4fubRyASxQ24yeJx/DFhDRUlswgUNx2jLz3RqY9rydNr6JKzRZghigknBakR/C
         gY/LuuM69DjXQ14pnmhxRmXnapGEIqdMY75tdEF9n56K1dTARwRLvp1yj1cevPxiPPgl
         5RBA==
X-Gm-Message-State: AOAM531srQmIXcE0vDxFzkurnFcr7St18RJDFReJfdCdhc4hyfZS/dao
        o8Oena7D+vCYX+w8suvbujdfxEhoysbYew==
X-Google-Smtp-Source: ABdhPJxQrN8lVMavG9vVJqyhHxsyo7gbqot5mVnp0NvQoH5PEJTl73qCfD9vzebM4b261GGYm1Xfbw==
X-Received: by 2002:a37:6902:0:b0:680:da57:1483 with SMTP id e2-20020a376902000000b00680da571483mr5299053qkc.269.1653031151797;
        Fri, 20 May 2022 00:19:11 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id z20-20020ac875d4000000b002f39b99f678sm2514221qtq.18.2022.05.20.00.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 00:19:11 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2fed823dd32so78102537b3.12;
        Fri, 20 May 2022 00:19:10 -0700 (PDT)
X-Received: by 2002:a0d:f745:0:b0:2fe:e903:b0f8 with SMTP id
 h66-20020a0df745000000b002fee903b0f8mr8901378ywf.383.1653031150703; Fri, 20
 May 2022 00:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220519153107.696864-1-clement.leger@bootlin.com> <20220519153107.696864-12-clement.leger@bootlin.com>
In-Reply-To: <20220519153107.696864-12-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 09:18:58 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUJpNSyX0qK64+W1G6P1S-78mb_+D0-w3kHOFY3VVkANQ@mail.gmail.com>
Message-ID: <CAMuHMdUJpNSyX0qK64+W1G6P1S-78mb_+D0-w3kHOFY3VVkANQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 11/13] ARM: dts: r9a06g032: describe GMAC2
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément

On Thu, May 19, 2022 at 5:32 PM Clément Léger <clement.leger@bootlin.com> wrote:
> RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> "snps,dwmac" driver. GMAC1 is connected directly to the MII converter
> port 1. GMAC2 however can be used as the MAC for the switch CPU
> management port or can be muxed to be connected directly to the MII
> converter port 2. This commit add description for the GMAC2 which will
> be used by the switch description.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- a/arch/arm/boot/dts/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> @@ -200,6 +200,23 @@ nand_controller: nand-controller@40102000 {
>                         status = "disabled";
>                 };
>
> +               gmac2: ethernet@44002000 {
> +                       compatible = "snps,dwmac";

Does this need an SoC-specific compatible value?

> +                       reg = <0x44002000 0x2000>;
> +                       interrupt-parent = <&gic>;
> +                       interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
> +                                    <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
> +                                    <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
> +                       interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
> +                       clock-names = "stmmaceth";
> +                       clocks = <&sysctrl R9A06G032_HCLK_GMAC1>;

Missing "power-domains", also in the DT bindings.
The driver already uses Runtime PM.

> +                       snps,multicast-filter-bins = <256>;
> +                       snps,perfect-filter-entries = <128>;
> +                       tx-fifo-depth = <2048>;
> +                       rx-fifo-depth = <4096>;
> +                       status = "disabled";
> +               };
> +
>                 eth_miic: eth-miic@44030000 {
>                         compatible = "renesas,r9a06g032-miic", "renesas,rzn1-miic";
>                         #address-cells = <1>;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
