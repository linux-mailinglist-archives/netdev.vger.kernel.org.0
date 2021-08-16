Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965263EDFA8
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhHPWFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:05:24 -0400
Received: from ozlabs.org ([203.11.71.1]:47621 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhHPWFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 18:05:23 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GpSrK4FqCz9sT6;
        Tue, 17 Aug 2021 08:04:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629151489;
        bh=C+bMqHlDd3mBl6TZcdPBNIEFp33RdS/NB1JqWmH7QW4=;
        h=Date:From:To:Cc:Subject:From;
        b=hexlHDVINemkUZwjrFSORfDD/yem7jhWosAMHfmMiGsMdGA4oPK7001XazFDQ6iqB
         SOMP9BRcmQU8YXVnNwRrK6+2djEPp14gLfrafPl3fQWZdLzhqsFbSzDuLdvrloINxv
         nvGLYBgWVkvnQK2559szifSyYJWQtVs5Na3M7bbKndowXpM+q18MwTednryEjtk1QH
         0pmLLziGY9QYYMv0vd4LnEQrsRJA/qyESidjvrz8C/WV2ldWl3Duw6BvjchuHwHvl3
         Qo4Kn8pz/SH5YqiIK7Wni1Okag4gNlcavI9t3CV+s7AQkIlU7s9NK3FcnmZT+gHwyw
         VNens9bSLmPIg==
Date:   Tue, 17 Aug 2021 08:04:48 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Juhee Kang <claudiajkang@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20210817080448.3bc182c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FPTHqf3kHb5g/Zb=s.4afe1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/FPTHqf3kHb5g/Zb=s.4afe1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  175e66924719 ("net: bridge: mcast: account for ipv6 size when dumping que=
rier state")

Fixes tag

  Fixes: 5e924fe6ccfd ("net: bridge: mcast: dump ipv6 querier state")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 85b410821174 ("net: bridge: mcast: dump ipv6 querier state")

In commit

  cdda378bd8d9 ("net: bridge: mcast: drop sizeof for nest attribute's zero =
size")

Fixes tag

  Fixes: 606433fe3e11 ("net: bridge: mcast: dump ipv4 querier state")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: c7fa1d9b1fb1 ("net: bridge: mcast: dump ipv4 querier state")

In commit

  0f0c4f1b72e0 ("samples: pktgen: add missing IPv6 option to pktgen scripts=
")

Fixes tag

  Fixes: 0f06a6787e05 ("samples: Add an IPv6 "-6" option to the pktgen scri=
pts")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Also, please keep all the commit message tags together at the end of
the commit message.

--=20
Cheers,
Stephen Rothwell

--Sig_/FPTHqf3kHb5g/Zb=s.4afe1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEa4QAACgkQAVBC80lX
0GwPHQf/edmNwjEUGgr8fwH4EjRTrR7gDlefW2JOHXJqlm/VQ2qh++WExnoL69YH
40ZxoT2fRHFuMX7V78tldmImVUElqcwg9s0pQpTJeV3QsCIU91pSyk9xXfu7fUrb
8756ociN54+SbLZgQ+Ds4YZ6/37Fv6sZdGXKvFHe0q2yIGPb90Z3MD8GrAzEMA1q
DQpGMjCHKxsDCEG8MSiDyLccVCzetTfJyWaUUcuP0wUdNf27SZtNz2fGlvlullXP
VjXb5ayF/ClOZCUj/Zk0uMYnbvM+1KRBuRBclGHuuDPRmxHZcafyr3aCeNr2jqlr
PR63HSiRP1E487p9iaW3C1/xT8pGmw==
=67Xo
-----END PGP SIGNATURE-----

--Sig_/FPTHqf3kHb5g/Zb=s.4afe1--
