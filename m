Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FFD181B9
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfEHVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:43:21 -0400
Received: from ozlabs.org ([203.11.71.1]:51507 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfEHVnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 17:43:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44zqj12YVsz9s7h;
        Thu,  9 May 2019 07:43:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557351797;
        bh=S79DeqKFsnMK7Z+G0v4i11VpRAQuuvyknUIOHBC/TYM=;
        h=Date:From:To:Cc:Subject:From;
        b=YWFEOs2zfM3FpwwcVv96Sgi4t+ZudQflk1EZBkay+G3t9vDvjAv6XvZ6gNIf6PWRs
         G9PUQtBqiR/vlEiF7c0tQ1H0U1aNmoNpesAmZiElWcaUprnWBodQSQWQkTa9BDjBY+
         Qu56cD7rHzFAvUYG1kEA2b906rc+Zqi+EtKgdVI22+jvaV4qFk6aSXs0PEUa3UmNme
         YJWCbtMygZPjua+Aq3/noUBdpUBU2IiaRe4aE+FcGkcC28JHKMF3GhUj/nbOZ4dhDE
         fz+dCiiNiqLftFxU1sfWSOKIgKs3AVI5yDcw6w2B+rNs8toCi19BmEsKJSGFohvluZ
         Chtiv/p/sp2dg==
Date:   Thu, 9 May 2019 07:43:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: linux-next: Fixes tags need some work in the net tree
Message-ID: <20190509074308.7c0ade7d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zd_DhxPtPy7N5zeooSkhzkt"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zd_DhxPtPy7N5zeooSkhzkt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  3b2c4f4d63a5 ("net: dsa: sja1105: Don't return a negative in u8 sja1105_s=
tp_state_get")

Fixes tag

  Fixes: 640f763f98c2: ("net: dsa: sja1105: Add support for Spanning Tree P=
rotocol")

has these problem(s):

  - the ':' after the SHA1 is unexpected
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

In commit

  e9919a24d302 ("fib_rules: return 0 directly if an exactly same rule exist=
s when NLM_F_EXCL not supplied")

Fixes tag

  Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrul=
e")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/zd_DhxPtPy7N5zeooSkhzkt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzTTWwACgkQAVBC80lX
0GxlCgf/b5yD/Wnlo5qm4dcDRcTmKTnt9HgRU7xWAPTZto5fDLbiUsRkyx4+bZHb
Z+6+drXkIQxh68OIKmpyA/6NItK7GukC5AwaXwz3cwOu6FbWwjSqw2Jbmc3zr1P1
BWbiKZd9nZtCer+lobMox4aWMOqXjt8XQLaoXABNhsMSMe/NP4/B0YoyHyuVdBDy
d2IEdL19ReyQeAMGUjQTBE0QgSsfTP2R933BsoFaODw8ApGMBLIij42M74SuIWs+
eIt2a+Y0nAVjy2uBZ7sjQfVuhz5s36h5xeweaq70vbdteD0eC2u9tNQENjfblxwB
HsShBhEhqRPsiCGD0LyavIguYLrAeg==
=G0pe
-----END PGP SIGNATURE-----

--Sig_/zd_DhxPtPy7N5zeooSkhzkt--
