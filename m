Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20263B415C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 12:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhFYKUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:20:51 -0400
Received: from phobos.denx.de ([85.214.62.61]:41910 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhFYKUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 06:20:51 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D160D82BED;
        Fri, 25 Jun 2021 12:18:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624616309;
        bh=IzUjC8qtz0wz/5DU4735vakKqG89fReInmoUKyyPtt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jykOLrjt4ZP857/BG5+9ZyQfu2yVaz9nAlUsaXEUSZHxnP8EcSTRQKsnVbZ9E1trt
         1h/ky/7I9b7Az04GnthhJwFJf5pM9Uqai1wwBZ/gNNRy3ApT88QKc2cFWOFZGxTqEf
         bfDEB5SIygBmHmD5DueWOmhvw5gp2KIIfQQnP0EetxTmdU1p7F7g3QMq+VApwOjtM3
         YcIIxfPs7cumvG97MftnC8plfclrjHAYItFGD14L6NMLQFsf7PV8bOJ0hj5W3PcJPB
         MvoUsbTlXFn4Ue5Oo2Sdf+ceNUAJMoTx6mb2U/lzzq+zGHfWHJsMQe6oNtRVC+rAIC
         poCQ8ESRAj/fA==
Date:   Fri, 25 Jun 2021 12:18:17 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <20210625121817.77643fe0@ktm>
In-Reply-To: <DB8PR04MB6795CDCD1DC16B3F55F97753E6069@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-2-lukma@denx.de>
        <YNH3mb9fyBjLf0fj@lunn.ch>
        <20210622225134.4811b88f@ktm>
        <YNM0Wz1wb4dnCg5/@lunn.ch>
        <20210623172631.0b547fcd@ktm>
        <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
        <DB8PR04MB679567B66A45FBD1C23E7371E6079@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <20210624132129.1ade0614@ktm>
        <DB8PR04MB6795CDCD1DC16B3F55F97753E6069@DB8PR04MB6795.eurprd04.prod.outlook.com>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/2mc=ShYF09lsy_uW76bivdq"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2mc=ShYF09lsy_uW76bivdq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Joakim, Andrew,

> Hi Lukasz,
>=20
> > -----Original Message-----
> > From: Lukasz Majewski <lukma@denx.de>
> > Sent: 2021=E5=B9=B46=E6=9C=8824=E6=97=A5 19:21
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; Florian Fainelli
> > <f.fainelli@gmail.com>; Andrew Lunn <andrew@lunn.ch>
> > Cc: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > <kuba@kernel.org>; Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> > Nicolas Ferre <nicolas.ferre@microchip.com>; Vladimir Oltean
> > <olteanv@gmail.com>; netdev@vger.kernel.org; Arnd Bergmann
> > <arnd@arndb.de>; Mark Einon <mark.einon@gmail.com>; dl-linux-imx
> > <linux-imx@nxp.com>; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2
> > switch on XEA board
> >=20
> > Hi Joakim,
> >  =20
> > > Hi Lukasz, Florian, Andrew,
> > > =20
> > > > > Maybe somebody from NXP can provide input to this discussion
> > > > > - for example to sched some light on FEC driver (near)
> > > > > future. =20
> > > >
> > > > Seems like some folks at NXP are focusing on the STMMAC
> > > > controller these days (dwmac from Synopsys), so maybe they have
> > > > given up on having their own Ethernet MAC for lower end
> > > > products. =20
> > >
> > > I am very happy to take participate into this topic, but now I
> > > have no experience to DSA and i.MX28 MAC, so I may need some time
> > > to increase these knowledge, limited insight could be put to now.
> > > =20
> >=20
> > Ok. No problem :-)
> >  =20
> > >
> > > Florian, Andrew could comment more and I also can learn from it
> > > :-), they are all very experienced expert. =20
> >=20
> > The main purpose of several RFCs for the L2 switch drivers (for DSA
> > [1] and switchdev [2]) was to gain feedback from community as soon
> > as possible (despite that the driver lacks some features - like
> > VLAN, FDB, etc).=20
> > >
> > > We also want to maintain FEC driver since many SoCs implemented
> > > this IP, and as I know we would also use it for future SoCs.
> > > =20
> >=20
> > Florian, Andrew, please correct me if I'm wrong, but my impression
> > is that upstreaming the support for L2 switch on iMX depends on FEC
> > driver being rewritten to support switchdev?
> >=20
> > If yes, then unfortunately, I don't have time and resources to
> > perform that task
> > - that is why I have asked if NXP has any plans to update the FEC
> > (fec_main.c) driver.
> >=20
> >=20
> > Joakim, do you have any plans to re-factor the legacy FEC driver
> > (fec_main.c) and introduce new one, which would support the
> > switchdev?
> >=20
> > If NXP is not planning to update the driver, then maybe it would be
> > worth to consider adding driver from [2] to mainline? Then I could
> > finish it and provide all required features. =20
>=20
> I don't have such plan now, and have no confidence to re-factor the
> legacy FEC driver and introduce new one, which to support switchdev
> in a short time.=20

Thanks for the clear statement, appreciated.

> I am not very experienced for FEC driver, since I
> have just maintained it for half a year.=20

Ok. No problem.

> To be honest, I have no idea
> in my head right now, we even don't have i.MX28 boards.

As fair as I remember there is still imx28-dev board available for
purchase. You can also use vf610 based board.

> I'm so sorry
> about this, but I am also interested in it, I am finding time to
> increase related knowledge.

Ok.

To sum up:

- The FEC driver (legacy one) will not be rewritten anytime soon
  (maybe any other community member will work on this sooner...)

- Considering the above, support for L2 switch on imx28, vf610 is
  blocked [*]. As a result some essential functionality for still
  actively used SoCs is going to be maintained out of tree (for example
  [1][2]).=20

[*] - as I've stated in the other mail - what's about the situation
where FEC legacy driver is not going to be excessively modified (just
changes from this patch set)?

Links:

[1] -
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-switchdev-RFC_v1

[2] -
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-DSA-RFC_v1

>=20
> Best Regards,
> Joakim Zhang
> >=20
> > Links:
> > [1] -
> > https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12=
-L2-u
> > pstream-DSA-RFC_v1
> > [2] -
> > https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12=
-L2-u
> > pstream-switchdev-RFC_v1
> >  =20
> > > Best Regards,
> > > Joakim Zhang =20
> >=20
> >=20
> >=20
> >=20
> > Best regards,
> >=20
> > Lukasz Majewski
> >=20
> > --
> >=20
> > DENX Software Engineering GmbH,      Managing Director: Wolfgang
> > Denk HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell,
> > Germany Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email:
> > lukma@denx.de =20


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/2mc=ShYF09lsy_uW76bivdq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDVrWkACgkQAR8vZIA0
zr08+QgA52HulydPpTba/n5izK1UKGy7ReuvNvsu7nuykMp9QYcNY+SzRL7rPmx9
TPQKsNm/YTR5zrr1ziOglojDRjztl+H4MUUyYGbXkcImylYJA0iYf2xqN5ciMjtQ
d1TqRKxmEhSyLfi1grqRLDiNDDhVbLD51F47Kad95cg0aBvioCBNunOcwsI4hywC
vrNL2iEcGbQTsLtLGhdnY+z6geMDXOhKfVH95ZWvr6fX41E6hqeYtZ1AQk6eG0CR
FFUFVhJLq8ToqX6nqV96lfL4QqPZ4aaWBPq564DX3YVv/vTSg8VMGw87ih69FfC+
y08gO5b/dQ3zeg0qM+4qh2GjM2yYhw==
=Zk3/
-----END PGP SIGNATURE-----

--Sig_/2mc=ShYF09lsy_uW76bivdq--
