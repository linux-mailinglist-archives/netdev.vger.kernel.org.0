Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAD5EF287
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbfKEBWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:22:04 -0500
Received: from ozlabs.org ([203.11.71.1]:47239 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbfKEBWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 20:22:04 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 476X2K1Sz6z9s4Y;
        Tue,  5 Nov 2019 12:22:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572916921;
        bh=1vKvH8dq3Din2iU9Kt0PmrHKb5TX/e5tlrWzgG30Xpc=;
        h=Date:From:To:Cc:Subject:From;
        b=jA9eFPvpKOSX8v7RyBEp/yLxXG5LKGSE1vfEp5H+EW0BB1y3silGPmWIeGtRZjeYa
         OqipzPwKsVWpVk/NdUaER/lWT7Af3Leh5aLsGdhCzVvH//y+a/dQfmFcf3lvnc+1GW
         FPtoDkK/s1dGKFgrv92xPDas1K2fMCPsdvxaoi8ccUYHmDpnhrLchPym/D3woD7LxJ
         OWaNTN9uMtzKeEAWKWb4I1/u5bOto3GB+hdFmVF0kayGHjVkLoOv1NpK3VX1u7iRyl
         n6oTrbu55/+4KnI2wyFPrnMau1Oj9DE3QYEtXHW7s/ljZUTBUI3kZmOCrBK6H3h4yE
         /iRmj7Zrf+2TA==
Date:   Tue, 5 Nov 2019 12:21:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the net-next tree with the
 staging.current tree
Message-ID: <20191105122159.6a285c9c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Mwec77+brgoTx7Au1mAl=A3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Mwec77+brgoTx7Au1mAl=A3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/staging/Kconfig
  drivers/staging/Makefile

between commit:

  df4028658f9d ("staging: Add VirtualBox guest shared folder (vboxsf) suppo=
rt")

from the staging.current tree and commit:

  52340b82cf1a ("hp100: Move 100BaseVG AnyLAN driver to staging")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/staging/Kconfig
index 927d29eb92c6,333308fe807e..000000000000
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@@ -125,6 -125,6 +125,8 @@@ source "drivers/staging/exfat/Kconfig
 =20
  source "drivers/staging/qlge/Kconfig"
 =20
 +source "drivers/staging/vboxsf/Kconfig"
 +
+ source "drivers/staging/hp/Kconfig"
+=20
  endif # STAGING
diff --cc drivers/staging/Makefile
index f01f04199073,e4943cd63e98..000000000000
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@@ -53,4 -53,4 +53,5 @@@ obj-$(CONFIG_UWB)		+=3D uwb
  obj-$(CONFIG_USB_WUSB)		+=3D wusbcore/
  obj-$(CONFIG_EXFAT_FS)		+=3D exfat/
  obj-$(CONFIG_QLGE)		+=3D qlge/
 +obj-$(CONFIG_VBOXSF_FS)		+=3D vboxsf/
+ obj-$(CONFIG_NET_VENDOR_HP)	+=3D hp/

--Sig_/Mwec77+brgoTx7Au1mAl=A3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3AzrcACgkQAVBC80lX
0GyWlQf/WnGTYpkNA/4DSckC2g4ZEuEpjr85BY/AZGLAcn2l7U6roAhxYkj3G4ck
D+mqWbTu+nSbTJTqC4viIghsUV3aRXZq3PuTQ6wqopOjxWwGdfKI/gDAKbY2lgWP
dZfkh9Bc5GHgyrq344kIAIGzfe+/NDKEpiKyfH5Ghen1iedb4bRa3br5/B+WIHgx
NAXvU1//9nzCspn2QUQ6LYygMwqBkx0Bkh6j78iYs945gKjGtebdiib5lbPVReQm
GZN0vS1AO3F3/q6X0Ar5ILezfoZWf8KRuFpBwIk8UvQ7GPIwQEYX/i3hZKm4G/0C
6qGDW5LV5VwoaHZPGrGBwH9rk4YJBg==
=TbGM
-----END PGP SIGNATURE-----

--Sig_/Mwec77+brgoTx7Au1mAl=A3--
