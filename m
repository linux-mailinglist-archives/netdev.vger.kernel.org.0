Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10602390C51
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhEYWfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhEYWfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 18:35:32 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB910C061574;
        Tue, 25 May 2021 15:34:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FqTQF06jxz9s1l;
        Wed, 26 May 2021 08:33:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621982037;
        bh=0sGkGFbwpUtcrWDso4ctGrH/KPXkkK5ySCMK66Rai9s=;
        h=Date:From:To:Cc:Subject:From;
        b=O73NK1RxuWsGblcF4liKa29I2KF8lp1JSv7xKRGLlWq9hsjHWnCYckQ45e5YeuT6q
         +ZHWy5zfmO1RUEMVxoAKHFJtNX3kgRAQbQgIe/y77WJsg2u19mb1yY2gdytixnmWi3
         iC+Ita0nWM1ug75bsURdodRHZTluaB4KMdkkAV7BL/4VCnqeFB2xnfq+03u2V4xFGk
         a7+UHP828VFJVJO05aizSMK+sbEW6o7lSOeMxiUmql9yB4SuYc0lDvkLr7CzkoGm6B
         lTdT5LCNLTTdoZaaK5V1AJd9H0x+UjkaJzh0fIZd7UGZcvSGEfK+cT1Btjc0VS2xAR
         cPxjHK8gT7IGQ==
Date:   Wed, 26 May 2021 08:33:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210526083356.62941b94@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/L+q0+y9//Kh87usM00+iBvE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/L+q0+y9//Kh87usM00+iBvE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  c1cf1afd8b0f ("net: hns: Fix kernel-doc")

Fixes tag

  Fixes: 'commit 262b38cdb3e4 ("net: ethernet: hisilicon: hns: use phydev

has these problem(s):

  - No SHA1 recognised

Please just use

git log -1 --format=3D'Fixes: %h ("%s")' <commit>

and dont split FIxes tags over more than one line.

So

Fixes: 262b38cdb3e4 ("net: ethernet: hisilicon: hns: use phydev from struct=
 net_device")

--=20
Cheers,
Stephen Rothwell

--Sig_/L+q0+y9//Kh87usM00+iBvE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCte1QACgkQAVBC80lX
0GwNlAf/QcfLpTzyeawP2GTG+1wcu95ksvnZ4RHqE8pBajRQ9KNYznv7aDO8D20B
NrqYyeNLkopS25viXbo33S+XyyeLNNj9nhFC23O8fk8dSRX2Ayg9nSJ62Il2vJgD
vKJEyREMXWL1wOmhQGqkhkh8Vzc08Rpof20n2cPDwh6P0jQr4553m6CDxJnHQMk/
RZ8SPzopmoM5uDmDiD4tRlqctFwPd7osLpXdLnGdRCVN7vOSlMS0ldIU942WWZOh
gPTcmwuqnJnCZpCY6EBdHKonCOSyFA+vFbS035EbcC43T3Ba6eJgCZpLRZPTJGiM
d2zuhHE2VpQqyR3rmSiNUD+kGISVXA==
=5Zpi
-----END PGP SIGNATURE-----

--Sig_/L+q0+y9//Kh87usM00+iBvE--
