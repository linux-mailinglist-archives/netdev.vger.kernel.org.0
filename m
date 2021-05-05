Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973FD374B10
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhEEWPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:15:51 -0400
Received: from ozlabs.org ([203.11.71.1]:37291 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEEWPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 18:15:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fb9xQ5Yy4z9sCD;
        Thu,  6 May 2021 08:14:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620252891;
        bh=AQMouoRiYVsgK0gBu01oNP5Q/wg6xBiXNQ0jeT6O5FI=;
        h=Date:From:To:Cc:Subject:From;
        b=uMLjdcch6t037Tozl/5PGePiEnKFYNr69vdmMLwco4pVpv5G4V+3TmYh82en4UYuk
         uPKN91ynl3RSN+xkNYkJ9d3mryb5HBgKrWqweZQwkyOt3Mdi8et8+ynwWAFvLVRYUq
         /q/yMWKBHdnCSWJzMMZ2c3YPte97l42Y32lF5CFpH3LZmSiViVZu+DybM3wF4UPPkp
         7VbH07RENZh1/IoipPV7VcslG8Y7jM2Uq+Z7mrMbZ8yWPf+p7pILLpOhiYZrjxeffK
         cBuUx4AymmpDdWCFuZ8ACTsUs2j192/iSScdzgH9mkXLCno0ujjKs7YDsmkEFFrCcc
         CktsE0yne54EA==
Date:   Thu, 6 May 2021 08:14:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20210506081449.5b993b8b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/W.wl/tg0sQQoEF3NmKKzHk=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/W.wl/tg0sQQoEF3NmKKzHk=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  2c16db6c92b0 ("net: fix nla_strcmp to handle more then one trailing null =
character")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/W.wl/tg0sQQoEF3NmKKzHk=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCTGNkACgkQAVBC80lX
0Gy3FQf8C7O/GJ9sD3cumwuu/KUSH/6Jgq7ntREDx70ElGgHdOPa9HnYg5IFrpeV
CMEUQYf5qxkfGf+8tfBvgBwpshyRzMTNXFCW4fCmjNpVoMbYCQc3Ux9jLbXQJ7gv
+e6H6xRp2T0php+IEfByInziENDEk5cdZrkGAh3mC0b2CfZ9i6Zv62aXtc3t4bcU
aI/mgwMKbassrr7c8S6yDr8gFoexxbSp/wPJIclquldpxJvkt/jRyVeV6KRCz8s3
+93PKg1BdLF/0Gd32DidajPFwC3VhNHuBlHrDZHY2Jzn+shOqte1cezdE2v/vVAB
WB96Msqt1hRMJuqGeyk7MfXGiWOZ6w==
=2XKg
-----END PGP SIGNATURE-----

--Sig_/W.wl/tg0sQQoEF3NmKKzHk=--
