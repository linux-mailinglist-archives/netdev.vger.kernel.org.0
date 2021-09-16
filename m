Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6685440D987
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbhIPMNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:13:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35977 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239110AbhIPMNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1631794321;
        bh=7sztpVLHF3xzQJBZaKGK0+5UlIXFQCYGKYPDrXPda+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePagv1MZ186VTzn8ozXg3BM7J2UvTGuG/1vYvB99Y0gML7e/XpMrjzrRPhn/EKOZz
         +M16vTA/IJudxGA+KRBA0Xzudjg1+YmLeiuEKRxGBJgasr/PgMFll6lZuS8x+D1/Nr
         enM8O6UaYVXFredz/yu6Gw4yAwsNmGLHq1jzupr+6sKPuUmKdFpUgB+WmCPUzn8nmY
         8umAndZ8r9iruOOSKU6ZrzFPkwKogVsCTztjifsWFd+GsZ4kyM94l8VzzeOdYJ+3LI
         Pyn1z8nhlc3gVaAERqnlAMBXscyLeOPoPvC44LgJ7yDZTmh5GrOpX8a0dlVfViTyub
         W240okspa9uwg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H9GD02n62z9sXS;
        Thu, 16 Sep 2021 22:12:00 +1000 (AEST)
Date:   Thu, 16 Sep 2021 22:11:59 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210916221159.7a495aca@canb.auug.org.au>
In-Reply-To: <CAK7LNASCbVJ0EYoGN8iz+yskpHUuR_PZnePUUtgJu9UZqGW2cg@mail.gmail.com>
References: <20210914121550.39cfd366@canb.auug.org.au>
        <CAK7LNASCbVJ0EYoGN8iz+yskpHUuR_PZnePUUtgJu9UZqGW2cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mzcw7ryvAFRIOGzBw.57AtL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mzcw7ryvAFRIOGzBw.57AtL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Masahiro,

On Thu, 16 Sep 2021 18:03:26 +0900 Masahiro Yamada <masahiroy@kernel.org> w=
rote:
>
> I am sad to see the kbuild change reverted, not the net one.
>=20
> 13bb8429ca98 is apparently doing wrong.
>=20
> Including <linux/types.h> should be fine.

This was fixed in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/mzcw7ryvAFRIOGzBw.57AtL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFDNI8ACgkQAVBC80lX
0GzUYwf/TGSVUPLkcU16Z7h2pDpCF/LCT6RnKKKhBIc7LOJEr9Nu34vRnCbxohn0
sd2PY3KXSngViYVczk+1lpSyI36TIhtZQ5+IjiVa48450qUVFw5rXGOac5DKLsYG
NdNdlkUg4MSt2Pmdmn2jIyywaUA3BuH1jk0VBnEGNvV22FZhAXD60aLek94IAOv2
8XneTE7R50TyefrAbEl5EGssAc06zzdaaPzrsxsiC3A0Oc2hkIEJP/kFQ8z3I1ia
pXl7VuNG0x77SqzXvPpucWDt5GkqW2JzMxdxGv3TgPb+/1IXADB+iGK8kC1dxanN
3OHj7vBaF3QZpjuynJWiKIPA6i4YVg==
=MuDj
-----END PGP SIGNATURE-----

--Sig_/mzcw7ryvAFRIOGzBw.57AtL--
