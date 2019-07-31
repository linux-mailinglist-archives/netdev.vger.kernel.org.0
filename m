Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352847CDA2
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfGaUCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:02:22 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:34959 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbfGaUCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:02:21 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MxHLs-1iGtlI0h4q-00xYiP; Wed, 31 Jul 2019 22:01:44 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] net: lpc-enet: allow compile testing
Date:   Wed, 31 Jul 2019 21:56:50 +0200
Message-Id: <20190731195713.3150463-9-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:bQO/P7oE1AasL5WRFX8A8Iw79gwR2TUWl5KOlZaoQbsLC6qyZ3M
 BqjvpoU3FzeJMaTmEyNZPpDYQsGf01s7vM6mqVbCCqYpR+VH9U3/oy0xO+7d/XqDKrZRScs
 GKPYEfqcPhZKIPwd/VF2tMUAfS5j7EliScirqrFjPu8WusX9n+IWZVIlecysf5C6EC7vNJV
 Y+CHXjmLXL6XBHVmlDthg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wgW8X3aAw54=:zzSiZhm815Ou/Nwd6C9iLM
 8pGGZZ1MNm+TJLjXzf5qAu/AU+nMBlFA8b+4jZEd1w9esMERStkBfjfc+hCYa4fvIVEGyrOY2
 rgAgi4qKEbp8czy7oAIf1f62ZHCdRci+Wx21+sgjylY/7OD9KMwh40IjuRtC5KIsOflIjss63
 2ny0LZzhcyhnMnSt66utWr6Py58xbkNhZYgxX2fejPF1IW734b5FLedEO34kKt0kqZ34JFOZ/
 4Z9/Fm+TrnN/g7EYnNC+2gnV2/4enSXdUzsNIjPjlEBCPO7VXfFNakW/QZyqg0UYxAPidEN5m
 Qe/0NFGLMWfxGncHijKtiX9XzMqxxIvf4XjGxVSLEdlD0BDUGu6FqiQIKfhMyn1DFk/XbO42/
 82qzSohrF3yATVgLCrSAPqK+sOmomtx5lPd/+rmUhLqAGXFnbsnxQHaIV7OvOmqqTUnETc/kh
 3ef4BZR3TAwakr2EnP5cY3eC0FhJHywe0TBxiRLevIBN2c1CtinvaCxz28sGp28S2SmUbCAy/
 pjkz8586/aXzkaJyvAr5gL76CGT5dDNUXYo1CwW7GWieGTW/P17EAWnJp0jjMSqrYgvBN5WCN
 G2/uUtYXb8yOdCkFMBF+8CWo7hzKHuPjy+oBnUA6SrOJ61t3gb/hYLmoL3OjWWdbIGDPA5w1L
 YaPT07myPbkUcnsdWJKaPeeBaeioX1lnNsZZ+RfngtM1BGJ16w3IOWLg+EgehEy8bW7ev6L/k
 iaOINOy1fT0MDbzlmDp6pVMc3XbEFBEzxk9HUA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lpc-enet driver can now be built on all platforms, so
allow compile testing as well.

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
index 0893b77c385d..34fdf2100772 100644
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

