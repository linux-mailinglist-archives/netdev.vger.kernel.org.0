Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F12E26B38E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgIOXFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbgIOXFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:05:00 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B695AC06174A;
        Tue, 15 Sep 2020 16:04:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Brf2D0nqvz9sTN;
        Wed, 16 Sep 2020 09:04:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1600211092;
        bh=2cPl+pITWd+vDIZL5DnD4Pvu9CM8FqL9TgUwktcR0DA=;
        h=Date:From:To:Cc:Subject:From;
        b=tYaqG76DA0F1y8CcJ2W5gkv2Y9ZOGkI5BRZ4uQm8YhMHmqvIgCt0oWOfbYaO1xALM
         EBpXHZ2MUnwxLT+ta16ZQhMO23kNL9oRjHipb1xhZThQTH95Ho6jMEEwvyN4dHkZ7O
         54WZQvd7vVKGM5/mqifYFhbxCtr39vUaicDCPdybaSL9BNNTjB75lBel7omjVnPaa5
         jb8oZX/cORmCk+IUMuOwf4iyRqqbhzN84oeOgljMe8YofiT+RYQzV21QSng8mi17kS
         ck+I/UUkwjaiGSDce8AhtURxC9afWA/Lxyi2wTYnxRKYladj6Q5e7MnVBWqYcyUcPl
         mtcGGr5It7thw==
Date:   Wed, 16 Sep 2020 09:04:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20200916090451.41e7a174@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iQstRI/L.BDLUj2VHUkCoVw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iQstRI/L.BDLUj2VHUkCoVw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  9f19306d1666 ("net: stmmac: use netif_tx_start|stop_all_queues() function=
")

Fixes tag

  Fixes: c22a3f48 net: stmmac: adding multiple napi mechanism

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

Also, please keep the commit message tags all together at the end of
the commit message and just use

git log -1 --format=3D'Fixes: %h ("%s")' <SHA1>

to generate Fixes tag lines.

Since Dave does not rebase his tree, this is just for future reference.

--=20
Cheers,
Stephen Rothwell

--Sig_/iQstRI/L.BDLUj2VHUkCoVw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9hSJMACgkQAVBC80lX
0GwffwgAoBxnbvEa4e+9EC19EERC6ylvIIY/zaWzZuQ7S/vFc9UwcM/DAtzSrSk/
CB3E0NuGrVOKDG5l3Mw2mREiuaWccHRGqPvkwjndQAQUWvufc2rCeGhEILcLdsAs
Ia8diC58IVQWTagu/1/DrWSeBLRsPzV8kupFcMM5Oz9urwhS5fSHYgVja6DBCRKr
5+Yg1e6M2m/o2wkGnwcvbwv8JjSLjafHvzI+7/2gLLhm+rRFazdyo1k3WR3mSLWQ
SdJe0Ip3CQfAUzNCsCnFwzGyTcuERXMH8hbaOB8MkMc9EpBNJYoqyG9/trIgz5wL
ltkE1Syfu1IG2AKdOCWAoaPR/tmDGg==
=jD7h
-----END PGP SIGNATURE-----

--Sig_/iQstRI/L.BDLUj2VHUkCoVw--
