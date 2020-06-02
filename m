Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3770D1EB970
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 12:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFBKSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 06:18:45 -0400
Received: from ozlabs.org ([203.11.71.1]:59541 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgFBKS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 06:18:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bp0G5RS3z9sSd;
        Tue,  2 Jun 2020 20:18:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591093104;
        bh=ZET4MgvIpPMKIHa0fYOqkkJtKMPEakdjQFvGhLoITrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+iVADk6QZM7Zivp4nDSJkDX1kd/lfZs1UhUyzjntR7YRfzzHdIn1JEW+OxJ7sMo+
         UCP4jfYoMvWNhq0c2SnL+yTStcLqMhCX2VWSsb3DZrD2QNAi1YwQt6DcNIUh49oWeu
         4Vq7B6/h7obAOxrA6D8iV7LhHcup25bfmTUlP1UB+pPaPkzRSNnXTfnWMaiW59SJ3X
         5CO05J0tRD+9zdOl4jwYXD6y60kjl5HXKKxeMSgykEl7887qKVknaHUoSP5WnJdZLU
         20JLkbVSl/vIDj1hIyL7pHMeYab7YpWLK9spiP/ctHCd3+cJISUlTUOC4sq9T0Y9aE
         YB1EEdTde9zxw==
Date:   Tue, 2 Jun 2020 20:18:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        ayush.sawal@asicdesigners.com,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20200602201821.615b9b7b@canb.auug.org.au>
In-Reply-To: <8a8bc5f4-2dc3-5e2c-3013-51954004594c@chelsio.com>
References: <20200602091249.66601c4c@canb.auug.org.au>
        <8a8bc5f4-2dc3-5e2c-3013-51954004594c@chelsio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ND+BUl2Q9HOIVP/Ns1F4i71";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ND+BUl2Q9HOIVP/Ns1F4i71
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ayush,

On Tue, 2 Jun 2020 13:01:09 +0530 Ayush Sawal <ayush.sawal@chelsio.com> wro=
te:
>
> On 6/2/2020 4:42 AM, Stephen Rothwell wrote:
> >
> > In commit
> >
> >    055be6865dea ("Crypto/chcr: Fixes a coccinile check error")
> >
> > Fixes tag
> >
> >    Fixes: 567be3a5d227 ("crypto:
> >
> > has these problem(s):
> >
> >    - Subject has leading but no trailing parentheses
> >    - Subject has leading but no trailing quotes
> >
> > Please do not split Fixes tags over more than one line. =20
>=20
> I am so sorry for this mistake.
> Is there a way to fix this?

No, David does not rebase his tree.  Just remember for next time.
--=20
Cheers,
Stephen Rothwell

--Sig_/ND+BUl2Q9HOIVP/Ns1F4i71
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7WJ20ACgkQAVBC80lX
0GwlaAgAlaLxQRgMK8I1tHCvSBD0Nv3JoVCWDxfHytfAcNDzsuCrqQnD0AoTaOez
1/LfrGhTRyFjd1lKEF6fK0y0B4L/rvezGKiCNFATj25kyZnlz6B5OxATxj5bnZ7Q
7Ix6/Ee9HhgEKz2cLg0mxp/MD7Kfa5aSV/FOrji1SiruNLC9k6xVNlrAqSl+6B+H
+nMiv0j4f1hwHHxzTZWd1OxzfXq4qQ96xt7oGzCpOI2v9G85MyOtppf3/kdh7h0S
ZuN/8tsEnyvF8gbq94QrdjpX502coPeTMBU2/oHNBRL3B4N50bMtIRyu+WTUADAA
oqMF29Jz/L3SSshpZ7jK2C6I/PjJIg==
=RuNp
-----END PGP SIGNATURE-----

--Sig_/ND+BUl2Q9HOIVP/Ns1F4i71--
