Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2473C7CD65
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfGaT70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:59:26 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:44131 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfGaT7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:59:25 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M60HD-1hzmMa1S2t-007WQU; Wed, 31 Jul 2019 21:58:51 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] watchdog: pnx4008_wdt: allow compile-testing
Date:   Wed, 31 Jul 2019 21:56:45 +0200
Message-Id: <20190731195713.3150463-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:9yUamtnf2TIEri8xToHi2HP0bNeq2o/bMYTbPMW/vg0ZGIzRlVZ
 urODGWophHwj2kamStrDk3IZ7zSpCTCX5t4sMnfLpIcxs9wmaHvSSDo+bNqZzwGdy5UYYR9
 e0Y4xZ9D2FHcXdSkv/oCMKk2yUHxFcbeBUTKPhHw7pX66dppRRr1TufSUvH+5QEVggfcs8Z
 6oMvoTmm1FtZK8+0oW/wg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:klU/jRvYVso=:PV42qGK6cAWld/OjjZOFZ1
 zGMpHnObvYTQrIpVxVh6vZz9g4QDbJfZyHjqGV0KF05shbnRpDiouYuKEl+7RdTrLXQfq6OUE
 3iGxoYpQ3HBCtxT3DWbqWWLjzoj7ATK7zwEPmUzqzrqjdRYzJszfhNAkX2yI5YVG3GmeBz7yz
 9RDZV4vuOZy22/0qG81uXna7kipOrx0kN2s5FikkKplOevEqJ5tLa4h47HbmthkC8KXX7zbgY
 pV8i3+EJvVZRSaDGhptWUul3T1jBR2b7BO9BWPZmbjlxSVhOASs7lsyj+eHcuceoXxIJkpoby
 7jns4DopRRhHvLL9wlR9ZhyFDkRbdO10LDreatLj5aTesK9vI3kXEjSfxlHluovG3Sm6QKYRF
 SsmRaoxRh7iE87EyMCkT62zLke0BDT/e7RQv10/x5qVYHLOpOHtZfMVaeh4dcS60FyguGq1Fd
 3ZzSA/0jVKSDYqdV5txFh/RZ4uwjHFxMsqS451Oz7732M9uDtqR/CDUNN+MlQKcXzJwbAGxMp
 dN/OymhwlkaxUFRN1E+sGRFvkVQ9MSPkAOc6KurE8C1j+ohNT7WqJgapbfcUiNpDiXpiDxUyg
 OGFd2tSeUG/ZzHAGSoQjoTxD08FMp+mpwJN3uF+xl+fiNsAqYJ3JEC4ZzIkQYYCsZHSoOrZhj
 +/i+eKY1tw950RZ1mXRqF+97hNuHJvmGGLacoaAjuOdNIxSHQXg065UQavatOfy/ovlux6y0Y
 LxMR5+Bjw4qB9h6YFWvXSUmP198oby4rMT3eBg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing that prevents building this driver on other
platforms is the mach/hardware.h include, which is not actually
used here at all, so remove the line and allow CONFIG_COMPILE_TEST.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/watchdog/Kconfig       | 2 +-
 drivers/watchdog/pnx4008_wdt.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 8188963a405b..a45f9e3e442b 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -551,7 +551,7 @@ config OMAP_WATCHDOG
 
 config PNX4008_WATCHDOG
 	tristate "LPC32XX Watchdog"
-	depends on ARCH_LPC32XX
+	depends on ARCH_LPC32XX || COMPILE_TEST
 	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 7b446b696f2b..e0ea133c1690 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -30,7 +30,6 @@
 #include <linux/of.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
-#include <mach/hardware.h>
 
 /* WatchDog Timer - Chapter 23 Page 207 */
 
-- 
2.20.0

