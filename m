Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C21481E43
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbhL3Qj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241346AbhL3QjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 11:39:24 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D87C061751
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 8so21848975pgc.10
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zO29Jk29w8X1VLicqiI4JcanC564KoC0YLQc2X0UZWg=;
        b=LuitDoKOp2BiUKKVSk9a9amLUvUaEnB/px+aJq8ECQf+DUWZtd6lkB0zeGeyeR/W5I
         EZnS//nhX0kbgzMWcnBjOkTTrN7c+SNkjSKVnrhjhlJ3yfEyxS6gsBSCGIV/Am+T8BmP
         4Dh0oVe97YcquO8BX+dYb3ByXgJVBgS6Z8YBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zO29Jk29w8X1VLicqiI4JcanC564KoC0YLQc2X0UZWg=;
        b=2ukclhz7X0SzAgNXVNpZtBsQ4n3TdBzCDmyg596R8w5RPfTRbf+L1HRY4oduRBKRF9
         xZD3v++OWguYJLvtr/td0K9A/G+mPcb0TQ0hJy034I/kQfoYsajdUR0u3CECrWFnTyK8
         XAz00ASYcHFINufQZfceJt4RTGooFV2OLwprcLF1mm1T4mhjVg1mec+kqWrfDjSFSXPZ
         WYEbrUJeCXELBUB/cSCkGXwjOIj+CSzqd1WDXgcCqnnHrd7+S70y+cbXuvqTiU0aDufy
         Bwny+rJCm/2QPb2oAQVlJX151mOCxR77NCjLkYFdlJ2dLSYndCDgL/dKp0EQjlDVF2sh
         tujA==
X-Gm-Message-State: AOAM532EVz1O9T5gBXDJj/GwXhUFI9avog/mbBWHLk9Dma+sD+vLjrEF
        pcgTyNIN6g9VKtDgSBI/bSE7CYe/Motspw==
X-Google-Smtp-Source: ABdhPJwdSldxWL+4R4ZgLZgcBHo5mhYpUJ2gs1D4EGs9VTnNnNXarLtLPCKPQt1duHQQSB2noy2lqA==
X-Received: by 2002:a63:3e44:: with SMTP id l65mr1354525pga.554.1640882363005;
        Thu, 30 Dec 2021 08:39:23 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l6sm27390380pfu.63.2021.12.30.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:39:22 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
Date:   Thu, 30 Dec 2021 08:39:09 -0800
Message-Id: <20211230163909.160269-9-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230163909.160269-1-dmichail@fungible.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
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
index 4d479b554361..400979e47a1e 100644
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
index 000000000000..132945164da9
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+subdir-ccflags-y += -I$(src)/../funcore -I$(src)
+
+obj-$(CONFIG_FUN_ETH) += funeth.o
+
+funeth-y := funeth_main.o funeth_rx.o funeth_tx.o funeth_devlink.o \
+	    funeth_ethtool.o
+
+funeth-$(CONFIG_TLS_DEVICE) += funeth_ktls.o
-- 
2.25.1

