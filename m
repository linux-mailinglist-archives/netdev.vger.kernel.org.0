Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DDD184EFD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgCMSxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:53:33 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56141 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgCMSxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:53:33 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCpR4-0002TT-It; Fri, 13 Mar 2020 19:53:30 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jCpR1-0003M7-7O; Fri, 13 Mar 2020 19:53:27 +0100
Date:   Fri, 13 Mar 2020 19:53:27 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Mark Rutland <mark.rutland@arm.com>,
        Marek Vasut <marex@denx.de>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
Message-ID: <20200313185327.nawcp2imfldyhpqa@pengutronix.de>
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <545d5e46-644a-51fb-0d67-881dfe23e9d8@gmail.com>
 <20200313181056.GA29732@lunn.ch>
 <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
 <15dafdcd-1979-bf35-3968-c80ffc113001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrnswsmuwla7326n"
Content-Disposition: inline
In-Reply-To: <15dafdcd-1979-bf35-3968-c80ffc113001@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:46:17 up 119 days, 10:04, 137 users,  load average: 0.20, 0.09,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrnswsmuwla7326n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 11:20:35AM -0700, Florian Fainelli wrote:
>=20
>=20
> On 3/13/2020 11:16 AM, Oleksij Rempel wrote:
> > On Fri, Mar 13, 2020 at 07:10:56PM +0100, Andrew Lunn wrote:
> >>>> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml =
b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> >>>> new file mode 100644
> >>>> index 000000000000..42be0255512b
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> >>>> @@ -0,0 +1,61 @@
> >>>> +# SPDX-License-Identifier: GPL-2.0+
> >>>> +%YAML 1.2
> >>>> +---
> >>>> +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> >>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >>>> +
> >>>> +title: NXP TJA11xx PHY
> >>>> +
> >>>> +maintainers:
> >>>> +  - Andrew Lunn <andrew@lunn.ch>
> >>>> +  - Florian Fainelli <f.fainelli@gmail.com>
> >>>> +  - Heiner Kallweit <hkallweit1@gmail.com>
> >>>> +
> >>>> +description:
> >>>> +  Bindings for NXP TJA11xx automotive PHYs
> >>>> +
> >>>> +allOf:
> >>>> +  - $ref: ethernet-phy.yaml#
> >>>> +
> >>>> +patternProperties:
> >>>> +  "^ethernet-phy@[0-9a-f]+$":
> >>>> +    type: object
> >>>> +    description: |
> >>>> +      Some packages have multiple PHYs. Secondary PHY should be def=
ines as
> >>>> +      subnode of the first (parent) PHY.
> >>>
> >>>
> >>> There are QSGMII PHYs which have 4 PHYs embedded and AFAICT they are
> >>> defined as 4 separate Ethernet PHY nodes and this would not be quite a
> >>> big stretch to represent them that way compared to how they are.
> >>>
> >>> I would recommend doing the same thing and not bend the MDIO framework
> >>> to support the registration of "nested" Ethernet PHY nodes.
> >>
> >> Hi Florian
> >>
> >> The issue here is the missing PHY ID in the secondary PHY. Because of
> >> that, the secondary does not probe in the normal way. We need the
> >> primary to be involved to some degree. It needs to register it. What
> >> i'm not so clear on is if it just needs to register it, or if these
> >> sub nodes are actually needed, given the current code.
> >=20
> > There are a bit more dependencies:
> > - PHY0 is responsible for health monitoring. If some thing wrong, it may
> >   shut down complete chip.
> > - We have shared reset. It make no sense to probe PHY1 before PHY0 with
> >   more controlling options will be probed
> > - It is possible bat dangerous to use PHY1 without PHY0.
>=20
> probing is a software problem though. If we want to describe the PHY
> package more correctly, we should be using a container node, something
> like this maybe:
>
> phy-package {
> 	compatible =3D "nxp,tja1102";
>=20
> 	ethernet-phy@4 {
> 		reg =3D <4>;
> 	};
>=20
> 	ethernet-phy@5 {
> 		reg =3D <5>;
> 	};
> };

Yes, this is almost the same as it is currently done:

phy-package {
	reg =3D <4>;
=20
 	ethernet-phy@5 {
 		reg =3D <5>;
 	};
};

Because the primary PHY0 can be autodetected by the bus scan.
But I have nothing against your suggestions. Please, some one should say the
last word here, how exactly it should be implemented?

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--yrnswsmuwla7326n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5r1qMACgkQ4omh9DUa
UbOGdRAAmDhBqloB1t+KikfgqS6pVFUKUz5Jizm+mm7mEVGA/O7i42ZyW68QDm6m
ZUqN7a8ZHqnqKH0Qs94ZroMwmcVyfYOnX3Wpryh71s3maHvyow/c03t2cJByiFal
OvvE0eE9fOBH3ZZEmqUEA4yAlr62Q1zsJH9SgY5ZKn+4rJfIvHboKokynKejvQkX
1QrZa9bMqVu6odPjpwkTO6aCesUN2ThtltoEC4jOxAbMm/Su9jIY5jnw+Cs88m2t
G1QQAvneSlRzBd2WBpydUa5rvCvDW4vMmzB5ZGcTJYxVQCfrdDA73n1GTWkqLf0F
NDwgazuU7zEd7ed+f3A6CwyocyJjbF1Dty24saK4Z7BZfbVUxKZDD0W6ALvDV3Yu
tcpIq9u4eAYNJJCKF+MnDlkfMkHDOKcGLpgHHs3drB8qUlYLlKq41ltpkO5LuMCj
T8et0XQ/FTnXS/hho9X6c7YFzmZTwNhkbvrJvy9YyU9L942YX7kpqeytSNvLGJTI
P8pzutpMR9E/2qPgYx57ujRWjxrwFVze13LDKCStMXwfXfpTfJDFQE3zvuy1t+MK
qZ1bmJ0K2x7nEVHGzrmiIdemsLDYBPc2WW4s3P8+5hqgU9FpNnv9f9DXFPP3/fGk
zIaZN08rxT+Cpu2LguR695vYAEJEVoQMXqKj+6GxUxk1Oed4zko=
=Cgfa
-----END PGP SIGNATURE-----

--yrnswsmuwla7326n--
