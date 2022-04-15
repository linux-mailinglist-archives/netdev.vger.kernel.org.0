Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E361502DF7
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355971AbiDOQtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355970AbiDOQtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:49:40 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DD2DD966;
        Fri, 15 Apr 2022 09:47:11 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E9570C0006;
        Fri, 15 Apr 2022 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650041229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqx76FGCWY9T5n5gaf7tqiaERTtvIFYRxivjOi7DJAY=;
        b=VQQ8Xiqp2cyrNI9GijO8dGgMuIEA9uZZMevCeq4Kk4x41bLZRA4yZrXc5DNgKVzCtFfSEf
        V9pEhQLWxgPvK9g47UAZ4O8MOwn29FgqNbhuF5GyiM3ZyXRCq0HWRWBdIiVqq18+Q5i8BY
        lLxadXlbVEES0uc4EVOh5cJh/d7L9hRAO+NOtk6eVoYz1VAyboG1o0hyo0PrgLwUXR0iaZ
        FSeWqsFaz1rBbC7L1I0V6d9MzrrWLEqOwz//c/Epv0LQYy5Z9idsu1KU6YPb+Qd7/XqPoR
        L/ihZTkUgUcRS8DvD3BSzcNp5ApDefEBGWY9w/US9S1fe8ez5tEKPQXu8GK84A==
Date:   Fri, 15 Apr 2022 18:45:41 +0200
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
Message-ID: <20220415184541.0a6928f5@fixe.home>
In-Reply-To: <YlmbIjoIZ8Xb4Kh/@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-10-clement.leger@bootlin.com>
        <YlismVi8y3Vf6PZ0@lunn.ch>
        <20220415102453.1b5b3f77@fixe.home>
        <Yll+Tpnwo5410B9H@lunn.ch>
        <20220415163853.683c0b6d@fixe.home>
        <YlmLWv4Hsm2uk8pa@lunn.ch>
        <20220415172954.64e53086@fixe.home>
        <YlmbIjoIZ8Xb4Kh/@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
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

Le Fri, 15 Apr 2022 18:19:46 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> > I think it would be good to modify it like this:
> >=20
> > eth-miic@44030000 {
> >     ...
> >   converters {
> >     mii_conv0: mii-conv@0 {
> >       // Even if useless, maybe keeping it for the sake of coherency
> >       renesas,miic-input =3D <MIIC_GMAC1>;
> >       reg =3D <0>;
> >     }; =20
>=20
> This is not a 'bus', so using reg, and @0, etc is i think wrong.  You
> just have a collection of properties.

Agreed, but this is the same thing that is done for DSA ports (at least
I think). It uses reg which describe the port number, this is not a
real bus per se, it only refer to port indices.

But if you think this should not be done like this, what do you propose
then ? These nodes are also reference from "pcs-handle" properties in
switch to retrieve the PCS. Would you suggest using something like
pcs-handle =3D <&eth_miic port_index> and remove the nodes then ?

Thanks,


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
