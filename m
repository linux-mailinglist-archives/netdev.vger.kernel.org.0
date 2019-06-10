Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3773B7DA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391010AbfFJOz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:55:58 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:40725 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390087AbfFJOz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:55:58 -0400
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 30B5F240002;
        Mon, 10 Jun 2019 14:55:46 +0000 (UTC)
Date:   Mon, 10 Jun 2019 16:55:46 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
Message-ID: <20190610145546.4xz7hdh3gk6vjrbx@flea>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
 <20190610143139.GG28724@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2hk2wdgp2lluy5gd"
Content-Disposition: inline
In-Reply-To: <20190610143139.GG28724@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2hk2wdgp2lluy5gd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrew,

On Mon, Jun 10, 2019 at 04:31:39PM +0200, Andrew Lunn wrote:
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - phy
> > +  - allwinner,sram
>
> Quoting ethernet.txt:
>
> - phy: the same as "phy-handle" property, not recommended for new bindings.
> - phy-handle: phandle, specifies a reference to a node representing a PHY
>   device; this property is described in the Devicetree Specification and so
>   preferred;
>
> Can this be expressed in Yaml? Accept phy, but give a warning. Accept
> phy-handle without a warning? Enforce that one or the other is
> present?

This is what we should be aiming for, yes, but right now we don't
really have a way to express that for properties.

The next specification of the schema spec seems to address that, and
it should be released pretty soon, so it's always something that we
can address later on, when it will be out.

For that particular case, we can also work around it by requiring
phy-handle instead of phy. That way, if phy-handle is missing we will
have a warning. phy will not be validated though, which is kind of a
shame, but still much better than what we currently have.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--2hk2wdgp2lluy5gd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP5vcgAKCRDj7w1vZxhR
xROVAQCE8VjN3D3Zq/0/xTCqKO9q7ZGhs12dLs6qtxTmR6RT5AEA+tzeMYZG2H0F
xHGLU34vLSD2stWREcS0ZBfkhOPARwE=
=PzlU
-----END PGP SIGNATURE-----

--2hk2wdgp2lluy5gd--
