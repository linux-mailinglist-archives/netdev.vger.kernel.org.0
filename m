Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1984DE974E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 08:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJ3HmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 03:42:11 -0400
Received: from ozlabs.org ([203.11.71.1]:41025 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfJ3HmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 03:42:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4730lj0Fwjz9sPL;
        Wed, 30 Oct 2019 18:42:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572421329;
        bh=lQsONMpR0MTh0vD8YZgUvYKo0894LJy7XmchuzJRsso=;
        h=Date:From:To:Cc:Subject:From;
        b=RjMBPwrc7N3a8mjOZctzrZlMd0bvdXYv5ALLN6gs9S0aeq3aSmbByi0vsT8Kc8/ic
         Ud2y8nHqOP8DMNFnDcBXU/u1QV9w9yiKBD6AcNM02Wc9sb+UT6uTvcQ2YHon1U2QG5
         EKgO2Mj1c/YGfcGrI5N4p4T1o7Zr/ilDbavQAMsNsx5oc68qHDdFYTHxcK+mqNAdLS
         WQXLie9bd+PAFpqFV/zJ2JWMu/Op1j8bdNnZ/m6doKm9YQCcuxv2usFF5SesVu9EnS
         QoI81DWnrnz0GB5mm0nsUTDGq9TaXUZ92bhyLjSWKzKerOO2y45VOgbnb55+l2bEQW
         hfYJOOvjPF1Ew==
Date:   Wed, 30 Oct 2019 18:42:07 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20191030184207.68236e5c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dd3m0J8qrfiSEHOQDGRYhwQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dd3m0J8qrfiSEHOQDGRYhwQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  621650cabee5 ("i40e: Refactoring VF MAC filters counting to make more rel=
iable")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/dd3m0J8qrfiSEHOQDGRYhwQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl25Ps8ACgkQAVBC80lX
0Gxsdgf/Sc1xc84sU9mPli2JcsYZsOgPJvS6PKBDUe98cPegMfS14e2FEybV1rh1
p7yfsIBT+lvJ5Hg+H80rVpv7mjAA2E2hr5Yo0OJYWQBTnObwifbpEjR/wBvMOzh8
+/feKNUHmKsPmNEwVjdZu+c5YFarVyl+gDkS94aqJ9vv0BrtbvEtWjcI7AKkoQL3
RVZ4jytwYn0LxNFnVzKC8KVWPPanxQs2ZFiuYZUyD/j+XiC1y4fb2rVq9zO7TVUt
oF18XGFX1Uho2xS0k5wFumMIYdVRGRKphqK5r133r7wFMc+Qcq0z4cAVLAtH6jTq
20tHNmJa0hCgAKHsNIuRz9TsprhuSw==
=R8Nz
-----END PGP SIGNATURE-----

--Sig_/dd3m0J8qrfiSEHOQDGRYhwQ--
