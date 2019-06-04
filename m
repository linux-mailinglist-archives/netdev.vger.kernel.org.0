Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7633C71
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 02:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFDAa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 20:30:56 -0400
Received: from ozlabs.org ([203.11.71.1]:44373 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfFDAaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 20:30:55 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45HtBP2ZZdz9s6w;
        Tue,  4 Jun 2019 10:30:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559608253;
        bh=dzXpENv1OmePxYHVyJSrUpufwoYB01ACwdxfvxnh4ls=;
        h=Date:From:To:Cc:Subject:From;
        b=sxV7P4iPNUZYxhCcBFE/DhTKZ17rT3AIWK4vj6ZxH3D+vfsk0/Pkjlae+8Tb/jy3g
         ZxcCB62gr1Q4GagcpQbpEq9QQmGNhUq+9rEPcdxiqqWBh3mrOBg+Jm6fMeqniMSj8A
         wz2g1U2eI5SC7sNfS/gbVuuuTTbo5Mz5MGWazdtb3/6wMCOd7gA7BD7VU8wLqTQBOp
         PpdMU9BYbHM8WLQ+Fl82j/8GGyoGrqAFCJ9rwws4/pfjPR93juKpvoNpiMs0L9BUas
         XTocJp9yX71xc0khOKzwgVwHixMxphIRA1aObpC5hLKahMbybf8MyEyAY8usRyz9rc
         TDxUbhjD9ZTSA==
Date:   Tue, 4 Jun 2019 10:30:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20190604103052.056719cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AbInN0eAngnG=.GdErjR.Yy"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/AbInN0eAngnG=.GdErjR.Yy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/isdn/hisax/hfc_usb.c

between commit:

  de6cc6515a44 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - =
rule 153")

from Linus' tree and commit:

  85993b8c9786 ("isdn: remove hisax driver")

from the net-next tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/AbInN0eAngnG=.GdErjR.Yy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz1u7wACgkQAVBC80lX
0GzE2ggAoX66HrO4SIyBxmtx83Aww/8eFqofGeUC1za6LOtj1hvZ99Aa2eKVrnyK
0SWwgd9dxVYDXO0Fte/BcZsOV6Tm8kBncHWcAQOMemJU/fkhQZAbKEkk5fenwWHV
0qA2nV368Q/kCmo/XnIhzQfM7wyHNUn3osz1w6HlqX3elZMrvtvMOoRfvozK3Nsz
oajuKzvQbaolKo4lb0blWMhoYURLkRJkUfHmAnFpRvE7PQ3BoUwK6ribbb1fpXZK
mepaAy5W2hYOBWtS0AqfKhuZFWU0oCiEP3UhxDPoZdU8RKePgzoCATmNBPeheOw3
AJo9fyguGNImmgXv4t5l7ulGmTJrPQ==
=1wTv
-----END PGP SIGNATURE-----

--Sig_/AbInN0eAngnG=.GdErjR.Yy--
