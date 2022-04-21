Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD807509C75
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387701AbiDUJhU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Apr 2022 05:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384833AbiDUJhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:37:19 -0400
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EB91F608;
        Thu, 21 Apr 2022 02:34:30 -0700 (PDT)
Received: by mail-qv1-f44.google.com with SMTP id dw17so3257778qvb.9;
        Thu, 21 Apr 2022 02:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mOiSQI/1VD18oOaTUb0xPlwkFtlJUDzIFqwnqSWVldQ=;
        b=hzV/tZFcowwImRdGexraxZbHXFdEMMFIMKgU99EhukVCjCsb+y35CHUgBHh1lbmTSB
         +0NMuIxDynEdnaAa1jAj8FAg0rnefS+Wc3Aw7D+MjKLzva7vfTcA22QNn5es8slUCIFE
         aJHIsoPkH7+dpbeQqIboVQCEZu7eL/YdLEGXLuxkX5LBr92QypBr+qD3noIt7TfoeMJP
         svjmfT/QxHfx/0ElGwtXgMnp79QlNfJQi2iUC06Kc7XVXtoX+rMvEJiXvRbrztHsoFbu
         CMn7DPuBsho8THfv/nFKLS06OelhWnc7gJfYnD4Ja1P2T8XV+J32w59eP2QbWVZBANL9
         dB/Q==
X-Gm-Message-State: AOAM532VrwRvhh6jGCBZkF0ESEZtBaDKeaG4QaldAbbBJiZGD4IdHCta
        Fsj8pPUiS70KfiKe5nfrbqQJu4TXEtiftOW9
X-Google-Smtp-Source: ABdhPJw+MiKAPrQny06x1ispO+kdzbd/v6/ZqvgBJBTscL/27eDVJL1Pku5tyY94DYkkw7M2CRZ3wA==
X-Received: by 2002:a0c:ed2b:0:b0:444:3f99:dc5d with SMTP id u11-20020a0ced2b000000b004443f99dc5dmr18414185qvq.2.1650533669382;
        Thu, 21 Apr 2022 02:34:29 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id w15-20020ac857cf000000b002f33f220c76sm2936759qta.32.2022.04.21.02.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 02:34:28 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2f18982c255so45951367b3.1;
        Thu, 21 Apr 2022 02:34:28 -0700 (PDT)
X-Received: by 2002:a81:1cd5:0:b0:2f4:c3fc:2174 with SMTP id
 c204-20020a811cd5000000b002f4c3fc2174mr5738857ywc.512.1650533668273; Thu, 21
 Apr 2022 02:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220414122250.158113-1-clement.leger@bootlin.com> <20220414122250.158113-12-clement.leger@bootlin.com>
In-Reply-To: <20220414122250.158113-12-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 21 Apr 2022 11:34:17 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXgZuBjC2URJdjeefacqNwWScf7-+01OCZKP3auaUcjKA@mail.gmail.com>
Message-ID: <CAMuHMdXgZuBjC2URJdjeefacqNwWScf7-+01OCZKP3auaUcjKA@mail.gmail.com>
Subject: Re: [PATCH net-next 11/12] ARM: dts: r9a06g032: describe switch
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
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Thu, Apr 14, 2022 at 2:25 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add description of the switch that is present on the RZ/N1 SoC.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- a/arch/arm/boot/dts/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> @@ -250,6 +250,17 @@ mii_conv4: mii-conv@4 {
>                         };
>                 };
>
> +               switch: switch@44050000 {
> +                       compatible = "renesas,rzn1-a5psw";
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg = <0x44050000 0x10000>;
> +                       clocks = <&sysctrl R9A06G032_HCLK_SWITCH>,
> +                                <&sysctrl R9A06G032_CLK_SWITCH>;
> +                       clock-names = "hclk_switch", "clk_switch";

"make dtbs_check":

arch/arm/boot/dts/r9a06g032-rzn1d400-db.dtb: switch@44050000:
clock-names:0: 'hclk' was expected
arch/arm/boot/dts/r9a06g032-rzn1d400-db.dtb: switch@44050000:
clock-names:1: 'clk' was expected
        From schema:
Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml

> +                       status = "disabled";
> +               };
> +
>                 gic: interrupt-controller@44101000 {
>                         compatible = "arm,gic-400", "arm,cortex-a7-gic";
>                         interrupt-controller;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
