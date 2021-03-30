Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B51234DD60
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhC3BP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhC3BPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:15:25 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297A6C061762;
        Mon, 29 Mar 2021 18:15:25 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F8Whm4t3xz9sVq;
        Tue, 30 Mar 2021 12:15:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617066921;
        bh=RE/4zNeWU0oV7LHlpxhXye5rJnYR0+bmzHviHH7mPqU=;
        h=Date:From:To:Cc:Subject:From;
        b=uJNHGusKg2VeleiKHbcR7WHTKGERQ55Wuc7OHGohsMgu9GBgQAEpw8qShaedb4k/c
         FyVxtiCzf2Ok48ysGatEaeHRyDEMROO6o/OrZ2DQA8FN6Vj4OxmVoa9EvyN+zbcpk4
         1MZUH/tMJussCZQAiY1Bk2y0mg6wJ5aaDGwPJOaTTbldJwwu3Bq7+vSn18WVJkQJoW
         F18v9j4QmXNaRNzryk4KYWnUOzXsp/OaO9L6C+An0EX+hvMX+YYl+5pykDQlRPjkDa
         90Y0y73am2vJuG0vQ6An7DXS6chiC8XRybL6UdbQ+4w5WcN86ts6Hy1HdYlxAUcPU1
         Gg1H4ACyNG/Iw==
Date:   Tue, 30 Mar 2021 12:15:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20210330121517.68f30964@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KR_6r_mnwoT+GRmBkT1+w+z";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KR_6r_mnwoT+GRmBkT1+w+z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  d24f511b04b8 ("tcp: fix tcp_min_tso_segs sysctl")

Fixes tag

  Fixes: 47996b489bdc ("tcp: convert elligible sysctls to u8")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 4ecc1baf362c ("tcp: convert elligible sysctls to u8")

--=20
Cheers,
Stephen Rothwell

--Sig_/KR_6r_mnwoT+GRmBkT1+w+z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBie6UACgkQAVBC80lX
0GzXqwgAkC7v4IDenZY5v6g6nkdY1RH7eV7cH8dVEebEDmgy/ZJi7i9LdzyXlByt
99jkBAIH+S6QP62gfJj7cJWob+t8LAuAak77MVtLih+VEY0YDjnO7L2hFA3B7VxY
U9tVHY2tcPInnzQmdV8khOK0XukMR3MBJ6RkjsueyI1nGUtbyUtQuxK+pE6B+YmH
2ydcFYhRxIuwhy/tSp6kARtS2fpU/KQKWERVOUTios3mdBtjFNBInrJmb6dAXg5D
APdxJtkmSlRMIsiUwEykeNsfyIRmIYVA06P/xrL/ZvTiVAyFvyT/0MYcmAP2oA92
S/d0WPCCLib5OJ82tqh66DGjaPqP/A==
=Tffj
-----END PGP SIGNATURE-----

--Sig_/KR_6r_mnwoT+GRmBkT1+w+z--
