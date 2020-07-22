Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D9C228E8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 05:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbgGVDVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 23:21:49 -0400
Received: from ozlabs.org ([203.11.71.1]:57315 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731781AbgGVDVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 23:21:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBLNT1JL4z9sR4;
        Wed, 22 Jul 2020 13:21:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595388106;
        bh=3HgY+CC86GTCRa19jhzQ4AK/8XRnemvEEJxm4cO6zVw=;
        h=Date:From:To:Cc:Subject:From;
        b=VUk00Yb4MHAp87ARMBZvs5vI5Vlq2UcH17ACTPqxb31FTcB/ydb9/fSkV9pPgOlll
         N+yFteQkWjg3LKc4WiiwyaChAZATam9Ar4rpC6AAfki3f5OZTWsPflcAOsyr56c4J4
         MyRVDPD5+q2dZWMq2XYify4L+QMjcBgRCDvSpLVL9Qrl2kkB5LW+nGMSX5wu5yTMvx
         wlRLrUmyW8oPUPGXlhMQjlnaTopbvjnLCQa+MfuFRqI0M/dWspz4vmFTfNIWrL7xV4
         efWFSA1YqdBYLS3jjCBhcvYVA2JK91qUCm3Vjt5TtZ0EKOVMrXfAyr3BH1KxXqLUiy
         dyku0KuCl2q7Q==
Date:   Wed, 22 Jul 2020 13:21:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20200722132143.700a5ccc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c_FeKRWTIj38lYfkiotFdSP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/c_FeKRWTIj38lYfkiotFdSP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got conflicts in:

  net/ipv4/udp.c
  net/ipv6/udp.c

between commit:

  efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")

from the net tree and commits:

  7629c73a1466 ("udp: Extract helper for selecting socket from reuseport gr=
oup")
  2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport g=
roup")

from the bpf-next tree.

I fixed it up (I wasn't sure how to proceed, so I used the latter
version) and can carry the fix as necessary. This is now fixed as far
as linux-next is concerned, but any non trivial conflicts should be
mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/c_FeKRWTIj38lYfkiotFdSP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8XsMcACgkQAVBC80lX
0GwE+Qf/a1w9/8mTXdOgf7C2LCQmVqsW+ZMzEldYYnotELRdB+IIV9q0egilu73h
SGg9if0oa/20sPA3Dy3YTMGB07swC4Moc7yxgKTuKjvA43ppf7SY1XZJrvBxEFgT
QhMlzjb2kmvUTG9hhMDVneGBK6znTlFmmtb8jxwQ/eD7/aLnoNZnRysf2j6PWWgI
jpXMcDdSyTL+rB4L54aOP2z1Hts2chWU3uNO136O9T8Z8tA5bgs+KPdW+uLUBFmz
Ol5SEI5S/w5hCbjzqmgOX+kFN6yBkiJWlMvGnKb1tK6ukpDpH8duo8aPrCpLe6/k
uhTUOegwz8z3CgV/BygFXNQ0Rrxt+w==
=Znn8
-----END PGP SIGNATURE-----

--Sig_/c_FeKRWTIj38lYfkiotFdSP--
