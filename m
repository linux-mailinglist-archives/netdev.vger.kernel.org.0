Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11AD87D0B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 16:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407014AbfHIOo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 10:44:58 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:53237 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHIOo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 10:44:57 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M7ehh-1hwwfj3ddd-0084kM; Fri, 09 Aug 2019 16:44:47 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 10/13] net: lpc-enet: allow compile testing
Date:   Fri,  9 Aug 2019 16:40:36 +0200
Message-Id: <20190809144043.476786-11-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190809144043.476786-1-arnd@arndb.de>
References: <20190809144043.476786-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:RCFvjeuu0t6f1S3c2jeBwyAit2sEKCe3winoluK8TV6k5NAoOUO
 0HaU0UeVh1bfmegCwZ/LxZYBGuVQ+7eXPexo60SZ4/fhiQPq4crzC1qGmIJ/ZR2C10ryy8P
 +3n+Rbdz54ykoqC2GhA3rvwxeJ73S0gOOpx9LpPn+IDp8M7Qct4l2VjHj5K1QVYXDT4/g+1
 gvS4O0eBreeQVVrF4XDYQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vO1wbEWxD8I=:6+u3R4GfutAihcMR0mmONZ
 HP7bzqimvfTuINSG21LTieDz2KUv6efnOlbOGeMn/i80QZwho0TC8mAEWfJXPHxbAKDG5Suh4
 RknDI+FhEgZXDXw+DJvO73m1TbsaSWq2ADaOzaNwMKz7Yz4pLjKnkyjMsAXyqXqCKvpsnzanG
 DgCK/RBBm1OyJ4pOqRVtrly4GqCbLNtqtqww+vCW+wF2UVLD8sfjRbflblvU3XjSkdb8lxMjW
 Od8LUDWA4Q/S4zjmOaM8r+7U6V1V9EUUhMU8ZmL7yMbEansGeMyI01jfvMSd/YY4eJ7Z5j9Mi
 4uew4FuY2ITGLxTVi3UPQQVs+qsi8o/GhBVluXyBAkVbRigHeUHG8DvCn2LGcPkWDbBBtAs++
 cnGw/LGJ1ElnskF8l3d/+52MiyvPTv7yNgPEPXW0G+JcTKe+NE3ZVT/64VkZrjVXr4w57wx5h
 v005eDqI5QkSiqRdjwzeJxgfoXeUsRsJrZtQtZyQOphMoQeJKZsR9dHCZBwq/ocx8x8bC7iGf
 BMS2ffpA+JkheWx0C7rTmkMzyAnIFPMYV/Po522SNNBCx4MlExhIzMw5aWwG5vujNXpeXtrSD
 0WeGsWIjjNnImHwadAS1ScB4KbQd0Xcv7VSH83TABwqk/9+M0AiscaQ6OL6rauWRhnvvucmdq
 hJ4xCU1b0ilijKOsiP6+DOn9UJH6iQOSwn5qWI79J+uZC16GTA08mzqfWm9BYDLFzck/qhkE9
 5iCn+1XwlD62XtNtWSIAMC5X1XYrH4ZPc/M73w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lpc-enet driver can now be built on all platforms, so
allow compile testing as well.

Add one missing header inclusion that is required in some
configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/nxp/Kconfig   | 2 +-
 drivers/net/ethernet/nxp/lpc_eth.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/Kconfig b/drivers/net/ethernet/nxp/Kconfig
index 261f107e2be0..418afb84c84b 100644
--- a/drivers/net/ethernet/nxp/Kconfig
+++ b/drivers/net/ethernet/nxp/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config LPC_ENET
         tristate "NXP ethernet MAC on LPC devices"
-        depends on ARCH_LPC32XX
+        depends on ARCH_LPC32XX || COMPILE_TEST
         select PHYLIB
         help
 	  Say Y or M here if you want to use the NXP ethernet MAC included on
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 96d509c418bf..141571e2ec11 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -14,6 +14,7 @@
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
-- 
2.20.0

