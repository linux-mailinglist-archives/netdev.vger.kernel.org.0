Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5291B5638AE
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiGARnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGARnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:43:14 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [217.70.178.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72D67668;
        Fri,  1 Jul 2022 10:43:11 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 521A920000C;
        Fri,  1 Jul 2022 17:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656697389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUzbSLv005MP/UCEKqCh9zUm8p9RbPlzIlf45EILH34=;
        b=XPtbBtckHQh+3uhjLNu9N2a9U3Q671XIyCVIAUchgK2J4r7etnXj7247sMNCVpW568vwBl
        BU9rovku4U3m5RaOg++hLum+Lks+9/DDcE0dREtYfXXA/yxdv7EbS3b36f/7MXtKr+tYB2
        rNPcdsm7+JfmspigWKJ71W6AAUxBsbWEzu3zT9IYpkKVW79ZrrmeYr4eETY5z8+5cnc4Ku
        O9mvZYOpjUSBOq6mst7m18qMuSQ8BARWHKPG9nyXNS7k3D4svfLqmOsg3ARkhmCj609FD3
        4fnga6mHzUnw+27mFNT7TDk6WLIZgjSTnT4M9Pg5GK2+yCca7qKph2wcpKhHiA==
Date:   Fri, 1 Jul 2022 19:42:18 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next v2] dt-bindings: net: dsa: renesas,rzn1-a5psw:
 add interrupts description
Message-ID: <20220701194218.71003918@fixe.home>
In-Reply-To: <CAMuHMdX135BkyDnedizD-9u1htwjbOa2=ko1Vm+mk0Jh3R+KPw@mail.gmail.com>
References: <20220630162515.37302-1-clement.leger@bootlin.com>
        <CAMuHMdX135BkyDnedizD-9u1htwjbOa2=ko1Vm+mk0Jh3R+KPw@mail.gmail.com>
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

Le Fri, 1 Jul 2022 09:45:51 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Thu, Jun 30, 2022 at 6:26 PM Cl=C3=A9ment L=C3=A9ger <clement.leger@bo=
otlin.com> wrote:
> > Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
> > are connected to the GIC.
> >
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> > Changes in V2:
> >  - Fix typo in interrupt-names property. =20
>=20
> Thanks for the update!
>=20
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> but some suggestions below.
>=20
> > --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> > @@ -26,6 +26,22 @@ properties:
> >    reg:
> >      maxItems: 1
> >
> > +  interrupts:
> > +    items:
> > +      - description: DLR interrupt =20
>=20
> Device Level Ring (DLR) interrupt?
>=20
> > +      - description: Switch interrupt
> > +      - description: PRP interrupt =20
>=20
> Parallel Redundancy Protocol (PRP) interrupt?
>=20
> > +      - description: Integrated HUB module interrupt
> > +      - description: RX Pattern interrupt =20
>=20
> Receive Pattern Match interrupt?

Hi Geert,

I'll modify that and send a V3, thanks for your comments !

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
