Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D7322B5C3
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgGWSew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:34:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:32929 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWSew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 14:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595529287;
        bh=4dzggtUFTTf4tJ1GC7zzMXg0K4euGkDCIt8jMoeGDiU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=MlKGsqs5kwpW3OXAOR9peZpoI9rVs5ibgJuoMSo3Mh+WVUXuicuBz34PcBHnCp2ed
         Ezf4bhIy5OBHFEvwI99h3s7ASfzJan5WXs6RxBX/pM1UwOe7nuvq3SgL6w5qKpBz6D
         yfXI2G3H608ZWwm7fSO5Et53IN+M0xInl6MhOJ0o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.208.104]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McYCb-1kWMNW0FYL-00cwOB; Thu, 23
 Jul 2020 20:34:47 +0200
Date:   Thu, 23 Jul 2020 20:34:46 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] 8390: Miscellaneous cleanups
Message-ID: <20200723183446.GA6772@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:r6SVjc3H/QUW2SyiROZm4xUwhXlBmxD/00ve6XNKCBYQQtGJP1J
 xmlmyJ+ejpYXg+bXNoTLvwGKpWNoRO3GRe+dzCWNJrMnO/FIEu8cUXC8jvHD+bnUe9+I3rK
 98H/6prA7nP9OJVm4g9ht6sK/kDFOZfVbD0kreMVnzVzX6Co90/NMna+iaqR3vWJ3IGQYR7
 mneXMxxSjDhDyFLzNkBxg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9xulOsHB2qc=:Fsxe3qKjQjIvQ/IwrnBH10
 IIsmpY30cdl8tyUJBtxrVKbdfeLDBvt4wOWhmLA+dXaf4gN9ZF2H7emk2xIH6FAnSIMj7+/Rw
 rFiiHPBJ8SRoHE2GKlPqHKFdmgISci1vDEzxiyxEAxyfzn5oMj6KM8/TLiLhBe1YmGI3cR681
 jx9A6QgRXFgrDEDGsLVUhnEZSfftVjUaTxzDoCf+XiFMSO/PrO2ht7EPS46uth1Eqts6EaeD6
 Z3Ub9z1HwbMAyrnuXzrpqhI6Vt41efRfKHgIKFVHO+5BoZh3TR+82iPrtyR8HLBQ6ADXKZbRn
 uX6jXuDwF9NlZR/4rDrszQCpb4NCjABkYnNsoB2JMur8V/CID6ZUkY4TeDlijio3832BlRGgm
 sTtD9USXGTWL0OXUnfVkRUacj2V17qaEQu96zpaSyswx9MrPejLMK857LCJGtSdW5rxXsMFQJ
 kvUeXJdl+02RB1X5hDkFAp5mPpLcuDs7FTBv0gNGT+szcaDvCIyXnE5jDRQfjksyxXigkhbOQ
 RR8l0F0BdPw9CseV5dWCpJ+D89ZDs+eE6KWohHBGTmRohJMXTrOb6higzbO31fQef22E4WgQ1
 WRBTOSCrIUogviHTiI+XpREEsmvIpVNDQcessVl8rMEr8ulXxqRhkxC1byFjoo83SiYLHnEJo
 Mnwg9BgTY43Cz9WU4Zyz3NZPOpHuqkpafCoH4BFDp7EBUKc1MDAkNqZFGNjhokdWOEnmozbH2
 3+TOZapQD/8VFWObMFOuZnPPuiYxaXfOFq+QIZHtwGkIXp6KD5tOsuDuLOTjQ7YlBcl2t1d9Y
 C7FcrZ84DAdfINq3VsxTbUYD1pM8E1X+CBovcRtFTpsbZtyJWMfob3DJRUfNL2NLEWn+/Peh2
 eFlsVyzp9OTL5Y8kDSLPRssqPxshQac4Yejx4zxmQZqTiBW1zZYOJD54cAbuXHO/LS6W3H2MJ
 wM380mFbWG6t7HkTeR3t7Nx2JigQM1oLAAfhxRxRjaEBnUsRRkIUYGomYAaZdd87gLIQGEiPO
 4hSbGMZMDUymfsdbgkSAlAo0TB+RwWp2sighuTOfMwn3/1JodohZZ9wreKAlahlCY6XK2NCXl
 lbPsweNDWw0Ed3dCHkpGwwvMelEMjWC2y4B/fuuKTaS7ivEECMgb22zgjj8MLClo6/Um//XyG
 Sw1fYcssZTYQDhO23vpFTyarvi/5iC27aIQTeM5U9owQvVTN4sIvl8CM6LYScjbRXMPUP5RLs
 jW31ivX6aD8dLnXcE
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace version string with MODULE_* macros.

Include necessary librarys.

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

