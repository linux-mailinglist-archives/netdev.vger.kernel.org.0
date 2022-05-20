Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BBC52E720
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346906AbiETIRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238394AbiETIRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:17:50 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6B113C1E1;
        Fri, 20 May 2022 01:17:48 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DDD3740006;
        Fri, 20 May 2022 08:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653034667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vrvuviG9eObZm4oJ0eZXyDKSUu8WHnWWXiVDYqfXkw=;
        b=cmstLgwJG/Vvl4BYUuqpqnKKzwfV3YwcplbHEiirKBbSQyMOy75oPMcMQYJbo4tDHVqWqu
        jJsZj4MEO8fmoLOQ3fbAV8+7ExCSvvzXNGSgS3KPEW5yFvSB9TpqT91ej/v5PEoReTDocx
        3/5CD5z1r3oFXR/SFf+BHHOfjW2+WdscMUh+px9vX1rnZfFO96GVrG+r7YGYNuf6ylWyD7
        dbkz6yyW6j8l+B7l8mUVu/IICYsDfb8DW4xh2T18OygrPcppYenTOkitgzPpEd8KhICMwP
        xhMQeTWdnn+QL5dF4jSbiMsCmOM16K8V/kgNomfl78HkqHf0Y84eF1svC9527g==
Date:   Fri, 20 May 2022 10:16:34 +0200
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
Message-ID: <20220520101634.201bdf92@fixe.home>
In-Reply-To: <CAMuHMdWOMYE7b=auNeVAMDgArso+8vUzkxAwnFxFYtKPxOnjxw@mail.gmail.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-7-clement.leger@bootlin.com>
        <CAMuHMdXRCggkTSxfnSHvz3N2Oekuw7y5Sy2AKkqZpZzK_Eg_ng@mail.gmail.com>
        <20220520095730.512bbb8d@fixe.home>
        <CAMuHMdWOMYE7b=auNeVAMDgArso+8vUzkxAwnFxFYtKPxOnjxw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
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

Le Fri, 20 May 2022 10:01:32 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Fri, May 20, 2022 at 9:58 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@bo=
otlin.com> wrote:
> > Le Fri, 20 May 2022 09:13:23 +0200,
> > Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit : =20
> > > On Thu, May 19, 2022 at 5:32 PM Cl=C3=A9ment L=C3=A9ger <clement.lege=
r@bootlin.com> wrote: =20
> > > > Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch =
is
> > > > present on Renesas RZ/N1 SoC and was probably provided by MoreThanI=
P.
> > > > This company does not exists anymore and has been bought by Synopsy=
s.
> > > > Since this IP can't be find anymore in the Synospsy portfolio, lets=
 use
> > > > Renesas as the vendor compatible for this IP.
> > > >
> > > > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.=
yaml =20
>=20
> > > Missing "power-domains" property. =20
> >
> > I do not use pm_runtime* in the switch driver. I should probably do that
> > right ? =20
>=20
> For now you don't have to.  But I think it is a good idea, and it helps i=
f the
> IP block is ever reused in an SoC with real power areas.

Ok, sounds good, I'll probably also set that as required to be
compatible with these potentials modifications without breaking the
bindings.

Thanks,

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
