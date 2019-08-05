Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53AA82708
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfHEVih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:38:37 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44075 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfHEVih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:38:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 462WNV4wqwz9sN4;
        Tue,  6 Aug 2019 07:38:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565041114;
        bh=E7WNoqdcZNgPLfPqVYfekY7Hgga7szM/usccC7EGb0s=;
        h=Date:From:To:Cc:Subject:From;
        b=JWWxH6CDEFiXRawn4//9VhHBOHEsBdpRXdfyiDMjrTUdlsl50MjR9vImj6TPJ/1uL
         4OD8AWy2+gJ+CqdxoVFyxCcWLH75v4erdzyVWpkHxwqsSj1M5+JQuZTneg+LpKl1K7
         UXBudyZCOnIqA9aD9hvJ5lXxrNgslNAXxmFOK/pTIyZ6wLa5hL1xe85xGUgOp+sibN
         2LstoCJ+lEGAna3V62CUQbfJJsd/tsTK/+PFfFxBCdoZFvP4W9rU6ll4/Kv26C+dhG
         T3V7hKKdPxrt3iEoFq8ks7F3fslSJkCU+hh1L8Tb65DOK0M+t/xH5nKYHVTWUkehHZ
         dhkhA3knGhl5g==
Date:   Tue, 6 Aug 2019 07:38:25 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20190806073825.6e6ba393@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nQVt.pCwO5eDK2yu8K/gXn5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nQVt.pCwO5eDK2yu8K/gXn5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  c3953a3c2d31 ("NFC: nfcmrvl: fix gpio-handling regression")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/nQVt.pCwO5eDK2yu8K/gXn5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1IodEACgkQAVBC80lX
0GzeUgf/bMTMu5IpZMz+Q/F6sha46kx5+/PP6kwY4FmahgyP9neX64X6wI9rBKxp
qEde3blmwvk/pkIA2V7O0BdB5C8ZP7eK+7K8t9l9e6K0XWTyB/KRQ+gIY1KY7jD/
PhvRUGS4LWoEEhBklBlG3xamPL0VYRFLLsI4W4b2tR38mevWWy4E3ewOcKwIb2xQ
r8bk78LG8X56LqAzcxOAw4rkVB/87WZA7JV2pg7zUpyYXknH0rWvK7+8If5BnYPe
7qH1yEXKQjG1s2mUTMYiNJLsCG2mCpPHa/4dr0+cgorLIzyRBFzD72DppdTf7uQ/
ZtLF6XrXkiaqcSVxpiDOdQu4+rdKew==
=t/KB
-----END PGP SIGNATURE-----

--Sig_/nQVt.pCwO5eDK2yu8K/gXn5--
