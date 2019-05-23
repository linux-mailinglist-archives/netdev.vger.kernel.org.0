Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DF028E09
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfEWXrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:47:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57405 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbfEWXrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 19:47:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4595l16FDdz9s6w;
        Fri, 24 May 2019 09:47:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1558655230;
        bh=XWWdsEP3pNjIJp19qUBYFv+Xqr5F2didhZCiLUurrhs=;
        h=Date:From:To:Cc:Subject:From;
        b=lZOla7VQYeovjc0sWCFraRiK9vXLQg8EN9O2PeaXsmfpgqUiiSZmI1fnopnEOWSRE
         VfLK8HKZvecMfebAYcqzoawr4QTzPeSJsf/R6leZ4wb4L1if3pSeB9xLsIC0wP5a93
         wHxtbRMyMKNYiK7N22Xigk3+moVPRF2KAprPAWz5Rw8cyWXoXfaCYUjgThWkN0kRCM
         d9iCTxvGjZTQGtj5EIaZ1OyFc0UD6OW9y7Nifg0BKK9scncTBiuuighs3E8/wq/A1r
         nmtiYqQD0JgB4t8rnrHelSlJgI9BeG/REQTG+olcu/c+fs0L7VmTox507dBXttCyIl
         sHpZ/2XSMvcZw==
Date:   Fri, 24 May 2019 09:47:09 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Esben Haabendal <esben@geanix.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20190524094709.3f9830f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Cuiezi5g/cA/rbWtws0fruG"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Cuiezi5g/cA/rbWtws0fruG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/net/ethernet/xilinx/ll_temac_main.c: In function 'temac_set_multica=
st_list':
drivers/net/ethernet/xilinx/ll_temac_main.c:490:8: warning: 'i' may be used=
 uninitialized in this function [-Wmaybe-uninitialized]
  while (i < MULTICAST_CAM_TABLE_NUM) {
        ^

Introduced by commit

  1b3fa5cf859b ("net: ll_temac: Cleanup multicast filter on change")

--=20
Cheers,
Stephen Rothwell

--Sig_/Cuiezi5g/cA/rbWtws0fruG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlznMP0ACgkQAVBC80lX
0GwQ8Af/RkRDO+UFIoOiriK/aUKOPdJqRLyjf6YDn1Tdh8nuOp5JOfYf3WICpOWh
k69aiQKv/B+6M5jFNXAWJ7hAR+quQ2idw2VfqxetJLqWULLt2F1a+54ILN6k54oW
1aJ5rF4Su2+aU6hEdiKYB3DBcd1bk7Zt4o2a4OKFqTWxq0tPMJz3xqr/Z9HLoRPD
DV7362RJ1kGYs1cTnin+bCnBZUp0rC4YgDJ4eRb6yHV83ZKG/tm1tjK15l0s3Mv9
i2rxkxvOkKJOLdIHF5AgH4sEfy41iqo4DgQ16ErNzx1irRHmgdybejdAhkKyYCCV
Os9J3BZX1BbHd0VAuCb/4yia3jq4Fw==
=4eOT
-----END PGP SIGNATURE-----

--Sig_/Cuiezi5g/cA/rbWtws0fruG--
