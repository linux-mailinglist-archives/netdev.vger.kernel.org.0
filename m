Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B363F5128B1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbiD1BYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiD1BYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:24:46 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D46989CD2;
        Wed, 27 Apr 2022 18:21:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KpdB31JS9z4xL5;
        Thu, 28 Apr 2022 11:21:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1651108892;
        bh=/zUY0uZdm8DEHDsmmVYn7dXawhy4V1WT3I/K1KXfZIY=;
        h=Date:From:To:Cc:Subject:From;
        b=DNN1toqJW9mW6J2hYAKsPiZtIOY1WmmEdXbDZC+O2bAhjtaW1W/5QHerWctIIJAj3
         y78kOYu7FHXcnQSRmNA6SlU8NKUCmtUB17y6lyoLYprHYAaS6Z+SfaUI8UizWvfT3C
         q8QFc5pXK2IypbIk9OdpmtTDCvKbkWAYy8XSkTZUDXJPho889/UZmLquKVWRd5elaP
         sD0v2w3jrjNKBViWmCl4J+fbmR4QJz+zwrYTnuojjsy+Jns5dKRt4gI/k/af04eDI0
         BKM5cPY3yxYiBjII3yWcu9tyVcaDQR70leCbeL97DdyjS3G7rjHo/78cIIa7cclh7l
         XXua+k5maS6JA==
Date:   Thu, 28 Apr 2022 11:21:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lv Ruyi <lv.ruyi@zte.com.cn>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220428112130.1f689e5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.6XHw4e_seBL1aVx_pir32e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.6XHw4e_seBL1aVx_pir32e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/wan/cosa.c

between commit:

  d48fea8401cf ("net: cosa: fix error check return value of register_chrdev=
()")

from the net tree and commit:

  89fbca3307d4 ("net: wan: remove support for COSA and SRP synchronous seri=
al boards")

from the net-next tree.

I fixed it up (I just deleted the file) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/.6XHw4e_seBL1aVx_pir32e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJp7BoACgkQAVBC80lX
0Gxctwf/Y3WJAv6fm9yWW+oAiXEaDTdcqNFePE5NVmvr3qRCveuYmykSHwCAaukG
m8rYzHvO2/4/uoyE2iwtRLNVsbA7B+dNv/YS8xz+6OEOnf91KnPiC0M4q+ivZi+D
C1DMKL30KV+337koN4+aMUyD+VEXxAwLmDqp3+wTigFNNtKh1fSJ2JM9o1Sd2Qtw
9uGzxwoG68IS2im1R4vdXsV1H3UUuAp42MCg5ilQGxzStlNLe6ZTTvePOykh6nw+
IWyWtsYLUw9a0Dc9hpR2tJw16rV8tnQtpmY0ead/C3K/iE6OEU3qDS5UVvV20olj
bS9guF6BVayyNaPpes0vteAv4QiHCg==
=X9ev
-----END PGP SIGNATURE-----

--Sig_/.6XHw4e_seBL1aVx_pir32e--
