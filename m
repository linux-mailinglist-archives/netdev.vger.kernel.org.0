Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0D23C1DD
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 00:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHDWW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgHDWW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 18:22:56 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286F4C06174A;
        Tue,  4 Aug 2020 15:22:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BLq56652Zz9sR4;
        Wed,  5 Aug 2020 08:22:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596579771;
        bh=0IZ9UVJ9I/xWMPT96mn+KqBxk0bq2lKpKJOtBNBPOS0=;
        h=Date:From:To:Cc:Subject:From;
        b=JCoptpFBbYvTuPMmj6wWtfcQZ3GkiKJfHNpL0TTd0OY2I17/VTapV3MojulLaJOrm
         FvExYfRZaMVSeNda/O4e698SDLLFmCi2rsn/EZm9shq567BfqMkeJl4snfnqga1YDP
         6lc+FmgBP6OtH3QwOdxNKWHmsqQcv1b1BBmKiurnzIj8AihPuiqKBDmbT/hwSfNLL/
         PUdEEm8n9T1STZDuGTRMrhmYz9Eanca0+0fALAheg/vQiRnMbIlLrjqCGdIyq3cowN
         saFGwIpmtx4GDP3s/Ff22Fol8dShH4DIMHisWBkpWBpoXniePAynYXpCyNm9+a5QbG
         IWbj0OoTU+Vug==
Date:   Wed, 5 Aug 2020 08:22:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20200805082249.4cd4782a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fL4W+oMs5jFDbCtkL+WA94T";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fL4W+oMs5jFDbCtkL+WA94T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  6c4e9bcfb489 ("net/mlx5: Delete extra dump stack that gives nothing")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/fL4W+oMs5jFDbCtkL+WA94T
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8p37kACgkQAVBC80lX
0Gy2Ngf+KW/muPyVMIhZi9HXkkDv7leQzC8QBD+RILexGiWBq3v+qUu4qCijn51L
jZksxEgZDod0D0xseIBnaDJMMnRf76YDvsr98D0FY9h9HpsJ6jT6dQTkEoBJGdgs
H2V0BxDWLhHc6+dz8sQFPV/HtGRwr/6YdQ6y3vak9xQ0E6cZyfSps1lmm3HB7oF9
B1BTUPo6KELC3AIYvdzi+zxbkTub7OdBzC3VZrfAc/OP4xmQGCJEJySlYoBHonGO
JstZq4lQWSW8nHg5Me7gwd1ivKClPB8lA7al6zLKXL7h2R0SZcmTmTX3pyKdInCB
tvnMXCApiVKjSdlCjc9g7MoHOPT16Q==
=Vv4Q
-----END PGP SIGNATURE-----

--Sig_/fL4W+oMs5jFDbCtkL+WA94T--
