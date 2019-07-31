Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605C87CD70
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbfGaUAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:00:09 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:34817 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaUAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:00:08 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mo6WJ-1ihbS32Skt-00pgri; Wed, 31 Jul 2019 21:59:24 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] serial: lpc32xx_hs: allow compile-testing
Date:   Wed, 31 Jul 2019 21:56:46 +0200
Message-Id: <20190731195713.3150463-5-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:FgQXWHBg8JwiLqFUWJflxqSabbAP8JCw6bQWgIJ0su4bbGS+nRK
 0kUqcrfqJfWTc10p+TkInneDvk18LhtSmF5HyllYlbCgM6NIe2ax1LYFHpLJUPtftTqVfHY
 LT8kDYequkxI5Lbi1wDejhDPoHyerdsb7xvK8eoFciT5n0YokYA8TO/pNPuR18xFg1KR67C
 ohO68gbXz9QjaHkKemAWQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9zXs2NceyDg=:N9NkeMAe628aOvT2TIb/xb
 PWR1SJ+Jn/xnW7MzNM80nxT0HFhj0IH9hRJO7YpP3nO1nzkVmMIuBW8MfuEjzvna4yYuw/NrN
 Xdgphu9Ry1EE8S2qqTWWjhUDz545qonpnL1oJEOm/Hr5xdROH7H2WeLZJpQCtnxVxQ8Wh5hqY
 nU5h7ie3lhbyDKd1IWAhOejvlfNepdIKHF1pDyXuAnlgQUVMople/U1mBLmt0NoxdvF/6Mcer
 8tH++YghoErbfk2yDkMI2HYS3ZeTBZRbPO2ZX3iDLbDarWtrQvzDqEVMyG8Y6EUmP0b4qyFjN
 PwLeOGDMs4lB0+cFHs97ILEblNeqmOzk14Ox/7D0BPmUuVaxPFJuCwl6Uh4bTDBi8TlEtcnsF
 qKLNzlhsV4qv+KM3IKY+XI8kOnePo6K95sFf+QHEEqVuX8oAp63/X9aVVWFpNTIHW6Va2GEm5
 rWdpIHl6eOJoB+r3wgOJizmqDyGRWK5+D7E47X3Bac211kWk2upDTiYsqftygCXSHNH6sKjd1
 AQJoQbtKh20u9ADOyh9GW2ko1Az6jrllCmcnPqt1XDs9uHtH/ygJG0Gn7GWFngWKjOpGMOcj0
 CGy7SaTzt3GuiyKDn9gHxUEXhOjsb4aCnEX5bWyLhHzocWJcLWujmLb48VzchIKZJgwZWu7lf
 UkS5FB881G9+x8p0cLogi/HR4km/FxXNvseAnDybpGdJN33PMpOBWTcW0/y9Clg0W5ImRhw22
 ktX8KghGubpyC+mg1c2YtkHDcs3NhemMbCnviw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing that prevents building this driver on other
platforms is the mach/hardware.h include, which is not actually
used here at all, so remove the line and allow CONFIG_COMPILE_TEST.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/serial/Kconfig      | 3 ++-
 drivers/tty/serial/lpc32xx_hs.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 3083dbae35f7..518aac902e4b 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -739,7 +739,8 @@ config SERIAL_PNX8XXX_CONSOLE
 
 config SERIAL_HS_LPC32XX
 	tristate "LPC32XX high speed serial port support"
-	depends on ARCH_LPC32XX && OF
+	depends on ARCH_LPC32XX || COMPILE_TEST
+	depends on OF
 	select SERIAL_CORE
 	help
 	  Support for the LPC32XX high speed serial ports (up to 900kbps).
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index f4e27d0ad947..7f14cd8fac47 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -25,8 +25,6 @@
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
-#include <mach/platform.h>
-#include <mach/hardware.h>
 
 /*
  * High Speed UART register offsets
-- 
2.20.0

