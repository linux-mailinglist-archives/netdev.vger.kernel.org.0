Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1ACB12CD
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbfILQ3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:29:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:13461 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733217AbfILQ3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:29:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 09:29:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="asc'?scan'208";a="386093417"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 12 Sep 2019 09:29:46 -0700
Message-ID: <869eb0382ed7c639332a5db5e29eec143c37a809.camel@intel.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ilya Maximets <i.maximets@samsung.com>
Date:   Thu, 12 Sep 2019 09:29:46 -0700
In-Reply-To: <20190913022535.65ac3420@canb.auug.org.au>
References: <20190913022535.65ac3420@canb.auug.org.au>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+R+RqxlQSR8iroAeA21A"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-+R+RqxlQSR8iroAeA21A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-09-13 at 02:25 +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>=20
> between commit:
>=20
>   5c129241e2de ("ixgbe: add support for AF_XDP need_wakeup feature")
>=20
> from the net tree and commit:
>=20
>   bf280c0387eb ("ixgbe: fix double clean of Tx descriptors with xdp")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your
> tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any
> particularly
> complex conflicts.
>=20

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

On how you fixed up the conflict.

--=-+R+RqxlQSR8iroAeA21A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl16cnoACgkQ5W/vlVpL
7c5x4A//XxfN9S4i0lwmc/GIFAWfPZ6SzCyKX5sf5/XIPMt2eBlIljiN6fKCf1m4
T9dX+7NNUZT1OPIYFrGnB1Ahs1ARQlvVDSDybCk0oYGdIsglGGiDA2YhXfR/LRIT
LJhdyo38VccRSeGjxixrzrKw5ut2RJ5NcRL5FGzuZ+i2BNVRIxjh2gW+cmGqT1gM
nu3ph7Skn85072PW4vsgKs/SDPbZ9ouHvafRkq6TnDrmBMLKpMplSw2ov/HlYGvo
OgtSg7pEcWeVjS2VXX18fDkoVopzS18fF6sR7i13MBi4A8o68y2d5yBTGuo9rgAd
FEaZyN7So/Y39KmjMs1U3XAUDEIJ4of0BdpdxzC842SmUDV0jnA97TC8woZPltkd
4hYOUTIbFz9/PEezna3aGCP8M5ZEdEtEtNGCILdR45A9jAONdQQDjPgRoXJz/UpU
+sz5Hz45rMU4oN8qG2CHhu+CU+q1Y9gO7YQoEICaJs1IX4XUBJZs3gtMVXyS0IeY
ybG/33YUVrYyJbvUMmPe9y3oqs2WGhwaWrJQrqe9tpy59GfMq0eKhQQN7LGVEJKb
h1JLrcXn2Euxtd1hwqLlwxIYEf18dITaRU+MgJ6zz4Voc60XbZivEzS4HA1Ekjqy
gApl3VivUUSckF45skrChKJNgiCeD+2j9Q77VAu1+UtsHecJGE0=
=Z0mz
-----END PGP SIGNATURE-----

--=-+R+RqxlQSR8iroAeA21A--

