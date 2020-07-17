Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20076223B4E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGQMWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgGQMWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 08:22:21 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB91820684;
        Fri, 17 Jul 2020 12:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594988540;
        bh=J1Qt3Lw28H9tRlMCjTFWuJ09Pp5bPH/VYq8pbZMeEGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZg5ba3M7HTo/BL5R2W6pSAW7PllQcfqW8aFdAOarRZ7DLNXyk5Oj0PHLN+VCQX2h
         q3uf68VE9AUxzajSmsN202GOx4mTbFJmPs5YIy9ULnckxHYoKrFfB3QD4iuNza9Ben
         A8KTxVxAzC3bjpYziEm0coq8ezKTAhI/fuiSabdk=
Date:   Fri, 17 Jul 2020 13:22:09 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 14/20] dt-bindings: spi: renesas,sh-msiof: Add r8a774e1
 support
Message-ID: <20200717122209.GF4316@sirena.org.uk>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200717115915.GD4316@sirena.org.uk>
 <CA+V-a8sxtan=8NCpEryT9NzOqkPRyQBa-ozYNHvi8goaOJQ24w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
Content-Disposition: inline
In-Reply-To: <CA+V-a8sxtan=8NCpEryT9NzOqkPRyQBa-ozYNHvi8goaOJQ24w@mail.gmail.com>
X-Cookie: No other warranty expressed or implied.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 17, 2020 at 01:15:13PM +0100, Lad, Prabhakar wrote:
> On Fri, Jul 17, 2020 at 12:59 PM Mark Brown <broonie@kernel.org> wrote:

> > On Wed, Jul 15, 2020 at 12:09:04PM +0100, Lad Prabhakar wrote:
> > > Document RZ/G2H (R8A774E1) SoC bindings.

> > Please in future could you split things like this up into per subsystem
> > serieses?  That's a more normal approach and avoids the huge threads and
> > CC lists.

> Sorry for doing this, In future I shall keep that in mind. (Wanted to
> get in most patches for RZ/G2H in V5.9 window)

If anything sending things as a big series touching lots of subsystems
can slow things down as people figure out dependencies and who's going
to actually apply things.

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl8Rl/AACgkQJNaLcl1U
h9DhTAgAgzuxfwIeWNm0FDyt+K9Mfz5di6xytCvItNaaahcI/Ct9HEQCGPpgG+SN
OegozumTbxf+HvdgEgg2JsMqKfoCid7/F/M/ywb24/SqHnpgIIKBA7U6bRF2PGMW
JHXG/oHSBd5yyV6xurj6YfaJidh9KJO5afRb8yisffI8ge1n+X7F2GQZyWke45cp
Ojag6elp7xYrRwC3ylAp2exRsoSw5SXYwqM4CNkrDEiXq1dKeePsm2vuxf6FmE4n
WclrCd+/9oWAk7dIoJTBX4BxBudcZlk25Y55Q6GyA/bbGMBWef1vWvUNasjQef0d
e/mSTsDdN+0RD9lg1rJ0RqtyHnDPhw==
=mPyM
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
