Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82000C9409
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfJBWGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:06:51 -0400
Received: from ozlabs.org ([203.11.71.1]:56587 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfJBWGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 18:06:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46k9GH20Z3z9sN1;
        Thu,  3 Oct 2019 08:06:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1570054007;
        bh=kmIljB+pBZIRZlpZcU0SXUaEhL8nILIPqTPaw0e4iUc=;
        h=Date:From:To:Cc:Subject:From;
        b=LMziiJS15qLS2gkWbuqMz1+tcgE1G9n0+8+KtVfpif7UhdFaIhhtRYjIcg6tD55+v
         E6hVc3HZZUk/M1jGV3tIw3+eQC/ZCVHikMmvmC+nQ4ae2FfdZvbYwvhtUuHpJ4irSC
         DqKzWfHhS4Rsr7hQqhErDCI3KbQEV3K33pogIJD9IxI27n6BLu7BY3ruKaPzNHeNQf
         jmMDRm20Pm/zTi4GFsAw6lDJ8yVO2Nqjud94hqggeUO62yUaEKqFkm0Czk+aWxjB3r
         15S6Hvf2yQck1LMTH2x/laFesEX4gyX3CdF8yubLWHbdcNndLRqCRzMFJudTx4+bDg
         5aqQdJYsBAHww==
Date:   Thu, 3 Oct 2019 08:06:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "rd.dunlab@gmail.com" <rd.dunlab@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20191003080633.0388a91d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4O8e4E9q2Ws8f1piWgRfnLZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4O8e4E9q2Ws8f1piWgRfnLZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  0f04f8ea62ce ("Minor fixes to the CAIF Transport drivers Kconfig file")
  21d549769e79 ("Isolate CAIF transport drivers into their own menu")
  0903102f5785 ("Clean up the net/caif/Kconfig menu")

are missing a Signed-off-by from their authors.

I guess <rd.dunlab@gmail.com> and <rdunlap@infradead.org> may be the
same person?  Please be consistent.

--=20
Cheers,
Stephen Rothwell

--Sig_/4O8e4E9q2Ws8f1piWgRfnLZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2VH2kACgkQAVBC80lX
0Gwx8Af+Ku6icVCNVC4kfGB3RT56hXizTxgQqpjUJM+AiN17uxTQ5t14pwUam63T
Kf1OrgVahvIw1gAAfw5YKZPoKkPFg6HHJDmENrfLC9vsyXQQQCaZXXDG/aEiJnZL
XdXU3AsecKGftoW+HnGi5F7nIZYF1qJXhIpJGP8rjYJ5WaF6R0+oQqTLqZqA8ukx
QVtQ0sJyRxXcN0ucvUv1+BLq3qc25PZ43ZZVDHMEHXHxlczneV+SgWSC8zOQw08m
Irjm7KbeeQmHlfB2TecT9BXBnul/ZBbEafCu6JXtjPtWjs7H3a9RSYFQKZ29PnH3
XQ82VfxU8FYAHM6axtpgmP1MCnXTXw==
=Pn2d
-----END PGP SIGNATURE-----

--Sig_/4O8e4E9q2Ws8f1piWgRfnLZ--
