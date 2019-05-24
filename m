Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE029281
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389419AbfEXIK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:10:56 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:42643 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389142AbfEXIKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:10:55 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2CBD3FF80B;
        Fri, 24 May 2019 08:10:50 +0000 (UTC)
Date:   Fri, 24 May 2019 10:10:49 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] dt-bindings: net: Add a YAML schemas for the generic
 PHY options
Message-ID: <20190524081049.6obsqdeywmx4io4k@flea>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <aa5ec90854429c2d9e2c565604243e1b10cfd94b.1558605170.git-series.maxime.ripard@bootlin.com>
 <e39b7a35-3235-6040-b3c1-648897fabc70@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nhmqncggqckfikyo"
Content-Disposition: inline
In-Reply-To: <e39b7a35-3235-6040-b3c1-648897fabc70@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nhmqncggqckfikyo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Florian,

On Thu, May 23, 2019 at 11:16:55AM -0700, Florian Fainelli wrote:
> On 5/23/19 2:56 AM, Maxime Ripard wrote:
> > The networking PHYs have a number of available device tree properties that
> > can be used in their device tree node. Add a YAML schemas for those.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 148 +++++++++-
> >  Documentation/devicetree/bindings/net/phy.txt           |  80 +-----
> >  2 files changed, 149 insertions(+), 79 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml
>
> Updating the PHY Library section of the MAINTAINERS file to include that
> binding document (not sure why it was not there) would be nice.

Sure, I'll do it, thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--nhmqncggqckfikyo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXOenCQAKCRDj7w1vZxhR
xUgbAP9wwE5sdteTuWzmvFDeY+ZJM3sYeePKoRl395ve/Qr3oAD9F9BoZLzYs5Ni
OuDix3LenJQC4xZN88XtLfwtItIvAgA=
=k8+g
-----END PGP SIGNATURE-----

--nhmqncggqckfikyo--
