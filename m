Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B728D812C
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389122AbfJOUgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:36:24 -0400
Received: from ozlabs.org ([203.11.71.1]:37313 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387914AbfJOUgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:36:24 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46t6dx3yM3z9sP7;
        Wed, 16 Oct 2019 07:36:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571171781;
        bh=gul401i8aRTFHG5mSep0Z13L0087plMgkOzTWUqUio0=;
        h=Date:From:To:Cc:Subject:From;
        b=EGmnNK3HxozJRhkcvqQMzwIX1KNdA//wcE2SP9Gq0D7ufSuPYDsr7pm4l3h6F6I+Y
         xEyvROpd+6Ba/ffLNphK08JK/iiUrralx+O2wms1XPXxxv7aVcYOrjHRx1uLTWydkC
         hoeAc7nBxHc1+enxmnenwqst4r6gYjTmVQMGo9//g/PSYgx7jh6G99a7z6/kuSXbAP
         FehvNKxzPWuN62HvGUcaFKtVSzfy2Ffg+Y+RIb7tkxDp17msMpnbnFGpj/nxPmNCIW
         bnod8MewwajHmFsc87jPgeh/cMjWwtofYr4Z2ZGqNzQJanQeyYuVjtVLugaLwvrlPY
         Olaay9gI6EzNw==
Date:   Wed, 16 Oct 2019 07:36:10 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20191016073610.7e18b0ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pzrNR0wccN06FE389AE7TlQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/pzrNR0wccN06FE389AE7TlQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  b0818f80c8c1 ("blackhole_netdev: fix syzkaller reported issue")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/pzrNR0wccN06FE389AE7TlQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2mLboACgkQAVBC80lX
0GwLMQf/dz94kiq40v56LCjOPWhW2xqSmh7YpE+92KtFJfFF/dL+NdmcmePHAjLh
AGNvjNkD07EhzOGNtO55LM3YYPFxOZ/EArKDSJwE00QDWS+ufG+8IsQBVeoo3Xul
vch/guR7Oy3r6w/yUJSxHtuHXV7MNoh2dXsf4YyBrsi/czI84TPPI7x4plJ70WES
wIKr1fEuoBRaUrPJWbGPXhNSPF2HjuDaJUiTDmVZmkjvrwVUp3bVQCy8Nxi5e8B8
i1Wlux8zCwYqTmr62wEvmV3oaousucRy9Ktuvm1R/UjY8SOHQj0Ujlvut2Indarq
k1X8frBZ5ulbXEeFC1qpx/kM6WBP6g==
=SQRF
-----END PGP SIGNATURE-----

--Sig_/pzrNR0wccN06FE389AE7TlQ--
