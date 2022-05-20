Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A20152E5E8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbiETHJm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 03:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345889AbiETHJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:09:40 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F47C14D7BA;
        Fri, 20 May 2022 00:09:38 -0700 (PDT)
Received: by mail-qk1-f182.google.com with SMTP id 14so207266qkl.6;
        Fri, 20 May 2022 00:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/gd2QrNW920jKEDeNc6oH0JJgiKsVitkuy57vUL4Nt8=;
        b=zJEYFOCH88VTDjpb6Re2XR51abX5fHhhqQmIIZ2AC5cgWAMfdpGB4XOEyP8JwD0pAU
         f6aLzuWdneinCzdBCbWyqUywNV2gcu6lx5xg+8BqyjWOA8Rwxosh3q8AA/rn6DxMXaDu
         36xU72IkqujUiAS8jhzWcz/geZsmTmoomSOntBXiU4YwfTD4zenx0ge8fbEDyNkbDihm
         4Z584mYYKJPNanuYJR6B9r6g7aJsjLDgxLq2bzVC3tRh9fAXUdMih1J22/ijocC3B2+t
         qJAeP4zEs5hogWUX/tbJfqDj/74q1Va5dS7h1hW+2mRYvV5VRfqDLrew7q+7ANthMhO1
         uxBQ==
X-Gm-Message-State: AOAM531kfI+CChePhytdYb8Fyy2TtSge7iSXzZEXUToZ3egLf3GXZPOx
        zg9WC+dZDinUaVQESzjDubeBoMtgZQSQKQ==
X-Google-Smtp-Source: ABdhPJyquiVofAh1ku48QqyP8uC8wSBQtT7lK5ZBBF7uLh3iVl68HLy98JZsCCY6C+0g1qJqC/ZPYw==
X-Received: by 2002:a37:6247:0:b0:6a3:3620:b07e with SMTP id w68-20020a376247000000b006a33620b07emr3975545qkb.339.1653030576830;
        Fri, 20 May 2022 00:09:36 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id h18-20020ac87152000000b002f39b99f69asm2470384qtp.52.2022.05.20.00.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 00:09:36 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2f83983782fso78286537b3.6;
        Fri, 20 May 2022 00:09:35 -0700 (PDT)
X-Received: by 2002:a81:ad11:0:b0:2fe:fb00:a759 with SMTP id
 l17-20020a81ad11000000b002fefb00a759mr8671091ywh.283.1653030575421; Fri, 20
 May 2022 00:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220519153107.696864-1-clement.leger@bootlin.com> <20220519153107.696864-5-clement.leger@bootlin.com>
In-Reply-To: <20220519153107.696864-5-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 09:09:23 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUdsgoOyFqMq--F3d67QwE4V=CTEedm=uC7grmWZZEHJg@mail.gmail.com>
Message-ID: <CAMuHMdUdsgoOyFqMq--F3d67QwE4V=CTEedm=uC7grmWZZEHJg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 04/13] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
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
        netdev <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>
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
> This MII converter can be found on the RZ/N1 processor family. The MII
> converter ports are declared as subnodes which are then referenced by
> users of the PCS driver such as the switch.
>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
> @@ -0,0 +1,162 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/pcs/renesas,rzn1-miic.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas RZ/N1 MII converter
> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +description: |
> +  This MII converter is present on the Renesas RZ/N1 SoC family. It is
> +  responsible to do MII passthrough or convert it to RMII/RGMII.
> +
> +properties:
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +  compatible:
> +    items:
> +      - enum:
> +          - renesas,r9a06g032-miic
> +      - const: renesas,rzn1-miic
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: MII reference clock
> +      - description: RGMII reference clock
> +      - description: RMII reference clock
> +      - description: AHB clock used for the MII converter register interface

Please add clock-names (and make it required), as there are multiple clocks.

The rest LGTM (from an SoC integration PoV), so
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
