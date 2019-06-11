Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A695439B0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbfFMPP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:15:27 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41451 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbfFMNZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 09:25:30 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id B224FC0002;
        Thu, 13 Jun 2019 13:25:15 +0000 (UTC)
Date:   Tue, 11 Jun 2019 16:58:56 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Mark Rutland <mark.rutland@arm.com>,
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
Message-ID: <20190611145856.ua2ggkn6ccww6vpp@flea>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
 <20190610143139.GG28724@lunn.ch>
 <CAL_JsqJahCJcdu=+fA=ewbGezuEJ2W6uwMVxkQpdY6w+1OWVVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="akgu3rpnhcjfd75m"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJahCJcdu=+fA=ewbGezuEJ2W6uwMVxkQpdY6w+1OWVVA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--akgu3rpnhcjfd75m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rob,

On Mon, Jun 10, 2019 at 12:59:29PM -0600, Rob Herring wrote:
> On Mon, Jun 10, 2019 at 8:31 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - interrupts
> > > +  - clocks
> > > +  - phy
> > > +  - allwinner,sram
> >
> > Quoting ethernet.txt:
> >
> > - phy: the same as "phy-handle" property, not recommended for new bindings.
> >
> > - phy-handle: phandle, specifies a reference to a node representing a PHY
> >   device; this property is described in the Devicetree Specification and so
> >   preferred;
> >
> > Can this be expressed in Yaml? Accept phy, but give a warning. Accept
> > phy-handle without a warning? Enforce that one or the other is
> > present?
>
> The common schema could have 'phy: false'. This works as long as we've
> updated (or plan to) all the dts files to use phy-handle. The issue is
> how far back do you need kernels to work with newer dtbs.

I guess another question being raised by this is how hard do we want
to be a deprecating things, and should the DT validation be a tool to
enforce that validation.

For example, you've used in you GPIO meta-schema false for anything
ending with -gpio, since it's deprecated. This means that we can't
convert any binding using a deprecated property without introducing a
build error in the schemas, which in turn means that you'll have a lot
of friction to support schemas, since you would have to convert your
driver to support the new way of doing things, before being able to
have a schema for your binding.

And then, we need to agree on how to express the deprecation. I guess
we could allow the deprecated keyword that will be there in the
draft-8, instead of ad-hoc solutions?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--akgu3rpnhcjfd75m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP/BsAAKCRDj7w1vZxhR
xU7tAQDcrE7AmbrNpKlW8XjNBwjZBTaNMJbwICwP0nzygayxHQD+MjHzz6TZnhQF
Qm1qbD7O25WDq9BPnYW8XMjLhY6IgQE=
=f1jE
-----END PGP SIGNATURE-----

--akgu3rpnhcjfd75m--
