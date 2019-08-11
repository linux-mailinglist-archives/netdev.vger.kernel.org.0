Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACE38946B
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 23:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHKVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 17:33:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55801 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfHKVd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 17:33:56 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 466C0J744zz9sML;
        Mon, 12 Aug 2019 07:33:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565559233;
        bh=qDrZU5sSbQGOlFIcYJ6w9TAc48JEnDDbLsWuOjRZ5oQ=;
        h=Date:From:To:Cc:Subject:From;
        b=kG3NVqcuvrS6sMVay6kxR5quR0lRYdQr60VBMl3h19mS2hfLZ94kc/8OIrTNO+8TV
         jg1IxFzi5R+AMimbpfVJipsD7E2JzR4R757WbX+PZNYST+Kb5lVTtbmBJSsKbWUdVL
         o6481F8j/+ZKLEVEF0SOc/9s2aZkrPVNOxuBvN+mTDxZMvxsVI4QMWl8rM1ksUSMB6
         KtuESPiULdb1hJOG1n8aGtvV/H55IsPPtCRgIuAne5v1cLQWPsBUheNUIav2XelZ2t
         jI7WuWjErriaCuOgZlJKCb3Cior50u4YLwZGJinpGTsMExENdTyplxRqvmy35iMXvM
         kUgspfXorYE/Q==
Date:   Mon, 12 Aug 2019 07:33:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190812073351.154098f4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DOBQBN+sU2Kca5ftC+YLIjr";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/DOBQBN+sU2Kca5ftC+YLIjr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  e1fea322fc6d ("net sched: update skbedit action for batched events operat=
ions")

Fixes tag

  Fixes: ca9b0e27e ("pkt_action: add new action skbedit")

has these problem(s):

  - SHA1 should be at least 12 digits long
    This Can be fixed for the future by setting core.abbrev to 12 (or
    more) or (for git v2.11 or later) just making sure it is not set
    (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/DOBQBN+sU2Kca5ftC+YLIjr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1Qib8ACgkQAVBC80lX
0Gy+2ggAg+1fyqDHfbeqStSP2FT+H9daFwPA/HhSxg9gObNM9jNV6NKTO/Z9Iz8s
OMqIVmo8PqmnbTqoA4j7iEdK691DMlW6372F2jniE228YzUVmX5kei1BQxbw5xCc
+LYPerthCVEQsjEfaZU5no4aVjsTVlyAF8ujSNueMMJ00f96+ZJ6vSRWGX965W9D
JwEoJVITtdhGSJXNIbReQlXHD8F2aWkb4ZVL7Sn+YTyDr8Raqaf6FPDwbbno7Zo+
Qg3OsXCoZfDbsoKCK6zuftIPMt+PSu16GgyMeOPw7f4e7WWDPtyi7c2rW60gbuoJ
du9Q1QaFbW/NmatiOAaaa/ppBU3YVQ==
=MRXg
-----END PGP SIGNATURE-----

--Sig_/DOBQBN+sU2Kca5ftC+YLIjr--
