Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE3D3B676
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfFJNvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:51:18 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43071 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390306AbfFJNvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:51:18 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 22AD7E0004;
        Mon, 10 Jun 2019 13:51:09 +0000 (UTC)
Date:   Mon, 10 Jun 2019 15:51:09 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset
 GPIO
Message-ID: <20190610135109.7alkvruvw2jbtwph@flea>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609204510.GB8247@lunn.ch>
 <20190610114700.tymqzzax334ahtz4@flea>
 <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hlwqgl7jkkjm4sqs"
Content-Disposition: inline
In-Reply-To: <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hlwqgl7jkkjm4sqs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Martin,

On Mon, Jun 10, 2019 at 02:31:17PM +0200, Martin Blumenstingl wrote:
> On Mon, Jun 10, 2019 at 1:47 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > Hi Andrew,
> >
> > On Sun, Jun 09, 2019 at 10:45:10PM +0200, Andrew Lunn wrote:
> > > > Patch #1 and #4 are minor cleanups which follow the boyscout rule:
> > > > "Always leave the campground cleaner than you found it."
> > >
> > > > I
> > > > am also looking for suggestions how to handle these cross-tree changes
> > > > (patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
> > > > go through the net-next tree. I will re-send patch #5 separately as
> > > > this should go through Kevin's linux-amlogic tree).
> > >
> > > Patches 1 and 4 don't seem to have and dependencies. So i would
> > > suggest splitting them out and submitting them to netdev for merging
> > > independent of the rest.
> >
> > Jumping on the occasion of that series. These properties have been
> > defined to deal with phy reset, while it seems that the PHY core can
> > now handle that pretty easily through generic properties.
> >
> > Wouldn't it make more sense to just move to that generic properties
> > that already deals with the flags properly?
> thank you for bringing this up!
> if anyone else (just like me) doesn't know about it, there are generic
> bindings defined here: [0]
>
> I just tested this on my X96 Max by defining the following properties
> inside the PHY node:
>   reset-delay-us = <10000>;
>   reset-assert-us = <10000>;
>   reset-deassert-us = <10000>;
>   reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
>
> that means I don't need any stmmac patches which seems nice.

I'm glad it works for you :)

> instead I can submit a patch to mark the snps,reset-gpio properties in
> the dt-bindings deprecated (and refer to the generic bindings instead)
> what do you think?

I already did as part of the binding reworks I did earlier today:
http://lists.infradead.org/pipermail/linux-arm-kernel/2019-June/658427.html

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--hlwqgl7jkkjm4sqs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP5gTQAKCRDj7w1vZxhR
xTX2AQDErQs37AlgMjoegkuBtrfya5ARL23dKC2yJPk5bFAPIQEA8brM32gT3g4u
5bbyMYmku0KJTlZo2bHr8P+VKtd70A0=
=Jc07
-----END PGP SIGNATURE-----

--hlwqgl7jkkjm4sqs--
