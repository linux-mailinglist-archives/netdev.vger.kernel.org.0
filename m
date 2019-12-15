Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE211F83A
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 15:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfLOO5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 09:57:30 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53883 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfLOO53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 09:57:29 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1igVKh-0000Uj-Jm; Sun, 15 Dec 2019 15:57:19 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1igVKc-0006G3-En; Sun, 15 Dec 2019 15:57:14 +0100
Date:   Sun, 15 Dec 2019 15:57:14 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jay Cliburn <jcliburn@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        James Hogan <jhogan@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v4 2/5] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191215145714.i22b5ndusnxo2rxy@pengutronix.de>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-3-o.rempel@pengutronix.de>
 <20191023003543.GE5707@lunn.ch>
 <20191029073419.gjr4y7qsxx2javuf@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vwadkjf67645dxog"
Content-Disposition: inline
In-Reply-To: <20191029073419.gjr4y7qsxx2javuf@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:48:57 up 30 days,  6:07, 38 users,  load average: 0.33, 0.14,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vwadkjf67645dxog
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, Oct 29, 2019 at 08:34:19AM +0100, Oleksij Rempel wrote:
> On Wed, Oct 23, 2019 at 02:35:43AM +0200, Andrew Lunn wrote:
> > On Tue, Oct 22, 2019 at 07:57:40AM +0200, Oleksij Rempel wrote:
> > > Atheros AR9331 has built-in 5 port switch. The switch can be configur=
ed
> > > to use all 5 or 4 ports. One of built-in PHYs can be used by first bu=
ilt-in
> > > ethernet controller or to be used directly by the switch over second =
ethernet
> > > controller.
> > >=20
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >=20
> > Hi Oleksij
> >=20
> > What we never really discussed is how this MUXing of the PHY works.
> >=20
> > What i'm worried about is that when we do understand how it works, we
> > cannot properly support it using this binding.
>=20
> good point. i would prefer to make it properly.
>=20
> > Please could you try to find information about this.
>=20
> Documentation says:
> The PHY interfaces (PHY0, PHY1, PHY2, PHY3 and PHY4) can connect to the s=
witch
> in bridge mode. In this case GE0 must be under reset. All five LAN ports =
are
> switched together and connect to the CPU through the GMII interface (MAC0=
),
> which is controlled by the ETH_CFG register bit SW_ONLY_MODE. If GE0 conn=
ects
> separately to PHY, then MAC5 should be under reset.
>=20
> There is no SW_ONLY_MODE bit in the documentation.
> I found:
> CFG_SW_PHY_SWAP - Used to switch the wires connection of PHY port 0 with =
that of
> port 4 in the Ethernet switch. MAC1 and PHY4 are paired while MAC5 and PH=
Y0 are
> paired.
>=20
> CFG_SW_PHY_ADDR_SWAP - Exchanges the address of PHY port 0 with that of
> PHY port 4 in the Ethernet switch.
>=20
> It feels like this are the right bits. I'll try to test it after ELC-E
> conference (If you are here, please ping me).
> If this are the right bits, should it be registered as separate driver? T=
his
> register is on MMIO and not part of the switches MDIO.

I spend some tine on investigating and testing it. So, the result is
pretty simple. It looks like *MII lines of ethernet controller GMAC0 and
MAC of switch port5 are just connected together and wired to the PHY4.
Something like this:

GMAC1-->switch--mac5-+--->phy4
                     ^
GMAC0---------------/


So, both of MACs can be enabled at same time and introduce resource
conflict. If one is enabled, other one should be set in to reset mode.

The questions are:
- how this can be reflected in devicetree?
- how this can be properly implemented in kernel?

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--vwadkjf67645dxog
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl32SckACgkQ4omh9DUa
UbMMXxAAhKsfNjbqFhnopjET9rCssWXRZZu4+sBhH74iw2dRZwe0HgCBy332bqn3
Gf3MYilGiaGPdBjVMNz2i3PLCW0VsrseiOOWGPf1kekqmMjZvb5JJ9YSDBENqypy
lWDH0lDIzr+k8m3AOJQCyEY0IEJauESpjqPsPCwMsZhTJY9mltCEeX9LfhGdtXz7
WLb6QO37AwLD96ZRfHBiGDv4zhl4qaZPQWqCJ6wuxA4GvXCABpSjXj9ytw1+IXPr
qFg7KwS/sZJv7dfAcEu5iB84g4TWbUu18fSpcvvuvmyozKtu9IVeij3OTrrKY1R/
9WTod40W+vtTOwwH0b48UmGqIdo6cT9zHpWoRnKO/x0sz/lGvLik+/Y8vKVIDPOH
YHEY8uYjQ3Vuq+hzNCKGzh6ilSaBs4zvpRU4jAFiiMvMWAHtFSfFdF8rN+Z+E4vy
AFSSlpDZ7TjhwvD6A1nBe1/kPvgy9LSfPPxNxP1TKxS6fc3LGdzy9OiVxj6XnwXv
VEmnycqyFSUBCLKnM6G/odDqWQjUishLiAJ6WheSn6vDJI2OOC1wz3FxutIqKjAw
1PD0D1Xw+sVUpdC3nr+gyXz8O9ud43hR6LpZCtOt4PQk3xO0Pkt0Gegq7deLkYY0
Sf69fxGWjWCeccZdzdPDjPs3R9lB+cn6PmpKNZpe7vvm8t/J1hQ=
=+uQu
-----END PGP SIGNATURE-----

--vwadkjf67645dxog--
