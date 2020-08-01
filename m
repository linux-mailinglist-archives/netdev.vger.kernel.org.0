Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C82235458
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 22:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgHAUwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 16:52:50 -0400
Received: from mout.gmx.net ([212.227.17.22]:48469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgHAUwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 16:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1596315163;
        bh=TAlTyGNN5upiQHaJEmjfEMJKi2SXfMkKSz5NVUMLDNM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=YlrkG0Mp6EOvJYePi8euyMoCtX7j34Suk+6cF2Vj6VGdPflbpW3WZ9MrKm1ege3WE
         V+bmWI6HICOwfEDqiwSoZbX68tyLZicUlKp07ZJ0LwZWua5eC6DF16KGl/3SgA6KFh
         JZE86+9un6namBsqqXsvJ5q7aPNmnJPzvSHYD1nE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([91.0.98.233]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEUz4-1k0LfV0J3q-00G4TS; Sat, 01
 Aug 2020 22:52:43 +0200
Date:   Sat, 1 Aug 2020 22:52:42 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 1/2 v2 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200801205242.GA9549@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:ppS96KFxJ0bPpNe/huMym5jZYj9Lf8zCPZzYlHQaIXFmrvbVYUd
 zKrCs7gTDRrfRwnzqBX5tbWwzpCrVvCEBGP5pWGhkJ8HezlUX534FQls2w7bQr/Ze5lTqPc
 y6j6WaM4mzlPUnFlKiKT2wZ9QgZQwF40sE/WvfKQXl4kAG37Yf/v8ovhvetrf7tM3Akx7dO
 qBVKchyDp/EDo25AwsVog==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bGBpmmnedxk=:YgE4tpPPQoHdEHt/v0Q3Nn
 zBWkG7hPK5r25poAmKMuaHU9dazTwFbQK7c2NwcaJ1J12TOhDO3ZVYF8eXeXwFLBWupFgf39X
 ENQVQK2+qrfKy5pdISJLSkhg7txkPywLhb9un9HtUj6BSXHtMnUR5DIqvORvnNST79fXcdfgn
 gxupE5Xjgsfkmf8UBwo3dljCYjxyPfpXVaGUSQHI/pKa6sw43NsApJMn+05aNu369Sg/clZnf
 Yh+lSf0pmcxwDqYw92WxqvhKc4sZS4P4bFIfJvzs26zeavKhU+7zSH7IZgU8cJVX9lLxz4ort
 4pbjb+8KfH6Yp0NqC53E0lyu+woC/0LKnzICOZzHE5BC8BH4YtbZ0AEqxXFdSG6JeeD8pT+c/
 enf/t12CNGZVLhFELcddaS5NBnsvii/2eNHw5C/M6pfgGzYox8mEQ2HD3WZfzZ2QiJdBB0u+P
 6k/JiA5i5Lg47UWMjKXhR1spca/DRqbpbuKsMqLSZEzzF9g6DYBx0QUKV8nnZmyqq1AlcSme+
 bQ60BBzEalb2tv6z6GkvI+LeELDnd2nwFzhUFM6R/ND5LvQ9mixRf9wFB/8XJUPkRo6+iVhgj
 pkPWu+rcmVjGhOwHPEuJ57GlLo7CgaeQ6fLQqtjCS82jHSe9spWBH51acXo6hwAQvJgWQp+97
 Tm+JiwJPTI64BVN0fir/0y9+o2YaMOPgirj2pd1FE9tHGNoj7wtgvTYuo+CMHZKH217CytM9T
 p8AzByKlm4CsxQ3tk7PBA6Yx/zsoNHW1OM6PW/nNSzBeWWu8HhrOJ/lfNIpFH0jYJqqo1PdTX
 K01vy0JApcW6vT9nKYi3JhIUxABvmN3Ajjeqt9GFNy8T6dKiqYgomK1UQcf1QjcEFDGbSr0hq
 K3vfeOtJW+NPqCnDdjXi0iITOQKiLzVueA7hcxf5XHnLdqs5C1fANWyqQBcRNxVjCGkvmUuE6
 /OuxUBr2ia3xlhbiZw8b/gHm6CKPaEBE3WdppL75wYoIjlnlCM9cRzu1Gw2hYMpiOh4WDCcqI
 W1LbFh03bqChMNjyDIxQPUnueWMyvGu6snlUZ4B1/3ZvrtDrkqXUCx3M5pWIyYaWjvuJl9Jtn
 abJ2bbn3AYbKrxRNYM/ZmOZTwCT82DXHEjoXDvIFgsI7q5y8+CFmHc/NAkeQn7Qy0pD8fUD2q
 qXh8BqYl0Vyws0h2upZmXzVV9IfWkp6H0E5SBOch6B3Moy9dv+bQwbrrYq1d3Wc6K/zKKiWHA
 7Eulgq/xgjsetHS0Q
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

