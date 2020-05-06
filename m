Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9221C767E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgEFQcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:32:13 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58200 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgEFQai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:38 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUZtI116946;
        Wed, 6 May 2020 11:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782635;
        bh=uz1sdE8nIH35tiI3ytR7TaghOPo8wemlGtX0o3Goy50=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=JOMWIry6l3HwF9ysIJdMafFl85uLnBNBtvdOl6V4iqt7iOXhQ4VXoG5YtrGAkFKaW
         V0jEvu877dTOOxbIpkKVp/cL6TeVthbN0rx1O5KW/SM2KIDt7XXCNBGg7XNf5nduNk
         lLUhKqth5fAEik7rIJg7A1pYvtIhpUaS6UUMiNEU=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUZnk104700;
        Wed, 6 May 2020 11:30:35 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:34 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:34 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDf119719;
        Wed, 6 May 2020 11:30:34 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 02/13] net: hsr: rename hsr directory to hsr-prp to introduce PRP
Date:   Wed, 6 May 2020 12:30:22 -0400
Message-ID: <20200506163033.3843-3-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As prp driver is expected to re-use code from HSR driver,
rename the directory to net/hsr-prp as a preparatory step.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 MAINTAINERS                         | 2 +-
 net/Kconfig                         | 2 +-
 net/Makefile                        | 2 +-
 net/{hsr => hsr-prp}/Kconfig        | 0
 net/{hsr => hsr-prp}/Makefile       | 0
 net/{hsr => hsr-prp}/hsr_debugfs.c  | 0
 net/{hsr => hsr-prp}/hsr_device.c   | 0
 net/{hsr => hsr-prp}/hsr_device.h   | 0
 net/{hsr => hsr-prp}/hsr_forward.c  | 0
 net/{hsr => hsr-prp}/hsr_forward.h  | 0
 net/{hsr => hsr-prp}/hsr_framereg.c | 0
 net/{hsr => hsr-prp}/hsr_framereg.h | 0
 net/{hsr => hsr-prp}/hsr_main.c     | 0
 net/{hsr => hsr-prp}/hsr_main.h     | 0
 net/{hsr => hsr-prp}/hsr_netlink.c  | 0
 net/{hsr => hsr-prp}/hsr_netlink.h  | 0
 net/{hsr => hsr-prp}/hsr_slave.c    | 0
 net/{hsr => hsr-prp}/hsr_slave.h    | 0
 18 files changed, 3 insertions(+), 3 deletions(-)
 rename net/{hsr => hsr-prp}/Kconfig (100%)
 rename net/{hsr => hsr-prp}/Makefile (100%)
 rename net/{hsr => hsr-prp}/hsr_debugfs.c (100%)
 rename net/{hsr => hsr-prp}/hsr_device.c (100%)
 rename net/{hsr => hsr-prp}/hsr_device.h (100%)
 rename net/{hsr => hsr-prp}/hsr_forward.c (100%)
 rename net/{hsr => hsr-prp}/hsr_forward.h (100%)
 rename net/{hsr => hsr-prp}/hsr_framereg.c (100%)
 rename net/{hsr => hsr-prp}/hsr_framereg.h (100%)
 rename net/{hsr => hsr-prp}/hsr_main.c (100%)
 rename net/{hsr => hsr-prp}/hsr_main.h (100%)
 rename net/{hsr => hsr-prp}/hsr_netlink.c (100%)
 rename net/{hsr => hsr-prp}/hsr_netlink.h (100%)
 rename net/{hsr => hsr-prp}/hsr_slave.c (100%)
 rename net/{hsr => hsr-prp}/hsr_slave.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index db7a6d462dff..94d357145f81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7789,7 +7789,7 @@ F:	drivers/net/usb/hso.c
 HSR NETWORK PROTOCOL
 L:	netdev@vger.kernel.org
 S:	Orphan
-F:	net/hsr/
+F:	net/hsr-prp/
 
 HT16K33 LED CONTROLLER DRIVER
 M:	Robin van der Gracht <robin@protonic.nl>
diff --git a/net/Kconfig b/net/Kconfig
index c5ba2d180c43..20216973d25f 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -239,7 +239,7 @@ source "net/vmw_vsock/Kconfig"
 source "net/netlink/Kconfig"
 source "net/mpls/Kconfig"
 source "net/nsh/Kconfig"
-source "net/hsr/Kconfig"
+source "net/hsr-prp/Kconfig"
 source "net/switchdev/Kconfig"
 source "net/l3mdev/Kconfig"
 source "net/qrtr/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 4f1c6a44f2c3..cab7e4071f42 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -77,7 +77,7 @@ obj-$(CONFIG_OPENVSWITCH)	+= openvswitch/
 obj-$(CONFIG_VSOCKETS)	+= vmw_vsock/
 obj-$(CONFIG_MPLS)		+= mpls/
 obj-$(CONFIG_NET_NSH)		+= nsh/
-obj-$(CONFIG_HSR_PRP)		+= hsr/
+obj-$(CONFIG_HSR_PRP)		+= hsr-prp/
 ifneq ($(CONFIG_NET_SWITCHDEV),)
 obj-y				+= switchdev/
 endif
diff --git a/net/hsr/Kconfig b/net/hsr-prp/Kconfig
similarity index 100%
rename from net/hsr/Kconfig
rename to net/hsr-prp/Kconfig
diff --git a/net/hsr/Makefile b/net/hsr-prp/Makefile
similarity index 100%
rename from net/hsr/Makefile
rename to net/hsr-prp/Makefile
diff --git a/net/hsr/hsr_debugfs.c b/net/hsr-prp/hsr_debugfs.c
similarity index 100%
rename from net/hsr/hsr_debugfs.c
rename to net/hsr-prp/hsr_debugfs.c
diff --git a/net/hsr/hsr_device.c b/net/hsr-prp/hsr_device.c
similarity index 100%
rename from net/hsr/hsr_device.c
rename to net/hsr-prp/hsr_device.c
diff --git a/net/hsr/hsr_device.h b/net/hsr-prp/hsr_device.h
similarity index 100%
rename from net/hsr/hsr_device.h
rename to net/hsr-prp/hsr_device.h
diff --git a/net/hsr/hsr_forward.c b/net/hsr-prp/hsr_forward.c
similarity index 100%
rename from net/hsr/hsr_forward.c
rename to net/hsr-prp/hsr_forward.c
diff --git a/net/hsr/hsr_forward.h b/net/hsr-prp/hsr_forward.h
similarity index 100%
rename from net/hsr/hsr_forward.h
rename to net/hsr-prp/hsr_forward.h
diff --git a/net/hsr/hsr_framereg.c b/net/hsr-prp/hsr_framereg.c
similarity index 100%
rename from net/hsr/hsr_framereg.c
rename to net/hsr-prp/hsr_framereg.c
diff --git a/net/hsr/hsr_framereg.h b/net/hsr-prp/hsr_framereg.h
similarity index 100%
rename from net/hsr/hsr_framereg.h
rename to net/hsr-prp/hsr_framereg.h
diff --git a/net/hsr/hsr_main.c b/net/hsr-prp/hsr_main.c
similarity index 100%
rename from net/hsr/hsr_main.c
rename to net/hsr-prp/hsr_main.c
diff --git a/net/hsr/hsr_main.h b/net/hsr-prp/hsr_main.h
similarity index 100%
rename from net/hsr/hsr_main.h
rename to net/hsr-prp/hsr_main.h
diff --git a/net/hsr/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
similarity index 100%
rename from net/hsr/hsr_netlink.c
rename to net/hsr-prp/hsr_netlink.c
diff --git a/net/hsr/hsr_netlink.h b/net/hsr-prp/hsr_netlink.h
similarity index 100%
rename from net/hsr/hsr_netlink.h
rename to net/hsr-prp/hsr_netlink.h
diff --git a/net/hsr/hsr_slave.c b/net/hsr-prp/hsr_slave.c
similarity index 100%
rename from net/hsr/hsr_slave.c
rename to net/hsr-prp/hsr_slave.c
diff --git a/net/hsr/hsr_slave.h b/net/hsr-prp/hsr_slave.h
similarity index 100%
rename from net/hsr/hsr_slave.h
rename to net/hsr-prp/hsr_slave.h
-- 
2.17.1

