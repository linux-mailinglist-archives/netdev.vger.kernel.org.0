Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A297A21152B
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgGAVdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:33:13 -0400
Received: from mout.gmx.net ([212.227.17.22]:36437 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGAVdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 17:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1593639185;
        bh=7Dmer/kIdAF/sNdgBXoZDRdban2LAdrRox+8TCtrFzc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=kf8zv/7Vqt9PFXUbwxdYHYNmnO4xq8U1xm0wqVFfXAWBgyB/D3J+oabdcsn913ZDj
         g/9Tm/DWHJD01ogzom5/4ugtasJp0mRJvWAVM/27RB355/+gQ1XD8nXz/6pIk6Gm2h
         +cx9voMyvhLP5l/gSh50/n7QxSHhDRdYve+bYu2o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([79.242.178.121]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MTAFb-1jNRPC36MR-00UYlf; Wed, 01
 Jul 2020 23:33:05 +0200
Date:   Wed, 1 Jul 2020 23:33:02 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 2/2 net-next] 8390: Miscellaneous cleanups
Message-ID: <11046a4a36d173c265f92588076b92b768e2fae9.1593627376.git.W_Armin@gmx.de>
References: <cover.1593627376.git.W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1593627376.git.W_Armin@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:HbZUcZ+zpNdzLNTdjM5kYqWQ0RpWEmOwwBKizCpngwS1DnMTap/
 fDIqyblggdi+bebEg3l1mG8fYD+H5yRtvBT7I5hdQW8hwcnl3j9OlrgNb+WETHwxPc0A0I+
 2OPaSK+gckYav+40BFt8OfJjD8JyOuPZVBxcsF99QwsGI9rY9D99T//QRCIDleKpi+B3tBp
 zVxp3hwtPwpaRc9ShPEpg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xA0h/Zqkgkg=:ZMDfA5AbzfN7IIdU8kTivt
 PZ8q5QBzAGhQfJuGobsDTzso2TK7UfH5d0oaMr9KbvzwFUL1kCF9sfFESTZsQa+DiqJKWUOsb
 fTfwUbXLAqBdjRV6kubswB4f+YF5uRz6u2mvt+Eprw23PuTeQk+luMqNvY6MoyRghsDz8nFJY
 upXq2Llyv0Gs5A7A3hOcPIqMJAclZtMpkaorxN2zjQMGIdsX6B8ItdLqgjM+ooQdwKE22gFDu
 66/8sXCAKxw/2nl+kSZzz6sW1gcASdVga+qY33laDTIbQU6yrF21YIIw9S4gqNusEDAXA5Q4/
 WIMBVppzZCBFUF3oV2TavCMajw4twiOmfWK9M37jGCT/bQpPKdW9FVTlacGT0UUt8oC2SOu8w
 WZpH+HIkXDeG5VQW39C0pascXx+HrkALkJma3JsXGOU4LLIUvBmXU0hm3UquxXntxkSPiGVOk
 KFlcIJBNtPbfz63AvVzNqvZQdPoowZnLruUSW2brMXZN/LUNmDGNjEFWs07zpakAozF2GfchV
 SB2rdcAJFG7uvtS6DNz36M/NbMF/GfqTh+eRU3kGKCKxycqrmQeWykXIdJB2MNpOw83QgQwns
 RVG7cAy+0W9pdNtwg7diTBk0DjyGKDZXRiqSPMfOXDJ53zojzgJJXnaMEytSBGvJTnz14Iu4I
 y6f8UUBR4uAc8NPi2wGYqVhYH5grjOwuauyiUkrt/npLA0vwUu0Nyg/K/6vCfmtcApM8TQnGI
 T1dWQ/1DxKd4vNnBVjHemVvtkBGb5GK0lrHLBFpbkT4zr5D7IUIwWsFy3aOzjQBlmjL2FCcQj
 Z9GJs+4EjXe80MCt0lR1dEj4+gH9r/3IkqJO4+ewqZHBv74JOwvXCy8DOF3OdDjLgyNYZoBVx
 VfogZSqMU7bWF0fDJMvfYspZqLKcERKWsthXqSmTdJ9Juif2y3lJJrHukZhYAD35EfxGOrL+W
 5mnWU0+IHm2hxtXglDo6i3CumrfqXxa9fCQpuw1SNH8ZTzqbl2KryM4z10wxu4KqS0vnPeE0M
 uUY2whrSMZPs9wyjigA4xlsostpfhJ/GJoDoo/YWZtFCPwA6BrqvsVnG3aR/RkdohjuLanWLv
 xZT9caJDNCYPrvytKh8k+qHUXztXiOs7SizbeFU4ke+tIe4h4bDKjyXv9JGJ2bJCfLVjOGL0p
 BwMR7SceUNCeqZPrgpq0I6X8PqT2sM3oq/kFDXp1nGlA/EWBc41atzYqfOpXcSX0PeSnQ3OW+
 BkgOfi8tDQh5sy1EO
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace version string with MODULE_* macros.

Include necessary librarys formerly present in lib8390.c.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/=
8390.c
index 0e0aa4016858..aabb637c1fbf 100644
=2D-- a/drivers/net/ethernet/8390/8390.c
+++ b/drivers/net/ethernet/8390/8390.c
@@ -1,11 +1,26 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* 8390 core for usual drivers */

-static const char version[] =3D
-    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\=
n";
+#define DRV_NAME "8390"
+#define DRV_DESCRIPTION "8390 core for usual drivers"
+#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"
+#define DRV_VERSION "1.10cvs"
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
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+
 int ei_open(struct net_device *dev)
 {
 	return __ei_open(dev);
@@ -64,7 +79,7 @@ const struct net_device_ops ei_netdev_ops =3D {
 	.ndo_get_stats		=3D ei_get_stats,
 	.ndo_set_rx_mode	=3D ei_set_multicast_list,
 	.ndo_validate_addr	=3D eth_validate_addr,
-	.ndo_set_mac_address 	=3D eth_mac_addr,
+	.ndo_set_mac_address	=3D eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	=3D ei_poll,
 #endif
@@ -74,6 +89,7 @@ EXPORT_SYMBOL(ei_netdev_ops);
 struct net_device *__alloc_ei_netdev(int size)
 {
 	struct net_device *dev =3D ____alloc_ei_netdev(size);
+
 	if (dev)
 		dev->netdev_ops =3D &ei_netdev_ops;
 	return dev;
@@ -100,4 +116,3 @@ static void __exit ns8390_module_exit(void)
 module_init(ns8390_module_init);
 module_exit(ns8390_module_exit);
 #endif /* MODULE */
-MODULE_LICENSE("GPL");
=2D-
2.20.1

