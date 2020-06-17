Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D9D1FC771
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFQHbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 03:31:05 -0400
Received: from ozlabs.org ([203.11.71.1]:34903 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgFQHbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 03:31:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49mxZH1WKhz9sSS;
        Wed, 17 Jun 2020 17:31:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592379063;
        bh=klSOmXdAG8xbHCOGkPZTgzGSr4iiKcDXqoKHVPsc3Fw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ctloyEHszdh4z5LULWzCov1inIK4hyGBfUxx02PhD3zLXNAwkELd0xbJSdm/jJSMR
         mkUPcFEYgt8b5UMiwq12Bhj2WIfAJ2BinDiNBKW1pASjkQTuy1tAprPf5YTSqZvv3x
         zR+QTSA1kIp7qHnF7s0Q5CqCchH9OuvmL6G0MS0wi3lLnr41NNqPH5KS9ZmZswZ8Zg
         QIo/dFqcykV2nzaAlb7F30BIKFgwp3Ok2wqWL0vNd8vyGDdw24yD5PQ68jP+xvi2sm
         E9ggrURFJbyPuFDG9z3YZ1VPE+EVQ4LvnQY/9oUKAOMtoTXmW/yNrBXPLJeNQkLNP8
         ZnEy5FGNMQthQ==
Date:   Wed, 17 Jun 2020 17:31:02 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200617173102.2b91c32d@canb.auug.org.au>
In-Reply-To: <20200617070316.GA30348@gondor.apana.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
        <20200616103440.35a80b4b@canb.auug.org.au>
        <20200616010502.GA28834@gondor.apana.org.au>
        <20200616033849.GL23230@ZenIV.linux.org.uk>
        <20200616143807.GA1359@gondor.apana.org.au>
        <20200617165715.577aa76d@canb.auug.org.au>
        <20200617070316.GA30348@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iy7rzYSZF1PbC4yRJ1Z80v6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iy7rzYSZF1PbC4yRJ1Z80v6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Wed, 17 Jun 2020 17:03:17 +1000 Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
>
> On Wed, Jun 17, 2020 at 04:57:15PM +1000, Stephen Rothwell wrote:
> >=20
> > Presumably another include needed:
> >=20
> > arch/s390/lib/test_unwind.c:49:2: error: implicit declaration of functi=
on 'kmalloc' [-Werror=3Dimplicit-function-declaration]
> > arch/s390/lib/test_unwind.c:99:2: error: implicit declaration of functi=
on 'kfree' [-Werror=3Dimplicit-function-declaration] =20
>=20

And more (these are coming from other's builds):

  drivers/remoteproc/qcom_q6v5_mss.c:772:3: error: implicit declaration of =
function 'kfree' [-Werror,-Wimplicit-function-declaration]
  drivers/remoteproc/qcom_q6v5_mss.c:808:2: error: implicit declaration of =
function 'kfree' [-Werror,-Wimplicit-function-declaration]
  drivers/remoteproc/qcom_q6v5_mss.c:1195:2: error: implicit declaration of=
 function 'kfree' [-Werror,-Wimplicit-function-declaration]

They may have other causes as they are full linux-next builds (not just
after the merge of the vfs tree), but the timing is suspicious.
--=20
Cheers,
Stephen Rothwell

--Sig_/iy7rzYSZF1PbC4yRJ1Z80v6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7pxrYACgkQAVBC80lX
0GxVjwf/fgDfnHpg2j8ykmXdJku5O9ABCw5fN759sVp+t0d7HDMEOB4R9diqU2lP
2ZWPKYtzEnVwAI334hbCZ8WVk2sJJpnaplWpHP6wIpQGxNZ6ykxTuiJu1lwkgTi8
lLu2iVRj6BUdTPD5ERnCk2upyM0s3GLVKxVIdHHQeCiK+1p+iC7yNUMFpQqJeE4z
CFOASpaOv/otkbsVjOuvZZuFu6O/RASv70KmRsKrImpYztq4i8xv3DsSA8oYjlMf
UiGBacdeu+O3R1uFmFAKodCCeV68VnXqc0USF8On/NQyVW1MLYytXLzMPu6n+jy1
goMiTp0d9lF4MG+7NtrSfMNJfJwy8A==
=p/Bi
-----END PGP SIGNATURE-----

--Sig_/iy7rzYSZF1PbC4yRJ1Z80v6--
