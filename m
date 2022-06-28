Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187F755E9AE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiF1QaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348450AbiF1Q3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:29:49 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F98437AA6;
        Tue, 28 Jun 2022 09:21:31 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 34A75240008;
        Tue, 28 Jun 2022 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656433289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJILk4EbIrX/QUizwFSo8cJFE+xAQSS0MordXAV+VUA=;
        b=RegWRrp+noheAHBZXzovc0UsFzQzpECYNGWN9YZXsGr4tuOSThWGNyxmQHOzG5JqtlrgFL
        mkIzI8vqBaNJVHGwiyAMKtsEvU0hv1WaXhn8NvWx0BqQW4iBNZqGINpFpQXMS8YaZhwsW/
        9WI1LW2qwTtrVtXIuCCQ1Mcgno5pm4EaSoTrpPlgVE7hRaiCGYjlniFD3VP4qXJf3BNwdT
        nFzYfM63bGCMrOYdfgoiuheBUiTAlqJk6iAEV7B56lSMHwaWJbSoxVKTtR7uiax9Jm55kL
        5zjISZA508JOO4ug1gC4Sjkedv549jX5rj+dkvE2B2/D6erJ0SiuRdOG9VxkOA==
Date:   Tue, 28 Jun 2022 18:20:37 +0200
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
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
Subject: Re: [PATCH net-next v9 15/16] ARM: dts: r9a06g032-rzn1d400-db: add
 switch description
Message-ID: <20220628182037.55b21637@fixe.home>
In-Reply-To: <CAMuHMdXwe0YmZr+BjArnWWALAsC28_Q+zy3F0cHMZDxOxdnCLg@mail.gmail.com>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
        <20220624144001.95518-16-clement.leger@bootlin.com>
        <CAMuHMdXwe0YmZr+BjArnWWALAsC28_Q+zy3F0cHMZDxOxdnCLg@mail.gmail.com>
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

Le Tue, 28 Jun 2022 17:34:31 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> > +&gmac2 { =20
>=20
> Please keep the nodes sorted (everywhere).

Arg sorry, again, the previous nodes seems not to be ordered.
I'll be more careful next time.

>=20
> > +&pinctrl{
> > +       pins_mdio1: pins_mdio1 {
> > +               pinmux =3D <
> > +                       RZN1_PINMUX(152, RZN1_FUNC_MDIO1_SWITCH)
> > +                       RZN1_PINMUX(153, RZN1_FUNC_MDIO1_SWITCH)
> > +               >; =20
>=20
> This is not a single value, but an array of 2 values.  Hence they
> should be grouped using angular brackets, to enable automatic
> validation.

Good to know, noted for next time.

>=20
> I will fix the above while applying, so no need to resend.

Thanks Geert,

Cl=C3=A9ment

>=20
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> i.e. will queue in renesas-devel for v5.20.
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
