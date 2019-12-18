Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D31123FAE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRGf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:35:29 -0500
Received: from ozlabs.org ([203.11.71.1]:50729 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfLRGf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 01:35:29 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47d4y61nmGz9sS3;
        Wed, 18 Dec 2019 17:35:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576650926;
        bh=BRsF0Dl7f917DVhX5qy9xBkJQ4N03Gdm7hNrZ69WciI=;
        h=Date:From:To:Cc:Subject:From;
        b=bj+js8MB9gKbOsTdmpIh3sLO838ozUpHQJnp//wi5xa/EXVG5SOE/c9YFihy+BTy6
         pfrSNmvPIrt88q7yq+A8Ounqn4njaAs5isXcqjcnR9ZWmpwCyuAIE/Wq4oPxkRIXW3
         i48J4GG8jsYBf1/Am3h8M2Y7cLiCte5tE8/CbhXbBOaa/r9wrrtCxHcEaidPwj2i1c
         Zbord9/uVA9wMRu6QtYfS19Ml0mBJNQv3d7b9mNS2ieXbX8h5e1SfuvDifn2A3xvbC
         IRHA1MT2eF0TkWa+0iN+KDuWDEvRFC032mlNDn36vF6iXtjiSk6v7Spv9GhcG4+PiQ
         ElRECGBwFzUwQ==
Date:   Wed, 18 Dec 2019 17:35:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20191218173524.7080b228@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xE=+se5c9PhkgCY=hDadDfc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xE=+se5c9PhkgCY=hDadDfc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  b7ffa045e700 ("tipc: don't send gap blocks in ACK messages")

Fixes tag

  Fixes: commit 02288248b051 ("tipc: eliminate gap indicator from ACK messa=
ges")

has these problem(s):

  - leading word 'commit' unexpected

--=20
Cheers,
Stephen Rothwell

--Sig_/xE=+se5c9PhkgCY=hDadDfc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl35yKwACgkQAVBC80lX
0GyR1QgAk7mKLSurBOrrAxNbqswLck4/KF9aT4gamZKT3RjO+2dzpKixCFb5TnR7
YLiiyjFPS6QPy5EqrECZhB7szAOXceHOYHDccUjtqCvDLZ9VvK1ee1xMlstosBP4
pyQkcEyECezgDjHrem8q/sSwI1fL5gsWGWu0yuQk4zQFMtzztKH35lt5l18bg3SR
WrIKA6MTYnVslkO7xBYkIwFfnuCyGetFDTOqxk3jvAQg5Tkdi6LBiUkwHfqXZIFu
4GmqOybgbFLM95GjHb1EjFkYKUUmnhyFkO3Wm1OdFIrFBDZ9sPz0oQaoFRrhHVCM
wN+LC3qCJ9m/GiHyCIV2iTZMJPuYEA==
=MbNd
-----END PGP SIGNATURE-----

--Sig_/xE=+se5c9PhkgCY=hDadDfc--
