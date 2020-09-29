Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D5327D7B6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgI2UKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:10:11 -0400
Received: from mout.gmx.net ([212.227.17.21]:48447 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbgI2UKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601410206;
        bh=BYVGwhdYWRwPgIgX6pe4TbIptFotKQQncbHF2lSJXfE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PNMkN0WG7upY332AU2/z8uj7/JA3Z2P+GGRfP8L4jMwKQ+EaZasKniy2zQ0FAg9fB
         bHFPPJar5N9yyj5gyLTjih6juI9WtQ0v8duGc/EuBWl4mwL0sJukePAGdKiZwop0gb
         o2wjOZ9FKabqF4XXDsHi2C3T/TeUVTY8R7tqlQD0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MAONX-1kFyUv0uDb-00BsBC; Tue, 29 Sep 2020 22:10:06 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net v2 3/4] via-rhine: Eliminate version information
Date:   Tue, 29 Sep 2020 13:09:42 -0700
Message-Id: <20200929200943.3364-4-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929200943.3364-1-kevinbrace@gmx.com>
References: <20200929200943.3364-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:GfygOfKfz/jty/7+rPxFj9bGk4HrKM1zkqE0WGxrExSQsZ5LbMi
 6ZvqoLguKBV2qnkPWtNBLVXMVGtOB9YtvUTvgJf9VJTjHY/pMiea8gBap+/OuuUCi0g2NOC
 CjV7VqaALUUKjfbYZCopDVkEG6S4H1a3GeXAoyOj6dgTOI6ak1pJ7Yc+RDfCfbpjSrxBjzW
 mi4DG2IKX5Ugv9S5K4m3Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CitgprZXY6Q=:2YxQqwwKquEupqpNf/1jkA
 6vhuIygy37PXgjStu31/t6WZCISRO8o/JeS/SpUkXyInSjdYlTK1H4hXXgWuMZffmbz5LTRcP
 GVdJPLJ6JDAm4rZKNFTomKfKYngImtumCINwzd2eRUHDWYj8OVH5XyusX8iAKfZxyOPXkzs5Z
 nE1aaqZnbgXJbS1Wv00IAQN3gqQyqrIoYs8priLKzRxNLRI6RDs0xkhGmqawTkvnCSn7FQKCG
 6/dtnpI36dW5KbLBCrj2YGWc8yBsNVWLGHuJGu93RESlJ55hGmh/1bKNeRkOaMgxTCvuWMhAU
 KFYW5WpZmWYphXlaFug7Ham0KDX/du3vJqVSjP2vaF/VxvaMR8FvSWYKmoI3jNlCKd3o9f8O/
 ol1OolQswYEtqRb0/DLC8S6KKQ3NP2RyOr86SkqspLF6RIi8woVvWiZP4b6ifZsBVPPrTaVSV
 L6p2B6FPHaKyQzD5tR6h6XYd/1awMPoOK0uccO5IqGhQpZlZOGteUleHwdhT4syiJnSXWV935
 2NpaWDPZLsE+E/AqRy1e2WcddH/C4B5yGeryHt+3Yyu3oo/86maFpSGmLv2CF4/zu6Hyf5Nkz
 zxt3vH4kjEkYQmguHNJuppf+buEb9XD8EOOmRUg9m78f8+2qiOweTnYxxF8botDBFRV8rTl0m
 i+bHvKdUBlzKPKvWq0Dwv1BKJPtPtKl/1QZ8VEHKwQ6Hxp1GWUhh4knR18rlNVtUcK7xqYWRb
 +/3m01Coh9XrpPak38RfjR//Yy7VyjuRU1pAWWzYrKa3FPnq71iP51PqRK612pEx/TVdM/MJP
 KR78pO8G+/G/2yqx7XNBplC6c17cLzClLFOLhpgwuOEC3AFxuZHVVVYOu75qpmwg8Ab8PXFUV
 vJHwIJFD2Id2PLNDk8ywXz84vvY6z8P91Nh12yJFzV68pAeuRlQS4e0f6kHZytg3wkFCiHi4W
 XcyxLbZBcnG97SuiQMtdnnhI2RrIn3sRk5cHPOBk5tRAbhjwoqzF0MII/vMzjtQKJN1Sbfvxn
 lEddyl6QX9ubT4JE2uZAGsObapKg0At3QLAYTBMU8t/00DvirrdicJVInyplaHdvXSztvRhyg
 mAfh2iIB73H5O2/FZeR7p82OKOxnPBrbPQkzS92pLxbrfxyBTR7lKE1YN9EAjusx25t6YucWR
 A5GuVY7MkJfaH8okwYcWJrUt7ty1XA1FxYmdvUBwqBovzaLFFBOjYCeQoZKqjG7qhr495227v
 KdkjfdF1uIz3tB5PkX1G8AqbYmO+awdOmxfAgYQ==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 drivers/net/ethernet/via/via-rhine.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index d3a2be2e75d0..8e8cfe110d95 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -32,8 +32,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #define DRV_NAME	"via-rhine"
-#define DRV_VERSION	"1.5.1"
-#define DRV_RELDATE	"2010-10-09"

 #include <linux/types.h>

@@ -117,10 +115,6 @@ static const int multicast_filter_limit =3D 32;
 #include <linux/uaccess.h>
 #include <linux/dmi.h>

-/* These identify the driver base version and may not be removed. */
-static const char version[] =3D
-	"v1.10-LK" DRV_VERSION " " DRV_RELDATE " Written by Donald Becker";
-
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("VIA Rhine PCI Fast Ethernet driver");
 MODULE_LICENSE("GPL");
@@ -1051,11 +1045,6 @@ static int rhine_init_one_pci(struct pci_dev *pdev,
 	u32 quirks =3D 0;
 #endif

-/* when built into the kernel, we only print version if device is found *=
/
-#ifndef MODULE
-	pr_info_once("%s\n", version);
-#endif
-
 	rc =3D pci_enable_device(pdev);
 	if (rc)
 		goto err_out;
@@ -2296,7 +2285,6 @@ static void netdev_get_drvinfo(struct net_device *de=
v, struct ethtool_drvinfo *i
 	struct device *hwdev =3D dev->dev.parent;

 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, dev_name(hwdev), sizeof(info->bus_info));
 }

@@ -2618,9 +2606,6 @@ static int __init rhine_init(void)
 	int ret_pci, ret_platform;

 /* when a module, this is printed whether or not devices are found in pro=
be */
-#ifdef MODULE
-	pr_info("%s\n", version);
-#endif
 	if (dmi_check_system(rhine_dmi_table)) {
 		/* these BIOSes fail at PXE boot if chip is in D3 */
 		avoid_D3 =3D true;
=2D-
2.17.1

