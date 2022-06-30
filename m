Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71756202C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiF3QVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiF3QVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:21:09 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0591631908;
        Thu, 30 Jun 2022 09:21:07 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4B5E51BF20C;
        Thu, 30 Jun 2022 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656606066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDaxbIWGSo+t7JTdTA4oSBuCwOAMzbzayTCjAMcuvJU=;
        b=kJfPfMbDvnsiRLnJPjz7yWSGEv6WOUu+3PvDvXVrKX//ZKg+TMnTo+G714yIlkspCgZt+x
        mdE9GZjhR28nilJjpy2UfuBKlm8vdknCZzyIZZGU+qo+leIIpx3V0dilRpaE4L1T4EppjD
        egQkyyPL+Bt3ra5DSdGvvG6gFn0QEHQr56lJSq9ZgzUEAYSmufEoXu6xFstp8Bl6hoax1t
        9XnvvBKOgXYkfNOrSoFDcBGsD42YiyGqjFZG29+gdK6fTbhXW8yMTig83jjAxwT6OkB/jx
        e6wRYJvqqStlo2pooZc4pqvuBJfwLGYCq3eakENN/NOYN4cjyeEsRFiBVJPrbA==
Date:   Thu, 30 Jun 2022 18:20:15 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: renesas,rzn1-a5psw: add
 interrupts description
Message-ID: <20220630182015.67f61f87@fixe.home>
In-Reply-To: <20220629091305.125291-1-clement.leger@bootlin.com>
References: <20220629091305.125291-1-clement.leger@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 29 Jun 2022 11:13:04 +0200,
Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> a =C3=A9crit :

> Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
> are connected to the GIC.
>=20
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 23 +++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw=
.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> index 103b1ef5af1b..51f274c16ed1 100644
> --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -26,6 +26,22 @@ properties:
>    reg:
>      maxItems: 1
> =20
> +  interrupts:
> +    items:
> +      - description: DLR interrupt
> +      - description: Switch interrupt
> +      - description: PRP interrupt
> +      - description: Integrated HUB module interrupt
> +      - description: RX Pattern interrupt
> +
> +  interrupts-names:
> +    items:
> +      - const: dlr
> +      - const: switch
> +      - const: prp
> +      - const: hub
> +      - const: ptrn
> +
>    power-domains:
>      maxItems: 1
> =20
> @@ -76,6 +92,7 @@ examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
>      #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> =20
>      switch@44050000 {
>          compatible =3D "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
> @@ -83,6 +100,12 @@ examples:
>          clocks =3D <&sysctrl R9A06G032_HCLK_SWITCH>, <&sysctrl R9A06G032=
_CLK_SWITCH>;
>          clock-names =3D "hclk", "clk";
>          power-domains =3D <&sysctrl>;
> +        interrupts =3D <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupts-name =3D "dlr", "switch", "prp", "hub", "ptrn";

Wait, there is actually a typo both here and in the property
description, should be "interrupt-names". Was not catched by
dt_binding_check though but probably due to the fact additionnal
properties are allowed.

> =20
>          dsa,member =3D <0 0>;
> =20


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
