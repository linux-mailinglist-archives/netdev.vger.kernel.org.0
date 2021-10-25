Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21A743A60F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhJYVoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:44:06 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:57509 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJYVoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:44:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HdT1K72xQz4xZ0;
        Tue, 26 Oct 2021 08:41:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635198102;
        bh=xBgmAL30seDzGpPv2ocrYzSLO0pEW6bOvRYpPYdaEaA=;
        h=Date:From:To:Cc:Subject:From;
        b=KiJ+eiRRCsLI16PGOFLsJgqsK7CytUCcPGctw4DGMiY5J9SU5Ml4gy+0yfY74VCcU
         8R1prK1BNVeYsqlpq2T2GI1chYskeTZhklmgsqC+7lSlmLrGCEFWYOO1FjtX5tplKu
         BihFlVmmTIqxC2J8Q05JSnbDex1B9HKxNX5CrE8yxAQtTeUrGfyPyRwRZhcFaVKCdn
         FmG7OGiwShPxm33AfFA+19Kvx1Ub5bNND2CF0a0FNBdzlYEfNPcenGr0B994Q+Uj23
         dvqZmGnkE8OThzQOJTmY13uWsgt11N/fceISinsNMiNtGd+ZTHg/eY9DgXg961Jxpo
         gI5ZktkSSAKEw==
Date:   Tue, 26 Oct 2021 08:41:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20211026084139.33cd1e57@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3z_yQSj/saYHu07U+yG+.G2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3z_yQSj/saYHu07U+yG+.G2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  2d7e73f09fc2 ("Revert "Merge branch 'dsa-rtnl'"")

is missing a Signed-off-by from its author and committer.

Reverts are commits as well and should have reasonable messages (i.e.
why did you revert those changes) and SOBs.

--=20
Cheers,
Stephen Rothwell

--Sig_/3z_yQSj/saYHu07U+yG+.G2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF3JJMACgkQAVBC80lX
0GyilQgAmXy2MWO4alndac38/L3f0/V2TVHRGTLnm4LGoVb+0YTewI/6RzgzIT0e
q2m+YlhO47JcsUu2gDTfo4+pBUlozZbeoQEwYAKReywJI8Am3G3tE0Hx6y6w9VSI
WWRYiSKh/G+o6J9jynEY0VyvGGP4xyImxvFY8xLNz6iv41sADZqk96XEaPm/5Pdp
Rk8ow1ZfNcT0LizzxeSIrKCCv+sBn0hRn4GIr/8s/J0fxdCLoGX8iiPU4oTC2qVK
LarHPTX3LGq5jUYxPzuRCjjZbqSMNB24TevKhUrJkRtw5efKTsc49Zwqmd9DdVkU
vwXqMU5kHigNVTUSu/k9BFwyc1AKVw==
=pRwr
-----END PGP SIGNATURE-----

--Sig_/3z_yQSj/saYHu07U+yG+.G2--
