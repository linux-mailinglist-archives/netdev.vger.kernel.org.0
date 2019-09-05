Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1E4A98EF
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 05:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbfIEDmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 23:42:17 -0400
Received: from ozlabs.org ([203.11.71.1]:44493 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIEDmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 23:42:16 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46P62G4pP0z9sDB;
        Thu,  5 Sep 2019 13:42:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1567654934;
        bh=D20kb8FI3SomKAMFU69sx2kOZjLBDN7Zio+s1/ojh5g=;
        h=Date:From:To:Cc:Subject:From;
        b=n4nBW4F6iU8JNHCd2sXvqFLwQv01DM83fps9ZYicuMoPD3F4t+EPZ7V99BScFAFN7
         CcV3qQ4PoST4MbLMx7yKrxtPtJ/AVQd86IjYo2Efo3o193crsys7vNnYR0w+T8QLDT
         f9XG5Q2Va93VGfrjsop0UJpAbttdKsn27U1+wg84/REF0wllVAWRhZrmXHqVBrNC8G
         kHnBXwozJBeVgPFQTt6iX42ADyLRIu5P7NgdckkXzFPyfoISY9OHt9O5rzJrykyhMV
         Be0hI3wOo/8tfxlR7OdqA3CshCpPcxMDrao2SUpkaFXYzRcn5KW40uFAMYM1zNPgMM
         FTyVkJhnVE9qw==
Date:   Thu, 5 Sep 2019 13:42:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: linux-next: manual merge of the net-next tree with the arm-soc tree
Message-ID: <20190905134213.739ca375@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7ZgpHNInDPnmm6UQg5TPdzE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7ZgpHNInDPnmm6UQg5TPdzE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/nuvoton/w90p910_ether.c

between commit:

  00d2fbf73d55 ("net: remove w90p910-ether driver")

from the arm-soc tree and commit:

  d1a55841ab24 ("net: Remove dev_err() usage after platform_get_irq()")

from the net-next tree.

I fixed it up (I removed the file) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/7ZgpHNInDPnmm6UQg5TPdzE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1whBUACgkQAVBC80lX
0GxxrAf9F2t1WiC/CROxhOEgz3XgdRi7F4M0XLeKgV6HYsch3nX5Wj9Z1Vh8tW6l
c/fbKI1ZSokhfgYm1cEiqm/9SQg2lhUiGywuszysvidYT7o1GX/zMb9CGNC5fg8p
zJsmfVIjLY5Qzo4RtOQSqFlT8wgd+CXFK2fEn/9nEnryStrlzb/E6xA+b437SxuI
gQ7U2Zl+eNgIgMJXMJlLQQP+3yfw5HJX7Ox4AbYxYbuV6wS9H1XZvWkT4JjCgSQZ
jsn8b1Ly8foiIhxb7K7cDl7yUCJyjCoVUqIGTAY6grwXCxRGRm5EDr9thpRRrCgS
yAxzxRctgd46mxhzjE9l0L2sbmpMOA==
=nc/L
-----END PGP SIGNATURE-----

--Sig_/7ZgpHNInDPnmm6UQg5TPdzE--
