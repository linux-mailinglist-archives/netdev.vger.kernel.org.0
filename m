Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493F4623768
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiKIXZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKIXZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:25:24 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADA32D1C8;
        Wed,  9 Nov 2022 15:25:22 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N71KR4F7Rz4xYD;
        Thu, 10 Nov 2022 10:25:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668036317;
        bh=ERJC9eRMspSvsDqwdNvHOLiIP1XOJz4EMAXQzGjCFDQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Dq29p6qEMuw95b6qrvea0y0KOVhyJaTY6uvGt8aRxNfEDnl+1bRW/0IjXW/J3JVbV
         cLKuwXkBvVxEMspmiVOZpw1A/VfsAslL3lPG6Fsu/PH1x+ZF0ISaTwVJFasbkwzy4i
         GiZLcnGSORWqMznK+cPy002+sOnFmGtHDBz7Sce4S1pCsDtBMUIyRYdDCGF17qlmjo
         FEvl0CntzCd8biNgfELg3nHHZB8ab19LqIBxthdnIaERN0Ekqz71l4g6MIK7CiT9mM
         ZZ9JQMrJ5T1tjaj4IHO1xKzq9JY7oFmVWmmZxN/9mnCkG2G1p5dTNoce5a94psJAIx
         EpTwjRYGbm9LQ==
Date:   Thu, 10 Nov 2022 10:25:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20221110102509.1f7d63cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/URFtFf22l.+X3Y1NFfBS6RV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/URFtFf22l.+X3Y1NFfBS6RV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/can/pch_can.c

between commit:

  ae64438be192 ("can: dev: fix skb drop check")

from the net tree and commit:

  1dd1b521be85 ("can: remove obsolete PCH CAN driver")

from the net-next tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/URFtFf22l.+X3Y1NFfBS6RV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNsNtUACgkQAVBC80lX
0GxFswf/djufZrRbLl+gPNoti1zVqCMOm95cWuWOTr6tAnsoYYCAdEKRdc9EK8hn
DvKNQghwe4DhpoRc3UvloA+ad0Iw5UATxMghWgXzVpJKD6KID+XDZwzy32ZqrCRk
xf/JCQgHEwVKuihfW1ryM6hpcMSz8s1OgBBxJyEzsiiJI33CJC0ylKi1177ws47o
2ErVgqkWS0zukPReWCUQbGv+ke0LafnR2uyPp+blqATaaqeSo/BlrvrFqvxKSHiG
nbIdZWmUjsnAmzwmM5+k/uJDHb4lVpuYO4sQWKS+k6Bsm80MPl07XdpJK4VS4ANI
qe6khrMbsB3aZACwMi9t0r51cdS4qA==
=rE2s
-----END PGP SIGNATURE-----

--Sig_/URFtFf22l.+X3Y1NFfBS6RV--
