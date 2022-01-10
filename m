Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D66488E7F
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbiAJB5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbiAJB4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:56:49 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5460C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 17:56:48 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id l8so8440994plt.6
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 17:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qeM1xKz+nlgOhyqQj8VZnOxHsnh32UZq7Sh8ToYZHlc=;
        b=DLPTHdU6MY6RK5cwxCUejZAb4fA6jLz0CazvWI+F6E8uF5IxrqHuJHJUkw9cu71zRt
         awcyH589DaFq54GloehNo3E5G0FpxzLpYaBker47KjV127IXxn3uk6D4MTA50hpUl5gk
         0/CKbp1RP2XuG6eQG08R9uNe+6aRTgpTdRpoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qeM1xKz+nlgOhyqQj8VZnOxHsnh32UZq7Sh8ToYZHlc=;
        b=52n0d2XChjd6S8WoWghhb0kRRfeuawcVqJjM9Vn02AWO79eC/CzCc238gzuNbUr7dD
         A5uORKYKCtldcRN9p4Kaz0GrjGvsqZwqkC7Mxlkdzkq+Bq84UezEjvbDOHfNdQ/90yr5
         4Ehtw6AVYk49VRVoZlmbKpW02XWRfT/7WoqQpvGuOigi6W52lLaf1eeh60RkUZtOSUTx
         SpSwIYX5lrR6mrMGJ5NWeMMv+Sv6hxq2j200Vd1EC4QUvy7LUMpwP9SgccLfP7SYVWkX
         IT0N1TeZWfKyr8b3I1//g3R0hmK/gErtduQqo/VDbbR8W3GJzW7STuahLkjhlfG92rGr
         Zj8Q==
X-Gm-Message-State: AOAM531mxq1oOmVDOHdH2fgxBj9+sK83tVcmBtxxXnbW5cUTuz0MZcXU
        aAmplcg2/Ne+eQStQCR81L2t4Q==
X-Google-Smtp-Source: ABdhPJx8XrwKvrpFjfh3HD9PSh3KX/exCkoH2fPMneOHFrhVHehXe9YuYJoNtYWQQV84hHO1iiLF9A==
X-Received: by 2002:a17:902:7688:b0:148:be1c:18b8 with SMTP id m8-20020a170902768800b00148be1c18b8mr72207942pll.146.1641779808369;
        Sun, 09 Jan 2022 17:56:48 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id rm3sm6909535pjb.8.2022.01.09.17.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 17:56:47 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v6 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
Date:   Sun,  9 Jan 2022 17:56:36 -0800
Message-Id: <20220110015636.245666-9-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110015636.245666-1-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hook up the new driver to configuration and build.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 MAINTAINERS                                   |  6 +++++
 drivers/net/ethernet/Kconfig                  |  1 +
 drivers/net/ethernet/Makefile                 |  1 +
 drivers/net/ethernet/fungible/Kconfig         | 27 +++++++++++++++++++
 drivers/net/ethernet/fungible/Makefile        |  7 +++++
 drivers/net/ethernet/fungible/funeth/Kconfig  | 17 ++++++++++++
 drivers/net/ethernet/fungible/funeth/Makefile | 10 +++++++
 7 files changed, 69 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funeth/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/funeth/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 735e3c7fd66f..0a96b1c7f6c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7854,6 +7854,12 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/fujitsu-tablet.c
 
+FUNGIBLE ETHERNET DRIVERS
+M:	Dimitris Michailidis <dmichail@fungible.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/fungible/
+
 FUSE: FILESYSTEM IN USERSPACE
 M:	Miklos Szeredi <miklos@szeredi.hu>
 L:	linux-fsdevel@vger.kernel.org
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index db3ec4768159..bd4cb9d7c35d 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -78,6 +78,7 @@ source "drivers/net/ethernet/ezchip/Kconfig"
 source "drivers/net/ethernet/faraday/Kconfig"
 source "drivers/net/ethernet/freescale/Kconfig"
 source "drivers/net/ethernet/fujitsu/Kconfig"
+source "drivers/net/ethernet/fungible/Kconfig"
 source "drivers/net/ethernet/google/Kconfig"
 source "drivers/net/ethernet/hisilicon/Kconfig"
 source "drivers/net/ethernet/huawei/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 8a87c1083d1d..8ef43e0c33c0 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_NET_VENDOR_EZCHIP) += ezchip/
 obj-$(CONFIG_NET_VENDOR_FARADAY) += faraday/
 obj-$(CONFIG_NET_VENDOR_FREESCALE) += freescale/
 obj-$(CONFIG_NET_VENDOR_FUJITSU) += fujitsu/
+obj-$(CONFIG_NET_VENDOR_FUNGIBLE) += fungible/
 obj-$(CONFIG_NET_VENDOR_GOOGLE) += google/
 obj-$(CONFIG_NET_VENDOR_HISILICON) += hisilicon/
 obj-$(CONFIG_NET_VENDOR_HUAWEI) += huawei/
diff --git a/drivers/net/ethernet/fungible/Kconfig b/drivers/net/ethernet/fungible/Kconfig
new file mode 100644
index 000000000000..2ff5138d0448
--- /dev/null
+++ b/drivers/net/ethernet/fungible/Kconfig
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Fungible network driver configuration
+#
+
+config NET_VENDOR_FUNGIBLE
+	bool "Fungible devices"
+	default y
+	help
+	  If you have a Fungible network device, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Fungible cards. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_FUNGIBLE
+
+config FUN_CORE
+	tristate
+	help
+	  A service module offering basic common services to Fungible
+	  device drivers.
+
+source "drivers/net/ethernet/fungible/funeth/Kconfig"
+
+endif # NET_VENDOR_FUNGIBLE
diff --git a/drivers/net/ethernet/fungible/Makefile b/drivers/net/ethernet/fungible/Makefile
new file mode 100644
index 000000000000..df759f1585a1
--- /dev/null
+++ b/drivers/net/ethernet/fungible/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+#
+# Makefile for the Fungible network device drivers.
+#
+
+obj-$(CONFIG_FUN_CORE) += funcore/
+obj-$(CONFIG_FUN_ETH) += funeth/
diff --git a/drivers/net/ethernet/fungible/funeth/Kconfig b/drivers/net/ethernet/fungible/funeth/Kconfig
new file mode 100644
index 000000000000..c72ad9386400
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Fungible Ethernet driver configuration
+#
+
+config FUN_ETH
+	tristate "Fungible Ethernet device driver"
+	depends on PCI && PCI_MSI
+	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
+	select NET_DEVLINK
+	select FUN_CORE
+	help
+	  This driver supports the Ethernet functionality of Fungible adapters.
+	  It works with both physical and virtual functions.
+
+	  To compile this driver as a module, choose M here. The module
+          will be called funeth.
diff --git a/drivers/net/ethernet/fungible/funeth/Makefile b/drivers/net/ethernet/fungible/funeth/Makefile
new file mode 100644
index 000000000000..646d69595b4f
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+ccflags-y += -I$(srctree)/$(src)/../funcore -I$(srctree)/$(src)
+
+obj-$(CONFIG_FUN_ETH) += funeth.o
+
+funeth-y := funeth_main.o funeth_rx.o funeth_tx.o funeth_devlink.o \
+	    funeth_ethtool.o
+
+funeth-$(CONFIG_TLS_DEVICE) += funeth_ktls.o
-- 
2.25.1

