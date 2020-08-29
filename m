Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5725672A
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgH2LkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:40:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:55399 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgH2Lgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598700995;
        bh=x7+tB5jivG0wRYq6NJy8F2LHKEV80xR7uFvirYj01Go=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=BIcgJGUp8S5JyA+Ssw3KNrSkrh09lRp98L9axOxUhjF1vKXxcYiw0xvnFTCjopiNF
         0IWwYJDXI5Mdcv4giXQ5iXFIECELR+Wt9HfSrnv7qEEY08sxKffD3mAUDq6pW82pSb
         ij/Jl/dY4DpSVXEfY4XzP9mJDNwMO+OlJMrg+2wk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([91.0.98.17]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MryTF-1kzqFB0Fd7-00nvWE; Sat, 29
 Aug 2020 13:20:00 +0200
Date:   Sat, 29 Aug 2020 13:19:59 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 2/2 v3 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200829111959.GA9675@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:pmmyx/2a8YnxU2AZBwKm1FkLVzxhmR+pLQ+ms2ywpIygplwkZiI
 dB2OdRfIe6AZr68FZbojUGWZH30hq1fw8mtSjEC+kTvul1gAA8aQbdUEqILyvrvS87YW+FK
 GQmTSUzDE/bpOzNStUXKIptmgb77o39+49b2QbRqySsTsmvQUovVSxWV8BGrqm8XTD+S2Qy
 ACspGUZ77tFFpw6bO1eUQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:uFVO7DYhM1k=:jDPdAw5sPcxc73UuWVngeF
 ilxMYtn4/+FfgNbTmuwZRxsbLTUCjrSs65Ib5coKvXqz/XAiBd2mpxIxNUReNsharGUlT3Kvl
 RzqfzP5CCmHWTLhWPRzn3Svl1iQsTzXEi8GLLqlIZCTKEh4Hv50aRYdh0xbBbpV/uWBZZvbdb
 VbAn2cX+2z6BU2nqyhDRYILshvc/cdEEX9TQq1Mj1GgF3KL+zeEB+8zdJ+m/YbzfiGhwwY8E9
 beV8Qhc0bvo/H3J/c1+3W/A99aHRLhKRW7YiDV0IdW1QZnHcaTO8ln/512niBkyhnn5HaOUOE
 YWapKLUfCZXKwCx7yoDnLWSWyk+pK4uP/WROsHJJ0liT5AzsKEHloVGTQ6DhWBALRZZixpa6Y
 nUeR0jwzTPcW3kr7m9/O94ytRQezv+xrogpFhOeeXcxZABOIpEoCl8olDP1r1zxr4od4rOxpd
 8rM87B10xWj43FLn1k4m03uCqAGTyV5e1taAZmwJSCjWx3rkb7R8I9+R+WUV42PWwcMNey5zC
 dIuBA93hcuBCzXEhBvaaQjoxTzQlSzGrYHi/b91bOeKMiSmlcBOeH5PkBxwcQNpVfoFHpTCO/
 +dWonvO/zH1f432Jm/WMopoRBhTOdopNW7SHZEcsJ6POZCCH0otT1OxpznAVoydFd1BwgzCsP
 V5DeS8NaAxdiH8nmSdML6meh79p3G9w8Rnyrj4GZnLTXMGTDH8SXAnVkdEb45fkPZYrYSfJVp
 h4xpOLU8nXVwIEbySIByqsGKz2fqulJ6gt8s+m35hoOVzBusjjfyOIpyI22F7o1tcyS4MXfWk
 ZcyCFba8Id6L0ttkiczAwZrDJnoowsH7wxIAk88q7KHceFDHWqOmm/UP10J0Z1XQuEfX4po48
 Ure0uykIJknTcd7yrCcLMO8y71A+ooNgJHwpjyJEh91Y8v6EUQ96QoFzC/5nRuMhCXTMy37Ff
 BHDGFQmDwmXtunf87fX9ON96FGUqCYPC0ngePNJktg5k3dhVX9PjsTE2t/tNiJ5lpr86YLcM9
 XdPF5G6AJ5rJY6qfhcFx2BQG/8EJxa9OvemoUWHExL0pdtESNm0omT7G2QezQRT9goCMudwkQ
 r5KHN4TrOTjK2qEn9W8eTX4b76oApQtdH2jOkeJ6q90ZVgNv39u46bSBGByXhWHRbpNuEu5fn
 UEVKSgybTfHPoMS3Q5dENimlOPdGRJkxC5r4ky9SUEitMVlwNlR+Vf6nCk6pwoY7kLO6fj3Bo
 KYcysOGVO6Zf8v3LU
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace version string with MODULE_* macros.

Include necessary libraries.

Fix two minor coding-style issues.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/=
8390.c
index 0e0aa4016858..a7937c75d85f 100644
=2D-- a/drivers/net/ethernet/8390/8390.c
+++ b/drivers/net/ethernet/8390/8390.c
@@ -1,11 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* 8390 core for usual drivers */

-static const char version[] =3D
-    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\=
n";
+#define DRV_NAME "8390"
+#define DRV_DESCRIPTION "8390 core for usual drivers"
+#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"
+#define DRV_RELDATE "9/23/1994"
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/export.h>
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>

 #include "lib8390.c"

+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+
 int ei_open(struct net_device *dev)
 {
 	return __ei_open(dev);
@@ -64,7 +76,7 @@ const struct net_device_ops ei_netdev_ops =3D {
 	.ndo_get_stats		=3D ei_get_stats,
 	.ndo_set_rx_mode	=3D ei_set_multicast_list,
 	.ndo_validate_addr	=3D eth_validate_addr,
-	.ndo_set_mac_address 	=3D eth_mac_addr,
+	.ndo_set_mac_address	=3D eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	=3D ei_poll,
 #endif
@@ -74,6 +86,7 @@ EXPORT_SYMBOL(ei_netdev_ops);
 struct net_device *__alloc_ei_netdev(int size)
 {
 	struct net_device *dev =3D ____alloc_ei_netdev(size);
+
 	if (dev)
 		dev->netdev_ops =3D &ei_netdev_ops;
 	return dev;
=2D-
2.20.1

