Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F9325E98A
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgIERoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 13:44:19 -0400
Received: from mout.gmx.net ([212.227.17.20]:48037 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgIERoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 13:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599327852;
        bh=x7+tB5jivG0wRYq6NJy8F2LHKEV80xR7uFvirYj01Go=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=BoBne33DuXjMIrbuE6LMop3AS0uISY4kpMm051MY5nOJvw+VRp39ODWwWmgTrGmzn
         gwvg91R9P3ZkPAKibL7lOhpNflY/Ipaki/BYl1hmCXmw5rJgZZA63uNL4LywAv6K9J
         GZki9vEv2oUz12yURf92FiObBY/w6nTcpwe0BDwc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.216.33]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mt757-1kXvT30rrV-00tWW1; Sat, 05
 Sep 2020 19:44:12 +0200
Date:   Sat, 5 Sep 2020 19:44:11 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 2/3 v4 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200905174411.GA6862@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:O26OOHAA1OOx60E+E84Z+zG7MtpQFZ0I1sAUxpnVA/gCXe4ic3x
 09LFC+So4Z4RPxPVxvEvWYuUxloyi03snEelNDMoTHlG+98q5pzZMGuEmuCVgc0CGJ2L9fO
 Z30Z5Fuld7klKrbEVZpdZOuj/aMCEw899N5KUYZ8pztcjxPZmwv5908iPHMWuQHYi43mQx0
 Q5gWgQYxM07aonab52r/A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZDwtOZ1MWik=:BWubjIw4jq/CNmlBDTLpZn
 FwTaYOmQGUu9dhWwlWBYFQqHxS9YzEWmnXwVVoZkK2jB1zIOrblnb6ptCAsMeRipyrHEZqpd3
 oFu8pFFf/H5/kwxdzdW3cetpq5LjI8C2+BQhEzmRYpZ5mgD//bAJnzMwvjlgrOvPR6c8fWxCI
 +hYtGko5hfXi3ItHHkI+xvjgBAMNDEXWgt1Xerur40cTLPe+wHXXq2id3+vnoZJ4clD40oTui
 evmmns+drWouB53rIOXf0UU5X6HRbjlKNw/X7HbskHAqR2NSMr6wUZKFmVgj0RdubXkIP4ogU
 lWwHbovODCJzxm3cjzyl5rrhtrwpAgpWxa4uXKbqyX/iV7VH2QABuf3r3WxxkYMsYLOEbreI1
 RtM9IpGsi1ZLCw11z04E/rd5K3T82b3x/w0JmucoT/OKz04wQ/4wgz0T7A/9DJmIrh64HXLJ1
 RAYLuqyRftuYyqzJY2mSIkh3Pu31BCUODP6oFGsMYmC/P5xFivvgiXAMktVpEVRtq2ahA15Xd
 9cA+JDzu7y+mZNQH6MBwzl9gXJT829W9TTtAZ+sM+X/aDY4Ou0c/UND7LeZViS4bzmcDZ9RLF
 s2PjJ3iAJupvqE3EMfnR2xMTyNn+zJJ42Z0IDKsyq6Kz+PbraarFTqO4JC2SwLfTlHNr6uKx1
 czAPDjl9sMPsGBGWbmVF5dJaTgii5YmQ+POFsA0psHnzL8w1cSjTMKvDSIye9PAw9T2458o+a
 NDBnAxv1zCGwUPKAMQmMSPhP1Q/gteQ189dOfK4VgfotBFrcKUcuZ0UrdO60Z8VkWUtm/UXrj
 JiIol9h0hKAvpVhCIg/TjzgHHFjEJD6A9zVElz1qqJ5OfSJtpUQQKCXfSS24JqskwXAOz3xkj
 38t04PDO/w6cGEb6tS5LEyQ6PzGI7DGhRa58i7fqo+Dn5yVGMkOAbm8dq3y+UlgrPaEkFVhsC
 MCAbhh9lpNLfwOcAIyKOr+U4SN4JNlpCfAAsIonExAzM5+CSCBflCp7Tj/A5uwGv6zF/6Sgdc
 hKoxG/1t9CTeXvFttwvFI29SGoMzAMmLW57avQNfQnaw8d9s38kwqloYAUhysyn9Y22qfmj7u
 Rq43TcC/ZrZHS64Ekuoi97vWNOITymvSWseP6reqeMrcw2emKqqT/a+l7JjKTYzx2Jtt74EWQ
 kk2EU9gu4l7bMSxJk2tRjRtjZvG3W0Hif8Jh6lqVh9FGrQFnQAyPzYBdE+Kckt8Fd4f5MCBbY
 cS08fNNMroB0LRHk3
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

