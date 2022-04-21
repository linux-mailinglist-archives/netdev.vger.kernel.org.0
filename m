Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F58D509C4C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387667AbiDUJeE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Apr 2022 05:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387075AbiDUJeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:34:04 -0400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A909C1572E;
        Thu, 21 Apr 2022 02:31:14 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id x12so2813230qtp.9;
        Thu, 21 Apr 2022 02:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JwCuSdNSLXEV9phfYC6AwyspdGojdlT32rEj1GMZCB4=;
        b=YFwkbZrAj+VdGfiCseZczgL+5tRMwhOWuYpxrEfcWnPfNzZSOK4CFtUeCOne21Noeu
         Ev16ZgyFQcxhkyfVv96hDpdq7e3F3tSyMC36OFOU4NPsF6WwYNsq79hU/AngQx1HoEMX
         1qgVecZoMWf6klmZHeGp7nHSBxwV0LyVV2t4nCTVgdJVXvItvN1Mb0bANapMHcg69jbP
         swyl5UwsZZJUa3XuFozLxyk1owtelbPqqPx6mjwDLTGcPQzNT/CyCnYAdMI8doHoixuw
         VZYob2Brmi0PYt0HcXOq165RFLDoR5EdpakcrD7won1nHwHhxR4DD5hX1s1gb/8T1syV
         cCzA==
X-Gm-Message-State: AOAM531sO/dF4sJ+C6kPAiJyHGD0/jChUwq+jhV8wg9Glscn8XuWqs14
        b+3f6s2EM79ztaaegma80XjtkOmb42sDXwJ/
X-Google-Smtp-Source: ABdhPJwWjPp6Owo2+4AsGu0yJlnOuXSdk8KjJ4zCKIQ22oGCbx7S7168jTqnFEZtfEgSpi6oJv9cjQ==
X-Received: by 2002:ac8:7fd4:0:b0:2f3:4323:7f91 with SMTP id b20-20020ac87fd4000000b002f343237f91mr3990120qtk.354.1650533473485;
        Thu, 21 Apr 2022 02:31:13 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id n3-20020a05620a152300b0069ec409e679sm2651317qkk.48.2022.04.21.02.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 02:31:12 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2eafabbc80aso45557967b3.11;
        Thu, 21 Apr 2022 02:31:12 -0700 (PDT)
X-Received: by 2002:a81:c703:0:b0:2d0:cc6b:3092 with SMTP id
 m3-20020a81c703000000b002d0cc6b3092mr24791356ywi.449.1650533472388; Thu, 21
 Apr 2022 02:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220414122250.158113-1-clement.leger@bootlin.com> <20220414122250.158113-11-clement.leger@bootlin.com>
In-Reply-To: <20220414122250.158113-11-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 21 Apr 2022 11:31:01 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU6TQbXusC7R1UmJ0TBkRCG3W54JgduLpDzUrNUzC0eWA@mail.gmail.com>
Message-ID: <CAMuHMdU6TQbXusC7R1UmJ0TBkRCG3W54JgduLpDzUrNUzC0eWA@mail.gmail.com>
Subject: Re: [PATCH net-next 10/12] ARM: dts: r9a06g032: describe GMAC2
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Thu, Apr 14, 2022 at 2:24 PM Clément Léger <clement.leger@bootlin.com> wrote:
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
> +                       compatible = "snps,dwmac-3.72a", "snps,dwmac";

"make dtbs_check":
arch/arm/boot/dts/r9a06g032-rzn1d400-db.dtb:0:0:
/soc/ethernet@44002000: failed to match any schema with compatible:
['snps,dwmac-3.72a', 'snps,dwmac']

> +                       reg = <0x44002000 0x2000>;
> +                       interrupt-parent = <&gic>;
> +                       interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
> +                                    <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>,
> +                                    <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
> +                       interrupt-names = "macirq", "eth_lpi", "eth_wake_irq";

arch/arm/boot/dts/r9a06g032-rzn1d400-db.dtb: ethernet@44002000:
interrupt-names:1: 'eth_wake_irq' was expected
arch/arm/boot/dts/r9a06g032-rzn1d400-db.dtb: ethernet@44002000:
interrupt-names:2: 'eth_lpi' was expected
        From schema: Documentation/devicetree/bindings/net/snps,dwmac.yaml

> +                       clock-names = "stmmaceth";
> +                       clocks = <&sysctrl R9A06G032_HCLK_GMAC1>;
> +                       snps,multicast-filter-bins = <256>;
> +                       snps,perfect-filter-entries = <128>;
> +                       tx-fifo-depth = <2048>;
> +                       rx-fifo-depth = <4096>;
> +                       status = "disabled";
> +               };
> +
>                 eth_miic: eth-miic@44030000 {
>                         compatible = "renesas,rzn1-miic";
>                         #address-cells = <1>;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
