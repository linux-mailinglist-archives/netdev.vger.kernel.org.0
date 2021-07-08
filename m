Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D43C1AFF
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhGHVdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:33:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55709 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhGHVdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 17:33:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GLTxQ0qcMz9sRf;
        Fri,  9 Jul 2021 07:31:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1625779866;
        bh=J2a+EdKORCEbOR3xyeM91vwoGUDd99J7urqHryoUKlY=;
        h=Date:From:To:Cc:Subject:From;
        b=KwQCDFyH82M9silohZKe3ojVWK/sEO6zg1SFJz4+Q69H6Prh866Bc0zPQ5r0Vgx6+
         fxcmU4BWJTFdFBA/dbl8AHthokitVV/owjjizhx85xZDD39gpZDMlG1/Z2yHWcqDvF
         BC42T6g22XgvcpkY42aYM/yqxpag8PQvQ9JkIcaULmoAyaj22XFYZ64gp1RsO6lS+n
         6y6oYjvAbdf7k61AFCG+ac4R+bhywmM/Q4ecMV9ZJqZNwwQGCeLInyOk9EhVm3emuQ
         kHGHPIddJtagGUEmna3am5cj9lOvhUEzRZZAsbH4R9H5/3r+7lmwCO9Ryyl4gxQ1lD
         QqH4VMV5aT/Ew==
Date:   Fri, 9 Jul 2021 07:31:04 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210709073104.7cd2da52@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GQG49nBzek==i_NXLqjVRjA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/GQG49nBzek==i_NXLqjVRjA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  9615fe36b31d ("skbuff: Fix build with SKB extensions disabled")

Fixes tag

  Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen=
 or re-used skbs")

has these problem(s):

  - No SHA1 recognised

Not worth rebasing for, just more care next time.

--=20
Cheers,
Stephen Rothwell

--Sig_/GQG49nBzek==i_NXLqjVRjA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDnbpgACgkQAVBC80lX
0GxSowf+IHi8x3JIxDVKp9TIsl3QyxNyh1BHV9J0h/omUDI3aL1ilDGMLs55L0gg
yxE0Y7IuI4OpThINIgeAj9MMsMDVKOmfr8U9eu6sVzoHHo11FwTJaGK7G3Dz4O+h
p2w6/6v4hoVQmVkLrzkpgkMof1B8/tbI1egfPZ4vdjaLoqzuPfjyxs8I4rAac4Ph
efh+tyXlgE3OufSlbdiCuVTwa4y3s/UAkvwRNoA4TqaipXo9AaxdEeiYofVauw3F
m4cn4AE/dQaf26bel9LYmIGuht3dqeBr2svkP/eN6SIRJDIGFenhTVA8536SG9RN
AnqsW3NIRRs/3062Yxj4sHidPHBonw==
=oaTm
-----END PGP SIGNATURE-----

--Sig_/GQG49nBzek==i_NXLqjVRjA--
