Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19A75A8A13
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 02:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiIAAzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 20:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIAAzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 20:55:19 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC82124B;
        Wed, 31 Aug 2022 17:55:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MJ2dZ3stgz4x2c;
        Thu,  1 Sep 2022 10:55:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661993714;
        bh=lOso3jPWVpnln6y1wBI3LkdpK6yTA2MDzgGIYggkxPo=;
        h=Date:From:To:Cc:Subject:From;
        b=mQV98eckJWqvPTFSooGrxQzy3oyHElfSdQStgwxB9/RW+cdCEm9CK1SAxC4Ui2gRY
         fwKPgvWl6HgxbD1lb9nutnCJZZlt0GNniRiMXm8Sgq67pYciNVJYB7BKTnJCI+sFGp
         C7iL/KQVoAMz85l3AjebHrLdsFB+BJ1kJm6Njs/9znV2I6cXbDevV/q4pXUdgDKSEX
         En9ToziohAD6p2mIRKr8thKWmBr6LPmvhQHNhsw+awGbNTH5/gLUhXD+wGq06ZDJ8x
         TQUxeeop6y1cG8AIX15d5r3cBLliQkqrJzqHc9QrEQdke5JpS1PW5lScRG732PCJXH
         YJOsXMzbMAqDA==
Date:   Thu, 1 Sep 2022 10:55:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220901105512.177ed27d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qwdtSox3rF/po_GVulbNPzX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qwdtSox3rF/po_GVulbNPzX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/.gitignore

between commit:

  5a3a59981027 ("selftests: net: sort .gitignore file")

from the net tree and commits:

  c35ecb95c448 ("selftests/net: Add test for timing a bind request to a por=
t with a populated bhash entry")
  1be9ac87a75a ("selftests/net: Add sk_bind_sendto_listen and sk_connect_ze=
ro_addr")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/net/.gitignore
index de7d5cc15f85,bec5cf96984c..000000000000
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@@ -1,15 -1,7 +1,16 @@@
  # SPDX-License-Identifier: GPL-2.0-only
++bind_bhash
 +cmsg_sender
 +fin_ack_lat
 +gro
 +hwtstamp_config
 +ioam6_parser
 +ip_defrag
  ipsec
 +ipv6_flowlabel
 +ipv6_flowlabel_mgr
  msg_zerocopy
 -socket
 +nettest
  psock_fanout
  psock_snd
  psock_tpacket
@@@ -20,23 -11,35 +21,25 @@@ reuseport_bp
  reuseport_bpf_cpu
  reuseport_bpf_numa
  reuseport_dualstack
 -reuseaddr_conflict
 -tcp_mmap
 -udpgso
 -udpgso_bench_rx
 -udpgso_bench_tx
 -tcp_inq
 -tls
 -txring_overwrite
 -ip_defrag
 -ipv6_flowlabel
 -ipv6_flowlabel_mgr
 -so_txtime
 -tcp_fastopen_backup_key
 -nettest
 -fin_ack_lat
 -reuseaddr_ports_exhausted
 -hwtstamp_config
  rxtimestamp
- socket
 -timestamping
 -txtimestamp
++sk_bind_sendto_listen
++sk_connect_zero_addr
  so_netns_cookie
 +so_txtime
++socket
 +stress_reuseport_listen
 +tap
 +tcp_fastopen_backup_key
 +tcp_inq
 +tcp_mmap
  test_unix_oob
 -gro
 -ioam6_parser
 +timestamping
 +tls
  toeplitz
  tun
 -cmsg_sender
 +txring_overwrite
 +txtimestamp
 +udpgso
 +udpgso_bench_rx
 +udpgso_bench_tx
  unix_connect
 -tap
 -bind_bhash
 -sk_bind_sendto_listen
 -sk_connect_zero_addr

--Sig_/qwdtSox3rF/po_GVulbNPzX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMQAvAACgkQAVBC80lX
0GyYCgf/TaoHbLkMm37PGBGviO4EeqEyfN5OLvZ4LB7tC/CE62ENE2zjCaJtq3lD
bCo8IBVnqTyJrQ7hw6UoxlOAq+u3RD8fXqQfn+2IWMtkjC8T0RlKCrBIiVnRNiqI
00zwY7EBNx5DuXcP9D+YVM1E9HjA5DcOCtZ6f2gA3rG3amEWSdGl6SCPVTsCY4p1
Tj3X51FkGPJNh98HBrlX189OZiR0yhQ7+LhWCHCCvfQ6NwvPro2UvCklxHqdDfT0
p7i+7W/gLitYP0dr7FaQ3XOIbnX318awQDgXrJPTqpNZM8vIUevIPERFoE3Q3J8d
/orBjhuDdS4oT+PxD9ZortXMQ/SG1g==
=Jc1Y
-----END PGP SIGNATURE-----

--Sig_/qwdtSox3rF/po_GVulbNPzX--
