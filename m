Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2B1BD3C8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD2EiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726682AbgD2EiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:38:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA89C03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 21:38:21 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jTeU9-00035I-0Q; Wed, 29 Apr 2020 06:38:13 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jTeU4-0006hD-J6; Wed, 29 Apr 2020 06:38:08 +0200
Date:   Wed, 29 Apr 2020 06:38:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        David Jander <david@protonic.nl>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
Message-ID: <20200429043808.jdlhoeuujfxdifh7@pengutronix.de>
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <CAL_JsqJgwKjWnTETB1pDc+aXVYp0c-cYOE6gz_KYOn5byQOKpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u5ojtjypdq5icgiq"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJgwKjWnTETB1pDc+aXVYp0c-cYOE6gz_KYOn5byQOKpA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:35:27 up 165 days, 19:54, 163 users,  load average: 0.08, 0.07,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u5ojtjypdq5icgiq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

@Rob, thank you for the review.

@David, should I send fixes or reworked initial patches?

On Tue, Apr 28, 2020 at 12:30:06PM -0500, Rob Herring wrote:
> On Fri, Mar 13, 2020 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de>=
 wrote:
> >
> > Document the NXP TJA11xx PHY bindings.
>=20
> Given the discussion, I'd marked this one as "changes requested"
> expecting a new version to review the schema. And gmail decided to
> make a new thread due to the extra 'RE:'. So it fell off my radar.
>=20
> This schema is fundamentally broken as there's no way to match for
> when to apply this schema. How do we find a NXP TJA11xx PHY? I suppose
> we can look for 'ethernet-phy' with a child node 'ethernet-phy', but
> then that would apply to any phy like this one. This needs a
> compatible string IMO given it is non-standard.
>=20
> >
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  .../devicetree/bindings/net/nxp,tja11xx.yaml  | 61 +++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/nxp,tja11xx.y=
aml
> >
> > diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/D=
ocumentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > new file mode 100644
> > index 000000000000..42be0255512b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > @@ -0,0 +1,61 @@
> > +# SPDX-License-Identifier: GPL-2.0+
>=20
> Dual license new bindings:
>=20
> (GPL-2.0-only OR BSD-2-Clause)
>=20
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: NXP TJA11xx PHY
> > +
> > +maintainers:
> > +  - Andrew Lunn <andrew@lunn.ch>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +  - Heiner Kallweit <hkallweit1@gmail.com>
> > +
> > +description:
> > +  Bindings for NXP TJA11xx automotive PHYs
>=20
> Perhaps some information about how this phy is special.
>=20
> > +
> > +allOf:
> > +  - $ref: ethernet-phy.yaml#
>=20
> Not needed here as ethernet-phy.yaml already has a 'select' condition to =
apply.
>=20
> > +
> > +patternProperties:
> > +  "^ethernet-phy@[0-9a-f]+$":
> > +    type: object
> > +    description: |
> > +      Some packages have multiple PHYs. Secondary PHY should be define=
s as
> > +      subnode of the first (parent) PHY.
> > +
> > +    properties:
> > +      reg:
> > +        minimum: 0
> > +        maximum: 31
> > +        description:
> > +          The ID number for the child PHY. Should be +1 of parent PHY.
> > +
> > +    required:
> > +      - reg
> > +
> > +examples:
> > +  - |
> > +    mdio {
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <0>;
> > +
> > +        tja1101_phy0: ethernet-phy@4 {
> > +            reg =3D <0x4>;
> > +        };
> > +    };
> > +  - |
> > +    mdio {
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <0>;
> > +
> > +        tja1102_phy0: ethernet-phy@4 {
> > +            reg =3D <0x4>;
>=20
> > +            #address-cells =3D <1>;
> > +            #size-cells =3D <0>;
>=20
> These aren't documented.
>=20
> > +
> > +            tja1102_phy1: ethernet-phy@5 {
> > +                reg =3D <0x5>;
> > +            };
> > +        };
> > +    };
> > --
> > 2.25.1
> >
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--u5ojtjypdq5icgiq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6pBKgACgkQ4omh9DUa
UbPdpxAAn2f/bOVYYyPeoJH51X6j3vw6VzICAMmpJEFUQapwQK9TLVY81n5d+OZm
mkHvdK/0cpuDEpJBahmPlU38IDk7uAfgauz5JE4rVmTnqJnaMjK4tpxKtgGqaRoA
T0ghABC89U+V1groHAPxNwTxRR3nz5sQRjWUCx6hZ5KqP7gRoOWyyNPI3Hh088d3
0YcJVFLxMoUNxRGUcmtPCNlp5UZ/mRZYhENAXQQ+c+jEttmQKfB52C730ogZfaIZ
E8SkpCrVzHFMu1b/aR0FBE0VkRR8NoG0nnxAUXLVfk2bEBkoIjOEn/+4XbN2Dmha
z270yAzDJeJux9Lx34EzXhFkA6bc+1V/yAHVc3ZmDXTp/GGFiDdLBnId+Q9LmXf1
97MNlkKxK17V8pc7exGy+5f5lX0uiwOMuRzUZGMqPdMXVHuzAnJeu1PUxAGI4B8F
Y0cJkZtVI9a/rTUHMgvTJZUtiPV+x9ZVn0XX3nnM9T9RWzF8fpE5VZP0Odl1n5ls
hVTQX5XZSCVsflrgaRAxTrN3taNe5sPs5tBVLhw+Uamit62bI+jiBczlg+I4MilC
lJoMLGNUqNENcVUuUUkJ5CWw0/7E3NfkhXxFx0H+8n/a2NbMSc/ywYx4aoe3MqXD
p/KU6QtUbHvi8Eg9vh3NlhYppQQj2U+b894d3K/LYd8A4bbMdSA=
=JVGP
-----END PGP SIGNATURE-----

--u5ojtjypdq5icgiq--
