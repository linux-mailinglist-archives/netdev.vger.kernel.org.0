Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6381B4FF9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 00:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgDVWQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 18:16:42 -0400
Received: from ozlabs.org ([203.11.71.1]:33437 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVWQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 18:16:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 496vsv17yRz9sSY;
        Thu, 23 Apr 2020 08:16:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587593795;
        bh=b3FpIbBdWLCE6rrc0j3weoC6BUfVk+LOtjJLdfX/Jw8=;
        h=Date:From:To:Cc:Subject:From;
        b=m1T2jrtKqALUKfvG5oQq52Lf4IKxe3TotkzeAIehzfM48hdeSjy6boOMROdDsGfNY
         g30OHsa2Ap26boYCBFx4rUR0QEUQm+SLL4UfRfnV0xLC8c6xWIntSmCTBiehL5O0ny
         xcq+qgmOvvY+FaXVRamcHCuEUid0bu0IPFJG6pCjtzimZKn4KWK0wYntoamJQbCR63
         6Xo/SSZG7iWu4pGEWAAkAVpeJR+O52nfr0qZ8YxrcfvFBeRnts0z7FOnHkN8tlGVsw
         1yPaWRcKKtW9nbEMUGJSBO0N9DmlLDkG6KHAECDSAmb3EyhqoF7sJt/deqsgDIcx3s
         IrcskcUMHu3MA==
Date:   Thu, 23 Apr 2020 08:16:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20200423081633.241888b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jUmrQpVGYDI4bLnMZAYPPUL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jUmrQpVGYDI4bLnMZAYPPUL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7dec902f4fc0 ("net: mscc: ocelot: refine the ocelot_ace_is_problematic_ma=
c_etype function")

Fixes tag

  Fixes: d4d0cb741d7b ("net: mscc: ocelot: deal with problematic MAC_ETYPE =
VCAP IS2 rules")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 89f9ffd3eb67 ("net: mscc: ocelot: deal with problematic MAC_ETYPE VC=
AP IS2 rules")

Dave, since you don't rebase your tree, can you start pushing back on
these, please?

--=20
Cheers,
Stephen Rothwell

--Sig_/jUmrQpVGYDI4bLnMZAYPPUL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6gwkEACgkQAVBC80lX
0GzHjgf+OvN/fIzhtSNJgATqEPg+xYYEMCnt5domZgarFplYXOPg8hTWPACM86ax
IESL1YiAFOSB9c2YDZPXNm/2tLDU/EGjGnkm3D3gdPyqlURzFjuze9rA1klPCn8c
U4UWqoNTkLO7vqi1c52LOtfRySsLumM9t+mTGtqAjpQo+mYIY8Vt4R/r0fHxc4QT
spMPno5x2nY5E/8rNnWA4yYTNnKrM7ngWaftY37/h6W7KYVEV9+dVDBR0p+/ROYT
zZey1QQtOxqo+9P3ZKgrlnO581/q/1gznUF1feuUDBbJ3eo4bxWADidCzdhszU9v
h8yWcNJfXqbz2p12+nImS7O2JPWtiA==
=PKvZ
-----END PGP SIGNATURE-----

--Sig_/jUmrQpVGYDI4bLnMZAYPPUL--
