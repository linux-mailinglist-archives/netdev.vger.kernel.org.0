Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AA61882A2
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 12:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgCQL4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 07:56:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56329 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgCQL4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 07:56:33 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jEAph-0004NO-Ff; Tue, 17 Mar 2020 12:56:29 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jEApf-0000e0-1U; Tue, 17 Mar 2020 12:56:27 +0100
Date:   Tue, 17 Mar 2020 12:56:27 +0100
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
Message-ID: <20200317115626.4ncavxdcw4wu5zgc@pengutronix.de>
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <545d5e46-644a-51fb-0d67-881dfe23e9d8@gmail.com>
 <20200313181056.GA29732@lunn.ch>
 <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
 <15dafdcd-1979-bf35-3968-c80ffc113001@gmail.com>
 <20200313185327.nawcp2imfldyhpqa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lfhwj2ovh2lzetah"
Content-Disposition: inline
In-Reply-To: <20200313185327.nawcp2imfldyhpqa@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:55:55 up 123 days,  3:14, 156 users,  load average: 0.19, 0.12,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lfhwj2ovh2lzetah
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 07:53:27PM +0100, Oleksij Rempel wrote:
> On Fri, Mar 13, 2020 at 11:20:35AM -0700, Florian Fainelli wrote:
> >=20
> >=20
> > On 3/13/2020 11:16 AM, Oleksij Rempel wrote:
> > > On Fri, Mar 13, 2020 at 07:10:56PM +0100, Andrew Lunn wrote:
> > >>>> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yam=
l b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > >>>> new file mode 100644
> > >>>> index 000000000000..42be0255512b
> > >>>> --- /dev/null
> > >>>> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > >>>> @@ -0,0 +1,61 @@
> > >>>> +# SPDX-License-Identifier: GPL-2.0+
> > >>>> +%YAML 1.2
> > >>>> +---
> > >>>> +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> > >>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > >>>> +
> > >>>> +title: NXP TJA11xx PHY
> > >>>> +
> > >>>> +maintainers:
> > >>>> +  - Andrew Lunn <andrew@lunn.ch>
> > >>>> +  - Florian Fainelli <f.fainelli@gmail.com>
> > >>>> +  - Heiner Kallweit <hkallweit1@gmail.com>
> > >>>> +
> > >>>> +description:
> > >>>> +  Bindings for NXP TJA11xx automotive PHYs
> > >>>> +
> > >>>> +allOf:
> > >>>> +  - $ref: ethernet-phy.yaml#
> > >>>> +
> > >>>> +patternProperties:
> > >>>> +  "^ethernet-phy@[0-9a-f]+$":
> > >>>> +    type: object
> > >>>> +    description: |
> > >>>> +      Some packages have multiple PHYs. Secondary PHY should be d=
efines as
> > >>>> +      subnode of the first (parent) PHY.
> > >>>
> > >>>
> > >>> There are QSGMII PHYs which have 4 PHYs embedded and AFAICT they are
> > >>> defined as 4 separate Ethernet PHY nodes and this would not be quit=
e a
> > >>> big stretch to represent them that way compared to how they are.
> > >>>
> > >>> I would recommend doing the same thing and not bend the MDIO framew=
ork
> > >>> to support the registration of "nested" Ethernet PHY nodes.
> > >>
> > >> Hi Florian
> > >>
> > >> The issue here is the missing PHY ID in the secondary PHY. Because of
> > >> that, the secondary does not probe in the normal way. We need the
> > >> primary to be involved to some degree. It needs to register it. What
> > >> i'm not so clear on is if it just needs to register it, or if these
> > >> sub nodes are actually needed, given the current code.
> > >=20
> > > There are a bit more dependencies:
> > > - PHY0 is responsible for health monitoring. If some thing wrong, it =
may
> > >   shut down complete chip.
> > > - We have shared reset. It make no sense to probe PHY1 before PHY0 wi=
th
> > >   more controlling options will be probed
> > > - It is possible bat dangerous to use PHY1 without PHY0.
> >=20
> > probing is a software problem though. If we want to describe the PHY
> > package more correctly, we should be using a container node, something
> > like this maybe:
> >
> > phy-package {
> > 	compatible =3D "nxp,tja1102";
> >=20
> > 	ethernet-phy@4 {
> > 		reg =3D <4>;
> > 	};
> >=20
> > 	ethernet-phy@5 {
> > 		reg =3D <5>;
> > 	};
> > };
>=20
> Yes, this is almost the same as it is currently done:
>=20
> phy-package {
> 	reg =3D <4>;
> =20
>  	ethernet-phy@5 {
>  		reg =3D <5>;
>  	};
> };
>=20
> Because the primary PHY0 can be autodetected by the bus scan.
> But I have nothing against your suggestions. Please, some one should say =
the
> last word here, how exactly it should be implemented?

ping,

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--lfhwj2ovh2lzetah
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5wuuoACgkQ4omh9DUa
UbNG5g/+KdSOq7b8v5yauULhvpEsrHlJGpaFL3EMI1ufAip3z/1a62usEZp1aVNd
IInBhS+m1Vkj4IIQ7+Aw962e3637PZPMEHswkW9nWS3ozpSlDZgZgb9NDqBlIWLp
B7uYxZlW401HdfSVl3tC8vYP9kxve/CsZAfPWfRtAk4DebWhV7d9c1Hib3YMJG7x
P46EVCl0IiSMrqQ1bVxDn+RimsCj3REeAJlQhaWHfzMwTG8Tr001pYmahL1d9/LD
NkaKi8CX9p1BgMkobHNP078bE7bKF2PVjHpa9fWKRkdFS6F5drXTaDiGW6eGRK37
sRragvu3xxHvrx+D2RpbyZ+XC+ifbU5zlQNjJ8meOrPMl/wdjqLrHMpDnJWc8gI5
fC7qwqraiEd+BEJaJM1lVHeGQ0A+19QDQ/NSTcsz70kMqg9wP7dORmraRz2BJaFp
WyZkVkRl9du9t4doptaybDTi4e5D2CF5wTmztq+PE935bhVz7qUTCiY59b0rRSkc
I0HPkoQUxH2uylzpv7sDuosefWIa62UvhThDQBtN8GXvdjxkvM0DHdSaaeRebZ0L
wivnBhgtKE5T8BKYdno/Yool41CY38tJ8/KEgc75COxp51yoE8h+4Ke+WehpKpSX
rnXW/6mn+Kk58hWf6GUPVzJYMVwT0AQ9Sd6Eh+ahIc3JPg9hnqE=
=hDpJ
-----END PGP SIGNATURE-----

--lfhwj2ovh2lzetah--
