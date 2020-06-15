Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481421F95DD
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 14:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgFOMB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 08:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbgFOMB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 08:01:28 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB9B20679;
        Mon, 15 Jun 2020 12:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592222487;
        bh=bckLxMEKq0w5/9SzJe+n69vU2/hXF7ff/hu/a17+8+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYy9uvJD0PYRI2p3DwIotJOPqtgow49a6afHPJvsWcuBY0yjMd4cMirM6pN9r8hnW
         bAuNvqGDTjO1PYNVybPD0JTt0QO17WOahY67f2Xbvv7ksMXm+vjQWpUNkhQeWo72XL
         h9meg4DTVT4OxdC2+kMDmPK4hWvZvLhU3rIlMDWM=
Date:   Mon, 15 Jun 2020 13:01:25 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Sandy Huang <hjc@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        linux-bluetooth@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH 13/29] dt: fix broken links due to txt->yaml renames
Message-ID: <20200615120125.GJ4447@sirena.org.uk>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
 <0e4a7f0b7efcc8109c8a41a2e13c8adde4d9c6b9.1592203542.git.mchehab+huawei@kernel.org>
 <20200615111927.GC4447@sirena.org.uk>
 <20200615135739.798f4489@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="va4/JQ6j8/8uipEp"
Content-Disposition: inline
In-Reply-To: <20200615135739.798f4489@coco.lan>
X-Cookie: Offer may end without notice.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--va4/JQ6j8/8uipEp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2020 at 01:57:39PM +0200, Mauro Carvalho Chehab wrote:
> Mark Brown <broonie@kernel.org> escreveu:
> > On Mon, Jun 15, 2020 at 08:46:52AM +0200, Mauro Carvalho Chehab wrote:
> > > There are some new broken doc links due to yaml renames
> > > at DT. Developers should really run: =20

> > I also previously acked this one in 20200504100822.GA5491@sirena.org.uk.
> > Has anything changed here to cause the ack to be dropped?

> Both patches are the same. I forgot to add your acks on my tree.=20

> My bad!

Ah, no worries - no wonder I couldn't spot the changes!

--va4/JQ6j8/8uipEp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7nYxUACgkQJNaLcl1U
h9AlAAf8D93i17Pj7T800BmwJ3UUHzaiQeRYZFSyfjkXbmviTRnh3rTP+7Rx/Rqe
83+UeFeMR/Rn18FzLvpCjXuZ1LTbEsOj7/3vkvecKW+LQy/oHwTsTr09Im4vI0h2
9r3wxGGCXOU+EPu2c9ZT3j+Sp9yhWheTN0ym70YLHDtJuat1Bjw96kBQF8vpo1d9
AGTB8NOjhstg/4Z+dZYlx5NhdbG4f5qV9zkkVGyZJ1xcdrgs60KfolFrCfTtUG2X
qRm7RhGf/Rum0bhUG8lvkRaJGz9+Wh9eQA3JUHItfxFEvpM1scwlHJrBTxo7fP9y
ytZ9j2PBRG+rP5iCMbibBf7cKbhhMg==
=xi26
-----END PGP SIGNATURE-----

--va4/JQ6j8/8uipEp--
