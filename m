Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1C34A35E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCZIqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:46:44 -0400
Received: from ozlabs.org ([203.11.71.1]:49709 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhCZIq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 04:46:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F6Fv32svpz9sS8;
        Fri, 26 Mar 2021 19:46:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616748383;
        bh=tL1lvbAhU/kPq+PEYJy3NKJd2hJcHAj+Dx6knFBUfDw=;
        h=Date:From:To:Cc:Subject:From;
        b=OMUHHqKY+q5hUYvZNCrBncNOwpcPC9/3dP7PWdSPqxLZePV6RtdJKw3WQnu5mBwDw
         9uuLOJEbZJQF0Nmoe5dSmuOEEn7/QzlTkP/qxjiuubKAVtXkjeutbpHsJwAC7ad9dG
         h6M9EPTcr3d01nT1C9kwq4A0L0y0Ub1K5GQpMS3/06hgVu24OvmyvjPeFox7IcFTKL
         s7BlrSMz4XeMSSw20wgrbwkMKUeWPObie44wiO3xXRgHggou5sADsZW4GSUzexiOmY
         NeXK+8KHnfosjUlLmmTXTSgMraHorcix4uPVhwYM+kHtD44IOjtDfdgnr8Ku1DZbUH
         C9Vid/jo5BxtQ==
Date:   Fri, 26 Mar 2021 19:46:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210326194621.4b402a37@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/P=3v/_3jMkf5z4UN.b8QuFV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/P=3v/_3jMkf5z4UN.b8QuFV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

net/tipc/bearer.c:248: warning: Function parameter or member 'extack' not d=
escribed in 'tipc_enable_bearer'

Introduced by commit

  b83e214b2e04 ("tipc: add extack messages for bearer/media failure")

--=20
Cheers,
Stephen Rothwell

--Sig_/P=3v/_3jMkf5z4UN.b8QuFV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBdn10ACgkQAVBC80lX
0GwBgwf9HlIil0hYpIkjIdlw/hoFao+G12RWn4FkS2YvKagz5CzffvKtVX2PM1fM
eqtp+p2nMFgRolPSCvWfPe6ypLduoC1rNQWej4QKELUSrx7N4RMDwggLjC1RlFcg
+tXtHP8PXDFvu9dv5hEFQqc4j/OsbM5/98exScSxu5vgyib4/ZctxaoFOXGcpbaw
X5mX4G4fX4y88xMl1157wv/7Pea92MDNNSm+MXL/AF7f31/E3m7dLaulz7By6ixY
cr8yMTRoIqSJiedNL8RZ1opjva9inUvXz66zjU19Xru2EqBpDTE2e93L5JZ18eBA
n5iuyiUeGgCrm3KryLJIij7HSUxoKQ==
=TIFc
-----END PGP SIGNATURE-----

--Sig_/P=3v/_3jMkf5z4UN.b8QuFV--
