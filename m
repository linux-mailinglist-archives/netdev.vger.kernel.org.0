Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCA1454F0D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbhKQVK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240859AbhKQVJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:09:13 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3728AC06120D;
        Wed, 17 Nov 2021 13:05:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x6so5311765edr.5;
        Wed, 17 Nov 2021 13:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L938AV2svNhJ44M4NS66rIX9RBK2nZqb7TB6m2Fm34I=;
        b=dGjmyaV9yH3K8V2sEENSRmPlMc4TNnbvRiNwpeE4U0PB/E42rgrVf7VYzjFtliOU9C
         bw0I4MVz0qlg4XXoSP1C7VBvaSF9bllc9eoaY6LBrcOjVquZ7q7UsUocC/jVZnnWrjSx
         JGea8g2vE+CmlemVHpUk+lOUJKrCV4UX4+kX/WXeZSsOHQiQxKHXpQAyAk/de7JsduQG
         kaDX8G0Z0rnJEwOgRREDMf442QFNI+6BtgIGSY2YmAuGNeZ+vPbTV/HKjHdR11jMQcx/
         +PZyMO1DNSugHV1Bly7WPZZOS6/CvWD8QxBHYxXS/gCjZcywAKz3Xc5yqBxXTRhJOdGe
         mWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L938AV2svNhJ44M4NS66rIX9RBK2nZqb7TB6m2Fm34I=;
        b=c5eXQai4yTgdKWHHKwzRJ7nNnTlzH0C4/0icZOUKRw66TIIDa5a8O9LSOQOwV1Qyng
         WzjXNmqWaw+bTYVQXCdXV/QHR77t+M9J6FtsQJsoiKRyYemxoGgrJ8Og/jNCIrb5PtPM
         hzBALkoTFgLUpA6sr29pQju6n6E5QnW988e3v+uf9J2S44lvdTpwPCGvV9rj/YqcZQuy
         pnyfAeGPW+ulXiU+5KCZHvu+gKP2qCmuAPqANMz5I9bnJqkoNMtHsM5Mn67kxK6ze5nO
         DaYrrprdO4xttNACUQeX4e4RggCCJcwnhWILDD8YI+x6bSBNHrSYDlx4kaw6G29xFNGm
         FK7g==
X-Gm-Message-State: AOAM531m1SOJgee2UGOvkz5YLjp10YmiwYMrA7fZfyj0/CO/yIwl2N6u
        rfmdc0wQi8FxH5hkbdzRwufY2edGy6I=
X-Google-Smtp-Source: ABdhPJyVzEqGlFPi7cyjP2XowEPldSFN3EpA41/t690Ij8BbOis/bjn7+e0U7FxAC6hheVEI8NFbSA==
X-Received: by 2002:a17:906:82c5:: with SMTP id a5mr26243217ejy.127.1637183134711;
        Wed, 17 Nov 2021 13:05:34 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:34 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 17/19] net: dsa: qca8k: move qca8k to qca dir
Date:   Wed, 17 Nov 2021 22:04:49 +0100
Message-Id: <20211117210451.26415-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k driver to qca dir in preparation for code split of common
code from specific code.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/Kconfig           | 8 --------
 drivers/net/dsa/Makefile          | 1 -
 drivers/net/dsa/qca/Kconfig       | 9 +++++++++
 drivers/net/dsa/qca/Makefile      | 1 +
 drivers/net/dsa/{ => qca}/qca8k.c | 0
 drivers/net/dsa/{ => qca}/qca8k.h | 0
 6 files changed, 10 insertions(+), 9 deletions(-)
 rename drivers/net/dsa/{ => qca}/qca8k.c (100%)
 rename drivers/net/dsa/{ => qca}/qca8k.h (100%)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 7b1457a6e327..19587620ef14 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -59,14 +59,6 @@ source "drivers/net/dsa/sja1105/Kconfig"
 
 source "drivers/net/dsa/xrs700x/Kconfig"
 
-config NET_DSA_QCA8K
-	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
-	select NET_DSA_TAG_QCA
-	select REGMAP
-	help
-	  This enables support for the Qualcomm Atheros QCA8K Ethernet
-	  switch chips.
-
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI Ethernet switch family support"
 	select NET_DSA_TAG_RTL4_A
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 8da1569a34e6..6c6fbb14eff8 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -8,7 +8,6 @@ endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
-obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
 realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
index 13b7e679b8b5..7186f036678c 100644
--- a/drivers/net/dsa/qca/Kconfig
+++ b/drivers/net/dsa/qca/Kconfig
@@ -7,3 +7,12 @@ config NET_DSA_AR9331
 	help
 	  This enables support for the Qualcomm Atheros AR9331 built-in Ethernet
 	  switch.
+
+config NET_DSA_QCA8K
+	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
+	depends on NET_DSA
+	select NET_DSA_TAG_QCA
+	select REGMAP
+	help
+	  This enables support for the Qualcomm Atheros QCA8K Ethernet
+	  switch chips.
\ No newline at end of file
diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 274022319066..16f84acf0246 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
+obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
\ No newline at end of file
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca/qca8k.c
similarity index 100%
rename from drivers/net/dsa/qca8k.c
rename to drivers/net/dsa/qca/qca8k.c
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca/qca8k.h
similarity index 100%
rename from drivers/net/dsa/qca8k.h
rename to drivers/net/dsa/qca/qca8k.h
-- 
2.32.0

