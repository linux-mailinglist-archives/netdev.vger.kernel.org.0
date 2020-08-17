Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479F3245C27
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 07:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgHQFxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 01:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgHQFxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 01:53:15 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD67C061388;
        Sun, 16 Aug 2020 22:53:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BVNW94j1Sz9sTH;
        Mon, 17 Aug 2020 15:53:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1597643591;
        bh=mFaorMpU/2N/sp0r+EBSBM5/iK2seMXlAMNmtKFb8gE=;
        h=Date:From:To:Cc:Subject:From;
        b=eKQ8syUbyAAwD18TMeRtgc+1zXZAX6X4m35PkCX99AXOfCKMVtu8Ztn31qz/uPq3s
         Bcq/0mLRLuoZTc3UNUkTxsm88EffOucRVnEjubK3sw6dehy28kkxzwEu6AlKYKLUtP
         llnkJna5blfOLl1u4R8oqkROIaIy6jslpFZIgtaI6jwOgNVGi0HIX8hogzcBUh0YBP
         unAtlfGckqvI4badOtK1qezo4k5ZuLRveiyrD5yVFs5Rkf3z9Tqv4F+BjYd2GD5Hg1
         Wa2uKUBSp9TTCbdfZpwyrNDsWxdeaVqo/i4+CsUrkrHgwApkfbr1WQp5Jqa1SqkW33
         12noW141lN1Eg==
Date:   Mon, 17 Aug 2020 15:53:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200817155307.2aabc9ea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Yp2VGUoYxVJg.uX4ToQ_9UU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Yp2VGUoYxVJg.uX4ToQ_9UU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  b3b2854dcf70 ("mptcp: sendmsg: reset iter on error redux")

Fixes tag

  Fixes: 35759383133f64d "(mptcp: sendmsg: reset iter on error)"

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/Yp2VGUoYxVJg.uX4ToQ_9UU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl86G0QACgkQAVBC80lX
0Gw9rgf/WsitZxRFjYFoS8rdLpln+Q9Vqd0cDd8JHGPQWMP0M49/bJjwoQ6ry4dl
UwBq3WCW+Ts6e60v9Okdjid4N9FFn/O0q7a/yT5xYvQoKbQ/y8R6zepNBESuSzdd
yZPW+l4JuVpTamz/li4ReSKQfrnWsJ0wLQBGFpiQZgKjDejPk0vklGjYFJ9kE6EL
6TEIO0gzEpol9dm3A47BlEqwMf50vkfEXGvRR36csIEteCcFjkmLA5utKsTQsCSV
ENVQQ8ZNC+h7CtlJ+lHPxD5L0f2TkOP6xw6C5VxM2E6HSgqKv4KUzAFNXC+zHwx5
vk0UShCeCnmbRohz3RnvPmG5cNi9jQ==
=ToE4
-----END PGP SIGNATURE-----

--Sig_/Yp2VGUoYxVJg.uX4ToQ_9UU--
