Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418B652E6BA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346728AbiETH6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbiETH6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:58:47 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFB714CDC7;
        Fri, 20 May 2022 00:58:44 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 539C16000D;
        Fri, 20 May 2022 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653033523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmGaXG6vGzUCTmc3IUGjVh5xf9GDtvuGXKgKOkXHkDg=;
        b=FCXHREZ1qt+UdZYwm20wexqRvwxbDqkkHAKfHFOA3VGw4YAyYfARjkff3ES9CaI7GIKYMQ
        m2vAYWqzYrk78/jCKZgcarpYAOHKcwxQjjPfsX9Ck7M+f6agVTNIa1TDrQQRQ/UQafHIqV
        +7UqI8G9t+7sb3NTo7+rSFBhV4T964t1J54uqCAQO8zod+VWHVeJu4Q1pURLcGg4Sj2wpL
        US/Cz2g2coP+0mGvpNLYQHuflJuF8xMi2tDGwRl/6GEGvJgGD72ccpA36fQTjfRoAtNxQ3
        UXzClgUeebv7zaDPgbotVtR0hksllHZ+7SIqiw6KIseZwQiS+0OXfnA7VaIlAA==
Date:   Fri, 20 May 2022 09:57:30 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5 06/13] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220520095730.512bbb8d@fixe.home>
In-Reply-To: <CAMuHMdXRCggkTSxfnSHvz3N2Oekuw7y5Sy2AKkqZpZzK_Eg_ng@mail.gmail.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-7-clement.leger@bootlin.com>
        <CAMuHMdXRCggkTSxfnSHvz3N2Oekuw7y5Sy2AKkqZpZzK_Eg_ng@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 20 May 2022 09:13:23 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Thu, May 19, 2022 at 5:32 PM Cl=C3=A9ment L=C3=A9ger <clement.leger@bo=
otlin.com> wrote:
> > Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> > present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> > This company does not exists anymore and has been bought by Synopsys.
> > Since this IP can't be find anymore in the Synospsy portfolio, lets use
> > Renesas as the vendor compatible for this IP.
> >
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> =20
>=20
> Thanks for your patch!
>=20
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> > @@ -0,0 +1,131 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Renesas RZ/N1 Advanced 5 ports ethernet switch
> > +
> > +maintainers:
> > +  - Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > +
> > +description: |
> > +  The advanced 5 ports switch is present on the Renesas RZ/N1 SoC fami=
ly and
> > +  handles 4 ports + 1 CPU management port.
> > +
> > +allOf:
> > +  - $ref: dsa.yaml#
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - renesas,r9a06g032-a5psw
> > +      - const: renesas,rzn1-a5psw
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  mdio:
> > +    $ref: /schemas/net/mdio.yaml#
> > +    unevaluatedProperties: false
> > +
> > +  clocks:
> > +    items:
> > +      - description: AHB clock used for the switch register interface
> > +      - description: Switch system clock
> > +
> > +  clock-names:
> > +    items:
> > +      - const: hclk
> > +      - const: clk =20
>=20
> (Good, "clock-names" is present ;-)
>=20
> Missing "power-domains" property.
>=20

I do not use pm_runtime* in the switch driver. I should probably do that
right ?

> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> > +
> > +    switch@44050000 {
> > +        compatible =3D "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
> > +        reg =3D <0x44050000 0x10000>;
> > +        clocks =3D <&sysctrl R9A06G032_HCLK_SWITCH>, <&sysctrl R9A06G0=
32_CLK_SWITCH>;
> > +        clock-names =3D "hclk", "clk";
> > +        pinctrl-names =3D "default";
> > +        pinctrl-0 =3D <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>; =20
>=20
> Usually we don't list pinctrl-* properties in examples.
>=20

Acked, I'll remove that.

> The rest LGTM (from an SoC integration PoV), so with the above fixed
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
