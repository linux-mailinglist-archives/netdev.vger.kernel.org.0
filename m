Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BB237254
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfFFLAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:00:10 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:49996 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfFFLAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oYOXjRQFx1z+6E0ax1Zx11BDYlrCjP+RsMwp6EKLiOI=; b=VBDtL01GAkY/Njk3N1+4YBarr
        nqRuHuFxIQzaLsab8s4rUGOZcri4e+qIwZxuPxc/OLVKZZzNQpWNmtVd6VDXKqxpf8FWnFUmG8ZDo
        3zKZWtwFZqHgv4VDrv/7IdbEHbB5FChNwmygerYfXaq13TpYL7RuwPZVk2n19X0vEUpiA=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYq7f-0005Nj-Pk; Thu, 06 Jun 2019 10:59:55 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 450A6440046; Thu,  6 Jun 2019 11:59:55 +0100 (BST)
Date:   Thu, 6 Jun 2019 11:59:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     lgirdwood@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, marex@denx.de, stefan@agner.ch,
        airlied@linux.ie, daniel@ffwll.ch, shawnguo@kernel.org,
        s.hauer@pengutronix.de, b.zolnierkie@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, p.zabel@pengutronix.de,
        hkallweit1@gmail.com, lee.jones@linaro.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8] drivers: regulator: 88pm800: fix warning same module
 names
Message-ID: <20190606105954.GZ2456@sirena.org.uk>
References: <20190606094736.23970-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JbpSbCMiCLmwdpgc"
Content-Disposition: inline
In-Reply-To: <20190606094736.23970-1-anders.roxell@linaro.org>
X-Cookie: The other line moves faster.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JbpSbCMiCLmwdpgc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2019 at 11:47:36AM +0200, Anders Roxell wrote:

>  obj-$(CONFIG_REGULATOR_88PG86X) += 88pg86x.o
> -obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
> +obj-$(CONFIG_REGULATOR_88PM800) += 88pm800-regulator.o
> +88pm800-regulator-objs		:= 88pm800.o

Don't do this, no need for this driver to look different to all the
others in the Makefile - just rename the whole file.

--JbpSbCMiCLmwdpgc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlz48ioACgkQJNaLcl1U
h9CG4wf+KwJtkqXwPsGULtOJI6nSm5LEkmrz72NfdgOqj1WW7rLXjWvVzFh/6QR4
Yx2iXClMJ3RT5wsgfK/nlN0mPPVrA7hVeHFDLig5RdvadGQZd0UdN6BgUYcZpZat
5jUkB6rgNxVOe+6kO4onKQn4RWHwkF3Sy7xlN0adWD2b2qqoZPMy3Sc62S+JtAb7
KcHORRkbS49Q1xEtsikUD7SZY3cgJOqjQ6ZQcd9dr1iEXZr8wQ3A8wAnBtqm+OEQ
ptNlJi9FmLI9Ihk1Ps82hCwgTT8hWRdQU0JxFV5ybOtLv5y24PoXCvdo2NNtRcdr
ysZl+LpymLjvpEgM2ByRehnnqcnyuQ==
=2HyU
-----END PGP SIGNATURE-----

--JbpSbCMiCLmwdpgc--
