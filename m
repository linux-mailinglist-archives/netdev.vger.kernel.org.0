Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10932C11DA
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 20:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfI1Svo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 14:51:44 -0400
Received: from ozlabs.org ([203.11.71.1]:52365 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfI1Svn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 14:51:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46gd702DDtz9sNk;
        Sun, 29 Sep 2019 04:51:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1569696700;
        bh=/l9qEG9lYLSfQiy+M11YKY6NZHNniz4+SxKxCR50HzE=;
        h=Date:From:To:Cc:Subject:From;
        b=bE20e8NlVnuqELQM6Muq0SfXvsMLaLUKEdW7gAGL5oCU0Jp2nI4A5Viy1oN6k0zmz
         +08N3MKTxaAI1776qPOrhS6VowSoOzq26jPwdNA+bBSKjU5UosZIVhy4TbxLQf88wL
         V6mMuzFpiDigU84Qqgn4jRKrYWzZWrhklBteN00vOvCpWGg4vbujbnybYZJjbwG6iC
         LRBJD3Yha8lWsSHWHwS2+lyyzfB8az98mg6/dUp5sXMf+i1lRyCr66Q7zSd+OZiNai
         pLHJdsR5qCPPHf+FBUaWMFfE6MU9daTkU/gVzu2V1Re3oeFJlVKYqMzkTszRdSJgFg
         6PYBwcnCbnvZg==
Date:   Sun, 29 Sep 2019 04:51:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Kevin(Yudong) Yang" <yyd@google.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190929045132.0bfafe1a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UEN2NK7YulpHY.04HhXfKmn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UEN2NK7YulpHY.04HhXfKmn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  6b3656a60f20 ("tcp_bbr: fix quantization code to not raise cwnd if not pr=
obing bandwidth")

Fixes tag

  Fixes: 3c346b233c68 ("tcp_bbr: fix bw probing to raise in-flight data for=
 very small BDPs")

has these problem(s):

  - Target SHA1 does not exist

Did you mean

Fixes: 383d470936c0 ("tcp_bbr: fix bw probing to raise in-flight data for v=
ery small BDPs")

--=20
Cheers,
Stephen Rothwell

--Sig_/UEN2NK7YulpHY.04HhXfKmn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2Pq7QACgkQAVBC80lX
0GxCoAgAoyfHAEebArs0G//Lmb33bVwzzOjFgXTIQl+7HfzvOkHCOdwrNQ7IM+qW
UmS20ZxbB8HvNm17xst0OkNcvxt65mUndA7lPRhkh9FgnsygCIoTk0QGppm6Bmqi
KpLhr53QmXWoVr+wlbdZ1D0B8RrJ1+86iqnn1uJd5ZkSNv+pUiPxX86vzgFzP2+4
SSSvhF20CtgpMlee1YC5i1+MMgBeDyx01O1wKEeJMlxOL6mW0Z95LRqv8/b4I/mo
yPeiWywcB918uPXjKhdmfkfwn8bJ/V3QpwqGMgZh4Gh9T+Jt8pXIpGGH9pyaZUZH
ZBNZHvMO26aAnHnC46RjQSp441mUDQ==
=maIg
-----END PGP SIGNATURE-----

--Sig_/UEN2NK7YulpHY.04HhXfKmn--
