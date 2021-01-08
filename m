Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942252EEA63
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbhAHA1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:27:37 -0500
Received: from ozlabs.org ([203.11.71.1]:44733 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbhAHA1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:27:37 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DBkSF43Llz9sVy;
        Fri,  8 Jan 2021 11:26:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1610065615;
        bh=mS4M6o3uvcn7ORG7o4f7rFpKYsO8/j0ox8ada/Qz2Mo=;
        h=Date:From:To:Cc:Subject:From;
        b=EHJj1mi7hyRAVHrpAXHYGfx+shPWx08E+bj/ZVv2XO8WRfS2OCzZly1JfuBZojEv9
         mJV/+vPUL0pJz17VFlkVSeXeGkdgfgN/7lTE1FqFLqtQRoKxEziT6e745JcfogXqyy
         9WKMuGCdZN7S+szTy9TRS3Us5LUBmzksOUUvEuLPKz27pmtnhUQVzR79mOBmGxRcPO
         s5fqRNh7qXdQa89AtIK2ZyAs4lu/ZyEleLgXXdDGKBqLIybMB3B+SeiCOKUufxbQua
         dHuKA2FYqVPCCqFpE+8IpHgglRK2ayrRQYCGRZ6igyzeVzy62/ZTSAdRzTsthBjnaU
         gAR8pjPTcx4lg==
Date:   Fri, 8 Jan 2021 11:26:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210108112651.671ba0b0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/R41lvpKas/jS7CyceB/qobx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/R41lvpKas/jS7CyceB/qobx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/can/m_can/tcan4x5x-core.c

between commit:

  aee2b3ccc8a6 ("can: tcan4x5x: fix bittiming const, use common bittiming f=
rom m_can driver")

from the net tree and commit:

  7813887ea972 ("can: tcan4x5x: rename tcan4x5x.c -> tcan4x5x-core.c")

from the net-next tree.

I fixed it up (just removed the struct instances removed by the former)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/R41lvpKas/jS7CyceB/qobx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/3pssACgkQAVBC80lX
0GxO5Af/TyldfLmPw7DLxwDAE5QaBz7hwsFs1bj+6LlfMEQXGNjtpZzoZhOsKJlu
WsjIQOrVqp0X+FWMvsOm2UipcZx9tm5u/KwGj7o8/PWYv56A3cPOvG3MdFnVMfLl
WS3xtXrRXrM+pHkOmWSHEXlVk/Lx95A8EUu6zonqfR/62HzFLHi+yU4Y40vzYevz
8JGEKSGHj0aMdy+p51cqgSV+WMK1fG4rJbRoRBQSJfQQ4R+fC4dXe/ldhCcoVPl5
zbzhQPO9U6i195PPrOW/BhkQQlQj9uI7lh7Mz40RcwXC0qjQl8nuuyR+fHLu4vp8
c0pBja8iKBLGGqkGNzpFtg/P7Eq1FA==
=3UsL
-----END PGP SIGNATURE-----

--Sig_/R41lvpKas/jS7CyceB/qobx--
