Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB41B3CA0E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389614AbfFKLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:31:15 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50507 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389464AbfFKLbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:31:15 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B79F460007;
        Tue, 11 Jun 2019 11:31:08 +0000 (UTC)
Date:   Tue, 11 Jun 2019 13:31:08 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 09/11] dt-bindings: net: sun8i-emac: Convert the
 binding to a schemas
Message-ID: <20190611113108.pxiia2u5skbnl2au@flea>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <f3f393db88b26d84a048cb71887a571611b984a2.1560158667.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqL8ARs3jQECS+E-BtZGouLYJhofM+oPpS1a3SxPORwMZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="twpj3baugamuul24"
Content-Disposition: inline
In-Reply-To: <CAL_JsqL8ARs3jQECS+E-BtZGouLYJhofM+oPpS1a3SxPORwMZA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--twpj3baugamuul24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, Jun 10, 2019 at 01:22:00PM -0600, Rob Herring wrote:
> On Mon, Jun 10, 2019 at 3:26 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > +    then:
> > +      properties:
> > +        allwinner,tx-delay-ps:
> > +          allOf:
> > +            - $ref: /schemas/types.yaml#definitions/uint32
>
> Can drop this as anything with unit prefix has its type defined
> already.

Not for picoseconds though. I'll send a PR to dt-schema if you prefer
to define it there.

>
> > +            - enum: [0, 100, 200, 300, 400, 500, 600, 700]
> > +              default: 0
> > +          description:
> > +            External RGMII PHY TX clock delay chain value in ps.
> > +
> > +        allwinner,rx-delay-ps:
> > +          allOf:
> > +            - $ref: /schemas/types.yaml#definitions/uint32
> > +            - enum:
> > +                - 0
> > +                - 100
> > +                - 200
> > +                - 300
> > +                - 400
> > +                - 500
> > +                - 600
> > +                - 700
> > +                - 800
> > +                - 900
> > +                - 1000
> > +                - 1100
> > +                - 1200
> > +                - 1300
> > +                - 1400
> > +                - 1500
> > +                - 1600
> > +                - 1700
> > +                - 1800
> > +                - 1900
> > +                - 2000
> > +                - 2100
> > +                - 2200
> > +                - 2300
> > +                - 2400
> > +                - 2500
> > +                - 2600
> > +                - 2700
> > +                - 2800
> > +                - 2900
> > +                - 3000
> > +                - 3100
>
> I think you can do
>
> enum: [1, 2, 3,
>   4,  5, 6]
>
> Or you can do:
>
> minimum: 0
> maximum: 3100
> multipleOf: 100
>
> IIRC that multipleOf is a json-schema key.

I really like that second syntax, thanks!

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--twpj3baugamuul24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP+Q/AAKCRDj7w1vZxhR
xXNCAP9Z7+EYu847+4dOo5AEj3ZOyAIpaf0cfysGi59ElDt8YgEA36E6Jv7/cOpS
KBTjh2j/vsuGvWij3L6KlfuKURO0UwM=
=3dqX
-----END PGP SIGNATURE-----

--twpj3baugamuul24--
