Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB11A86EC
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407477AbgDNRGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbgDNRGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:06:21 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5D820678;
        Tue, 14 Apr 2020 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586883980;
        bh=N+wDVFj4k9qNnM4H4JBhjazm1jiklG8jskgZRqJY8vE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GLTIl/JCaTkOhZA5OQwDfanxfbTEyIdCvGi1wIKXRvXuh3XsA+ROea7ZdVEIEMoUp
         rkUKYqb5ScEV9JzmaLWwUPEzla8bLzvty9CCTcNG/rMrOF/dgEbtEBXh5A5+9KH9XJ
         dgb4ux3lsK5o5RvJGS7cBTojbNGLUizRObK2g7/U=
Date:   Tue, 14 Apr 2020 18:06:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-hwmon@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix dtc warnings on reg and ranges in
 examples
Message-ID: <20200414170618.GG5412@sirena.org.uk>
References: <20200409202458.24509-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Content-Disposition: inline
In-Reply-To: <20200409202458.24509-1-robh@kernel.org>
X-Cookie: I've only got 12 cards.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2020 at 02:24:58PM -0600, Rob Herring wrote:
> A recent update to dtc and changes to the default warnings introduced
> some new warnings in the DT binding examples:

Acked-by: Mark Brown <broonie@kernel.org>

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6V7YkACgkQJNaLcl1U
h9C0nggAgbznZBSepYyVohp/1H4rCte0Z/wk6K7EfPvfDL1M/M+F5oW6AU4YZ7Kq
lnSn9hweJBFpxBwrrAv0lHakge/LpEQZ1Aqig/t9jd9NgwKqJWJ8Y2aKPx+Oli9k
mdb6G44fbxVgVruXHd1n2XzJwpISNXksvKBTYWY63Gb7DRAfzSqlexWfysRbtI/O
NgdIihQ9ti6mjE0Nxso/6KeZbooinBxVRntCOiinYSHraOWbfTn24MQXa70JtuVC
m7cod5i1+C4PiKb+3m5aYIEQxvzN08qRxnnZFrnknqj+N0GcA1N9wVkJ06JhXrzn
a84u535dpkRwCg+2Nf9leoevVqXUqw==
=wm8m
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
