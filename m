Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664403CA3F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403954AbfFKLof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:44:35 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:52668 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfFKLof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:44:35 -0400
Received: from relay5-d.mail.gandi.net (unknown [217.70.183.197])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 450943AB2FD;
        Tue, 11 Jun 2019 11:28:40 +0000 (UTC)
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 950021C0009;
        Tue, 11 Jun 2019 11:28:28 +0000 (UTC)
Date:   Tue, 11 Jun 2019 13:28:28 +0200
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
Subject: Re: [PATCH v2 07/11] dt-bindings: net: stmmac: Convert the binding
 to a schemas
Message-ID: <20190611112828.nstilhcyflpuyt3g@flea>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <40b91798a807cc3c232119ec74285325ebb6692a.1560158667.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqJ_Y4nzN+BCKcUu7jBDwtT+6w5FFOR5S1eYtLm-uUjGqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qew5pxuoqrxydleq"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJ_Y4nzN+BCKcUu7jBDwtT+6w5FFOR5S1eYtLm-uUjGqA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qew5pxuoqrxydleq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2019 at 01:13:25PM -0600, Rob Herring wrote:
> On Mon, Jun 10, 2019 at 3:26 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > +    then:
> > +      properties:
> > +        snps,pbl:
> > +          allOf:
> > +            - $ref: /schemas/types.yaml#definitions/uint32-array
> > +            - enum: [2, 4, 8]
>
> As this is an array, I think this needs to be:
>
> - items:
>     enum: [2, 4, 8]
>
>
> And the next 2, too.

This was actually an error on the types, those properties are not
arrays. I've changed the type, thanks!

maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--qew5pxuoqrxydleq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP+QXAAKCRDj7w1vZxhR
xV9cAQD5L7HheHjAdvoGBNb7CPTPUZI4imYlYaEM5mHnERlzhQD/UsXNJZh1LLwq
3lzUjzZeUKdRAytJJAPH9N/9JIEjOAA=
=10ZG
-----END PGP SIGNATURE-----

--qew5pxuoqrxydleq--
