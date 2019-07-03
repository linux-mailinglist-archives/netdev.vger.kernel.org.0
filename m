Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B715EEB4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfGCVm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:42:26 -0400
Received: from ozlabs.org ([203.11.71.1]:54825 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfGCVmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 17:42:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45fF2703htz9sCJ;
        Thu,  4 Jul 2019 07:42:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562190143;
        bh=o+473wFhtVjiy0ckHYq5we6vAWRdKnr3jC+e6q2Np30=;
        h=Date:From:To:Cc:Subject:From;
        b=cIKJ1VjzJ5NXt3UMrJSSHCFknoDp+MeSPNpv9aq4N8aW783KT/kDOXOm0Bke1ZLTs
         XWebXhZUaizMh6BU6ObKd+EWVw6mCrwEsJjovQfjNVX/gPaw4A+6n0k3Gi5SMztZLf
         E7q25hfxJ55TDkv7s9VvEMnFoM5bTjCMP609VeGqCY8gQoxK4uYKseFVM8YTh9aBlg
         tWJbKLd1fkAUEL9x8fl47vhMKZHWYQkzW0yPQy6N2LJVBgxHAhU4QaxkijZZdsFb01
         sJbavEScAR23AgzSSWOOrArDZBb9CMLJSKVffSQxNNkksbhxLmjXMzrJGmngGlw1gG
         hRQ7MFPaiSzNg==
Date:   Thu, 4 Jul 2019 07:42:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20190704074220.42e4771e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//+.awAE4SFPtT.RyYWny0+a"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//+.awAE4SFPtT.RyYWny0+a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  d62962b37ceb ("loopback: fix lockdep splat")

Fixes tag

  Fixes: 4de83b88c66 ("loopback: create blackhole net device similar to loo=
pack.")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_//+.awAE4SFPtT.RyYWny0+a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0dITwACgkQAVBC80lX
0Gz6zwf+Maozgm+A2X2QXXhY4JeyxbZuDCuvlK47fqNn0lWOStxC7ZSGGBQt+ODe
7EvVuHxu3PQFLfM+TmrEQSVhDrB7PFUo/LNsb6/XkaE+Uxs8DFTYCyCfp9YkpgWF
BDRVNv6rROkFMVLJixX1aI4BS1JJPUBRTN6RNJs0EW5fzKZujCBMkj122RqDp5E8
2ZtMdlXRZ97vIkrPBdlHVHGg0pTYo/UvzI1aqvE0QGzGqkJUyeZIV0pXypOSSdz+
zSWZFddIwblscF3MnfrtTn5DawEMpg5scu2tGrvQGw1Ow0IR/9xiK2SrebDIL/qd
Ar1LUBPZxH+H6LiwUyDXdh3YhpU9Hg==
=X12Y
-----END PGP SIGNATURE-----

--Sig_//+.awAE4SFPtT.RyYWny0+a--
