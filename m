Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29327F573
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbgI3Ws6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:48:58 -0400
Received: from ozlabs.org ([203.11.71.1]:57897 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbgI3Ws5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 18:48:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1ryt4D3vz9sSf;
        Thu,  1 Oct 2020 08:48:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601506134;
        bh=IGJbmv5mcrkAA2X9zezbI36z8dO7q2w6agEZE4CGtvI=;
        h=Date:From:To:Cc:Subject:From;
        b=NjLpLjo07KfTbhqFICWl1G+mLumgIgWBFnhKtk+Nvb7eMbf/TE5b6xszvPZjsbvoW
         8B43VGtphX9WjweZgwYp9ZX/CTpQ0qfHSYTxcM8ZBt1sCXNRzzPhNWMtfSiqj+hdxG
         XOBBr7yVTLfx3YXBgr+DDixRDZPexHoFzjX7czg3rz+Hp/KF2ImArwXgfsg4wYL+9q
         MlOYhGhB79zZSeslPQPAln4v7bis6AVZrG37CSPnYOF6xBgFfwZ/a0HvAZcQlz/2GF
         Ax4NkihiVzN3kHZ88Y4HXYLxxvsqvvGEjRz/gYE06n5NDTwwjWJ9o70VZDSqZ8JRwI
         RPui/lfMj8fkw==
Date:   Thu, 1 Oct 2020 08:48:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: linux-next: Fixes tags need some work in the net tree
Message-ID: <20201001084852.5bc93fca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/N+8f45KqlWeNX8c7Gt4=XzP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/N+8f45KqlWeNX8c7Gt4=XzP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  66a5209b5341 ("octeontx2-pf: Fix synchnorization issue in mbox")

Fixes tag

  Fixes: d424b6c02 ("octeontx2-pf: Enable SRIOV and added VF mbox handling")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  1ea0166da050 ("octeontx2-pf: Fix the device state on error")

Fixes tag

  Fixes: 50fe6c02e ("octeontx2-pf: Register and handle link notifications")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  89eae5e87b4f ("octeontx2-pf: Fix TCP/UDP checksum offload for IPv6 frames=
")

Fixes tag

  Fixes: 3ca6c4c88 ("octeontx2-pf: Add packet transmission support")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/N+8f45KqlWeNX8c7Gt4=XzP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl91C1QACgkQAVBC80lX
0Gw2SAf9F3XXldpShN9oWWZwD0T5/Dtu/hIxQlVMY8Fsz9P9ZLTqqdRs9NnO5del
DRLITE6lxMLwqoZjOHruYavTupQGgwQLMJ78G2GWxKzDcwE4mbH4YF4Vfq0zhiiR
xUJeSASbXhNSDReP/XAeKvsyiPYt90sl88seflM66FE6cS2541U2nBsO7WmWJoy+
BF2cqmBIz5x75a/T3PBa2P57rQ+weiYVIAY01cOjNydiTyxTTBTVgAGy/Yz1LC9Q
iL/GnpQOugPWhUnJPSvutipWVST0s3x44JHRZedGS5OAUoL2o3ShgeOQQtW6WTu3
k30G4YBVd619RCHdO2IV0HWpxMwEqQ==
=28NP
-----END PGP SIGNATURE-----

--Sig_/N+8f45KqlWeNX8c7Gt4=XzP--
