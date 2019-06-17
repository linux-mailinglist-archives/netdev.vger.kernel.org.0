Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019F9477BF
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfFQBob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:44:31 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53929 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbfFQBob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 21:44:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45RvCH2Gm8z9s3l;
        Mon, 17 Jun 2019 11:44:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560735868;
        bh=uyDPSEsGbtzjM2k7wvSdt9RNOft85m5KYBjz3pWVb3w=;
        h=Date:From:To:Cc:Subject:From;
        b=dR99MtiYoyqswo63D/sDCiGPoIJQ4Y5r04+OP/LAjQknfgVS5N/5AmglDgAyeaU8+
         1TrQxdStN858fJbnB0+HdhbUfTkcjs0V32zpPkuY/JNYqq2aj5scDvxi0f+JPakzio
         oCiaWIkB1lJRwMTXNX50bIwQxWx9kKaWs+bIr1LIta9y7wEpzu5NmVM6O8liN5vjcJ
         DfbjRj2/trbjI1AM0thkKwaQUer9pJnJ9mtNsU3jyW+19ueh132as4puVl1Pw+lTVB
         ih+VASD7fGLedKoRT5irq8I1e9c3mXt3dQI3tFTWLsY34GcoNZw9f/c/0dAWLnuyql
         06BRzG+ML9dng==
Date:   Mon, 17 Jun 2019 11:44:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20190617114426.252bad21@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JECoWF66TezDh1sU.LvYkGn"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JECoWF66TezDh1sU.LvYkGn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mac80211/cfg.c

between commit:

  28c61a66abd6 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - =
rule 432")

from Linus' tree and commit:

  bd718fc11d5b ("mac80211: use STA info in rate_control_send_low()")

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

diff --cc net/mac80211/cfg.c
index a1973a26c7fc,fcf1dfc3a1cc..000000000000
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@@ -5,7 -4,9 +5,7 @@@
   * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
   * Copyright 2013-2015  Intel Mobile Communications GmbH
   * Copyright (C) 2015-2017 Intel Deutschland GmbH
-  * Copyright (C) 2018 Intel Corporation
+  * Copyright (C) 2018-2019 Intel Corporation
 - *
 - * This file is GPLv2 as found in COPYING.
   */
 =20
  #include <linux/ieee80211.h>

--Sig_/JECoWF66TezDh1sU.LvYkGn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0G8HoACgkQAVBC80lX
0Gykrgf/eqAM1ycrNANPAyOVqu3sbuVyCl/APrEOHs6uN8op7AFKUBIME6O8Jm0g
6IBSKqCoEJ+YX60IjFZQ7wneF+bwyDxjczqMnibqvCiLIWeFi9+13vkEsPgV3Yhu
OgSHz8hLV92j17m8Rhbb+0lSC7fqJJ0au00CL29XU69rnDMM7xMfzNJGB5SqC6nx
CFfyKl2VCWyoekMSD7ZT/VVO+iUo+D7DZdSRwseKeZasbD0BLwH8vjf4dlseKGxr
2mmNH/j/yp2hfhutYV5f62AJOK4cIJeYOhbGVnyR7VgrL2hKy6OkcO100j7qXpz5
Bm4Wn4TAu0f34EH1zt8YP0brrhfj1A==
=lq8O
-----END PGP SIGNATURE-----

--Sig_/JECoWF66TezDh1sU.LvYkGn--
