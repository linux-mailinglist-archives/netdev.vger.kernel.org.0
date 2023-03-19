Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001376C067D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCSXJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCSXJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:09:35 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB613903A;
        Sun, 19 Mar 2023 16:09:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Pftq808xSz4x7y;
        Mon, 20 Mar 2023 10:09:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1679267365;
        bh=TZLxrj5/6fHM8y+5KOD9ISidLDcprEMDdYcd/FhT4O8=;
        h=Date:From:To:Cc:Subject:From;
        b=Uwo8NvBQuOE68JEs9Xr4y4cZA5nYyadiiUGFlLzi/lQyA19n9JHL0+9Hfusl6ViBP
         v5azRqiLAnb4j7kX4+9q5Qm85cgwLeoGoBz3exmp10t+c4NjeU+nVQWRVx4CaGucCy
         Ei94Uf+o41wKZgqJ0fvkikxm6+KaOLT38241lM6ORawUgo8gg04To7hwp8XSmDKlfj
         Cik3QMKxJznee4C26Ej+JYJ1sMedcMDfmLXb910UQyITOud0qeggL+a91CbLlgyyVO
         hl9y0BvFQcHPiM+6JbRa/9KPt+ojxcc7WkFfHHpZo7Ub1lykL8V+vHhnQs0CJsTQlV
         /7bzS2qXpcXMg==
Date:   Mon, 20 Mar 2023 10:09:22 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20230320100922.0f877bb9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mKk_Hs=FSMAtsGa8pI=eLM.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mKk_Hs=FSMAtsGa8pI=eLM.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  Documentation/bpf/bpf_devel_QA.rst

between commit:

  d0ddf5065ffe ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev=
/net")

from the net-next tree and commit:

  0f10f647f455 ("bpf, docs: Use internal linking for link to netdev subsyst=
em doc")

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
index 7403f81c995c,e151e61dff38..000000000000
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@@ -684,8 -689,11 +689,7 @@@ when
 =20
 =20
  .. Links
- .. _netdev-FAQ: https://www.kernel.org/doc/html/latest/process/maintainer=
-netdev.html
 -.. _Documentation/process/: https://www.kernel.org/doc/html/latest/proces=
s/
  .. _selftests:
     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/tools/testing/selftests/bpf/
 -.. _Documentation/dev-tools/kselftest.rst:
 -   https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
 -.. _Documentation/bpf/btf.rst: btf.rst
 =20
  Happy BPF hacking!

--Sig_/mKk_Hs=FSMAtsGa8pI=eLM.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQXliIACgkQAVBC80lX
0GzBoQf/aLTrlT3xp30d+NW/2ybvlwzA7fD/ahnIGvDGzDefKcZa7ZwAbE/Brmx3
Dfcp9AqUlnx7bUPGg/YqXgzZS92sp/lZBmr+LoNKPE3CjXeJCnC3jkZZM9uDUuCm
5IiIfwkS9Tj5ow2BYE1fG/BWI9X1LzlsbfmjDHbKHA//YKZlLpY8BVC/OYkWsVAW
8sZY6eZnu4h5OmroHhAvZ335RWcjx8Dc3HaQNnCmfXxhv8evaMB8UnS/zV0ZI1oH
L3Fk6u5Wd1rCHTp43lIaJ9h0qHnSTMq2WJUTD9m1y6JcYuAz9lIdFVJEXpLenqQA
KFZt2g68X/vhtQ8itXLPipH+aZMZ1g==
=x0W3
-----END PGP SIGNATURE-----

--Sig_/mKk_Hs=FSMAtsGa8pI=eLM.--
