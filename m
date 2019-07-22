Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E609C70B89
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbfGVVfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:35:39 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45405 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfGVVfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 17:35:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45svzW6TQRz9sBZ;
        Tue, 23 Jul 2019 07:35:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1563831336;
        bh=L80NI8xzhTtIgcmhZBig5LBwXSPMVdF1dSa76Kz0qZY=;
        h=Date:From:To:Cc:Subject:From;
        b=uCq5/5ckzLldaxfM3EQOng/bIaMOpcshjYbk2GoVLWLYscsTU3QjsvwxJTbdVUS+Z
         sI9iQzl5x8t465P8Ny1jO+mH8Qg6wIE92GhoFkd2M2+G4KUDKzrYK1NkGnx7AcESHv
         vYQXingTSwAkKcsn8GVES1Bpwl58SR2LAL/cQD4nVaL4QXra1LG9e8U/Vb1elk5s7c
         TatZJuuW3BPvAM/83HFLZbKWXRS0PYhwKeUMmSSKyZhBxctGOCW9YCQmUZbd+wnXv8
         vWHlaWYp7s79QZOCGKkV++zwTUSE8lGwnL9xuFNsYoxnxCP7T8eb1QwWT7e3y9RXK9
         51dV53GgtpJDQ==
Date:   Tue, 23 Jul 2019 07:35:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej =?UTF-8?B?xbtlbmN6?= =?UTF-8?B?eWtvd3NraQ==?= 
        <maze@google.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20190723073518.59fa66e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lFBGb0vxewojfyG=A0Rc5=N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lFBGb0vxewojfyG=A0Rc5=N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  66b5f1c43984 ("net-ipv6-ndisc: add support for RFC7710 RA Captive Portal =
Identifier")

Fixes tag

  Fixes: e35f30c131a56

has these problem(s):

  - missing subject

Did you mean

Fixes: e35f30c131a5 ("Treat ND option 31 as userland (DNSSL support)")

--=20
Cheers,
Stephen Rothwell

--Sig_/lFBGb0vxewojfyG=A0Rc5=N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl02LBYACgkQAVBC80lX
0Gw8Nwf/VOjsejY1Z6g6NK+bOt7as3NHUho/x9gL6y3Bxg99UraEbJjWKBvvvf7y
wvE8Vr56Q+yw1qdixQDP+yg5LOjXpO+7lo5z921mPTd4n8kOieK61GFk1WecayiW
wI8IyWlSUnq5DKMBCxxGnObQSKLas0Fn+oMXd+/x+39iUleGoNnvzrAQZ+SWNbL7
bIg4mRvV9i6WLsn4J4YScvhMh+hJzru25OXktl9UJXWVH3fzqtMetCwV8X7rkgEq
8lqKzWXP6h0I1bFab9kA2B1WSplAG6WN35UyTgDJKN0IWP8taETODT4yQOo5Ef45
IBzFiJWaXoSgnZRcF0RCGbr+wjPwOQ==
=BZZl
-----END PGP SIGNATURE-----

--Sig_/lFBGb0vxewojfyG=A0Rc5=N--
