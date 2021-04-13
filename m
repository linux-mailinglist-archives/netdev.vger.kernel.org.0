Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011EC35D922
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhDMHlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbhDMHlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:41:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F24C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:41:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWDfa-0002wF-17; Tue, 13 Apr 2021 09:41:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:d93:7b32:b325:ef5e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EAD7060D881;
        Tue, 13 Apr 2021 07:41:06 +0000 (UTC)
Date:   Tue, 13 Apr 2021 09:41:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH 1/4] dt-bindings: phy: Add binding for TI TCAN104x CAN
 transceivers
Message-ID: <20210413074106.gvgtjkofyrdp5yxt@pengutronix.de>
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-2-a-govindraju@ti.com>
 <f9b04d93-c249-970e-3721-50eb268a948f@pengutronix.de>
 <20210412174956.GA4049952@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="glnpqqhpnvjspjxs"
Content-Disposition: inline
In-Reply-To: <20210412174956.GA4049952@robh.at.kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--glnpqqhpnvjspjxs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.04.2021 12:49:56, Rob Herring wrote:
> On Mon, Apr 12, 2021 at 12:19:30PM +0200, Marc Kleine-Budde wrote:
> > On 4/9/21 3:40 PM, Aswath Govindraju wrote:
> > > Add binding documentation for TI TCAN104x CAN transceivers.
> > >=20
> > > Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> > > ---
> > >  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++=
++
> > >  1 file changed, 56 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x=
-can.yaml
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.ya=
ml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > > new file mode 100644
> > > index 000000000000..4abfc30a97d0
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > > @@ -0,0 +1,56 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
> > > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > > +
> > > +title: TCAN104x CAN TRANSCEIVER PHY
> > > +
> > > +maintainers:
> > > +  - Aswath Govindraju <a-govindraju@ti.com>
> > > +
> > > +properties:
> > > +  $nodename:
> > > +    pattern: "^tcan104x-phy"
> > > +
> > > +  compatible:
> > > +    enum:
> > > +      - ti,tcan1042
> > > +      - ti,tcan1043
> >=20
> > Can you create a generic standby only and a generic standby and enable =
transceiver?
>=20
> As a fallback compatible fine, but no generic binding please. A generic=
=20
> binding can't describe any timing requirements between the 2 GPIO as=20
> well as supplies when someone wants to add those (and they will).

Right - that makes sense.

> > > +
> > > +  '#phy-cells':
> > > +    const: 0
> > > +
> > > +  standby-gpios:
> > > +    description:
> > > +      gpio node to toggle standby signal on transceiver
> > > +    maxItems: 1
> > > +
> > > +  enable-gpios:
> > > +    description:
> > > +      gpio node to toggle enable signal on transceiver
> > > +    maxItems: 1
> > > +
> > > +  max-bitrate:
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    description:
> > > +      max bit rate supported in bps
>=20
> We already have 'max-speed' for serial devices, use that.

There is already the neither Ethernet PHY (PHYLINK/PHYLIB) nor generic
PHY (GENERIC_PHY) can-transceiver binding
Documentation/devicetree/bindings/net/can/can-transceiver.yaml which
specifies max-bitrate. I don't have strong feelings whether to use
max-bitrate or max-speed.

Speaking about Ethernet PHYs, what are to pros and cons to use the
generic PHY compared to the Ethernet PHY infrastructure?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--glnpqqhpnvjspjxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB1Sw8ACgkQqclaivrt
76k2xAgAoYRIJ2saZpOlKBVdCP3F6bacRxhFyVXdgCtFvOEJlHrmc1ITd9wQxqlD
M66lTqpLObfL6a4OBhT8IuV1vm/WrXuMmpBbeL8d48nyuzGi3HBifVoPGEDNOL+E
JgGfe4HSGrr7+P/PxdfwwEkgKFPITRLJf2oM9Pp9E2VSpGS8idb5RdcC+4JwRv8E
ULOFgqmu5MlXrzNPh83vCEmJ9zBLQ5YsL9LRmInBt2bnCZmz/TjcsSVa5fKAlKq+
TpC+ZNKLO2dcIu/VE51okEzHxT0QQDkdGTyy8WJZ5ThlYf9al8j8hJN2usLLLqww
V5v0Gte8QuZC8ZolWxEZo5UtELUfDA==
=3aAL
-----END PGP SIGNATURE-----

--glnpqqhpnvjspjxs--
