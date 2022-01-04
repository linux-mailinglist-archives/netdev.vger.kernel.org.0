Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EA9483C0B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiADGrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiADGrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:47:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3427C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:47:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so2177852pjp.0
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BuZrFangnAeGBItoPZfFYDBCPbpS6oDICVdp9y2b1/0=;
        b=TI6o7IYwjhMAoH8BYq+lTyCLauS5VsKXS5G4j2bWn7RywaMiBWvlmibr3U/U0o/gYy
         laCwoBOONoGxKM9dFk7Xfk0fgh3KTyOFXibUYTWptz38c6eOPF3/WreAiK6852bclFCd
         mlu2X7+Npw3qiJx0PLDtKcHoYRy+ZQY5c7wGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BuZrFangnAeGBItoPZfFYDBCPbpS6oDICVdp9y2b1/0=;
        b=CINZnXnKhrdQkCHWg2Unf/BGSK/opr06QR0Q5WogBuAnfNpotmD+CcCSkE7uwvsTJs
         OjY9JDhNwtedFpOZ+zLZdwpKpsps24cl7q5sx4pBY+4sarWMMVNDcWqNBX++kO8Ql3z9
         VGStzDLn8u+C3azzIoRkumOF4OnAMDQhqy73vratEt6+kqrDlY/+w9Y9VnwVnSVFUQ4D
         yi6Pxfy49rWYzEfBJAn5lU4shtFG8LzQIpKDjcSrWF70IBqMCo0r9I+II9A48zai+X9m
         9w3tFaWncdk1Jo873LOjNU16tDthRTCru+TEcR+0QDnY4A4T5rWg+TkRC21NRffxlp2z
         UBgw==
X-Gm-Message-State: AOAM530Yr9uB8REgJETY7qn/bnklULrrYu12Bt+R0AGR8RONkE1NbqKE
        e2lZdLYzEvBBsnOrDzslOHjFLFy3YczMSg==
X-Google-Smtp-Source: ABdhPJwXop/KiA1WyHlmNgNTyXEntGSqO3a/PrldLbSiCwliVeSTskB/NDaX0v+KbdDaZ3CskF1lwQ==
X-Received: by 2002:a17:90b:3891:: with SMTP id mu17mr59807561pjb.242.1641278830480;
        Mon, 03 Jan 2022 22:47:10 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id 93sm40424090pjo.26.2022.01.03.22.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:47:10 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v4 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
Date:   Mon,  3 Jan 2022 22:46:57 -0800
Message-Id: <20220104064657.2095041-9-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104064657.2095041-1-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
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
index 0b5fdb517c76..850f762df779 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7853,6 +7853,12 @@ L:	platform-driver-x86@vger.kernel.org
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

