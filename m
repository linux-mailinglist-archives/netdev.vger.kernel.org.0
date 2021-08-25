Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B6B3F7252
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhHYJx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236405AbhHYJx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 05:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBE561153;
        Wed, 25 Aug 2021 09:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885161;
        bh=k4qW2MGVv6lsjTMeqsBszx1sWAWurkEnyKnzQikbJaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fiSY+43j4Yih7SIz3JeRfD7Rgrum1vl+IBCXizvIdRvKFNbHORmNquKph2O/mZFRh
         nfnkwO0kk+g94JiI/lke5bRCFWyWnrIK2d4F+V7PIa8e93uvD2jszET7/qYhjEfpdo
         6RVHYPzGKhojaacCwIneU6t45qN5FSjx/KJ0r6uhLXYutK6/mb6n2iw/s5fKCVVIkJ
         3t5qOjE/JSk0EW0Pu3xauaJjN5JX2mdk9BD9Md6HwFdcwryA36HC+f2ttCR0T4Sz2c
         6zX+eNo+YOTQblU2vYu91g/NBewiko35f4e1YrxSY9K6jEkVvIFv7SueGGGs6gGvSf
         VxQUkq1/zAe6g==
Date:   Wed, 25 Aug 2021 10:52:14 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] kconfig: forbid symbols that end with '_MODULE'
Message-ID: <20210825095214.GA5186@sirena.org.uk>
References: <20210825041637.365171-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20210825041637.365171-1-masahiroy@kernel.org>
X-Cookie: MY income is ALL disposable!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 25, 2021 at 01:16:37PM +0900, Masahiro Yamada wrote:
> Kconfig (syncconfig) generates include/generated/autoconf.h to make
> CONFIG options available to the pre-processor.

Acked-by: Mark Brown <broonie@kernel.org>

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEmEs0ACgkQJNaLcl1U
h9Aq4Af+OUuZSvmzbZyoTGGCofB/L+N5Ehn/9iHBJTZBr46S9ip0Zv7RZXiHqhtu
yJO2Gq1P6j1xVYtqqPCDOvNgaeEghTvLtpukroOGR/uA/S21Xobqhy6F3Tb/jrPm
KTrf5LWtRKS0I2sxbgteQRvOOjPIELQv8Lr0Y2ykO+yL+UEtNDJH4OsuNdXhdbh5
t2jZ7OgZ/Ot/6AB78YWbaZTZZHqfGM/jzeUpWG6kCdItSPXam0Q5LyYheMGn7MBb
6zAG6O+2Napi31AkH6Pyx18+hzh4XhnBLSX9ZPNP8ZM5iRQZjLHt1sYdukoFEATI
zkcxGg7hM8LCp7KGuyMcTafl0ikf4A==
=yeET
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
