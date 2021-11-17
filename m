Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87871455096
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbhKQWgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241389AbhKQWgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:36:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0FE561B5F;
        Wed, 17 Nov 2021 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637188415;
        bh=TK+XD16u7cr6iJKdvQMk7Axtk7gXReM6Z3titsT9zzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DnEfdCTQCBa3GoPL5SGFdkvuuk/fnSgNAY1+uftL8bCXiIO9ibhSoqw1EWk1xLWMx
         8dGYXHKAFKQRLIUhXlsQCunI6e3cyfDj61hUXPMWBajKoG0vdeqPp34mTuf992fBMx
         stNTJbQ9CrCKsm6mjmLZaWJ6qsncrCvTgaDrwIzvmUqsuJxqT75S3jVQGmGstc6s1Y
         ouN8vfBSJxpP6D41sQY71YxXKceqvI2lniokhMuKuwpVVQyXE1kGkwMKUiKEU0vHMw
         ESCr6ianwNcymVkvHzkLEPLlfHgDk6rImTHzf+en5f1KAbMu8kT/enn2er/w82U3GZ
         yH7wZzg5J+HTg==
Date:   Wed, 17 Nov 2021 22:33:30 +0000
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
Message-ID: <YZWDOidBOssP10yS@sirena.org.uk>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-2-ansuelsmth@gmail.com>
 <YZV/GYJXKTE4RaEj@sirena.org.uk>
 <61958011.1c69fb81.31272.2dd5@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Bp6B0V8vyfWbpphh"
Content-Disposition: inline
In-Reply-To: <61958011.1c69fb81.31272.2dd5@mx.google.com>
X-Cookie: I smell a wumpus.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Bp6B0V8vyfWbpphh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 17, 2021 at 11:19:39PM +0100, Ansuel Smith wrote:
> On Wed, Nov 17, 2021 at 10:15:53PM +0000, Mark Brown wrote:

> > I've applied this already?  If it's needed by something in another tree
> > let me know and I'll make a signed tag for it.

> Yes, I posted this in this series as net-next still doesn't have this
> commit. Don't really know how to hanle this kind of corner
> case. Do you have some hint about that and how to proceed?

Ask for a tag like I said in the message you're replying to:

The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:

  Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-no-bus-update-bits

for you to fetch changes up to 02d6fdecb9c38de19065f6bed8d5214556fd061d:

  regmap: allow to define reg_update_bits for no bus configuration (2021-11-15 13:27:13 +0000)

----------------------------------------------------------------
regmap: Allow regmap_update_bits() to be offloaded with no bus

Some hardware can do this so let's use that capability.

----------------------------------------------------------------
Ansuel Smith (1):
      regmap: allow to define reg_update_bits for no bus configuration

 drivers/base/regmap/regmap.c | 1 +
 include/linux/regmap.h       | 7 +++++++
 2 files changed, 8 insertions(+)

--Bp6B0V8vyfWbpphh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGVgzoACgkQJNaLcl1U
h9BOEgf/aFW4fBTWA2tY0O4vTXJz7IhnZSL1UEwHyCOH4W5rIu4zGJxoNq2OZnij
LjdheZTu63J9sjMkgIvFMrLE597/z6QEqQMS6fG0961xJBAXJZIPiBLeCnUw7PY5
fnPzHbbQtYfL4QFEr+hRRAuwFjZP4tLEpqBNWREQdPS3C4sfZJWP/RnfVodqYF7H
6fI87LEehosQA34P8kyTKmf4yFi6Pu1wGo/yucfwUDPOoZOZzvr6Ywi+abBEZ1Cu
DkAaWNvJCpacvaRW4QjZLR3E5yt/X3xJcF7q+Sk1j2FpN+2/dFuK4+Dat23XEQOL
LyMrUjUhwzvhvOkqxLYZzruitHC+Hw==
=7vmY
-----END PGP SIGNATURE-----

--Bp6B0V8vyfWbpphh--
