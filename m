Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C2A43D30C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243985AbhJ0UpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbhJ0Uow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:44:52 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B941AC061570;
        Wed, 27 Oct 2021 13:42:25 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hfgby4y8Fz4xbr;
        Thu, 28 Oct 2021 07:42:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635367343;
        bh=vmDS/GWkMu1yFl4fOJkChcYqAokt1FKesRPIJ1VXgqo=;
        h=Date:From:To:Cc:Subject:From;
        b=vI8Ef+XvokvfhFTALu/+MUI7HVGlw/Rwd68tNDj3rQ01LSnm10J9eiQ6v/ysQ4YEv
         j6+W61wkNbcPbPvuB6iJmGKQXEWiwN+txzSyA+5OTRaN/63kyrerLoJSmeUfPuiKS6
         hfn2DHKzPTA4YRMvuZJK9QpRdxsq+JkTKgQrLSFVEj81pVB/nSTZI23A3mIbLL/rjF
         pnAtSRtee4MFTa2iKThLW7CY7tURB6T1SS/KCzZ5RWYB8OkAv0W88foRHMx38+8W7W
         seclNP5Kl6maq3PmyVSMejBNNPrKeux0Jn0iwmllFySZ4DjPGq9PcTZSQupPJUf16k
         dyMUhvUhABSaQ==
Date:   Thu, 28 Oct 2021 07:42:20 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20211028074220.7ac95b03@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nZM+.0Lr.zeWxp+ZNqq3=DZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nZM+.0Lr.zeWxp+ZNqq3=DZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  6754614a787c ("net: hns3: add more string spaces for dumping packets numb=
er of queue info in debugfs")

Fixes tag

  Fixes: e44c495d95e ("net: hns3: refactor queue info of debugfs")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/nZM+.0Lr.zeWxp+ZNqq3=DZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF5uawACgkQAVBC80lX
0GzLPggAoI5ERsPjk++Pv4yVIY1E/jflslz+1s2UCqPWopyxPMf30VYm+0RyjQ9S
0hGVWo9DXYNVQH0RQXtcVm5Ldiu1fMTk6KSyI18GAFgcw6Wr+ho4H0m4eSETlzrJ
L1zrWCczw0cpeKYyfTUFNY0uzGG6rceDLqdBYt+wxMu8+cpIFZcuYJIYYGMyaLe5
bbX1V0o37tQajk7gqID5SF4NL6/OIRSGOR5ClgUB8fH5cLla1BeOY+zGGubL+5mu
3qDDkp5idLkQvVAx5CDFhjzgXQ7+YPLoNzoapEN+9hfdYDxSR85xXGvuYMd1G5rb
quGCPc/J+67Te0MaQ+URcjME95LMEQ==
=xOe7
-----END PGP SIGNATURE-----

--Sig_/nZM+.0Lr.zeWxp+ZNqq3=DZ--
