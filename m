Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9E5399B29
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFCHB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:26 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46910 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFCHBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 45735219EA; Thu,  3 Jun 2021 14:52:30 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 05/16] mctp: Add initial driver infrastructure
Date:   Thu,  3 Jun 2021 14:52:07 +0800
Message-Id: <20210603065218.570867-6-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an empty drivers/net/mctp/, for future interface drivers.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 MAINTAINERS                 | 1 +
 drivers/net/Kconfig         | 2 ++
 drivers/net/Makefile        | 1 +
 drivers/net/mctp/Kconfig    | 8 ++++++++
 drivers/net/mctp/Makefile   | 0
 include/uapi/linux/if_arp.h | 1 +
 6 files changed, 13 insertions(+)
 create mode 100644 drivers/net/mctp/Kconfig
 create mode 100644 drivers/net/mctp/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 262451188c46..d3114697601b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10874,6 +10874,7 @@ M:	Jeremy Kerr <jk@codeconstruct.com.au>
 M:	Matt Johnston <matt@codeconstruct.com.au>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/mctp/
 F:	include/net/mctp.h
 F:	net/mctp/
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 74dc8e249faa..fd4f15709d5d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -482,6 +482,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/mctp/Kconfig"
+
 source "drivers/net/mdio/Kconfig"
 
 source "drivers/net/pcs/Kconfig"
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 7ffd2d03efaf..a48a664605a3 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_WAN) += wan/
 obj-$(CONFIG_WLAN) += wireless/
 obj-$(CONFIG_IEEE802154) += ieee802154/
 obj-$(CONFIG_WWAN) += wwan/
+obj-$(CONFIG_MCTP) += mctp/
 
 obj-$(CONFIG_VMXNET3) += vmxnet3/
 obj-$(CONFIG_XEN_NETDEV_FRONTEND) += xen-netfront.o
diff --git a/drivers/net/mctp/Kconfig b/drivers/net/mctp/Kconfig
new file mode 100644
index 000000000000..d8f966cedc89
--- /dev/null
+++ b/drivers/net/mctp/Kconfig
@@ -0,0 +1,8 @@
+
+if MCTP
+
+menu "MCTP Device Drivers"
+
+endmenu
+
+endif
diff --git a/drivers/net/mctp/Makefile b/drivers/net/mctp/Makefile
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/include/uapi/linux/if_arp.h b/include/uapi/linux/if_arp.h
index c3cc5a9e5eaf..4783af9fe520 100644
--- a/include/uapi/linux/if_arp.h
+++ b/include/uapi/linux/if_arp.h
@@ -54,6 +54,7 @@
 #define ARPHRD_X25	271		/* CCITT X.25			*/
 #define ARPHRD_HWX25	272		/* Boards with X.25 in firmware	*/
 #define ARPHRD_CAN	280		/* Controller Area Network      */
+#define ARPHRD_MCTP	290
 #define ARPHRD_PPP	512
 #define ARPHRD_CISCO	513		/* Cisco HDLC	 		*/
 #define ARPHRD_HDLC	ARPHRD_CISCO
-- 
2.30.2

