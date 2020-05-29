Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E771E84F7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgE2Re6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgE2Req (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:34:46 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EACC6207BC;
        Fri, 29 May 2020 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590773686;
        bh=Tj/FiXm9L46xIAj+p6XUnNDSmgbZDNg7hmK/iOpJGn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gmRxWwulTJ5xCRnlQS2kj5Vz7xJempByuTtdjQ+9XyT4a96FAW9LYS9SziACP22tg
         /nVFs9BbEz73JbCpwHypssGqdbfHDZJ8B7QWS7AB6YccZHzB+IeG2PLjYmRfremCVI
         JttCAb0EK5SLeBtW2S7o9bkVag5t1LuZ+0oqSVfw=
Date:   Fri, 29 May 2020 18:34:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>, fido_max@inbox.ru,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        radu-andrei.bulie@nxp.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Subject: Re: [PATCH net-next 00/11] New DSA driver for VSC9953 Seville switch
Message-ID: <20200529173442.GS4610@sirena.org.uk>
References: <20200527234113.2491988-1-olteanv@gmail.com>
 <159077110912.28779.6447184623286195668.b4-ty@kernel.org>
 <20200529165952.GQ4610@sirena.org.uk>
 <CA+h21hqV5Mm=oBQ49zZFiMbg6FcopudCxowQcTwF-_O_Onj81w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ABd7dauUP597Mpr3"
Content-Disposition: inline
In-Reply-To: <CA+h21hqV5Mm=oBQ49zZFiMbg6FcopudCxowQcTwF-_O_Onj81w@mail.gmail.com>
X-Cookie: The Killer Ducks are coming!!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ABd7dauUP597Mpr3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 29, 2020 at 08:28:01PM +0300, Vladimir Oltean wrote:

> Thanks a lot for merging this. I plan to resend this series again (on
> the last mile!) during the weekend, with the feedback collected so
> far, so I'm not sure what is the best path to make sure Dave also has
> this patch in his tree so I don't break net-next.

That was what the pull request would be for, though if you need to
resend the chances are it'll be after the merge window before it gets
applied in which case he'll get the patch through Linus' tree which
makes things easier (that was part of the reason I just went ahead and
applied).

--ABd7dauUP597Mpr3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7RR7EACgkQJNaLcl1U
h9DF7gf+OPqQRKaMNkIEhfuQ5+UqusGSWqLS3pNVrC2PmLmYiW3UiqqrC0bPm8Oz
u43W1ootfjGrnkqHGm0BojfNK2ldpe3dfrbtYf8Cm+TWWWzK7G+Gd5x6MEeKugBV
D1AQynBY9t0Mmaq0R+zstjLBK1jAcDOaBR+/8YMyAsklMngVDVkOgXX9QgQfRL9d
op2xEgzH0viAfo+tiEA0CGKpnIJcFOHuLfE0KFCyjAiPiG79eOMOLMt857qVo52j
XEwy33biJ7ooMFZSyqWRL1aM31k6rO3GKFo0C+fJYq3Q6lIpGwvZL7e3EHHEDGzv
t8lCGmDYWek1n0doYi8f2mIY6wbOBQ==
=N7bK
-----END PGP SIGNATURE-----

--ABd7dauUP597Mpr3--
