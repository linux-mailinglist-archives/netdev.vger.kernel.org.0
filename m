Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFE355E9AA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiF1QaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345817AbiF1Q27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:28:59 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F8639B88;
        Tue, 28 Jun 2022 09:19:39 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 71344C0006;
        Tue, 28 Jun 2022 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656433178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Fr78hu1IzNkGovgp2ZyKWev5AVil0eVFYUNZCvLcQo=;
        b=fCpk88xbvNBWFuPmASyduxc/42gf75Kb6dAIspiVcyyVpy977pyhaznBFNFwEhxYCsaLOo
        lQzTL5/OOF9P88UP8itE44u4yNTb21E1erTUjc+trJQ27D2u8l/SMXaSDkh0vO2+Q6X2cG
        aVzD0i5xhwN0sWx4jzTt7uUx3sXi3j/0LBcrl2e7I716/6nfGm3PTdPQCdumKA1Hv8jho6
        ohQbKptnGjinSeiTxR30j0X6ka2eu16f4xdsFJKn/lJC4mGxua0cJBXEDVrExCAJNrZNwc
        cUFTbPUFzKp9ueOO8fvFlkIH3fZ4fDrX+os9be0BtkYpZ6u2kBEK2pVyu1Z9yw==
Date:   Tue, 28 Jun 2022 18:18:46 +0200
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
        netdev <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next v9 06/16] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220628181846.05cf88b6@fixe.home>
In-Reply-To: <CAMuHMdU9fpY5b9GGFYQ50KmFNu35J5d129F=9=LYZEN82R=cfw@mail.gmail.com>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
        <20220624144001.95518-7-clement.leger@bootlin.com>
        <CAMuHMdU9fpY5b9GGFYQ50KmFNu35J5d129F=9=LYZEN82R=cfw@mail.gmail.com>
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

Le Tue, 28 Jun 2022 17:37:57 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> > +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> > @@ -0,0 +1,134 @@
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
> > +  handles 4 ports + 1 CPU management port. =20
>=20
> While diving deeper into the RZ/N1 documentation, I noticed the switch
> has 4 interrupts, which are currently not described in the bindings.
> Presumably the driver has no need to use them, but as DT describes
> hardware, I think it would be good to submit follow-up patches for
> bindings and DTS to add the interrupts.

Noted ;)

Cl=C3=A9ment

>=20
> Thanks!
>=20
> Gr{oetje,eeting}s,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
