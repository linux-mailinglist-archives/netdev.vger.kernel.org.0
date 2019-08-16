Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31D38FA94
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfHPGBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:01:33 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53829 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfHPGBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 02:01:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 468t4860Hnz9sDB;
        Fri, 16 Aug 2019 16:01:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565935290;
        bh=OeeJGI9inIBhfS6RIGTOT5XHhVqxRQStz6U4WyUU+CQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LBscnaUyCTTZQR0o+uCECbbzsbwM6Rq6hqOZenZNLBGamJIemk81CsXRzg8lSrJ5R
         ODrRV89t8GbaEonxGDdFnEUrGFnvm7IeWnPWLnjNu3nJVHI0jfuSDrTJsle8a9Uujq
         +1EXW/B7AhNfmbnI9x6ZfsKaHGVbA6ggXtZMCha4RXsKiIYzRjEJKjy4LC0AXiDCQz
         JT3cBz8m0lHSxlKQw0kT6Dj3qCYpLBlJgobj5wu/0//gNxSsaVaREJat3Mzp1jkm2T
         WAjBxY2TdVN0LgH7TpCV59WvegY2hi1H+34ywT0v7LHCRePYuc+7fPwuwxlJPBrZWI
         zaKtrj3immeaQ==
Date:   Fri, 16 Aug 2019 16:01:28 +1000
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
Message-ID: <20190816160128.36e5cc4e@canb.auug.org.au>
In-Reply-To: <CAEf4BzY9dDZF-DBDmuQQz0Rcx3DNGvQn_GLr0Uar1PAbAf2iig@mail.gmail.com>
References: <20190816124143.2640218a@canb.auug.org.au>
        <CAEf4BzY9dDZF-DBDmuQQz0Rcx3DNGvQn_GLr0Uar1PAbAf2iig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fF964hQqfEz/QhjhVQDvId8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fF964hQqfEz/QhjhVQDvId8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrii,

On Thu, 15 Aug 2019 22:21:29 -0700 Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
>
> Thanks, Stephen! Looks good except one minor issue below.

Thanks for checking.

> >   vmlinux_link()
> >   {
> >  +      info LD ${2} =20
>=20
> This needs to be ${1}.

At least its only an information message and doesn't affect the build.
I will fix my resolution for Monday.

--=20
Cheers,
Stephen Rothwell

--Sig_/fF964hQqfEz/QhjhVQDvId8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1WRrgACgkQAVBC80lX
0GylkQf8C8W6JHqojMWEN7wUR3oywhqPY24LCDP4wu0FBftaMAAecEsy2baw9zZp
WhgOW4wgZ6n/tUmFYTA7n/vDQW1d3UMQX9O+WSgMHESin+GaktO+UOhQf3i+d8Vd
F0pOgwjJGUpapl28oCg664agT+ps/K5aguj8RnyDMdOtYsCbNdf3VLv4PZOgVL3D
4Br5nDEUE0tD4h9JZ283A8Lb6/ZGn0H5KRyQdgs5yQfnpUuHCNp2wTxxVIC9ZChz
WQjmkH83/JAJFVY/tT1xDMzSsfAC+wdk7TyT0QfXd0/ClLwC0mZMVHRs0V6Wz0af
HHN2cgbPu7Ol5x7ls59j0P3BvsM64Q==
=+cb+
-----END PGP SIGNATURE-----

--Sig_/fF964hQqfEz/QhjhVQDvId8--
