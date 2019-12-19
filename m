Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B5212715E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLSXYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:24:03 -0500
Received: from ozlabs.org ([203.11.71.1]:56215 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSXYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 18:24:03 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47f7HN3nqBz9sPL;
        Fri, 20 Dec 2019 10:24:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576797841;
        bh=L3pydL2Ngv3G7U0NNXz1d30ilpikZOS17+/Vd+VSnpc=;
        h=Date:From:To:Cc:Subject:From;
        b=i4QWQ8qgnEEP/T5LXRMzEq1e7MuUgZPSrPKMKz90RrM2LOY2BMvGaCvV+PP/0Rkaa
         rSyC4XSbpbzLibyDVDxpB1Mb1+aK1v7F8hJZXGDWf8WWoe6HO8l3btTPY9ip2ooLwv
         Uu9dB61n+ZQ1GgC3q3ydjWUQsJiU50tRNz6nxolCifKfUp7v2JlhEb24ILZZa8Lvic
         4QAG3xxPZq4i8953R+GmxMxilDkdierCUZ+scRVznND6y0zAr6fONMo4jFpfWBlEX/
         WpA0hBK8MAjnYymlQLyElQTdSc2mJqYxtSCZZufYOo347GhMO3tavMiayoQ3y9SAyw
         Nt8bwf8HaZUPg==
Date:   Fri, 20 Dec 2019 10:23:54 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Chaignon <paul.chaignon@orange.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20191220102354.1b1cb3fd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_z6.GrJ=MVBvH_br755K9vj";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_z6.GrJ=MVBvH_br755K9vj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  arch/riscv/net/bpf_jit_comp.c

between commit:

  96bc4432f5ad ("bpf, riscv: Limit to 33 tail calls")

from the net tree and commit:

  29d92edd9ee8 ("riscv, bpf: Add support for far branching when emitting ta=
il call")

from the bpf-next tree.

I fixed it up (I just used the bpf-next tree version) and can carry the
fix as necessary. This is now fixed as far as linux-next is concerned,
but any non trivial conflicts should be mentioned to your upstream
maintainer when your tree is submitted for merging.  You may also want
to consider cooperating with the maintainer of the conflicting tree to
minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/_z6.GrJ=MVBvH_br755K9vj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl38BooACgkQAVBC80lX
0GxWzggAmAYGyGJ6MoKba2FdA3OJ1OawhcaCQZ+3X8LuuPIuMYL7zyYkOQ0e1dge
796us+S/9p+/aHGtwQ3xtOS2/Rrwo2OiEHnv3aVjdwoNRcCIrYwQDDaYidrCcDFE
nunUe7FepTP9OHGfoO87awgQfzn25eIULuRrdhbyI8Hrod0D46zf2F1Gx0yUmoZI
gtUHW8aiUI+PzZXJAA2ScXGI8Ed2Jk9X5OtZRFP+tGQRsi1z0DUWAKgGU4LUSS/S
J7iDO1/21SlS5JPITGFsStx9TCRpxoHQXYlwg3oslIJUgdMyib7kkOElPDBrK6Kh
N5gSEA5kxD8t6W7zqLePEPSWLO39ig==
=U515
-----END PGP SIGNATURE-----

--Sig_/_z6.GrJ=MVBvH_br755K9vj--
