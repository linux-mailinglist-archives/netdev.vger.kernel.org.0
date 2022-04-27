Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDC6511716
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiD0MX6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Apr 2022 08:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiD0MX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:23:57 -0400
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBDA3A5DE;
        Wed, 27 Apr 2022 05:20:46 -0700 (PDT)
Received: by mail-qv1-f51.google.com with SMTP id a5so915896qvx.1;
        Wed, 27 Apr 2022 05:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7IblRXw+IlRsIpma65z+vY+J/pcL54rFKRWppWIp02E=;
        b=O3CdkQv4cYeQR75NZsj42LjUgccfGNp/y6NotezEn4kTtTka21SMi7uwxsFiN09zpC
         uahxVZs73d7B2rXBfV1kfzM1A15v1buMS9JMTcUydE8IosadZCvEPiNp3xdC3Zj9PQpn
         eBrShPkKOaM83wt1IpBSm2N3/XHin+c4nVGdO+jwe/R2nh0oPwpEytjX69GEiByNaZxO
         Y1qnBPwq8aYIxcKl092guD+Yh5phHs6pkyJ1a0B0EmLy6g5rkxKsSquTUIlLfj0hsBqn
         teFqNSaGFT80uCa1tpEUpXXMuH/WcSRep726ZKztZScEwAPl1RNmGDnQx4uXLlNENjcf
         1W+Q==
X-Gm-Message-State: AOAM533+3++Fou2ASMFTSOIZBBfoeNnsFfoVD3C3IYD7u8ujmwUoHf4Y
        RGUGdGYXQrES84nr6FdegFjjdTPMClD0yQ==
X-Google-Smtp-Source: ABdhPJyVQRDiG1YrApjp41wD1Jo0ktqu1HzK4hDe/+jDGHwfNgHMPIkn1Yz+S6jPqiZ9B4gA8gf7IQ==
X-Received: by 2002:a05:6214:2aa7:b0:446:2f18:d005 with SMTP id js7-20020a0562142aa700b004462f18d005mr19705064qvb.33.1651062045462;
        Wed, 27 Apr 2022 05:20:45 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id v12-20020a05620a0a8c00b0069eabadd6dasm7711882qkg.41.2022.04.27.05.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 05:20:44 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id w17so2993689ybh.9;
        Wed, 27 Apr 2022 05:20:44 -0700 (PDT)
X-Received: by 2002:a5b:24e:0:b0:63d:cba0:3d55 with SMTP id
 g14-20020a5b024e000000b0063dcba03d55mr24895863ybp.613.1651062044076; Wed, 27
 Apr 2022 05:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220414122250.158113-1-clement.leger@bootlin.com> <20220414122250.158113-6-clement.leger@bootlin.com>
In-Reply-To: <20220414122250.158113-6-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 27 Apr 2022 14:20:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU+kosUPavthyPcWVAC_WhdwXiFKt61oSmgdV6Qxk_0xg@mail.gmail.com>
Message-ID: <CAMuHMdU+kosUPavthyPcWVAC_WhdwXiFKt61oSmgdV6Qxk_0xg@mail.gmail.com>
Subject: Re: [PATCH net-next 05/12] dt-bindings: net: dsa: add bindings for
 Renesas RZ/N1 Advanced 5 port switch
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Thu, Apr 14, 2022 at 2:24 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> This company does not exists anymore and has been bought by Synopsys.
> Since this IP can't be find anymore in the Synospsy portfolio, lets use
> Renesas as the vendor compatible for this IP.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -0,0 +1,128 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas RZ/N1 Advanced 5 ports ethernet switch
> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +description: |
> +  The advanced 5 ports switch is present on the Renesas RZ/N1 SoC family and
> +  handles 4 ports + 1 CPU management port.
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +properties:
> +  compatible:
> +    const: renesas,rzn1-a5psw

Please document an SoC-specific compatible value
"renesas,r9a06g032-a5psw", too, so we can easily handle differences
between members within the RZ/N1 family, if ever needed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
