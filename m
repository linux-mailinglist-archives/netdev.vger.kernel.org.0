Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF36455032
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbhKQWS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241020AbhKQWS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:18:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D854F61B3E;
        Wed, 17 Nov 2021 22:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637187359;
        bh=18kkfrg4AgOIt1mZK6Dedmf6SMs42bal/deXI6yPuLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vKhNq7Uk0AGaKm34w3Qhgetrs5Bq+0eEZlXqFRkOII8l0t70tvC4u2PLYKEIpai9o
         VaKqVCE68b9yLAIsZTJHLMe6S02IOuSUTCgLFXYCIveWbto1504Q7TEIKpRU9UN0pp
         BcVUtHlOCylmgbimSFqYTWdjcUooZKc8vSdqVV94OvSZ/OtOVZW/yyq9hffR/A/jpF
         JV+D+9futCUOGj3UUrXnf0yyNaWPQNJOTVvQebjxkapUd82om6Z0aD3+RAhVJVmXF8
         Oku+vfruHMaVoWBJ5vKel1NpjDcEW+2fMfl5l7CDjsBXSOBwKC/0FDQKF9ICyFXYJ6
         sG81BcVMUNFCg==
Date:   Wed, 17 Nov 2021 22:15:53 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: regmap: allow to define reg_update_bits for no bus configuration
Message-ID: <YZV/GYJXKTE4RaEj@sirena.org.uk>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/Q9YqCthrNTTr8b+"
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-2-ansuelsmth@gmail.com>
X-Cookie: I smell a wumpus.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/Q9YqCthrNTTr8b+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 17, 2021 at 10:04:33PM +0100, Ansuel Smith wrote:
> Some device requires a special handling for reg_update_bits and can't use
> the normal regmap read write logic. An example is when locking is
> handled by the device and rmw operations requires to do atomic operations.
> Allow to declare a dedicated function in regmap_config for
> reg_update_bits in no bus configuration.
>=20
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Link: https://lore.kernel.org/r/20211104150040.1260-1-ansuelsmth@gmail.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  drivers/base/regmap/regmap.c | 1 +
>  include/linux/regmap.h       | 7 +++++++
>  2 files changed, 8 insertions(+)

I've applied this already?  If it's needed by something in another tree
let me know and I'll make a signed tag for it.

--/Q9YqCthrNTTr8b+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGVfxkACgkQJNaLcl1U
h9Cu5Af/Zw71VW8AU+geoTpjR5nlUgdZQBHtrqEucSzknp7TE6Bb4IGYEwAmxfJ8
k62rok0LG6hGrkiujUd2TRBhGAEvoCOiwnnRzirGD++i+vl3sqYIyBr1kASLMppv
iL3vcGpgq/dtc71EEziurFzFPQy1pOe8MH2IVLB7FxAEFn3zZc0NlxYsDjKsFSZA
GymChTVLiQfyiKvVwR4QBPgpLiZLeW0BfFPqhWtydKuGxltnKH8A83Z5kPP/KBLA
9P4W1BSLXPXI2whoDyEGXl4ewJf4CzcwVjMDVZL/U3WirB2wJgdc42rtvMmho5Pk
gf8u47l9pDNPPTRVMJ0LTQQYLrtsqw==
=vOjt
-----END PGP SIGNATURE-----

--/Q9YqCthrNTTr8b+--
