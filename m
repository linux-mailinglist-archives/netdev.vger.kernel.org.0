Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB311BDF98
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgD2Nwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgD2Nwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 09:52:32 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0FD20B80;
        Wed, 29 Apr 2020 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588168351;
        bh=ytyUCCIGyI+obLrMHzKUGgdlqFzyE04ZtGFK91iRm3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJkD/zbF1yevejOPgDCxQVSXUwBW/PWbOWYpI/zUSqNEq2OM6x8+7V+spbjIyhxcg
         eN9lkO0ouItL2Ik+0MigJ11kTM7haS58xBWd4EqV2++KMVrtEELIMHeaJcxnFR2Ccp
         Bg/nUNm71ptDOwgsWg3HxAKyf3jcXK2iQLdS37HQ=
Date:   Wed, 29 Apr 2020 14:52:28 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] driver core: Revert default
 driver_deferred_probe_timeout value to 0
Message-ID: <20200429135228.GL4201@sirena.org.uk>
References: <20200422203245.83244-1-john.stultz@linaro.org>
 <20200422203245.83244-2-john.stultz@linaro.org>
 <CGME20200429134605eucas1p2bd601082e7a6b8c8fdbe79c83972e2e3@eucas1p2.samsung.com>
 <9e0501b5-c8c8-bc44-51e7-4bde2844b912@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="00hq2S6J2Jlg6EbK"
Content-Disposition: inline
In-Reply-To: <9e0501b5-c8c8-bc44-51e7-4bde2844b912@samsung.com>
X-Cookie: I know how to do SPECIAL EFFECTS!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--00hq2S6J2Jlg6EbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2020 at 03:46:04PM +0200, Marek Szyprowski wrote:
> On 22.04.2020 22:32, John Stultz wrote:

> > Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_stat=
e() logic")
> > Signed-off-by: John Stultz <john.stultz@linaro.org>

> Please also revert dca0b44957e5 "regulator: Use=20
> driver_deferred_probe_timeout for regulator_init_complete_work" then,=20
> because now with the default 0 timeout some regulators gets disabled=20
> during boot, before their supplies gets instantiated.

Yes, please - I requested this when the revert was originally proposed :(

--00hq2S6J2Jlg6EbK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6phpsACgkQJNaLcl1U
h9B9Ogf+MFUG/IZB61LkLCHnKhJON6xWRLosWtR73L7yE/rRElq2K/LdbZGCyN7I
EjK3VX1zEARY+I/ZQFGed1LNwAn9hMdFEVwqFv+PHOCC6hzJd+0O2jnbyUaC+3Bq
+Hg2vXWb9z9UXLyoXcPiz4B+1fLkS2e48lLf/ahWQfd+BZQpzNrpoZ3i+0Pt+Vqn
mXKIC9ZbFJtslUU6Gt6fz8DzseaPWMw0qPfdssdaG4EfNCP+UO4GtxVsFwnV2h/u
fYgUlXaMEwQJN0p+g6Qu/f4419vhBIqoDXRtqQ0Fc4tPoUif0qYSx/bEpK6No3ue
yv7+6TCSurJPLib9y1EXa60sVn/4Hg==
=4Efx
-----END PGP SIGNATURE-----

--00hq2S6J2Jlg6EbK--
