Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BC1119F56
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLJXY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:24:59 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:57281 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbfLJXY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 18:24:59 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47Xbkb4Xf4z9sPh;
        Wed, 11 Dec 2019 10:24:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576020296;
        bh=uCoc12Pet8WQmpschZh+CqMD1M9wWkIH4XIWAJZ6Rwk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pqWaPhq5t/1wLbWRty5QzrzDlNZjnB1k/tmUvg2wkUfsQIByymp3/1LDrSVDRRhZm
         dXvdBjSDSLFRhVMUMnxNr5GWzw0d9Yv+CmqqIZXG0Sp7cLezZ6Ldl2rZixHTGN/o+7
         cK4S0JwQvX0LGFtitlhWnHN5tbpzPBHv8JIidqyULtViibCDLK5Finciug9b1J3fMm
         iO4AvcZ/sMfkcvpQFMo8UytBsC8srRTKFgfuElQZZ06OkI3pf2j9wBeMCrfrvFRcbm
         TlLda16QGBfwDshJVssan3EEFSEtbKJzkiWVxYsyfG9LpyN8h9Tki3pUdjx9aL2hON
         j/ZoWZMt/X7hg==
Date:   Wed, 11 Dec 2019 10:24:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>, linux-next@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: next/master build: 214 builds: 10 failed, 204 passed, 17
 errors, 57 warnings (next-20191210)
Message-ID: <20191211102455.7b55218e@canb.auug.org.au>
In-Reply-To: <5def8fc0.1c69fb81.d0c08.f4f4@mx.google.com>
References: <5def8fc0.1c69fb81.d0c08.f4f4@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jojN3qX8pgpqY2kxvzXkuY4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jojN3qX8pgpqY2kxvzXkuY4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 10 Dec 2019 04:29:52 -0800 (PST) "kernelci.org bot" <bot@kernelci.o=
rg> wrote:
>
> allmodconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 20 warnings, 0 sectio=
n mismatches
>=20
> Errors:
>     ERROR: "curve25519_base_arch" [drivers/net/wireguard/wireguard.ko] un=
defined!

curve25519_base_arch() is only defined for X86.  Though its use is
restricted to CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519 being enabled.
Arm selects this if CRYPTO_CURVE25519_NEON is enabled (which it
probably is for an allmodconfig build).

--=20
Cheers,
Stephen Rothwell

--Sig_/jojN3qX8pgpqY2kxvzXkuY4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3wKUcACgkQAVBC80lX
0GwmZAf9G06t6XBSBFoYm0OmGAjGAtWU0CbCyDUCClLjajfq/jevXtgkjr6yoiTd
l46ufzE1IaeL9F0hZDS4kA/fzLIKeWEueToQsnmpbEDgVFqh2h9cSHEIBfN+ts1N
Kygd3LLC8FWggVOmOVQPQflIAQbZtKb4pQamDeVaiEGln2HK4A86KzxHuknW8XFY
QdPHOXlBdt2CnCMFDFwr5Z9FG+cvslWfwFScwyEa6tFdH3vPgvJNAHVASesR3629
gtzOJnN8AGWJYbmZzD2MiGdHVa70/9EayaPN1YrhAfaqZjXsWH8yyQ6YtMw44grl
Wf5OvyT9Kx9QHPAc10qYtfqQoG1tRQ==
=GUn4
-----END PGP SIGNATURE-----

--Sig_/jojN3qX8pgpqY2kxvzXkuY4--
