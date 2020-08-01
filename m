Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A42351D2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 13:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgHALAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 07:00:37 -0400
Received: from ozlabs.org ([203.11.71.1]:52379 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgHALAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 07:00:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BJh5D47qRz9sR4;
        Sat,  1 Aug 2020 21:00:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596279634;
        bh=rNDU9ZqkpSMNiNaQ8gyomZuB+Xr4hAmobVLVMtFHhyo=;
        h=Date:From:To:Cc:Subject:From;
        b=BmlLtxY8F8+7K4TBzwEwfwnB48Q/l4b+Cxyx5Rxlt11R402x8ktYLuM7mBBbyEy2W
         RjpkoMSoroxjDLg7i53d7T65m7xA/MB45vujHtPQHvc89+o01ksJSex0IEBZDGRmAY
         38MrbY9h3Y3yk8xj18d1kt26wXHp/fyeBoxYxrHb6GoY2/059UxCkebkS34MCmeSTt
         KcTNls1NcRMuoO0s4Vy1uiYSAMDaSlD+7bcXk7qmlKCcnJa7061pKmL4wKWtx4gBYX
         pHQZGm75PB/FJdBLPplH/vJd6yXlWuMI9vC2xQs/XDP0W1SfbIjM3YajwJq4SZgQ/T
         eZIUCUEUeYqHg==
Date:   Sat, 1 Aug 2020 21:00:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jerry Crunchtime <jerry.c.t@web.de>
Subject: linux-next: Fixes tag needs some work in the bpf-next tree
Message-ID: <20200801210030.05d28152@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/X56+PooCIpC4xOjZOqGHdb.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/X56+PooCIpC4xOjZOqGHdb.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  1acf8f90ea7e ("libbpf: Fix register in PT_REGS MIPS macros")

Fixes tag

  Fixes: c1932cd ("bpf: Add MIPS support to samples/bpf.")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/X56+PooCIpC4xOjZOqGHdb.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8lS04ACgkQAVBC80lX
0Gzi1ggAjjzzBU3p40cpQvEVbcLEc241JohCGWtIcuZtsv5YKysqxl0k8BNaEtsA
HCltt+stH0STJ2FDloj+HEMTyvSnblA+QdIgeg1bGhI0OmEnUXsf1KbpYcBdGpML
cOvK61llvOx8YeKx/l4u3RCWA0PriX3gW+loa+i66sFR3KUPfDYPIYI4Ojn0s5vn
4kP+TKZqrbyDmVCULTEI7JJtSNUy4UbD7a0QxxumcD0Gfx3BsTeDHeGDHG3q3ZX6
EwDnfCfJvW2tl95wdw2XqPB5xuRZJeNcMBNkcic2tlZ/WxOf06OWpuj2GSOburOl
A4LksETNz87kvrlzvYaBjPXgKeF82A==
=MEA2
-----END PGP SIGNATURE-----

--Sig_/X56+PooCIpC4xOjZOqGHdb.--
