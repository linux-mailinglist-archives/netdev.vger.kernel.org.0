Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454D233C6B
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 02:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFDA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 20:29:18 -0400
Received: from ozlabs.org ([203.11.71.1]:41919 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFDA3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 20:29:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Ht8V6blgz9s6w;
        Tue,  4 Jun 2019 10:29:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559608155;
        bh=r3KCnLSx74LcwbNZPnkG/2bFOXjBmwsu/lLVPQHFA0M=;
        h=Date:From:To:Cc:Subject:From;
        b=YD7YRIhVhI5bezwdwcIlyFGOl0tPj4gXYOiNkbVZ4bFNIHv7qRZuoCCdlEDIMCd9X
         2TfWAXd/GUbb7NAcNFF0q8bB5cUdyb6AJEUGXKrW+lE4Yimt0tpbk7FJmdkLf/yU5a
         Vqw96qyeYqnhKUnjzBbtcjtq1irxW90egWO+b3BPwUQiu9p6JUXvhX8IbQdFx2jx1u
         etLz38VGPRqmvBJgMO8pm8Cm8XMQycrVLuE9IgbyTXzDbWSZoBU+GxTSUUzpEA9wUX
         7UiiKV7dr+Kb02BmWuXowaDloB5UY25J6TNgUa8UdWi6TezE8TnHE5XepLOVZ0VMsa
         7KxBVyX3nRcgQ==
Date:   Tue, 4 Jun 2019 10:29:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20190604102908.7d2b6556@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jpZYh4wHWoERUCfofU4DMv3"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jpZYh4wHWoERUCfofU4DMv3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/isdn/gigaset/i4l.c

between commit:

  2874c5fd2842 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - =
rule 152")

from Linus' tree and commit:

  8e6c8aa3b52e ("isdn: gigaset: remove i4l support")

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

--Sig_/jpZYh4wHWoERUCfofU4DMv3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz1u1QACgkQAVBC80lX
0GwPzQgAlnF5YvEEPMkB2NN7pzDvxx551Dc2d5raOASREKdPyoH7OJ5fCgVXjJpj
pB+6VbEJj70kZxSN3XeSTpnDFtdGCVVS5dz130WJCrkpNL408G64zRgvFG7ysAA/
/9BkaqUs7bsNnUfGwkicLpbxxf6YZf8oA9UesfFAg7sUtscAbheQ59szgulo1XEG
YVPHynlDqGZL745gp+WerU2MKgRghC9o1PIXraOj7lY25tPkREHu1cWryc3MDOwZ
+cXBz5h/JFQEFR3J637hw1lWSMi6w4s45vSMoK/biYxIWVkF1yW0aD7B4md6QQwc
KYaDf6pCTL7KT44v3Xbc0A4+r7qQTA==
=SagT
-----END PGP SIGNATURE-----

--Sig_/jpZYh4wHWoERUCfofU4DMv3--
