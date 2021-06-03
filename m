Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26C739979F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 03:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhFCBsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 21:48:39 -0400
Received: from ozlabs.org ([203.11.71.1]:41029 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhFCBsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 21:48:38 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FwTK82g8wz9sW7;
        Thu,  3 Jun 2021 11:46:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1622684813;
        bh=ynMpJRWwCkz86MbxAZ5P7Fs8o/NBJCBM3ePrUfjkQZw=;
        h=Date:From:To:Cc:Subject:From;
        b=Og5qbeWUW5IMVC/ZzrSS73TsyKrRt39tzHE0cVftwMnKcCRBGwIk1qy/+O+kYcSU9
         VPTamEAEifp8s+XWJSEOTQYMC7XNx46Rb8saNvY7kxow12BU8kmv3HdJpmfwAvDMIh
         d3Mof3dSLM9SbscPr5vaLP92PUdA58ZNnKnrHGM/iZ/cQBPQnsazxGHDz2+Ib960L9
         D74XtFTa6bjaGN0+DvoBl28eEGhXuwK8GIgu1vKxcJkIx7nEmsu/EA1PJrz7JZVMqK
         l4dQOvl8UyTHrkeeUzKj8TAiUd93/XAJRVmKiTeA1p8qBaNwW9PnDahz4KBRmyMsw0
         x7M25pCKgTcrA==
Date:   Thu, 3 Jun 2021 11:46:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210603114650.70163765@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BO0FPj7bs4EEMlgyakhYDM_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/BO0FPj7bs4EEMlgyakhYDM_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/virtio_net.c

between commits:

  5c37711d9f27 ("virtio-net: fix for unable to handle page fault for addres=
s")
  8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")

from the net tree and commits:

  6c66c147b9a4 ("virtio-net: fix for unable to handle page fault for addres=
s")
  7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")

from the net-next tree.

These patches are different version of the same idea.

I fixed it up (just used the latter versions) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/BO0FPj7bs4EEMlgyakhYDM_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmC4NIoACgkQAVBC80lX
0GyzKAgAo54mdzqKe5Pjbpc5sG0EVUqLSLMMGXLufC6FrzZL7zvJuFkmd+93x03E
Sl4QUCsVu8geuQJFx/eyjbdzzHOVQKp65o/lZIb1ukSoJSmwSaAtX1oUKYPn8f12
hBhsmumN/WFS9xpPUbhm8Xkx41hEzVBWqvuqC4kn/0jnBM9OVuqgjqqUQyuQDm7B
hHkX+tHIxA6FaDcgah7lAsS1HH7adCwdhngyU4iQH2JCNbYFzEgCKUq26+URWwYl
257nmq5FlyuOSks2VEYus8ffLFdNwDwfw/YI4XnUqBCHacvIltsL0Myr8+GtHOaZ
59MPhSDlRAaHeV8hdmQEsAEqD5eUTw==
=X3LT
-----END PGP SIGNATURE-----

--Sig_/BO0FPj7bs4EEMlgyakhYDM_--
