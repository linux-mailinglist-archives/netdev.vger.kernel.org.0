Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478D8562CEC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbiGAHqG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 Jul 2022 03:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiGAHqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:46:06 -0400
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6D948837;
        Fri,  1 Jul 2022 00:46:04 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id n15so3339835qvh.12;
        Fri, 01 Jul 2022 00:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wE4bFtTL36vFmikZ1ytwvzCWwTBgGc5pXW0bXvIIsbc=;
        b=MTKEDwujyQaxHEO0aCHEmM7pJvCzOCWCffrlGAoY9GeArM+S5SFKuA3D2bVzcrsfJc
         jbdUc03pMHz87gFbv5L+xf27FcCJgKDFjw/tkgKvsHkiRsyVhxyAEn1bySGIyiWYpQVg
         1q9L9wZcFZjaeo7yeSbgzJYzwirjmjIPgiUgHsIlGXSibyR6XlVTvHj+cynIoHnhwsmP
         ySqKayh3cy/wQlPoyme2h+9S1rtJiiGBvxccdhwK7ANhtGJ+k7464V230wG9StzaOqWk
         wUg7UCgkiPu4m2fDVT2Xw5GvwBn/wcjZS4wECKlbtiWaCL9xsyNF6/McuaSrgj8Uh2wC
         v0ZA==
X-Gm-Message-State: AJIora8rfUEk22h8NSvIpdvHGW8ihjStHdJdJ02vhb+i6HEp5hR1HBhT
        eMAQloR8BWDnok0HlzOG3Z819t29mjFNPw==
X-Google-Smtp-Source: AGRyM1vhfhp+91QYY3y9wnv6FH7LV7i9o2/+15bpimdDz+wTZB3Maiv4UfamJnQJMw0znb85v3v1uQ==
X-Received: by 2002:a05:622a:1aa8:b0:31b:f4b9:650c with SMTP id s40-20020a05622a1aa800b0031bf4b9650cmr11266535qtc.1.1656661563921;
        Fri, 01 Jul 2022 00:46:03 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id m5-20020ac84445000000b00307beda5c6esm13975709qtn.26.2022.07.01.00.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 00:46:03 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id r3so2649874ybr.6;
        Fri, 01 Jul 2022 00:46:03 -0700 (PDT)
X-Received: by 2002:a05:6902:1246:b0:66d:5b0b:19b0 with SMTP id
 t6-20020a056902124600b0066d5b0b19b0mr13181284ybu.365.1656661562781; Fri, 01
 Jul 2022 00:46:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220630162515.37302-1-clement.leger@bootlin.com>
In-Reply-To: <20220630162515.37302-1-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 1 Jul 2022 09:45:51 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX135BkyDnedizD-9u1htwjbOa2=ko1Vm+mk0Jh3R+KPw@mail.gmail.com>
Message-ID: <CAMuHMdX135BkyDnedizD-9u1htwjbOa2=ko1Vm+mk0Jh3R+KPw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] dt-bindings: net: dsa: renesas,rzn1-a5psw:
 add interrupts description
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
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

On Thu, Jun 30, 2022 at 6:26 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
> are connected to the GIC.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
> Changes in V2:
>  - Fix typo in interrupt-names property.

Thanks for the update!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
but some suggestions below.

> --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -26,6 +26,22 @@ properties:
>    reg:
>      maxItems: 1
>
> +  interrupts:
> +    items:
> +      - description: DLR interrupt

Device Level Ring (DLR) interrupt?

> +      - description: Switch interrupt
> +      - description: PRP interrupt

Parallel Redundancy Protocol (PRP) interrupt?

> +      - description: Integrated HUB module interrupt
> +      - description: RX Pattern interrupt

Receive Pattern Match interrupt?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
