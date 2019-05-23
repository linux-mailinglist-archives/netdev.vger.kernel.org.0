Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FFD28028
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbfEWOrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:47:03 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:50336 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730757AbfEWOrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:47:02 -0400
X-Greylist: delayed 4865 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2019 10:47:01 EDT
Received: from relay11.mail.gandi.net (unknown [217.70.178.231])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 2FAA73ACB8F;
        Thu, 23 May 2019 12:46:01 +0000 (UTC)
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id CD9B2100022;
        Thu, 23 May 2019 12:45:46 +0000 (UTC)
Date:   Thu, 23 May 2019 14:45:46 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 6/8] dt-bindings: net: stmmac: Convert the binding to a
 schemas
Message-ID: <20190523124546.6agw7fu5qteag3ol@flea>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <ba1a5d8ad34a8c9ab99f504c04fbe65bde42081b.1558605170.git-series.maxime.ripard@bootlin.com>
 <78EB27739596EE489E55E81C33FEC33A0B92B864@DE02WEMBXB.internal.synopsys.com>
 <20190523110715.ckyzpec3quxr26cp@flea>
 <78EB27739596EE489E55E81C33FEC33A0B92BA5B@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tf5grxv2ddxyomh6"
Content-Disposition: inline
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B92BA5B@DE02WEMBXB.internal.synopsys.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tf5grxv2ddxyomh6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2019 at 11:25:09AM +0000, Jose Abreu wrote:
> From: Maxime Ripard <maxime.ripard@bootlin.com>
> Date: Thu, May 23, 2019 at 12:07:15
>
> > You can then run make dtbs_check, and those YAML files will be used to
> > validate that any devicetree using those properties are doing it
> > properly. That implies having the right node names, properties, types,
> > ranges of values when relevant, and so on.
>
> Thanks but how can one that's developing know which bindings it shall use?

I'm not quite sure what you mean here. Are you talking about which
file to use, or which property are required, or something else?

> Is this not parsed/prettified and displayed in some kind of webpage ?

Not at the moment, but it's one of the things that are made much
easier by using a formal data format.

> Just that now that the TXT is gone its kind of "strange" to look at YAML
> instead of plain text and develop/use the bindings.

Well, it's kind of the point though. Free-form text was impossible to
parse in a generic way, and you couldn't build any generic tools upon
it. YAML provides that.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--tf5grxv2ddxyomh6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXOaV+gAKCRDj7w1vZxhR
xbIiAQDiQ/YoNNi0GkGaqteHf9TnQ2HqpEptDspMMmoMtI/iUQD9GIkc5JePBFh2
kcr5Fwff9irX+EB/TCiw12tiyLODug8=
=9C+d
-----END PGP SIGNATURE-----

--tf5grxv2ddxyomh6--
