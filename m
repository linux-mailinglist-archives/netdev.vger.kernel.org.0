Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6844E59D2F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfF1NqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:46:01 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:44849 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfF1NqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:46:01 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 2633B240009;
        Fri, 28 Jun 2019 13:45:54 +0000 (UTC)
Date:   Fri, 28 Jun 2019 15:45:53 +0200
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
Subject: Re: [PATCH v4 03/13] dt-bindings: net: Add a YAML schemas for the
 generic MDIO options
Message-ID: <20190628134553.l445r5idtejwlryl@flea>
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
 <e99ff7377a0d3d140cf62200fd9d62c108dac24e.1561649505.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqKQoj6x-8cMxp2PFQLcu93aitGO2wALDYaH2h72cPSyfg@mail.gmail.com>
 <20190627155708.myxychzngc3trxhc@flea>
 <CAL_JsqLhUP62vP=RY8Bn_0X92hFphbk_gLqi4K48us56Gxw7tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zjmpquddmsmyw3nm"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLhUP62vP=RY8Bn_0X92hFphbk_gLqi4K48us56Gxw7tA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zjmpquddmsmyw3nm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 27, 2019 at 10:06:57AM -0600, Rob Herring wrote:
> On Thu, Jun 27, 2019 at 9:57 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > > +
> > > > +        reset-gpios = <&gpio2 5 1>;
> > > > +        reset-delay-us = <2>;
> > > > +
> > > > +        ethphy0: ethernet-phy@1 {
> > > > +            reg = <1>;
> > >
> > > Need a child node schema to validate the unit-address and reg property.
> >
> > This should be already covered by the ethernet-phy.yaml schemas
> > earlier in this series.
>
> Partially, yes.
>
> > Were you expecting something else?
>
> That would not prevent having a child node such as 'foo {};'  or
> 'foo@bad {};'. It would also not check valid nodes named something
> other than 'ethernet-phy'.

Right, but listing the nodes won't either, since we can't enable
additionalProperties in that schema. So any node that wouldn't match
ethernet-phy@.* wouldn't be validated, but wouldn't generate a warning
either.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--zjmpquddmsmyw3nm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXRYaEQAKCRDj7w1vZxhR
xcfbAP0StcNKYljUjaKh+7kNRQmW2KY7UHR2qG+yIslRuaKsBwEA9WACBZA+N2PQ
q0Mqev0oV23zbWU9jcIrJV2ljPCzGwE=
=Klyx
-----END PGP SIGNATURE-----

--zjmpquddmsmyw3nm--
