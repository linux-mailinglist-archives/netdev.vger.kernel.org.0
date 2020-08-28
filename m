Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEB32551FD
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 02:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgH1Aj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 20:39:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60681 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgH1AjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 20:39:23 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bd11z15KFz9sSn;
        Fri, 28 Aug 2020 10:39:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598575161;
        bh=hw2QVv72fnMpKpu16MEIWpkdlhdwHEwKMjWP0v3x6IQ=;
        h=Date:From:To:Cc:Subject:From;
        b=CkU0mwhiRpaERUjfUxqWh6MrG5Y1HDM5YI3ps4hH60suB+XQQeYDWG4R6Xe5yCwHt
         U02pYP1IcKfh6L2bylbe2y4J7qLmmSHJOcAy/kWLF5NnvdfJ8GZAEiRt3G7a6Jn7Qg
         aQPva0I3DKoWWuYJvDdWCgMDcg/qBSVNAemUJdazwBAOYDl7KA6UcWjDzUYB5BTY+g
         qXsqolp2dpf9pFk7SOgIFoHJWZSjPHMhLXaled5nuidww9/6+7ZBiH5wzGMwkw58yB
         +1tHEFnSPFGbP6AHXdrQf76NBjR9jtQ6au2iCgCUppEcbefkLW6vKQi/TExw5d50En
         GARYDPU+mLkew==
Date:   Fri, 28 Aug 2020 10:39:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200828103911.7f87cc1d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rdDiGHzhoAGPz5IxfgPjeA/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rdDiGHzhoAGPz5IxfgPjeA/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/raw.c

between commit:

  645f08975f49 ("net: Fix some comments")

from the net tree and commit:

  2bdcc73c88d2 ("net: ipv4: delete repeated words")

from the net-next tree.

I fixed it up (they each removed a different "and" - I kept the latter)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/rdDiGHzhoAGPz5IxfgPjeA/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9IUi8ACgkQAVBC80lX
0GzfOgf+LT5gCWANakQWEiMOnGhgaYVymlk03R+65rDxrxpJQjUO3EilAeO1y382
MYXPFWIAsXyFf568qw62nviiuUxWRc/qaQh+OMdibyl8UntVK6j/+lv3Xq/S8ThH
VMhEs57nlbdnPnL0yqbkaJlKoeZ7FqGx2oKyLJ5ddiSLk3oHI17QO94NVxKhaIGr
W4SsAGh/J9ENFNIO5HiLSfGGnAdYjqirdyEYVdXDFS/BL/rGghwx/V0djuFxC8+D
6qyKfJ6o2yA2eV1rp9/ddkm9yh/R8MlztIZ2aQx2InNrRNdQ2buovF49cgCNj1ZD
6rIFIPvghwKSjmPcibIfXbf8+WqBSA==
=/4dJ
-----END PGP SIGNATURE-----

--Sig_/rdDiGHzhoAGPz5IxfgPjeA/--
