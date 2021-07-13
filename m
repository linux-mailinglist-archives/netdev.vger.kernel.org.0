Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2773C3C79A3
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 00:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhGMW3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 18:29:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41039 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236344AbhGMW3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 18:29:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GPZxW16qZz9s24;
        Wed, 14 Jul 2021 08:26:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626215215;
        bh=LxsApQZowMIJGUYum3V446Peey7HP/sSDp6TEeZXofg=;
        h=Date:From:To:Cc:Subject:From;
        b=gM/2TO8/I8o5r5JBfRTmc1KYQD/zx8ioFTiPsEg5mk5nWeQvGwyfVdvY0cy4D+/rs
         Vem4rIBQ1wfjVSoTj5kqa9nMPyjIte+W11Uc3sYVTFDsTaB1BqGixDb63K6ivUY0Pw
         tq8UbdqYwilE6ctsvyApXxdr0v2YJWmV1S8TfDqDIRubtjBPEoegrtD5OWQXUMat/k
         o3zuiZ5sdk3Nt627wgOtcEaYT9MobLWWEc+G2KU8zwIAqaGW5/BVGRYfSI4zhsY5iM
         RsyG5ihqUx3NH5abVbW0w34cxv1Rwe+s/S4tPH7/jFe9zjO2SPae3VALRNB0yH8IyU
         0WXtvL85llE6w==
Date:   Wed, 14 Jul 2021 08:26:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210714082653.612f362d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/14iO_U3OP.vQBPRjFq4J7uU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/14iO_U3OP.vQBPRjFq4J7uU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  deb7178eb940 ("net: fddi: fix UAF in fza_probe")

Fixes tag

  Fixes: 61414f5ec983 ("FDDI: defza: Add support for DEC FDDIcontroller 700

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/14iO_U3OP.vQBPRjFq4J7uU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDuEy0ACgkQAVBC80lX
0Gx3agf/ZtZVj7VyxHpj0XT+9gvUf+Max0GRPEwstCr+0qjba0y4lSnsc5FVXnud
sVRT/Yhza/SNIg5Zb368aujKARsavibBNCSIDD7nnYoJ+/WF79xVo6wxe8DjlwT1
Ph4G9Dq++R6uWREXMoXfeBl9sw+BvmG3vSZ/czGiJNINmYxM1tK/Tum5OypLx8+1
/sVCwlfF0rYu5OB4Z0Svgs+Ws9viA5rGOdpQbLK1GGhjQaLeUjB1YNEk3aW4k2GI
UHoFun78PwJjccGUVZo8CoICEoLlotvvllRkAogrSGPx5GTl/imG2CBPEPvTDHo4
gYWJCTC2ZzDW1Tqq3jcBv4R17E2p7A==
=R8V5
-----END PGP SIGNATURE-----

--Sig_/14iO_U3OP.vQBPRjFq4J7uU--
