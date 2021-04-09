Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFBB35A598
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhDISRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhDISRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:17:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA3346100B;
        Fri,  9 Apr 2021 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617992222;
        bh=0jPzMEGM0f8cnlSy+snpfA8H7Bl20KBPP6k1D4APmQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fv+IdUwvlWRD4p/GB2s4mSpdf2EHhnfCR56c0QNSrcJ5uNdgaSZeuq9jFsG+mUeOt
         Mv8YznDKJGR4QCwutft7ziLexiEC7rRozuNvfpufgLhkd1Dn00YL5Znj3QeBZZI0CW
         kXY/UPpQPzTZJGCk+01Vjga4rPkQGHsMJSNWNuEkZVnxCjdJs+g/8dW7jEejDhQl2S
         gVoDfpIH352HWOTT56XFs6gscsJj5VoPAS6TsvJZXL2grbvzITE+/0hfPc8oeEESv2
         o3nkipl1i4YwNw5cD6/cIb7u4yRK7JI1/usniYivfTZ0ijY1Qb6BgSqIuwQvCbyF9P
         tPS5T9fOFrXTw==
Date:   Fri, 9 Apr 2021 19:16:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com
Subject: Re: [RFC PATCH 1/2] regmap: add miim bus support
Message-ID: <20210409181642.GG4436@sirena.org.uk>
References: <8af840c5565343334954979948cadf7576b23916.camel@svanheule.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
Content-Disposition: inline
In-Reply-To: <8af840c5565343334954979948cadf7576b23916.camel@svanheule.net>
X-Cookie: I'm shaving!!  I'M SHAVING!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 09, 2021 at 08:14:22PM +0200, Sander Vanheule wrote:

> The kernel has the mii_bus struct to describe the bus master, but like
> you noted the bus is generaly refered to as an MDIO interface. I'm fine
> with naming it MDIO to make it easier to spot.

Either mii_bus or mdio seem like an improvement - something matching
existing kernel terminology, I guess mdio is consistent with the API it
works with so...

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBwmgoACgkQJNaLcl1U
h9DmFQf/T45AVkUo1q5KLZbUs2WVXsi4M+PcQ9H60g5E6IDG4Bg+BqZ9FUcjejVB
cGctze0AXuA3bWHbrNpRi2f2Wi4ui2HXsJZBUq1i1ECtH+hA4x6A1DQLcfzk/z0x
SLeEwwmlRFmtv5p0l3ZEt5kDYRIlKgKqxJspaixVGbp5YDTQROTvGO5tMqqLFeXr
HVK6bZSfgjCWj0ccrBU6weP6QwyyPSohedX6F27SPhkRDVAx535Q1gRQGUnbij5q
fViGDiei456YrJ9ZZVlg55XDyA54ZpaxxLJ5VvQ3yam4fS5HkBM3rCXTf+E/6kwQ
VBr7Rkk0nbi9utZLfwMl7sL0oZcspA==
=UK/C
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
