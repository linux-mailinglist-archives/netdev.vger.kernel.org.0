Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99A6184E76
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgCMSQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:16:14 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38113 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgCMSQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:16:12 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCoqp-0007rb-Gk; Fri, 13 Mar 2020 19:16:03 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jCoqn-0002TA-On; Fri, 13 Mar 2020 19:16:01 +0100
Date:   Fri, 13 Mar 2020 19:16:01 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
Message-ID: <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <545d5e46-644a-51fb-0d67-881dfe23e9d8@gmail.com>
 <20200313181056.GA29732@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h5xqpdlw2psmzsqz"
Content-Disposition: inline
In-Reply-To: <20200313181056.GA29732@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:11:37 up 119 days,  9:30, 137 users,  load average: 0.10, 0.06,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h5xqpdlw2psmzsqz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 07:10:56PM +0100, Andrew Lunn wrote:
> > > diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b=
/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > > new file mode 100644
> > > index 000000000000..42be0255512b
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > > @@ -0,0 +1,61 @@
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: NXP TJA11xx PHY
> > > +
> > > +maintainers:
> > > +  - Andrew Lunn <andrew@lunn.ch>
> > > +  - Florian Fainelli <f.fainelli@gmail.com>
> > > +  - Heiner Kallweit <hkallweit1@gmail.com>
> > > +
> > > +description:
> > > +  Bindings for NXP TJA11xx automotive PHYs
> > > +
> > > +allOf:
> > > +  - $ref: ethernet-phy.yaml#
> > > +
> > > +patternProperties:
> > > +  "^ethernet-phy@[0-9a-f]+$":
> > > +    type: object
> > > +    description: |
> > > +      Some packages have multiple PHYs. Secondary PHY should be defi=
nes as
> > > +      subnode of the first (parent) PHY.
> >=20
> >=20
> > There are QSGMII PHYs which have 4 PHYs embedded and AFAICT they are
> > defined as 4 separate Ethernet PHY nodes and this would not be quite a
> > big stretch to represent them that way compared to how they are.
> >=20
> > I would recommend doing the same thing and not bend the MDIO framework
> > to support the registration of "nested" Ethernet PHY nodes.
>=20
> Hi Florian
>=20
> The issue here is the missing PHY ID in the secondary PHY. Because of
> that, the secondary does not probe in the normal way. We need the
> primary to be involved to some degree. It needs to register it. What
> i'm not so clear on is if it just needs to register it, or if these
> sub nodes are actually needed, given the current code.

There are a bit more dependencies:
- PHY0 is responsible for health monitoring. If some thing wrong, it may
  shut down complete chip.
- We have shared reset. It make no sense to probe PHY1 before PHY0 with
  more controlling options will be probed
- It is possible bat dangerous to use PHY1 without PHY0.

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--h5xqpdlw2psmzsqz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5rzd0ACgkQ4omh9DUa
UbNpEw/+LHH8MzgLbJS3H6AZLbBx73nKWAZSeS0xsINrSfeBd5XgyBHIUOVugm0p
wML9tUFMXvgemYhgB1vJkywFsB2gJjw1Yc2RwJI5W1j9agZmOIeAJX0cgbHhTBFP
NX9DitLsN1+AnaTHj/q7OTbf3B/PBnh9qPjNrMjGuyEvN0UZP36dUw7mVe+KjUEo
NkOejzVqDEvGB4Vnq0TjOx4aJla8bpOI95X4NAbGEMb9bTg/+9f/W3RBzVpKk9k4
gi2qX3hAzryMmgVEOsPzjSZD5a4Y8oF5Ioc4PRxzFS8axtF38UMKYn2E3rTpkfBH
xGnk5sQMoRv5wFLY6xkg61qrZEY1GzJWXTMWvo9oyjvRF1EIq90dFRGBCyouDJPu
3lHmWY0WaoLw45E7UFonbEEt3aAaZ1tjhf4QT3cytgJmCTh1hcUmW0nzn9xQRmAQ
eS7W+4Q4dK1mjn98BkUwyxgXYIo1SS4OQhHCpYpnvglTlwTZCbKgjEBE4nvLpTGn
+JlOvqAOZt0uxtnPRM5TJAriNIOYqXPmC+sP5CoVUOSNvYl+HBVZB7OYGOkJg1/N
A9NlW5HOp1iFL2ytNDdE8yPDigjdCuJB+lW6qKtNr7a0YVgVltWpNaKlbpJhSngE
GWwdUPlHkGPSm6IBh3aeWNPV42Lof8KuUgIpffFBjrsAF5J1308=
=l+DD
-----END PGP SIGNATURE-----

--h5xqpdlw2psmzsqz--
