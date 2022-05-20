Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9E52E5FF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbiETHNk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 03:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbiETHNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:13:39 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E73140841;
        Fri, 20 May 2022 00:13:38 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id x65so2087009qke.2;
        Fri, 20 May 2022 00:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GCrhi2K2Dty2bgxNnj28EIUE9cUht+MAZzziai/dEyk=;
        b=ZXP1Dbf/xZQBx0+NmsxKiqAq5+cqZZ3RToePL3kTDKdvUGojxgZy4YxLo80C3CcqDv
         msbYn3C1qhPH7R4msYs8TMyGfPP1xO13nYJ2Qvj313xzZBuRleRp/eaVz2tOR+hhVZz/
         Ps63lt3TWn5Z7NP1Atc7e7e/ifVPFFB5ZfXjr9oj9e+KgXJZFBUFyUNgMKEk0QhUHz/c
         89Vu7f9kURWbXQ/RTtp7/7E9i7pTn1hKBOjAQ42QEuUmgih5wQ0ZqKd6qyG0KSJxen1L
         JfjJPejHNnrsMVYMyQZvrLCb7vnVGmKwuks9u8/eCgGnX2rj+g1Vtmsof94TdY4a8W7j
         nsQw==
X-Gm-Message-State: AOAM533ZMtcbDAF1zvP+End5p000CaaQykCBRDOIAYNQIapn4zEcpgme
        sqlvsxkWsH3Z/KqNvlaXBQrka8s7QVjoUg==
X-Google-Smtp-Source: ABdhPJxTQ4fBg9pwRl76dbxTgY0mvGa/fcf3vJH/1xsBLce6fchFkLftXf0Y+YKSTdGQR8qI2RS7FA==
X-Received: by 2002:a05:620a:1456:b0:6a3:35dc:2307 with SMTP id i22-20020a05620a145600b006a335dc2307mr3905933qkl.456.1653030817056;
        Fri, 20 May 2022 00:13:37 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id s65-20020ae9de44000000b006a2f129425asm2412878qkf.130.2022.05.20.00.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 00:13:36 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id x2so12448552ybi.8;
        Fri, 20 May 2022 00:13:35 -0700 (PDT)
X-Received: by 2002:a25:e04d:0:b0:64d:6f23:b906 with SMTP id
 x74-20020a25e04d000000b0064d6f23b906mr8138784ybg.380.1653030815564; Fri, 20
 May 2022 00:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220519153107.696864-1-clement.leger@bootlin.com> <20220519153107.696864-7-clement.leger@bootlin.com>
In-Reply-To: <20220519153107.696864-7-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 09:13:23 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXRCggkTSxfnSHvz3N2Oekuw7y5Sy2AKkqZpZzK_Eg_ng@mail.gmail.com>
Message-ID: <CAMuHMdXRCggkTSxfnSHvz3N2Oekuw7y5Sy2AKkqZpZzK_Eg_ng@mail.gmail.com>
Subject: Re: [PATCH net-next v5 06/13] dt-bindings: net: dsa: add bindings for
 Renesas RZ/N1 Advanced 5 port switch
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

Hi Clément,

On Thu, May 19, 2022 at 5:32 PM Clément Léger <clement.leger@bootlin.com> wrote:
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
> @@ -0,0 +1,131 @@
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
> +    items:
> +      - enum:
> +          - renesas,r9a06g032-a5psw
> +      - const: renesas,rzn1-a5psw
> +
> +  reg:
> +    maxItems: 1
> +
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false
> +
> +  clocks:
> +    items:
> +      - description: AHB clock used for the switch register interface
> +      - description: Switch system clock
> +
> +  clock-names:
> +    items:
> +      - const: hclk
> +      - const: clk

(Good, "clock-names" is present ;-)

Missing "power-domains" property.

> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> +
> +    switch@44050000 {
> +        compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
> +        reg = <0x44050000 0x10000>;
> +        clocks = <&sysctrl R9A06G032_HCLK_SWITCH>, <&sysctrl R9A06G032_CLK_SWITCH>;
> +        clock-names = "hclk", "clk";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;

Usually we don't list pinctrl-* properties in examples.

The rest LGTM (from an SoC integration PoV), so with the above fixed
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
