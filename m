Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677D23C7AE
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 11:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404983AbfFKJxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 05:53:23 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52681 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404425AbfFKJxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 05:53:23 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id C88DFC000B;
        Tue, 11 Jun 2019 09:53:17 +0000 (UTC)
Date:   Tue, 11 Jun 2019 11:53:17 +0200
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
Subject: Re: [PATCH v2 06/11] dt-bindings: net: sun4i-mdio: Convert the
 binding to a schemas
Message-ID: <20190611095317.l55zjuomxqfvpqlo@flea>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <664da05aaf9a7029494d72d7c536baa192672fbe.1560158667.git-series.maxime.ripard@bootlin.com>
 <20190610143730.GH28724@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nt34jhbgjztm3vnl"
Content-Disposition: inline
In-Reply-To: <20190610143730.GH28724@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nt34jhbgjztm3vnl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrew,

On Mon, Jun 10, 2019 at 04:37:30PM +0200, Andrew Lunn wrote:
> On Mon, Jun 10, 2019 at 11:25:45AM +0200, Maxime Ripard wrote:
> > Switch our Allwinner A10 MDIO controller binding to a YAML schema to enable
> > the DT validation.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> Should there be a generic part to cover what is listed in:
>
> Documentation/devicetree/bindings/net/mdio.txt

Thanks for pointing that out, I'll convert it as well.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--nt34jhbgjztm3vnl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP96DQAKCRDj7w1vZxhR
xemGAQDeKHYJUTJ7pEQdZKX1WZEmIhNHWPhuhjM7yYBI+DFawgEA5Hrj2kSgRSzG
FFEkc4IqWkvbt0d584kNLqDInxO1VAY=
=DaeR
-----END PGP SIGNATURE-----

--nt34jhbgjztm3vnl--
