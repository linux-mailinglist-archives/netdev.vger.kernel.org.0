Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDD6383C7
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 07:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfFGFhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 01:37:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34369 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfFGFhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 01:37:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so538958pfc.1
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 22:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:to;
        bh=Y10NLKD/ZqpLSEJSwJhGmqd2pbOsNMyfYz/FOU0gi+M=;
        b=uNvyY1vp7pd0Gu+b7ZTTP/pVgawMmmM20MeRjDLaFvOjLB9JPticDFT8HYYZL40v8o
         7BKuJKMNf/7Nu6ZK/5T4VcKgzRXv2TrTAsfuVOi0nP5aQePXfP5EThHgtMxOjwU+djDQ
         qexPPskoL5GmFdk6pkE4EY0FffOt0pJmMAMcaURdrG39aly1DAnvfn33zgm57ASr83R4
         pC89J13246T6m+AE5ninYik0/fD4FDPO9eL6uYEYV/vkIg1OOKY6IKoEWgwHMZs8gVID
         bLatOhbhanWtNrQO9upuOqh8iNw2VZ5vlRJb71uyFshE2mGhgeIUJbVpSVrpAmSdR+eG
         26rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:to;
        bh=Y10NLKD/ZqpLSEJSwJhGmqd2pbOsNMyfYz/FOU0gi+M=;
        b=gjiA1VkU13QWWQLWM0tVPEsBtMZ8dp3r/I/xj+HHtgSCupc0IwipSZOIemzdEY/s0r
         9iJEqW69Obx6Ky25ZzKAukdAUPZG28BwUjNQmoNmzFVo6HW/yaBl5vMSqRVC7+34JIGn
         XJYwUZP0cxNdJA3MiVui7+eSEG8DUXkGkXRG2/qJKbiRR0Z2XpCeBdrJeXzgpnm+34We
         12Ye0SGIuPjnTZAgo4kVUMjlumY4ne8Xx7ZFn+bVCQX8uhBC+FVZYJKR0e80r9Jam3E1
         TDT7A5FStAKZSt/aT05+MNm5Md6mZqh59xISqTG2k6iV0wgxW72fWexy3MMps71eUO3x
         K9NQ==
X-Gm-Message-State: APjAAAWufin699sAlLPxBIPQfUuLpLw17AwOtWfpz1wckBTXBnP/XQV6
        ptbeOZ32q5UeScfPRp1vHtUEQium
X-Google-Smtp-Source: APXvYqzocuznyQpMTNzmJ4QmW+0M9Sw9QFsmPxCjZA3gcf3MokEgQK3N9Njo4MBVVh0jBWgI5G87NQ==
X-Received: by 2002:a17:90b:d8a:: with SMTP id bg10mr3630942pjb.92.1559885861950;
        Thu, 06 Jun 2019 22:37:41 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id y185sm1193217pfy.110.2019.06.06.22.37.40
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 06 Jun 2019 22:37:41 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id F09F2360079; Fri,  7 Jun 2019 17:37:36 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     netdev@vger.kernel.org
Cc:     anders.roxell@linaro.org, Michael Schmitz <schmitzmic@gmail.com>,
        andrew@lunn.ch, davem@davemloft.net, sfr@canb.auug.org.au
Subject: [PATCH net v3] net: phy: rename Asix Electronics PHY driver
Date:   Fri,  7 Jun 2019 17:37:34 +1200
Message-Id: <1559885854-15904-1-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20190514105649.512267cd@canb.auug.org.au>
References: <20190514105649.512267cd@canb.auug.org.au>
To:     netdev@vger.kernel-org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Resent to net instead of net-next - may clash with Anders Roxell's patch
series addressing duplicate module names]

Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
introduced a new PHY driver drivers/net/phy/asix.c that causes a module
name conflict with a pre-existiting driver (drivers/net/usb/asix.c).

The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
by that driver via its PHY ID. A rename of the driver looks unproblematic.

Rename PHY driver to ax88796b.c in order to resolve name conflict. 

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
---

Changes from v1:

- merge into single commit (suggested by Andrew Lunn)

Changes from v2:

- use rename flag for diff (suggested by Andrew Lunn)
---
 drivers/net/ethernet/8390/Kconfig      | 2 +-
 drivers/net/phy/Kconfig                | 2 +-
 drivers/net/phy/Makefile               | 2 +-
 drivers/net/phy/{asix.c => ax88796b.c} | 0
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index f2f0264..443b34e 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -49,7 +49,7 @@ config XSURF100
 	tristate "Amiga XSurf 100 AX88796/NE2000 clone support"
 	depends on ZORRO
 	select AX88796
-	select ASIX_PHY
+	select AX88796B_PHY
 	help
 	  This driver is for the Individual Computers X-Surf 100 Ethernet
 	  card (based on the Asix AX88796 chip). If you have such a card,
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index d629971..5496e5c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -253,7 +253,7 @@ config AQUANTIA_PHY
 	---help---
 	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
 
-config ASIX_PHY
+config AX88796B_PHY
 	tristate "Asix PHYs"
 	help
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 27d7f9f..5b5c866 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -52,7 +52,7 @@ ifdef CONFIG_HWMON
 aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_ASIX_PHY)		+= asix.o
+obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
diff --git a/drivers/net/phy/asix.c b/drivers/net/phy/ax88796b.c
similarity index 100%
rename from drivers/net/phy/asix.c
rename to drivers/net/phy/ax88796b.c
-- 
1.9.1

