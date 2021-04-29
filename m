Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EB436E797
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 11:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbhD2JG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 05:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbhD2JGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 05:06:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7DFC06138B;
        Thu, 29 Apr 2021 02:05:38 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BC47D22249;
        Thu, 29 Apr 2021 11:05:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1619687134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGlBK//hIFViSV+qyHZn068w4JR3qL4cxAnd+11uHFk=;
        b=kAaxmuhNpJejecjCHqTyLe/l5gZaCeCVDnjvGr+ZyLwHWs5PpM6zLNyQ2bAaq5D/oYYna0
        zDglfQyMiECfZlryFGZb8xhdcE4Tx20OQO8BLJxWF5LTjpn5PSuW30ymZPuGKVSDY9ptxE
        2d2JIclBCHK2t+Y6pApo46V8PirBmmo=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Michael Walle <michael@walle.cc>
Subject: [PATCH net v2 2/2] MAINTAINERS: move Murali Karicheri to credits
Date:   Thu, 29 Apr 2021 11:05:21 +0200
Message-Id: <20210429090521.554-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429090521.554-1-michael@walle.cc>
References: <20210429090521.554-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

His email bounces with permanent error "550 Invalid recipient". His last
email was from 2020-09-09 on the LKML and he seems to have left TI.

Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v1:
 - rebased to net

 CREDITS     |  5 +++++
 MAINTAINERS | 13 -------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/CREDITS b/CREDITS
index cef83b958cbe..80d096dbf262 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1874,6 +1874,11 @@ S: Krosenska' 543
 S: 181 00 Praha 8
 S: Czech Republic
 
+N: Murali Karicheri
+E: m-karicheri2@ti.com
+D: Keystone NetCP driver
+D: Keystone PCIe host controller driver
+
 N: Jan "Yenya" Kasprzak
 E: kas@fi.muni.cz
 D: Author of the COSA/SRP sync serial board driver.
diff --git a/MAINTAINERS b/MAINTAINERS
index 04f4a2116b35..e264e63f09c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13780,13 +13780,6 @@ F:	Documentation/devicetree/bindings/pci/ti-pci.txt
 F:	drivers/pci/controller/cadence/pci-j721e.c
 F:	drivers/pci/controller/dwc/pci-dra7xx.c
 
-PCI DRIVER FOR TI KEYSTONE
-M:	Murali Karicheri <m-karicheri2@ti.com>
-L:	linux-pci@vger.kernel.org
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	drivers/pci/controller/dwc/pci-keystone.c
-
 PCI DRIVER FOR V3 SEMICONDUCTOR V360EPC
 M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-pci@vger.kernel.org
@@ -17974,12 +17967,6 @@ F:	drivers/power/supply/lp8788-charger.c
 F:	drivers/regulator/lp8788-*.c
 F:	include/linux/mfd/lp8788*.h
 
-TI NETCP ETHERNET DRIVER
-M:	Murali Karicheri <m-karicheri2@ti.com>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/ethernet/ti/netcp*
-
 TI PCM3060 ASoC CODEC DRIVER
 M:	Kirill Marinushkin <kmarinushkin@birdec.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
2.20.1

