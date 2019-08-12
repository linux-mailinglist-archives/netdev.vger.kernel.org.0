Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E1F89507
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 02:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfHLARo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 20:17:44 -0400
Received: from ozlabs.org ([203.11.71.1]:51939 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfHLARn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 20:17:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 466GdH6G4lz9sDQ;
        Mon, 12 Aug 2019 10:17:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565569060;
        bh=tTAmM0rqLDF9JKfis5IQj+l/3eMnopG/qapZz82Tfw4=;
        h=Date:From:To:Cc:Subject:From;
        b=DKdwKFCblq0vflHXcsTCLxRhBQQt5SEXTEEc3XWYBJIk48WXVjN7bdf+MH5Z+F0l8
         exJxYAofKsbvVeIAaL5xwbga0HXI54Hze2noBhjuh8Ohnfw6VdklDZ9sHQjkws39g4
         xdmdW28uj+qpdNCXTE6t7Hptz0SX3hTrMUIlmC/sC6EBsXkOPP5BpzA/eqHTnY6xSo
         /A4gCAWsmZ5Cn8b19fhi9oFihMnA81G4P7XIRSKBMa9syXuWX394Iy4DvuK2YYeSDD
         Py9SVvUubl5qOHmvLU0m2iTizEsg99JZFWhGoLHORwcQoSSxvt/yYyoMTTJaFHx+pD
         lV7ugrEX3eVdA==
Date:   Mon, 12 Aug 2019 10:17:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the afs tree with the net tree
Message-ID: <20190812101738.7175b852@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zv6DtvVw_99+.6wKZXNzY=E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zv6DtvVw_99+.6wKZXNzY=E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the afs tree got conflicts in:

  net/rxrpc/input.c

between commits:

  730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
  e8c3af6bb33a ("rxrpc: Don't bother generating maxSkew in the ACK packet")

from the net tree and commits:

  5c2833938bf5 ("rxrpc: Fix local endpoint refcounting")
  49bbdebb23f2 ("rxrpc: Don't bother generating maxSkew in the ACK packet")

from the afs tree.

I fixed it up (I just used the latter versions) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/zv6DtvVw_99+.6wKZXNzY=E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1QsCIACgkQAVBC80lX
0Gy4ggf/Yuq6vmzz7FfadDXkA54jmOilB0+AdejIcQRlmt2R9K47D5qGWb4/ZEZ0
aSWYuck82HAzSLtr6YuMYY5azsx95Vi4Fppz2NaIEfBFltiIgVzSMu/oJ1QGzFjo
XbpvEybXytXtguf4VqsWLNMr0ydKxbuiQlO1Z8wsNRB6e/MWdzvfQ2ywfKAV1V3Y
td4fd+0I/MuCgQZBehsLyipPoLDaw10VfXDuYXfuRvEHnIB1QYHvVdJXGVOF6tDk
QSOKv0G9lc+FH1uj7xARErB3pQHykH/p7a68BAZ1OybwjxMplLdof1MWXCTuhO3B
QXxpNiNeUDOOes6eHRdOYJaVioohqA==
=Qsr7
-----END PGP SIGNATURE-----

--Sig_/zv6DtvVw_99+.6wKZXNzY=E--
