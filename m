Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E9F51195B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiD0NAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiD0NAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:00:54 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C3A4BFEF;
        Wed, 27 Apr 2022 05:57:41 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CB96AE0008;
        Wed, 27 Apr 2022 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651064259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qc5/U3N1o7dvPqfVXlG1fPptC5KuXavUKRblgiRmNqU=;
        b=TZkkQkztssaeZibsd9DvPtSIw63vA5l50nicSNeYGhgvWumLdbG0K9pUUH+HCdh1HKxkpt
        /YSlUELOllBLwoi5EQbAyNSzrAcSAd/ceiBZlbxt0bhvdLEsEOkFeAJBFFuzajIItSUT1R
        s4xs0y/A0T6YStQfCQF7sHLD0mAnSQuPjlIVvwtQS1AUlAvVldtrA33+IRp5BpJUP9rl52
        Ud+Wq8NKo4eWWKylPamqMUkHNNuZt4nO0tD+Hi82amiyCCG7b2lyAch8MKrmglSUqpOHqp
        msNl2pufqL8qVtnyXwJ/NKQWXbWDKE8fPGPNjlDRv2fbFEGxCndPG0Xx6Qo+bw==
Date:   Wed, 27 Apr 2022 14:56:17 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 05/12] dt-bindings: net: dsa: add bindings for
 Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220427145617.0b36e9dc@fixe.home>
In-Reply-To: <CAMuHMdU+kosUPavthyPcWVAC_WhdwXiFKt61oSmgdV6Qxk_0xg@mail.gmail.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-6-clement.leger@bootlin.com>
        <CAMuHMdU+kosUPavthyPcWVAC_WhdwXiFKt61oSmgdV6Qxk_0xg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 27 Apr 2022 14:20:33 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> > @@ -0,0 +1,128 @@
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
> > +    const: renesas,rzn1-a5psw =20
>=20
> Please document an SoC-specific compatible value
> "renesas,r9a06g032-a5psw", too, so we can easily handle differences
> between members within the RZ/N1 family, if ever needed.

Hi Geert,

Thanks, I already did that for the V2 after your first comment on the
MII converter bindings ! I'll sent a V2 soon.

Cl=C3=A9ment

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
