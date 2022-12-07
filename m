Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F422646333
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLGVXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLGVXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:23:32 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D67B554;
        Wed,  7 Dec 2022 13:23:30 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NS9Hz6xThz4xFy;
        Thu,  8 Dec 2022 08:23:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1670448208;
        bh=skFp02LLaaYnCICffHDRFegmfkjpdWAOsEShVo3tYzY=;
        h=Date:From:To:Cc:Subject:From;
        b=YZcTp0J4SPYZBkF8cGUuFlS9GtVMT/FvaOyPjKwhaCPeCU9jh8aOjZNSk2F/cjBzX
         fQ4D/9iA8qrpZKxC9Z9vmJaVU0aJkRfpu7roNI29Tyw2uQ4PHJxEfpLHxPQWdDl22A
         rLIjfKKpL079SNBV86ptjj7jQq7JFyCuBTev7JSH/81cXZWPcy0tRQ20ikm9RETACN
         e/gbU9RDv5k1p4Ogf01PWjdImqJP3mzaBoD7o1GesuVrppXB12KUPHWd3a3Dnu/YI8
         c3WRwLssh2hWkpzb/8Gio/EfUJ8PVLpC6Q5VnPIW9DHGbo6LXmhgh/tZfbrV+osEPO
         w4iyncEfOkIDw==
Date:   Thu, 8 Dec 2022 08:23:01 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Juergen Gross <jgross@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <20221208082301.5f7483e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BBoFWBm3G8D.uuP4C6PiDj_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/BBoFWBm3G8D.uuP4C6PiDj_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in:

  drivers/net/xen-netback/rx.c

between commit:

  74e7e1efdad4 ("xen/netback: don't call kfree_skb() with interrupts disabl=
ed")

from Linus' tree and commit:

  9e6246518592 ("xen/netback: don't call kfree_skb() under spin_lock_irqsav=
e()")

from the net tree.

I fixed it up (I just used the version from Linus' tree) and can carry the
fix as necessary. This is now fixed as far as linux-next is concerned,
but any non trivial conflicts should be mentioned to your upstream
maintainer when your tree is submitted for merging.  You may also want
to consider cooperating with the maintainer of the conflicting tree to
minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/BBoFWBm3G8D.uuP4C6PiDj_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmORBDUACgkQAVBC80lX
0Gw0awf+Ljq8FCkkBHKNr/Ow1PMqCcSfW6hDzj1DTusJr8dJ/bfwl+465fFNK47G
XETYph0oA/coKmc3gpfQ3uU+HclRU3qDZklLLZwcw/MrBQ86m9z8VxwrcDhhZ/+O
0Ckr6D3AinEbqRCd0gJ05Q/jWkdRjNORGrPrwo6uvDPi8JfbPANAQBHWpLO0hLyI
a6lVtl7Y/7NeLeBgLLPz6j42Z7+9L0sh5ccagPmPLtrc+UIHSwYHu5CN5H656DFP
JcEVovbfr8KsSAYit3npE2KD1BgmxuMoW3fCWGtfEJwWErWCNRZnJFWMp1ryHV/B
du+cSCTFqqmCNIfLI1QiKfopjh+onQ==
=uxy7
-----END PGP SIGNATURE-----

--Sig_/BBoFWBm3G8D.uuP4C6PiDj_--
