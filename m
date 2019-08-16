Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C094901C8
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfHPMjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:39:22 -0400
Received: from ozlabs.org ([203.11.71.1]:37755 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbfHPMjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 08:39:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4692v90yfSz9sDQ;
        Fri, 16 Aug 2019 22:39:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565959159;
        bh=BViRoTUOAfG+pYpx8zNplnOf0mFkjZ2oGDklRG/VWIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aW9RsszNHcmOQIoQlpVO3Q0a2krBJN0PJaQQQfGQKg9xmkAq5ppFud5qbPiV7GO0p
         ObixDABG2hCmyVK/c4OrF5WSAFtjHm1aKIu0CZgfWVf0Q8WXrDa3e1Obmx3VngM8Tr
         13srGruUtxDdL4vFWGjxnnbUndCcCB534qwSybQy8Qwl+xHEYTQVZyllS7992p83Ia
         w5M2BXZNTQI+YMGvbcFxHPhsRTGFQVu8nXauRNo9SHV+yQG0rUuqu/oSmcb1rIGEoh
         gOZeAxlaO0ZHlJYuwVI+a+PCOAoiJoZhcU/oOYQOYCr0fshidtxvjMCG8s29vYP7O9
         /P3cwxeswgQ+g==
Date:   Fri, 16 Aug 2019 22:39:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: linux-next: manual merge of the net-next tree with the kbuild
 tree
Message-ID: <20190816223914.1cc64295@canb.auug.org.au>
In-Reply-To: <20190816160128.36e5cc4e@canb.auug.org.au>
References: <20190816124143.2640218a@canb.auug.org.au>
        <CAEf4BzY9dDZF-DBDmuQQz0Rcx3DNGvQn_GLr0Uar1PAbAf2iig@mail.gmail.com>
        <20190816160128.36e5cc4e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/spNxyuS=dKTRE=B2ygqtFmd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/spNxyuS=dKTRE=B2ygqtFmd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 16 Aug 2019 16:01:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 15 Aug 2019 22:21:29 -0700 Andrii Nakryiko <andrii.nakryiko@gmail=
.com> wrote:
> >
> > Thanks, Stephen! Looks good except one minor issue below. =20
>=20
> Thanks for checking.
>=20
> > >   vmlinux_link()
> > >   {
> > >  +      info LD ${2}   =20
> >=20
> > This needs to be ${1}. =20
>=20
> At least its only an information message and doesn't affect the build.
> I will fix my resolution for Monday.

I also fixed it up in today's linux-next (just so people aren't
suprised and report it :-)).
--=20
Cheers,
Stephen Rothwell

--Sig_/spNxyuS=dKTRE=B2ygqtFmd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1Wo/IACgkQAVBC80lX
0Gyz4Af/ewkkUYxT3pvXClY2luiHNEx7ic7jT2jK8sY6lPKBYWVFi6DDOBe5np3u
bWiiA3RaZBDnCts7mw/mfS2NJTRrza51FnjQeVIPHucqlUt8L5sjDorBSwS6Rgyh
TXTXXQVer6Fldf9dm+5WoVgUDys3DUIrKtSMsQ+iKWQRykiaaHWgKDz8is250Z+v
FX7eQ27AwYnl/eTsTAOf65gIDekjDauaJnbljKBl1jIOxC/5VEmU0YFXrKCP4nnU
cHNsvPruzO+d1+0sTapb2MiEGpndV3m4HlvaB705hJaLmI3E0Jtu/d+3zX3rQDkr
VYZ7Ug24gl+wJClrOC1c0WzpdIv0vg==
=E/fG
-----END PGP SIGNATURE-----

--Sig_/spNxyuS=dKTRE=B2ygqtFmd--
