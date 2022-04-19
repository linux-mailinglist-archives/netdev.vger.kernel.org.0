Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE401506769
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 11:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350283AbiDSJHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350295AbiDSJHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 05:07:36 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD332BD7;
        Tue, 19 Apr 2022 02:04:52 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E1D9E240004;
        Tue, 19 Apr 2022 09:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650359091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P15AbQJC6wP8LbZh3j3wNlnBCOzTtvLQULPM3JHRUlI=;
        b=LH9njdcpi5vlimjDAwr6c6Kf0oFhSQihIOw9dBXIKcXl8rlF4XhOX3GfCzxbNZ8zLUwnvH
        ujfEcWUQNGf3f3kh3znt+WSRQJq7zkD3uw9BeGowlEenheqqtpW8oU9DslBl5n74Vjz/pH
        y4bmqxkpsVJbPlSkPJLwJ+fVoD7EdL/D5biHn7XDDA7RdU4G02Gh7X4cBj/2SjMDkyg5rp
        a8yF33774x7EUcUQy6f10onHXTEKtLR1n9WCgSmPiodRQyl6gm7lwVxUAHEMIwFswJeqCZ
        qxHqKHa+1Hc0xx8jR8vxa3jeIG5yjtXq6LUS/msP7tuq/+KWPug8gNI3cq6z7w==
Date:   Tue, 19 Apr 2022 11:03:28 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <20220419110328.0241fb1f@fixe.home>
In-Reply-To: <YlrJQ47tkmQdhtMu@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-10-clement.leger@bootlin.com>
        <YlismVi8y3Vf6PZ0@lunn.ch>
        <20220415102453.1b5b3f77@fixe.home>
        <Yll+Tpnwo5410B9H@lunn.ch>
        <20220415163853.683c0b6d@fixe.home>
        <YlmLWv4Hsm2uk8pa@lunn.ch>
        <20220415172954.64e53086@fixe.home>
        <YlmbIjoIZ8Xb4Kh/@lunn.ch>
        <20220415184541.0a6928f5@fixe.home>
        <YlrJQ47tkmQdhtMu@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
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

Le Sat, 16 Apr 2022 15:48:51 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> On Fri, Apr 15, 2022 at 06:45:41PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Fri, 15 Apr 2022 18:19:46 +0200,
> > Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :
> >  =20
> > > > I think it would be good to modify it like this:
> > > >=20
> > > > eth-miic@44030000 {
> > > >     ...
> > > >   converters {
> > > >     mii_conv0: mii-conv@0 {
> > > >       // Even if useless, maybe keeping it for the sake of coherency
> > > >       renesas,miic-input =3D <MIIC_GMAC1>;
> > > >       reg =3D <0>;
> > > >     };   =20
> > >=20
> > > This is not a 'bus', so using reg, and @0, etc is i think wrong.  You
> > > just have a collection of properties. =20
> >=20
> > Agreed, but this is the same thing that is done for DSA ports (at least
> > I think). It uses reg which describe the port number, this is not a
> > real bus per se, it only refer to port indices. =20
>=20
> True. That is an old binding, before a lot of good practices were
> enforced. I'm not sure it would be accepted today.
>=20
> I suggest you make a proposal and see what the DT Maintainers say.

Acked.

>=20
> > But if you think this should not be done like this, what do you
> > propose then ? These nodes are also reference from "pcs-handle"
> > properties in switch to retrieve the PCS. =20
>=20
> This i was not thinking about. Make this clear in the binding
> documentation for what you propose.
>=20
> Humm, this last point just gave me an idea. How are you representing
> the PCS in DT? Are they memory mapped? So you have a nodes something
> like:
>=20
> eth-pcs-conv1@44040100 {
> 	compatible =3D "acm-inc,pcs"
> }
>=20
> eth-pcs-conv2@44040200 {
> 	compatible =3D "acm-inc,pcs"
> }

That is a good idea since the converter are indeed (partly) memory
mapped, but the hardware guys decided that it was a good idea to share
some registers. Amongst shared registers, we have the reset for each
converter and the muxing control which as stated before is contained in
a single register.

>=20
> The MAC node than has a pcs-handle pointing to one of these nodes?
>=20
> You implicitly have the information you need to configure the MII
> muxes here. The information is a lot more distributed, but it is
> there. As each MAC probes, it can ask the MII MUX driver to connect
> its MAC to the converter pointed to by its pcs-handle.

Hum, that could be done but since only some values/combinations are
allowed, it would potentially require to validate the setting at each
request, leading to potential non working devices due to invalid MUX
configuration required. I think the fact that we could have everything
in one single node allows to validate it at probe time.

Anyway, I'll make a proposal an we'll see ! Thanks again for your
feedback.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
