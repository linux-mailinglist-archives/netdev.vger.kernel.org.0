Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9892379B08
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfG2VZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:25:47 -0400
Received: from ozlabs.org ([203.11.71.1]:45739 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbfG2VZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:25:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45yCQv74bTz9sBF;
        Tue, 30 Jul 2019 07:25:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564435544;
        bh=Hm4cWm4Sx9br2Kg/TJ4DCrGqjB3bgR17NwoIbxj8BWU=;
        h=Date:From:To:Cc:Subject:From;
        b=usKnPllxKTMUxfdejGQbEt0u308F4l0xxijWlKteoZ35vOPlCUXY0oeF3oGaz/EOj
         KTZhq5X8wixxYTOKNYr00hu7G2eHLMpriyGtxv1iPT5mOBLdT3Sjb+yQyYc3pts8mG
         nIkQ2pGArz+a/G2hYtz1r7WY/nNlTlRrZYGnzzCzJXFs9POcbMD6YYU9P86bihfC5w
         olRaU54D6AWlR63KWpkutvNj3pxRxwKAvUUAqHwRkaa7I9hTF51rzNo09jjcqC2p0C
         UkgA2j5u2DRcXA+tDtL2LqooTFHs2JF5wvj1zZas2sY2PbTisxfBQs6uCwPYvTRJHU
         d9mR/XVeD5t4Q==
Date:   Tue, 30 Jul 2019 07:25:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20190730072528.61dc41b0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4ff8KR8asv4YEcV_8eNUE9s";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4ff8KR8asv4YEcV_8eNUE9s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  473d924d7d46 ("can: fix ioctl function removal")

Fixes tag

  Fixes: 60649d4e0af ("can: remove obsolete empty ioctl() handler")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/4ff8KR8asv4YEcV_8eNUE9s
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0/ZEgACgkQAVBC80lX
0GwrmQf/S/RdpxuZete0fU6UtHVcS2Hs/FRIUPtqGJJ7XiIrlzUqnaN9or8kuNj+
0RG8p2IA270tME/EcckLg1coSIMNxZfXfmLSwTs+YalmalpGeHSJgcVnV/l6Tddi
b4MmZ6ve7lDKyxC/Nzx8e1gdAzMMJ/7ZleJ5giQ92x5pL0Vh4pmThEwn9nho7LA1
8vCNRmRT51DdVdAYzGEw7bd+twt5290RxUOeqpmYLppUt0aa7lZLsUQFcN8P6utb
eumtQIBdUk3Q0KdhsFwrFP0Z0sPK27drdpMgHTid/cFSaGGac+BDSxEiesTiyfxA
WfbvWU4y4E63WJi4FgcIviHCfwzorA==
=5FyS
-----END PGP SIGNATURE-----

--Sig_/4ff8KR8asv4YEcV_8eNUE9s--
