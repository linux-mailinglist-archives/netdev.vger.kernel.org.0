Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE8E3434CF
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 21:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhCUUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 16:48:58 -0400
Received: from ozlabs.org ([203.11.71.1]:40957 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhCUUsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 16:48:38 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F3V8b4nG3z9sS8;
        Mon, 22 Mar 2021 07:48:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616359713;
        bh=PM3mc5URKC4fT+ts9F6ePl8Ad5BqKjldkxwwww/NuUA=;
        h=Date:From:To:Cc:Subject:From;
        b=KsL2rg2oYvdiFCR1/mqv2EOVrIFCRzzvg1XOOZU8RWa2i5VcmL57GrHitTBHbDJL3
         R6BIxq4H0EiZ4BCI41fqtRCSYqTpij8sCzyiFjRlhkpbmnylYq4S0VaIwVje1FJsk+
         zT9P5ZBAQF2byM84zB692ZWXPsCoU/LMoAWcdY5HfjiIH9wfo2tjRTjmmSS1EL6y1/
         +Y6hcev1Daa/8FS8FYJTxmA3Ei+haZgLNNhGk5si0ueBkEaLB0HvjmWipVN1Y1r2Rh
         GkprqtAPUPd700coip+SYSt+/OCaa3DWewbdMtAeGu4s5SRDGMYPoULwSoZfXBuoIN
         0YM8OpY1TnE2A==
Date:   Mon, 22 Mar 2021 07:48:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210322074829.5ce59a97@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Wuc7qK1JLYnP+HJpGwSifxg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Wuc7qK1JLYnP+HJpGwSifxg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  014dfa26ce1c ("net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes")

Fixes tag

  Fixes: 9f93ac8d408 ("net-next: stmmac: Add dwmac-sun8i")

has these problem(s):

  - SHA1 should be at least 12 digits long

I don't think this is worth rebasing to fix, but it can be fixed for
future commits by setting core.abbrev to 12 (or more) or (for git v2.11
or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/Wuc7qK1JLYnP+HJpGwSifxg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBXsR0ACgkQAVBC80lX
0GzR/QgAmf7iGMxbO6xURCcfc3ghMiUDvN/58O+pLv2xbvq7u+J73msuQBWYDttE
gGzzPu5NKxc86TcMPns8UksoaM/YjLNvQrxPPcF0ZzE/G8ehHB2vJZchHXV97yUE
XcNG88JUd5kE8fAmFGFybKDdtIbQjTz1QSSKKT4LAeQkNvD++oMAVFUyxc7qVvaC
mFA7llFwqFjeIP7zloOekHiXyMyGzLSbNvBVYI92x9Av6Ak5STanKO1fsxV9JEGa
oZgRXVmsZSRn1iu2H2LJb6x/Y2t6zpcOJ8iegCpCJr/WNVbs7mtjVWQ5/FTUwCQW
GfjEQ/D4CQhGPNbJGqnzLwH7KHEYJg==
=mLda
-----END PGP SIGNATURE-----

--Sig_/Wuc7qK1JLYnP+HJpGwSifxg--
