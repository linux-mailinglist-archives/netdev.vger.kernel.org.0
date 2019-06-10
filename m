Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916A33B42B
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbfFJLrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:47:15 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:55577 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389421AbfFJLrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:47:13 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2DA15FF811;
        Mon, 10 Jun 2019 11:47:00 +0000 (UTC)
Date:   Mon, 10 Jun 2019 13:47:00 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        devicetree@vger.kernel.org, narmstrong@baylibre.com,
        khilman@baylibre.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset
 GPIO
Message-ID: <20190610114700.tymqzzax334ahtz4@flea>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609204510.GB8247@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fo7fw3siaxhdftz7"
Content-Disposition: inline
In-Reply-To: <20190609204510.GB8247@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fo7fw3siaxhdftz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrew,

On Sun, Jun 09, 2019 at 10:45:10PM +0200, Andrew Lunn wrote:
> > Patch #1 and #4 are minor cleanups which follow the boyscout rule:
> > "Always leave the campground cleaner than you found it."
>
> > I
> > am also looking for suggestions how to handle these cross-tree changes
> > (patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
> > go through the net-next tree. I will re-send patch #5 separately as
> > this should go through Kevin's linux-amlogic tree).
>
> Patches 1 and 4 don't seem to have and dependencies. So i would
> suggest splitting them out and submitting them to netdev for merging
> independent of the rest.

Jumping on the occasion of that series. These properties have been
defined to deal with phy reset, while it seems that the PHY core can
now handle that pretty easily through generic properties.

Wouldn't it make more sense to just move to that generic properties
that already deals with the flags properly?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--fo7fw3siaxhdftz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXP5DNAAKCRDj7w1vZxhR
xa7wAPsFyeyyMzy2Mo76JgsYSYvgpcYRFmoiWzu3x+sgya0khgEAjtxK626tAXRA
KJga7pcCDwguE9DoA7ftHh5GzRGyjQo=
=h3Ed
-----END PGP SIGNATURE-----

--fo7fw3siaxhdftz7--
