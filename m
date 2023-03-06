Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979486AD227
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCFW6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCFW6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:58:37 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8605301A2;
        Mon,  6 Mar 2023 14:58:32 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PVvBW2Yldz4x80;
        Tue,  7 Mar 2023 09:58:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1678143507;
        bh=h5XIYN5L+EoItQ8HxafPRNG77c3wSJgo16ZNnxBR3Es=;
        h=Date:From:To:Cc:Subject:From;
        b=bOs5su7ciaqw/yKhjZ7qLbanP2hVmgE7EhMpI3QYSN3MDjAuBTbPBCIkB/V7nMZRb
         HV1zj27yRmk0ViLD4qpDhOiUMIEsJXf2EoZFvP16QBoH6T9hJt97yIunlJc0vNfKCm
         2sbNSxBN5eSZ/959kPfY/y4BGW3i3ZGwUloUmqvIBKionrG5OkRXmzihLi2Rr1y0Bo
         +xyqt+5s7VsMoGrvhhRq5rcXs7bFTPgXQhKHj1SsMjdZNZsm+PCcSlvSoSVxi8ER0I
         d/E+EwB1mEhulUvpkzDnsj/eeLcR3nqWs87Ux3OsKumDdJcMtbnmHlHs5yUvX+cMFI
         5HTqYTrnXYJ3Q==
Date:   Tue, 7 Mar 2023 09:58:12 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        David Vernet <void@manifault.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20230307095812.236eb1be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//ojnktPX=ubI7kDj46Szf7e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//ojnktPX=ubI7kDj46Szf7e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  Documentation/bpf/bpf_devel_QA.rst

between commit:

  b7abcd9c656b ("bpf, doc: Link to submitting-patches.rst for general patch=
 submission info")

from the bpf tree and commit:

  d56b0c461d19 ("bpf, docs: Fix link to netdev-FAQ target")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/bpf/bpf_devel_QA.rst
index b421d94dc9f2,5f5f9ccc3862..000000000000
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@@ -684,8 -684,12 +684,8 @@@ when
 =20
 =20
  .. Links
- .. _netdev-FAQ: Documentation/process/maintainer-netdev.rst
 -.. _Documentation/process/: https://www.kernel.org/doc/html/latest/proces=
s/
+ .. _netdev-FAQ: https://www.kernel.org/doc/html/latest/process/maintainer=
-netdev.html
  .. _selftests:
     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/tools/testing/selftests/bpf/
 -.. _Documentation/dev-tools/kselftest.rst:
 -   https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
 -.. _Documentation/bpf/btf.rst: btf.rst
 =20
  Happy BPF hacking!

--Sig_//ojnktPX=ubI7kDj46Szf7e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQGcAQACgkQAVBC80lX
0Gzo3ggAnAwF8pcK2Kgrbc2Gbw7zflcf000en2d5pNmMqM6mnK52SVm8vlJ+HCEV
GHy7UMv4SWf7mFe8jcN7II58aW5s2xzt1ZRU8v0grEOJq1kIYEF1Ei42raeEJ9dm
IIriGREcFGWrMSM41tt7Pfw6v7O7pSkxCz4bHztHbYcRDcBQ/LqxUmulE9JWmtlU
cCSJ85UFLn20XDUkHf1bhTQZM/4QK/K61vNqNPuM9eniyVgSh66USPEDDDV3xSme
RXKKaoIZ7bytDwV4VO2Z0wLemdfuFXTBQ4WjDtLnJQKQSfNDjOousvdfSTaBZZ51
ivV1HIKCKsgzAVdQEgIiVSG0c8wdfA==
=scRr
-----END PGP SIGNATURE-----

--Sig_//ojnktPX=ubI7kDj46Szf7e--
