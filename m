Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6E36D453
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbhD1I5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:57:15 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:54951 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237781AbhD1I5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:57:08 -0400
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 569D822258;
        Wed, 28 Apr 2021 10:56:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1619600180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcLBw+PUeYywj+WWxtOGbEGLOKsKoAKsCiaukzdxIbk=;
        b=jDdO3ZebQwHBi0Pbb0OOa+bMFdOWAhcEprk4KDLi5f3TQyQRyUplchsjXfL8lFkIBDUIOu
        6Ea8uklTLl673jq2h3c/P+OCtc3gmaEMkvkpGRkQO6Cc9dQF2yGdMxpfsx+QVRgGi5KnFE
        z47Jb2K/aMoyr0uO6tsmx4HqajM9/nI=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 2/2] MAINTAINERS: move Murali Karicheri to credits
Date:   Wed, 28 Apr 2021 10:56:07 +0200
Message-Id: <20210428085607.32075-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428085607.32075-1-michael@walle.cc>
References: <20210428085607.32075-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

His email bounces with permanent error "550 Invalid recipient". His last
email on the LKML was from 2020-09-09 and he seems to have left TI.

Signed-off-by: Michael Walle <michael@walle.cc>
---
His linked in profiles says that, but I guess that shouldn't be in the
commit message.

 CREDITS     |  5 +++++
 MAINTAINERS | 13 -------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/CREDITS b/CREDITS
index b06760f09c66..7ef7b136e71d 100644
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
index 981413f41bf3..2cd7b40bb15f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14096,13 +14096,6 @@ F:	Documentation/devicetree/bindings/pci/ti-pci.txt
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
@@ -18323,12 +18316,6 @@ S:	Maintained
 F:	sound/soc/codecs/isabelle*
 F:	sound/soc/codecs/lm49453*
 
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

