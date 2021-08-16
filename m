Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748363EDF8E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhHPV5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:57:19 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41843 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233017AbhHPV5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:57:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GpSg06fJvz9sRf;
        Tue, 17 Aug 2021 07:56:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629151005;
        bh=6J3Pdung5DggWw2mz71wpwlsWj/Ia2fep+LVWCnGUik=;
        h=Date:From:To:Cc:Subject:From;
        b=cM5vPL2PKTCi+4QQkSiGVudV6DCOQ6ISa2U0JKeM5ayNCHPdP06wF9XIEgLUzKh8T
         yyKeNZ9SN7UIs0TXM7NW3d3MyIXOm7pnLx1B0lbiwM/10p25TcLI0UNqbMNGvEx4Nz
         jJjqMZ/VhYUljaB7d4bSbol0BMrFea1UxvDkyeykRT3zsE7jsEsrWZaD2e1oTDJZXR
         m9w8eiLTzvyBObqgTI78xXOY7kYKlb8xFl8eUGBM167S81EkTo5nRtjYcuTGw6vOf7
         +H3wQTOG+KTFURJoCLXlLBCkZk67cI2J34esKhVi5i5bnplNKWd1D1v3DdNVpsj65G
         wJZp26DDBJ0Mg==
Date:   Tue, 17 Aug 2021 07:56:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210817075644.0b5123d2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7D4wL3LFxNG3M4Umzn3BsSk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7D4wL3LFxNG3M4Umzn3BsSk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7387a72c5f84 ("tipc: call tipc_wait_for_connect only when dlen is not 0")

Fixes tag

  Fixes: 36239dab6da7 ("tipc: fix implicit-connect for SYN+")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: f8dd60de1948 ("tipc: fix implicit-connect for SYN+")

--=20
Cheers,
Stephen Rothwell

--Sig_/7D4wL3LFxNG3M4Umzn3BsSk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEa3xwACgkQAVBC80lX
0Gy8JQf/a0omLLgqLG/wJLKKYCID4BoOnDNWTbtYKUWYwkR4nY++bNQ+7x76hCcz
z2SCSV8NCUAVKpOdlzdZTVnj31+Fdnj637+3uc30LPdvPhuKsfJYJ24SqXSRDbDg
oGgT9uoULbWPJPnD9R4Bgb0nHX/zEmskfgTKxtDN3C5cT25j6t1oXNQWbfS3vdjv
8d0Lr+f31nndl09gWeU7e9X/atKBaK28pq4WT0buOH7/OEG5giIHfEqpxoc1RlQ0
Ruqfg0BoM/72nvmhf/ujrFDrCO5MMiJft0nAFdiVdvecK/khpTcSASEWVZrOw9+0
FhZmo3IXqUPsiQb/Cgfme5XB8GPfxA==
=fiAH
-----END PGP SIGNATURE-----

--Sig_/7D4wL3LFxNG3M4Umzn3BsSk--
