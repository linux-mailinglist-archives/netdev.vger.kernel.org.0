Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81944550EF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 00:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbhKQXQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 18:16:42 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:38331 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbhKQXQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 18:16:41 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hvdyr08Gjz4xdc;
        Thu, 18 Nov 2021 10:13:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637190821;
        bh=1KdIYkXQj6OUYXFVarRsAwE3ZpERCpX1hgrcQuIfkps=;
        h=Date:From:To:Cc:Subject:From;
        b=TME2eGfFBhYhYfD+I3PqZlZa1VMqt0I/ja/xJcNM6JPutdo43cMSnVld4k4c3yMdm
         gCA+QTgtsV81rBpa5ZkOE0tV22lQE0qOU+xoZu/xcQSIMsdI9F+BUGBJplv4BcEJh6
         chFO0sukJXv2mx7BfAKTtL/Q3Orn/a05nu1lPnk0cHPqkIskI8nASGf/pJyX/pcjxo
         +H86aJVk2kNMM+C8DCOAWukx6QhM1pFY5VxYDND9JlK+QOIaZUweAQveY7DeOJUB5b
         vJ9CfqKzrrt8ugKbLDYhyXYlVzHlb7aRGPJcl64HAvzHvzkphdFEtiTvUVfepKMA1O
         b85q/vZN3fAMQ==
Date:   Thu, 18 Nov 2021 10:13:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Dave Tucker <dave@dtucker.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the jc_docs tree
Message-ID: <20211118101339.6ec37e14@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5L9+vwtChqc/S0w0YGdhq+U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5L9+vwtChqc/S0w0YGdhq+U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  Documentation/bpf/index.rst

between commit:

  1c1c3c7d08d8 ("libbpf: update index.rst reference")

from the jc_docs tree and commit:

  5931d9a3d052 ("bpf, docs: Fix ordering of bpf documentation")

from the bpf-next tree.

I fixed it up (the latter removed the line updated by the former, so I
just the latter) and can carry the fix as necessary. This is now fixed
as far as linux-next is concerned, but any non trivial conflicts should
be mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/5L9+vwtChqc/S0w0YGdhq+U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGVjKMACgkQAVBC80lX
0Gwb5wf/RINYTn/Oo4Zx3IplVB4jA9W3DvOmx/IsW7H+nZcOKCH+86QD751fkQcl
PsNI+kLXimzNiW7HujBnAw4j6gSUL+Tjs6+p/Xv6GaZxZZyg1jagM/uwSaL/6rUQ
1dFDebvs7UtBWNt4GFqxuQOqr01lFy6wVrM45YwgEC2q/VKCkafU1VXZyIbwFp0X
5ana/9jSucDqfTCfcFHW4Js0pi3wZZzOrWvLJfNIxwzXVICXc2fBCoz7rMoK+S4J
/fVId/XZSPcx8ode+bVlEJdr/pxVXOj/+HrBDPff4myAV5PI5ojshznMplnFim+p
BSbKZJ0Jt2kIM9SjoLsL6sLFQmYuuA==
=XdIC
-----END PGP SIGNATURE-----

--Sig_/5L9+vwtChqc/S0w0YGdhq+U--
