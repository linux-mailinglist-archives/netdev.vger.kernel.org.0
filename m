Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD7F1E8439
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgE2Q7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgE2Q7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 12:59:55 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028DB2077D;
        Fri, 29 May 2020 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590771594;
        bh=SgCTW71aJiZP9m3FKPSpV5GzwDGTraBIw7v6AEea32s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E9lOjE5obdmia7otNj4UI41jeTSNtXtPsZc8Cqo6Uu2grGXTJN91nDIiaPk62Hgc4
         P3Qb4Siq6Nhhbf5BGNhUo1rhnYNROxtCGxZjQ2jcXMGvcVPERntYsP5sgSnHlEvTC7
         vfvGZPXy7rl8EWtUQ5kIDany8SBkYN7rJtoQPvoo=
Date:   Fri, 29 May 2020 17:59:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     linux@armlinux.org.uk, claudiu.manoil@nxp.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        netdev@vger.kernel.org, fido_max@inbox.ru,
        alexandre.belloni@bootlin.com, radu-andrei.bulie@nxp.com,
        horatiu.vultur@microchip.com, alexandru.marginean@nxp.com,
        UNGLinuxDriver@microchip.com, madalin.bucur@oss.nxp.com
Subject: Re: [PATCH net-next 00/11] New DSA driver for VSC9953 Seville switch
Message-ID: <20200529165952.GQ4610@sirena.org.uk>
References: <20200527234113.2491988-1-olteanv@gmail.com>
 <159077110912.28779.6447184623286195668.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5AmtYbcgdBTTPS58"
Content-Disposition: inline
In-Reply-To: <159077110912.28779.6447184623286195668.b4-ty@kernel.org>
X-Cookie: The Killer Ducks are coming!!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5AmtYbcgdBTTPS58
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 29, 2020 at 05:51:52PM +0100, Mark Brown wrote:

> [1/1] regmap: add helper for per-port regfield initialization
>       commit: 8baebfc2aca26e3fa67ab28343671b82be42b22c

Let me know if you need a pull request for this, I figured it was too
late to deal with the cross tree issues for the merge window.

--5AmtYbcgdBTTPS58
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7RP4cACgkQJNaLcl1U
h9A+nQf/Smy5iBPsXtHhDQ3oVrP4+AgVMbi+yKzT3cO2wJ2+ovNyGSPZ9QGSnKLq
T/Ls95nPibi3p3Bjlbuo4PqS7FaQ4PFtF4w37mxUurGJYhfVti/Rd0A6xti4HqW3
aUK/AlhwXCaHbIH/yWd8jf5j7eT6Er/QqrUC6KaH7ZFfx+E9rwM8pcOrTZvrnWJt
6W4qAuR4ZpA0mmsRFA950D7sS6AGg7uAoqR/rGZSCXWAEV4uro+eSxfJTZ2KDN1Z
nIRGJ6M3TIUlNUZaHuubLAmqZCAjy6GBBSDDmrO3nIOgGJWaei98utqww5boC3w3
sIVDluT4gfuOhoV1ir9451AS7VXB5w==
=NKvw
-----END PGP SIGNATURE-----

--5AmtYbcgdBTTPS58--
