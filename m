Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B1431F16F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhBRUyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:54:46 -0500
Received: from ozlabs.org ([203.11.71.1]:52873 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231438AbhBRUxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 15:53:39 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DhRk14YVSz9sBJ;
        Fri, 19 Feb 2021 07:52:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613681577;
        bh=mbks+mMscNaIdkDjqnY7Nnb54RoU2CCcSOK6AZlVAfI=;
        h=Date:From:To:Cc:Subject:From;
        b=OTCcrfp/+Y1l/VLnYNEF393XECP67TRy0shjuEAFMt/bsqEhThLjJyySkK5v+5oM5
         SuNs+MX6COEByVHkYRQnWcKGwxNMQU9D+vqEaJvhLQCfg4K0+CpkM5m8HoyvWYatvc
         VJ3IOsz5w/YEqKGVoBQFT7N1bYZho00D2q0EQHXi4NkJ2DF4xoVHxZXhi6/N+1z3K3
         kgRKk4h+6dx6bhNomJTiWfYT7/qNycfEq/rPnHqnazSpDp9AOqAhdh1wxPVRN0rgQD
         Ed0sWQFph8SRfNEVLYM0yiJs73fTG48jiaButaITHlBO9GVj76uQYFaV9SJ2iHGITp
         3Lj6UntjH0A2A==
Date:   Fri, 19 Feb 2021 07:52:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the net-next tree
Message-ID: <20210219075256.7af60fb0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lFxdG8TW_eZZr4dQ8a5F=aP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lFxdG8TW_eZZr4dQ8a5F=aP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced these warnings:

Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.
Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.
Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.
Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.

Introduced by commit

  91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other atomics i=
n .imm")

Sorry that I missed these earlier.

--=20
Cheers,
Stephen Rothwell

--Sig_/lFxdG8TW_eZZr4dQ8a5F=aP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAu06gACgkQAVBC80lX
0GzBCAgApTtuAAay2d4m9sdTUCRpHQWD5TyPja7zZTYF6rFWWybt9nO6Oa/8ssbj
afIn7P+hTps2SqPBzDkmtbJP9zczwIvHSAC9n4J2g/IMFK+omJl0Inx77QcYnljc
VNjwgzOJDEfnODGmIGqvohcRpMaGUfrmAQqHhAn07OqRvTs3+qeA9sPi5hn3HGJ/
nr1xGPTgumvTn6mvs+GvxhcaI2NZjS84pszgeNLSImM27HSYqmOKeuF35TExreXd
q2PJx+XGqPn3VWEPVE2NesLYgKUKT17A8pFYb8jLLfXJle9n5r4dvrZFx64NNCcT
TeBaHjCRu7HXOIwdiGcciTkKBCvsRA==
=MK4p
-----END PGP SIGNATURE-----

--Sig_/lFxdG8TW_eZZr4dQ8a5F=aP--
