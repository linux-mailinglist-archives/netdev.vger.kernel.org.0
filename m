Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED5F87154
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405193AbfHIFTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:19:44 -0400
Received: from ozlabs.org ([203.11.71.1]:47853 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfHIFTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 01:19:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 464YT86Y04z9sP3;
        Fri,  9 Aug 2019 15:19:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565327981;
        bh=BR9Ij2+hk/2oswruDRALxXKgz1mT/r0E9zp7O8jaShw=;
        h=Date:From:To:Cc:Subject:From;
        b=q/obf0UAMQ/EbWfxhmZfenl6EAtNDUbmfs30QLIr8kpLIu9teref0n2u/bKAkbLF5
         TXyKrVbztHfro82HcTeZ2sGJxKcY5v52wCTmmF/sFL1LE61tBBm2EJXVMLiNo5XMN+
         oXm5No8LeXzvikAP7bIyGk7HjagrjQt3/wWNiSMUhgPG9x9+3Q2GQGOaPzluwmkuON
         E4b/4hOXpojDLRP08+5Ix0firyGIPnWGKxbeLo2shmGb6Y1vnrkBI0UwM9Wz+mTDYM
         kTiq7vgM2ZYYm2LTTwJQZxpCTOW8hN+msKXpIAMdwr0nxWX/NIPxLVxAdzDi2vxCc0
         Tef3oyouMyQzw==
Date:   Fri, 9 Aug 2019 15:19:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <bpoirier@suse.com>
Subject: linux-next: manual merge of the usb tree with the net-next tree
Message-ID: <20190809151940.06c2e7a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.l+_1uVzQ3ayu/CLvyiJFn3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.l+_1uVzQ3ayu/CLvyiJFn3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the usb tree got conflicts in:

  drivers/staging/Kconfig
  drivers/staging/Makefile

between commit:

  955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/st=
aging/qlge/")

from the net-next tree and commit:

  71ed79b0e4be ("USB: Move wusbcore and UWB to staging as it is obsolete")

from the usb tree.

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
index 0b8a614be11e,cf419d9c942d..000000000000
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@@ -120,6 -120,7 +120,9 @@@ source "drivers/staging/kpc2000/Kconfig
 =20
  source "drivers/staging/isdn/Kconfig"
 =20
 +source "drivers/staging/qlge/Kconfig"
 +
+ source "drivers/staging/wusbcore/Kconfig"
+ source "drivers/staging/uwb/Kconfig"
+=20
  endif # STAGING
diff --cc drivers/staging/Makefile
index 741152511a10,38179bc842a8..000000000000
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@@ -50,4 -50,5 +50,6 @@@ obj-$(CONFIG_EROFS_FS)		+=3D erofs
  obj-$(CONFIG_FIELDBUS_DEV)     +=3D fieldbus/
  obj-$(CONFIG_KPC2000)		+=3D kpc2000/
  obj-$(CONFIG_ISDN_CAPI)		+=3D isdn/
 +obj-$(CONFIG_QLGE)		+=3D qlge/
+ obj-$(CONFIG_UWB)		+=3D uwb/
+ obj-$(CONFIG_USB_WUSB)		+=3D wusbcore/

--Sig_/.l+_1uVzQ3ayu/CLvyiJFn3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1NAmwACgkQAVBC80lX
0Gzl2Qf9Hsotlxd1+c7wrVnnuSe1LDmg16HsfhGaM+mQqTucByTa3pTR3cy2LO14
M+snHLsoNEfWYzAAH2Nk7srNOPiyw+1SVnFCUqMgUR6pVQXn49qDU8tPc3buBHF0
BY46gxN/dWakmj184f3m3mxVZt32W233NM+d3CrK2GF27fv8mc7ztGUW9Oz5g/zJ
qZViy2jgargihczRv0m8l99634Os0Vt64K4z73Qn9iCXC0CTeoJoiy+1ugX0/OqP
wmMpwvorlUK9++VbqN28Vh1XtbtOdtvIhIjXPak7SbIHzLHkLDrTXj6c+1b2gF/j
B/ilwBJfP2PNjbR9jWH7c0E2V9uDkw==
=Cft/
-----END PGP SIGNATURE-----

--Sig_/.l+_1uVzQ3ayu/CLvyiJFn3--
