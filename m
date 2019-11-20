Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D995C10315F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKTCFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:05:38 -0500
Received: from ozlabs.org ([203.11.71.1]:52225 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfKTCFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 21:05:37 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47HmHf2vjSz9sPK;
        Wed, 20 Nov 2019 13:05:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574215535;
        bh=lSfFCEYhhKnh8tz6CK8SGQ+GHvCao8yS4zOVSz1rlKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dY7Thfk/SmVGNhf1CwzWd0VToC3uejpJd2UkD+1eMKnDRFGIP/m4MGC/5NHt5qK94
         dJs9BIZch687jBda5gtnBizI38pW/AKe8lDalwsLsp60g9zpp3uZuJpUW6IodCnEwe
         1yV9h52SQS8WCLPiI0tU2CgPxUhvyYIoEf/HuUXhZ9OoZYwjcn5AglJwaKEVOc9hni
         eF0uyVVjGQq5+R85BKALLTwcv7eRDz/kvnhjVcQW53ETUlkZ73A6m5E+hRbMYnHQCS
         94OshlUzAuj4HykiOrhH26igKlHeo5ja1EqJIimpqK7x90GGSho5eKbSlR7buytNEA
         so+hSKxvULK+Q==
Date:   Wed, 20 Nov 2019 13:05:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH v2] powerpc: Add const qual to local_read() parameter
Message-ID: <20191120130532.74844fb2@canb.auug.org.au>
In-Reply-To: <20191120011451.28168-1-mpe@ellerman.id.au>
References: <20191120011451.28168-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3gHtgYrcMa6xEZr1_kkvIuh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3gHtgYrcMa6xEZr1_kkvIuh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 20 Nov 2019 12:14:51 +1100 Michael Ellerman <mpe@ellerman.id.au> wr=
ote:
>
> From: Eric Dumazet <edumazet@google.com>
>=20
> A patch in net-next triggered a compile error on powerpc:
>=20
>   include/linux/u64_stats_sync.h: In function 'u64_stats_read':
>   include/asm-generic/local64.h:30:37: warning: passing argument 1 of 'lo=
cal_read' discards 'const' qualifier from pointer target type
>=20
> This seems reasonable to relax powerpc local_read() requirements.
>=20
> Fixes: 316580b69d0a ("u64_stats: provide u64_stats_t type")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au> # build only

--=20
Cheers,
Stephen Rothwell

--Sig_/3gHtgYrcMa6xEZr1_kkvIuh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3Un2wACgkQAVBC80lX
0Gy86Af8DJ2cdW4dN38n9ofBTe3NKtzh4L8r54R2/+/O/z5M730yoet72WkTZHuR
P64gaVtiwmIDO62eS5aG/kknNnLt36MR2M36GjbES8f3/ZN2TFnXMSU8wntqYrJo
ei9JkBWKuXbnxXSgYXV41vgCLodvxJZ6Zz72GgD7QMk4UotpB7oJsQyckpxFndLl
OqY4vIBQs7YflJNwQP4s+RcDcb8e3Vymr0eDRV6bfzfgCub2nrFxG5mqcscTYJZg
lgRQg+tuQBvWi1uNUZkx7PdTiTFJ4W7orhpbaLhM+RH4gH9RchsNhJ8+53y3ZuTE
SzUFtdcMgWkABWE9uDFPONiw6PB0eA==
=rR9i
-----END PGP SIGNATURE-----

--Sig_/3gHtgYrcMa6xEZr1_kkvIuh--
