Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02A4436E34
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhJUXWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhJUXWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 19:22:00 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9C7C061764;
        Thu, 21 Oct 2021 16:19:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hb3NF2cVqz4xdb;
        Fri, 22 Oct 2021 10:19:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634858382;
        bh=6/t6+f25dFPDKmlst0gpSR2W5GgVgdO7IRWg9l8R+R0=;
        h=Date:From:To:Cc:Subject:From;
        b=FBrnlLKZIaV9qsYE6qxeYvX6uNZUZHHGeCzkPjdrXK6t70wRQLSlgTfUC5aJwbP9H
         0PuoTu9GeD7VV7TV74Q5pdxR7xXU13T7lrGTZ4kZtYP1NREdpOUGcOuJCMqqiEkNxc
         WALSa/FHVL1sFaU6dPfOG2mUXCaH4UCNFmv2b5osQHtOcGBI368aX5kOdvYKR1vdRR
         th4LgO3B5cnOHZyKlhPxQQvR/B3V5BJNXZ5JBCcpnb4rzQ/UD6U2EjWkl1lO/Cp3yd
         y4wlQVKcKuote1liA7LB0uszR06baRi6CGfeDSoTIHvMiysrnQcDxZIMdRg82hZh/p
         AqGc20mDIsuXw==
Date:   Fri, 22 Oct 2021 10:19:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20211022101939.3fb5beb2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wVyx0QaeSkc_b51qrGoZ=4f";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wVyx0QaeSkc_b51qrGoZ=4f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_devids.h

between commit:

  7dcf78b870be ("ice: Add missing E810 device ids")

from the net tree and commit:

  885fe6932a11 ("ice: Add support for SMA control multiplexer")

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

diff --cc drivers/net/ethernet/intel/ice/ice_devids.h
index ef4392e6e244,8d2c39ee775b..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@@ -21,10 -21,8 +21,12 @@@
  #define ICE_DEV_ID_E810C_QSFP		0x1592
  /* Intel(R) Ethernet Controller E810-C for SFP */
  #define ICE_DEV_ID_E810C_SFP		0x1593
+ #define ICE_SUBDEV_ID_E810T		0x000E
+ #define ICE_SUBDEV_ID_E810T2		0x000F
 +/* Intel(R) Ethernet Controller E810-XXV for backplane */
 +#define ICE_DEV_ID_E810_XXV_BACKPLANE	0x1599
 +/* Intel(R) Ethernet Controller E810-XXV for QSFP */
 +#define ICE_DEV_ID_E810_XXV_QSFP	0x159A
  /* Intel(R) Ethernet Controller E810-XXV for SFP */
  #define ICE_DEV_ID_E810_XXV_SFP		0x159B
  /* Intel(R) Ethernet Connection E823-C for backplane */

--Sig_/wVyx0QaeSkc_b51qrGoZ=4f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFx9YwACgkQAVBC80lX
0GzODwf/SbgfhCK4YZohL9xD9TRMbuZpTf++S8zyaRRS8O5az5mtZ30nUp7hBLhj
z+ilaAaloCasXkfPReCFC6Dr6LxaTNMRAap6q1XCiBtoii4/srVT0hMCww+l8Gby
vHeEQVe25ZCinMuWYPkJ/F35TRrZHEoyo0B6H8Ws+30vp3VIFADg3sVDneAo34+a
k4yJsRGOrBKLCm1MYoS2b1YDOg4ykEqGp+i0MBRlJZgQdUZtcRugcHNfqjnMljrP
vR2M0I4kVJlWInsMEVQcv7gZynqrKUXVUcyaAFNNEuU7XSJ4HYhQNc8/PN3nnj7S
IJQNrtzzZ4jN0NwHkz5afgrVpfeltA==
=PIid
-----END PGP SIGNATURE-----

--Sig_/wVyx0QaeSkc_b51qrGoZ=4f--
