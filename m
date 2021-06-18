Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3445F3AC0AE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 03:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhFRB5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 21:57:48 -0400
Received: from ozlabs.org ([203.11.71.1]:60309 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhFRB5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 21:57:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G5hpH5W9Fz9sW7;
        Fri, 18 Jun 2021 11:55:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623981337;
        bh=XmyczsaQJihdD+7yn5OfStr2NqGehTh8SfXAVkoT4UA=;
        h=Date:From:To:Cc:Subject:From;
        b=Aj5s6kzmUqVCwdg48oFyA4+4YGiUy/rLH+qkATlNd6V7PHUOt3EckY+MCXHwoAyYl
         QiKcgQqJOQxXCoOt+l0ps9vGZdcgSWFQpHc8FDa5OEelSPhH0Zl+z2GeVCT/Sa33RU
         wVws+tY1cLwkZ6jWVDgeqdROYM8nlo16jcqIUGaOvME4TVcphZOvspvVgclc5ogIWL
         XEGhPelmGPbXz3oUbH1dfIltt6Ck2P6fPPFJLrDJfmwEUi3FZ6tfyHLW4C4FXGf+PV
         uoBReRTA8uL2uDJMRQMIPJD1DCGr/17Sx/qoc7rCCCilUrs/GyfGwmR+oB5riGICOv
         46svGyQSpbZyQ==
Date:   Fri, 18 Jun 2021 11:55:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: linux-next: manual merge of the net-next tree with the jc_docs tree
Message-ID: <20210618115533.0b48bf39@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/951M1p4Xhojfz7Qb2cfUEEx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/951M1p4Xhojfz7Qb2cfUEEx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  Documentation/networking/devlink/devlink-trap.rst

between commit:

  8d4a0adc9cab ("docs: networking: devlink: avoid using ReST :doc:`foo` mar=
kup")

from the jc_docs tree and commit:

  01f1b6ed2b84 ("documentation: networking: devlink: fix prestera.rst forma=
tting that causes build warnings")

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

diff --cc Documentation/networking/devlink/devlink-trap.rst
index efa5f7f42c88,ef8928c355df..000000000000
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@@ -495,8 -495,9 +495,9 @@@ help debug packet drops caused by thes
  links to the description of driver-specific traps registered by various d=
evice
  drivers:
 =20
 -  * :doc:`netdevsim`
 -  * :doc:`mlxsw`
 -  * :doc:`prestera`
 +  * Documentation/networking/devlink/netdevsim.rst
 +  * Documentation/networking/devlink/mlxsw.rst
++  * Documentation/networking/devlink/prestera.rst
 =20
  .. _Generic-Packet-Trap-Groups:
 =20

--Sig_/951M1p4Xhojfz7Qb2cfUEEx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDL/RUACgkQAVBC80lX
0GxBhwf/TiJXYFl1pmGuXq+x8sV9KjTpACydjFxe2N16HC9bG4O3Utp6i7JCpelJ
nEUBpDecCVk+5Y5MvAOD/TkHa4LpU7/vpjCDx6Yh6gete9sClu3k37j1aRBtna7a
XqqLFG1GUKdVH2E7XuNlhMFenZ3+P4ZdikiiqDki5dG+eKonELE90eiUmO0KmiEC
0901TS3QRaq43NOq2BFk5AGvWA1nYKHd9EJtAGglMf9F7JgznYhepgpzTaNTn4Vq
HRtoD1ylgRHmR5vi7YA2n/sn2ETl2rVn6ZddBOTc7X3Z6esLkZM/RTdiXIUemnWQ
dc9dHFkkByjmTqocQImtkq8YVeNxpg==
=MwXc
-----END PGP SIGNATURE-----

--Sig_/951M1p4Xhojfz7Qb2cfUEEx--
