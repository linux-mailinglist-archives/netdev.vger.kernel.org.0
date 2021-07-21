Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F143D0665
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 03:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhGUAqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 20:46:23 -0400
Received: from ozlabs.org ([203.11.71.1]:38045 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhGUAqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 20:46:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GTybx6ZH0z9sWS;
        Wed, 21 Jul 2021 11:26:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626830814;
        bh=PD5aBmlSsWDfHbyhJMyznAe/fch2NwDfbSt8on99lkg=;
        h=Date:From:To:Cc:Subject:From;
        b=RekI72uDE97Ftj1BZj8cNonY16kBEeaVOH2s2ws2PLGLjtfqm/f/gyt3yj3tHUJcf
         TQjC18z3L69ek9/I/LAwMT+yZ9FMq4RajSlAeLczO0xPBHVNBvMBP7/X5cM+yy8Inq
         Naqj4KRyY7Brmfeci+aYrqGO1TJOxOTVzpFDKOVdtvnbGnr6/jRL7aGJiPUwvybzx6
         v6tJ2IOrJzT38lb53z317sa/nW14f057AhdXdCii9WFN3rNsy5VC4ss5RhcNH8Rwq6
         Ywp47H3PIY4A9sHtlbK85KXY4KUorAEQ2f79oHOZzeSw/Q6PNpdqelmW3D/JH0CCyV
         yasu1n1C+ZEZw==
Date:   Wed, 21 Jul 2021 11:26:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210721112652.47225cb4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=Bvj6mJdUmBVPTVmWVIKz+V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=Bvj6mJdUmBVPTVmWVIKz+V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/net/dsa.h:23,
                 from net/ethernet/eth.c:59:
include/net/switchdev.h:410:1: error: expected identifier or '(' before '{'=
 token
  410 | {
      | ^
include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_device=
' declared 'static' but never defined [-Wunused-function]
  399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/net/dsa.h:23,
                 from net/core/flow_dissector.c:8:
include/net/switchdev.h:410:1: error: expected identifier or '(' before '{'=
 token
  410 | {
      | ^
include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_device=
' declared 'static' but never defined [-Wunused-function]
  399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/net/dsa.h:23,
                 from net/core/dev.c:102:
include/net/switchdev.h:410:1: error: expected identifier or '(' before '{'=
 token
  410 | {
      | ^
include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_device=
' declared 'static' but never defined [-Wunused-function]
  399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/net/vxlan.h:9,
                 from drivers/net/ethernet/emulex/benet/be_main.c:22:
include/net/switchdev.h:410:1: error: expected identifier or '(' before '{'=
 token
  410 | {
      | ^
include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_device=
' declared 'static' but never defined [-Wunused-function]
  399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/net/vxlan.h:9,
                 from drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:37:
include/net/switchdev.h:410:1: error: expected identifier or '(' before '{'=
 token
  410 | {
      | ^
include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_device=
' declared 'static' but never defined [-Wunused-function]
  399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/net/vxlan.h:9,
                 from drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:50:
include/net/switchdev.h:410:1: error: expected identifier or '(' before '{'=
 token
  410 | {
      | ^
include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_device=
' declared 'static' but never defined [-Wunused-function]
  399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  8ca07176ab00 ("net: switchdev: introduce a fanout helper for SWITCHDEV_FD=
B_{ADD,DEL}_TO_DEVICE")

I have used the net-next tree from next-20210720 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/=Bvj6mJdUmBVPTVmWVIKz+V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD3d9wACgkQAVBC80lX
0GwPwgf9HXVvl9iHMXpt6OtBw+q0VBSm/4vlMsRz3al1Ppbdp8qBSror7nsDCsJG
1KYL1/8wjoDAk2dolYX29e9UGcXAfHWytPYTaQYjOpSEcheAC+tVw37yyV6df1pr
lAPt5nDjHb/TgQBvHj9xRyjIhik9A8DWQpiZPGvV1gIGKpwUxLi+z4qCQiqo047b
+/fe2IDq21v+n2gCn8bBLC5cka+4604oRQKo5hjG5LGr7wP4PhTFsjvjGqqoWi7y
NCaSQZdtgw8AotRmWcSWnOAUODAxZetOZmAJSaE2QZ7OFXU+q3IqXRc2LgUQYbt2
wpwGxMUewy/pliDlc/O9lqOC4HT0AA==
=KRAc
-----END PGP SIGNATURE-----

--Sig_/=Bvj6mJdUmBVPTVmWVIKz+V--
