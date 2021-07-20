Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A707C3D035B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbhGTUJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237642AbhGTTwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:52:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA00A60FF2;
        Tue, 20 Jul 2021 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626813196;
        bh=eAL8QwelZEjqkrY6xpSxtA3PODMbnmYsssC4KoVZiOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJpAfKhnABUmpxOg9U/fYhIdK676lUC7zxdZO4Ov+XkzsTN1uNQpBFvYrirDfIakZ
         byh9JWGpUaePwdP9P8a5i5BEvhoOUPFLDQF/TDfF6Dt16A3BeRLHI/9/G2uzjph8jw
         MevIZGtIuySKTu1ntOZrkKNQFaWrdWeYOaJyeJpxUnq3KG8ahCOJyb+BlK+zntCxgx
         Ed4I0eXobO8J3Ubp6zPV5nmDpkVivVrUweH+mzg1CoHXf/MLoxDBrQyTc2c5HwIyLh
         QY1nFaI0Gwrfw7HTmsQ+TalbuwunzUd9K0sOoGUuoML7Km3jvcukKSLHc3yF+IDiUt
         vtHRTxUbK9qGQ==
Date:   Tue, 20 Jul 2021 21:33:12 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ramesh Shanmugasundaram <rashanmu@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Dilip Kota <eswara.kota@linux.intel.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples
Message-ID: <20210720203312.GG5042@sirena.org.uk>
References: <20210720172025.363238-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kadn00tgSopKmJ1H"
Content-Disposition: inline
In-Reply-To: <20210720172025.363238-1-robh@kernel.org>
X-Cookie: Revenge is a meal best served cold.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kadn00tgSopKmJ1H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 20, 2021 at 11:20:25AM -0600, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).

Acked-by: Mark Brown <broonie@kernel.org>

--kadn00tgSopKmJ1H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmD3MwcACgkQJNaLcl1U
h9Bjsgf8DIiqqQ26ZTa4jvNqa3wI4t/EHPC0PLaGmxZWA2e7eTEGVrmipVIkUz2m
dX2Rrsl6xOoU39mzMuCNQwVu9iqiJUoxt6xQsFG13raVCQhBTxxgkkVV2qU6BWh0
TEuDrDM4Uh5EIU/PxpwbywfyPELaMCBkFvkd9D8O/0ek7OPcVuw5Au7es/ZG+NS/
nQBA4oFRFdrIVSQmZ+Tn3/VjiivJhZ4H8MZ3oSKcFrMpQjG6ppG31dZGHpKtJNwE
bUqasYXWrqKz1seky+xKbpbMnSjok627Byj0cGtNir3l8MpB2bV+Ae2OE/tc3nyZ
aRZ/bNwgS/oYZ+vrKSOeJcgAasfyYw==
=3Ukn
-----END PGP SIGNATURE-----

--kadn00tgSopKmJ1H--
