Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C7F5228AE
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 03:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbiEKBKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 21:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239940AbiEKBKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 21:10:21 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE8B21553E;
        Tue, 10 May 2022 18:10:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KycK145GZz4xR1;
        Wed, 11 May 2022 11:10:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652231415;
        bh=/50pI0KRJ589VMgCiJQAiMLEFbliv21CbjUjnNtZiPA=;
        h=Date:From:To:Cc:Subject:From;
        b=C1IctHzFNLEjbF+bo+9BwpBiCrwgjM17YB1Yzpxy0/enrkLyxo6VE3N4aTH6O5/5I
         6DjLWSL2xFeat8Y2Eg+vxYa8YEqmrW7bD+BnMmR//LcpwKFH1wiU+W7s0KphUsurjn
         nMyS21z4lt7wF37XTDXOswFcBpBFI6WoW4IPAMXWKSRDG+uoWw2agLnPPcEzrrA8pq
         swathpHuVvjWHsHclj5UabQsFpoRacZ85S3/6xjPBWn+EE8nLQRCbDr3ePTU5BrsPT
         P132Y9k7sgY2w6GNQYMMI/0G4btU45S66OmDSmaWjMokl160X65B87+4Ykm+5QbAGK
         zmFazGykk+qAA==
Date:   Wed, 11 May 2022 11:10:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20220511111012.22c08135@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+e5uSlANdXi62TvsRbQbd.C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+e5uSlANdXi62TvsRbQbd.C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  net/core/sysctl_net_core.c

between commits:

  bd8a53675c0d ("net: sysctl: use shared sysctl macro")
  4c7f24f857c7 ("net: sysctl: introduce sysctl SYSCTL_THREE")

from the net-next tree and commit:

  f922c8972fb5 ("net: sysctl: Use SYSCTL_TWO instead of &two")

from the bpf-next tree.

I fixed it up (bd8a53675c0d and f922c8972fb5 delete the same line) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/+e5uSlANdXi62TvsRbQbd.C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJ7DPQACgkQAVBC80lX
0Gx1wQgAi7w6IumhPsHFhfGCD8bYRT3RWZ9nARJ/Fcq+05mEqjAo9UNWWw8uOZsH
cUVBaDEXzgaD/LeH2T1bNYpFz9XF8kZzWpcWes4Zd7Ezl3sca3LaPXDPVC0I328y
JBH6NJsVkvSctusAinAvBVwa6AYIN7n+NjIPLxkKvjXNtOBiSP22pz2p4BoVH7Vp
hR5WoRizcb3AmICnekeHyJIX5x9CNJEB4t9UD83eEQTHG+rWnn3c1zTikUU1BCMW
Yxkk6L5KzCMFYTh4uiLXHZwisZE8XFVXlWJIlHWPBRqNEyh3kNFYq1iBrTE8ANxr
r1RPBL/zQps1b7upUbLNxQvNALaGtA==
=gbic
-----END PGP SIGNATURE-----

--Sig_/+e5uSlANdXi62TvsRbQbd.C--
