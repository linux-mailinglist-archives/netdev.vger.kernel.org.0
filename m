Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1863E191E3B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 01:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCYAkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 20:40:23 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53419 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgCYAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 20:40:23 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48n8R80zKKz9sPk;
        Wed, 25 Mar 2020 11:40:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585096820;
        bh=Bai3sk8CLodeWGRu1CYGl+WPcRwjBXEwTh1ZqVH0/F0=;
        h=Date:From:To:Cc:Subject:From;
        b=SZuiJWZjueCoU/j2ge/QJZn5TO8/hbxrbvdGMY0tdUQznTjEXROCYx90KhZvK2r7S
         AZUcYE3j69ONyJTPgm9k8VBQy+GRwJZOsS/n4xnyoeQR2YsMa/369Yw7+zT1pGktLq
         cRbYBsWkQMwALGn+8J8xmqVFff5+8zUqedVzBK/W0eJBuLkKE+hvI27U2Uix83qAq/
         bOVKLD2xjNYjAYsjBaujQaAT54kSwVI77/lzCNRG1nERhmv+8IL56VwN81LpHb6XW7
         8q0sJ8JCVqDovfkLeLMOQLU4r+jIZIu3Dk0nQ/dTo9W6AVvRIyPJ8MWvHslbQMRlCL
         +WJ1WbwJLx8eA==
Date:   Wed, 25 Mar 2020 11:40:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Era Mayflower <mayflowerera@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200325114016.156768f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sv3AX7jQUXkgO=e5bapi3NH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/sv3AX7jQUXkgO=e5bapi3NH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/macsec.c

between commit:

  b06d072ccc4b ("macsec: restrict to ethernet devices")

from the net tree and commit:

  a21ecf0e0338 ("macsec: Support XPN frame handling - IEEE 802.1AEbw")

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

diff --cc drivers/net/macsec.c
index 92bc2b2df660,49b138e7aeac..000000000000
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@@ -19,7 -19,7 +19,8 @@@
  #include <net/gro_cells.h>
  #include <net/macsec.h>
  #include <linux/phy.h>
 +#include <linux/if_arp.h>
+ #include <linux/byteorder/generic.h>
 =20
  #include <uapi/linux/if_macsec.h>
 =20

--Sig_/sv3AX7jQUXkgO=e5bapi3NH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl56qHAACgkQAVBC80lX
0Gxt/Qf9H8xBjtaPori8bP7C7ScBjmtat11519pOpi5LyDdlD1TjEQNV93SmAi/h
TsfTKpq63rLgfQuEdY7qX4HCfFZtjgfLENbt7Q4ManjoDBmtPTjUz9B7FA+q7nrI
2bAUjLmapVq1WAK5C5B5kd1wsoVl77FEi7KU29lsYA8K0cgD7JsipSqEDQUldU78
C2fRFgyde4XbCL+9VnPZmoWDA79qFINZZiYzPXk29lB8MGuE6EeAbYQDoYg7I5Eh
eVShEytRIEbACpIyYotW8ucJLvOednmCYq1vldaw7BcSuUSlm2pxqbyp04gaMDIy
A9TUG1Puw6EaisLvHAiLmhTzosv6ew==
=nL9v
-----END PGP SIGNATURE-----

--Sig_/sv3AX7jQUXkgO=e5bapi3NH--
