Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5DA33C8E8
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhCOV5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:57:22 -0400
Received: from ozlabs.org ([203.11.71.1]:54931 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232152AbhCOV5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 17:57:10 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DzqyX3Klxz9sPf;
        Tue, 16 Mar 2021 08:57:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1615845429;
        bh=NoHwXOgxdwjCIOsOUn+xBqlS8d+1WIyWDoDRzsElZZo=;
        h=Date:From:To:Cc:Subject:From;
        b=pY8NqhyUGMjvyoNidA5BrVXjUAAFLwyDtO0BtEeC3US8azX6RmzsLvi378wDZ/+7G
         L/qCS3RVMJTWtNFaov4OS6wAY9grU/kTTm1iXw9BbhK9247sg+h/UPtzSllM9sr4ef
         +Q/hjUCli6fdwj1j6CzuIyPAelfmPSr3kp0MOEOFDPMcbgMzRZ5DClXEGhsd9qSIET
         5Sfe2gO/WNY4fEhlScfnKBwJ7oS1IN2s3OreAy86JLBdu9s+gmuhyoGDtj9w7OnHyX
         yFncbzdTHxar8kEJikpWEYKt/3w3WaEp5Sgl4UhVVsjPjrMwTLC5bWV11njvA33l25
         LU3n/eqavgDog==
Date:   Tue, 16 Mar 2021 08:57:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexander Ovechkin <ovov@yandex-team.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210316085706.7df472fd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Sf=EHNm.5=al3VQJ3TPwgtA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Sf=EHNm.5=al3VQJ3TPwgtA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7233da86697e ("tcp: relookup sock for RST+ACK packets handled by obsolete=
 req sock")

Fixes tag

  Fixes: e0f9759f530 ("tcp: try to keep packet if SYN_RCV race is lost")

has these problem(s):

  - SHA1 should be at least 12 digits long

This is not worth rebasing for, but can be avoided in the future by
setting core.abbrev to 12 (or more) or (for git v2.11 or later) just
making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/Sf=EHNm.5=al3VQJ3TPwgtA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBP2DIACgkQAVBC80lX
0Gxe8gf+K4Kgh7RbXGOjeH2USp2hnorFzHLPbWenmg1Z0ps/eovVxlMJ+e58gdmM
AjRgyaUQspJfhnbqWvn4tE7wM+iQ7x49znaH42t2jAwC3JKS+jVSj20L8zHzC9jT
K5xRcofCX7N0TYWCT8/oefvedJDOHHtGA2A1igISrp1lFVuNZ+TWn0ESPq29viyv
2AC9mv2slBIe4I4EUPwAqpLADay4XG2HatDsbKIB1HtuyelohCpbym2/DWT6TEGD
5cuipYJfwp2BnZQu+glentR7xkG9KjPp12h3fxi7aYW8OTiqouVMTaew2jSEqIAD
4KQHrDdXUMTUNa0A6+Mr3idAnzekSw==
=MM0W
-----END PGP SIGNATURE-----

--Sig_/Sf=EHNm.5=al3VQJ3TPwgtA--
