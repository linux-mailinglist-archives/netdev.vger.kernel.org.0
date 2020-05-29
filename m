Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76901E8429
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgE2Q5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2Q5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 12:57:40 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BDFD2075A;
        Fri, 29 May 2020 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590771460;
        bh=HWaJ8knx8jrtX7vWoPGCCZuj0FJ8BoiCzWy4GdgYnO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCbzduRgjSFdejSVXTKyb4aBGbgxLCd3Zu5BI/JY6FwKuB36l0/z0zq0mmYi3rqT/
         Lb+edgaa5BiCvyMhhB0TfzqinNJ1U0wHVILwbpMBlYrsfua9zE7rZehF/YRotogZb5
         RFAmWgO1nSn3av8C6YbepQw1oVnNsKgErWaOSO0A=
Date:   Fri, 29 May 2020 17:57:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>
Subject: Re: [PATCH v3 0/2] regmap: provide simple bitops and use them in a
 driver
Message-ID: <20200529165736.GO4610@sirena.org.uk>
References: <20200528154503.26304-1-brgl@bgdev.pl>
 <159077110913.28779.5053923375043778782.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gqEssfNGWsEa4HfM"
Content-Disposition: inline
In-Reply-To: <159077110913.28779.5053923375043778782.b4-ty@kernel.org>
X-Cookie: The Killer Ducks are coming!!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gqEssfNGWsEa4HfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 29, 2020 at 05:52:00PM +0100, Mark Brown wrote:

> [1/1] regmap: provide helpers for simple bit operations
>       commit: aa2ff9dbaeddabb5ad166db5f9f1a0580a8bbba8

Let me know if you need a pull request for this, given the merge window
is likely to open over the weekend I figured it's likely too late to
apply the second patch before then.

--gqEssfNGWsEa4HfM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7RPv8ACgkQJNaLcl1U
h9Csowf/Yd4cPlSB5f6vZznQyt6ZA4E9LGl+xUJ0HP+QooGqUbPwRV29fAMfSDUY
rWXfSQzj8EtTBt9ukCNQLMrmsHZ8EYqD+YC2E3j7yxXtdYknq9rg4vUPXaie/X1S
D40fyHEDaMDKwk469zZbJJavMooYstd6PEkPTFSiOy6jN5X/asm1bYUH3JEJCXp+
l3b6FlrXH+RChM75PPhzNZD8GpMdXUzBUIbWwvFErM3I8OcVoLJKHHhSX7hW9fDu
Zb+jZtjHDBCfVzauWnwt1drGsDCHCAD+QXLAaMty1KJMa9+00P2fMv++2JICI0Qe
IhTFLfPiVmMkifKoF1wf6TFbu8jN1A==
=2xIa
-----END PGP SIGNATURE-----

--gqEssfNGWsEa4HfM--
