Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A821C3670
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 12:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgEDKI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 06:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbgEDKI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 06:08:26 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A0320721;
        Mon,  4 May 2020 10:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588586905;
        bh=SEUEOqsjoer4k2pCLVUZGnBWrdTnfIZTUHr1uR6kYbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8qWgABDlen8Jac9q20c1YllmktbBgQLwXvc8TBGFNLZ2MO1yY4Ec1y361P0/V74B
         I1neWkTKuG7sNhzZqWsXbJ6hnkIKSKwGvLVKRk8tXi/nQ5Jmadvr9Uiykfd916GshI
         PbRZU1DH16iq28zmb1/RCo2z6rsKEhwjbInxx6VU=
Date:   Mon, 4 May 2020 11:08:22 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sandy Huang <hjc@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jyri Sarha <jsarha@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Olivier Moysan <olivier.moysan@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        linux-bluetooth@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH] docs: dt: fix broken links due to txt->yaml renames
Message-ID: <20200504100822.GA5491@sirena.org.uk>
References: <967df5c3303b478b76199d4379fe40f5094f3f9b.1588584538.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <967df5c3303b478b76199d4379fe40f5094f3f9b.1588584538.git.mchehab+huawei@kernel.org>
X-Cookie: My life is a patio of fun!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 04, 2020 at 11:30:20AM +0200, Mauro Carvalho Chehab wrote:
> There are some new broken doc links due to yaml renames
> at DT. Developers should really run:

Acked-by: Mark Brown <broonie@kernel.org>

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6v6ZIACgkQJNaLcl1U
h9Aaywf9G/ypPAVhxAZkzN0IYu6e43sydvSull/M+q3UIdY9VmDdIhUXVgXoOCOh
ltmOBr9lM8MTLi7nYRlTCsC7mmSE9EMyF3AlPAwCzT9Y9gffa33run0/3I2SDvJZ
pUXeobj10+FRhp4iWUSpCkUrMEO8SzGHVXCbLZBLUYkvPWdsaMchNpj2iuy/IIMg
TW9jzMHLeZGsGR/6OgEBbyKegSqC8r3BHT6xfLGtEzoji30kwnPAHvx2D75DBbHH
dMN+lrHBjpgpaLZWPYHVf5yVjqrH77LcpGqpvTdoP4ckdZZfHyu2ZmFZiyl5yXJV
56POKfO+q6cm0wiAfAZyg41Om6tanA==
=2+iq
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
