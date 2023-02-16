Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E18969A22E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBPXTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPXS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:18:59 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36344474DB;
        Thu, 16 Feb 2023 15:18:57 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PHrVM3X3Wz4x5c;
        Fri, 17 Feb 2023 10:18:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676589532;
        bh=ONZ/RDG4r61XWf83e7y+Iud7M4HE3cO69bubmMLSvH0=;
        h=Date:From:To:Cc:Subject:From;
        b=SkjXv/CXc7D8mE/Q13s7Ne+r/R2vHhD1Ph/Y9KHIezn8R8xfeZ18XC6kWhLl34OvY
         ixfgmdFboaPtAGQE/WGSo1y5A2a8gdOO+LsdD7Q5VqXD5TG/jYLhl+uVx/e3AF+5dV
         q3Hk+9CtHmG0t9W6Y3NW/KnmUEjokZEy21/6KwbM1YY6CVqe4bMSvGOKeuXNLjREIP
         euvH12239BZJmdecvfBam8jrmKnQ2fZU23Pnkf988V9A8XNemdepBzchrnEy+o5lE1
         owcSZ3HnxL7Aro5MmQH28oBM0XnCUB6dJgcYP4L417tYsWGj0sXV/7jYsRep4qLLBr
         Ovo0oGaAqMxiw==
Date:   Fri, 17 Feb 2023 10:18:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20230217101759.466083dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FcRGsq46lT6f.kn.6BAyRvl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/FcRGsq46lT6f.kn.6BAyRvl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/sched/cls_tcindex.c

between commits:

  ee059170b1f7 ("net/sched: tcindex: update imperfect hash filters respecti=
ng rcu")
  42018a322bd4 ("net/sched: tcindex: search key must be 16 bits")

from Linus' tree and commit:

  8c710f75256b ("net/sched: Retire tcindex classifier")

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

--Sig_/FcRGsq46lT6f.kn.6BAyRvl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPuudkACgkQAVBC80lX
0GxKlwf+KUhC37mnuqI1O/Dbc4nMEVvBFp0PXd2rDpmhuIquS7LaLKlyNo5VWEI+
FdiQ2iuIg1809hfxNbQRKMswX6mF7tDYwhcSUiisTWELwrRIXyVoKDIzlpR3yD4z
9u12W5R7ToFaSHFUIH4VTlW3BqU6ZbVWAXdAKYS78hr0qW01DTLPdURyjajvMOGX
RJ+J0CsXYrHF0p6F5Kp90q8iHs0wbLLSJeGHSjnLFVPNC7dG0p0uF2NfS8CeJu3m
cd1X6d6zQzYIsLJZ10s4yaBw+UqrAJrajB6rGfbNdTCBJWh2+ZY3geIbNUbB6cID
tmc3bIc5oRJoEq9mwEhLleaFoUDCaA==
=OdjB
-----END PGP SIGNATURE-----

--Sig_/FcRGsq46lT6f.kn.6BAyRvl--
