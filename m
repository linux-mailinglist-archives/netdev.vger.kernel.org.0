Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A0E1680A6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgBUOqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:46:32 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40700 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgBUOqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:46:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id t14so2172020wmi.5
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 06:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DgIei8lwFhjFPY7Bp+tiiWlUhaELYCBMIv4p/cERHeE=;
        b=XczP7BzgZ77IXmvKimyGWlXml6McItLga8UZjo1ZXyxx0Vb69iYLa0P1suvuPvHsN8
         CXw6f2OHYiosGT4FCh+qidRNCkarlCKEQigYwwU0sRq8EBPPHNlM+is6twcC0yCfj6tt
         6wM5EVSp0tdGfhFhptB2YKHzlM7bDmAjVMeToew916DsuCepeBKZ6tN6ZC+dkD31Q181
         Sx7SV9/JymPKWiVuPgdis407gpn8yO52Z3BFBlzW6hyg1kNX2r9n0t+p4Np6xlALkJDg
         5SJXSvvxSdWk3KkbECb4WF4wPT7fBFuQIn886FfureDys4bFv+cbvAchadz1BstBcvUf
         DNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DgIei8lwFhjFPY7Bp+tiiWlUhaELYCBMIv4p/cERHeE=;
        b=Im4UWgD7kAW0Or2FTSX1IFy5srTvQ6qkkkQ/niVFjTI1UsVzcnyVXwXGri2zKQBDKw
         oQpCrifX3omYH2/GuFo/ekBTIU7iD7mwHukCS9FcAESTBsFQE5j1e/WCNo4q5ypzu91k
         tcyQrbHFRhXQN2GmDi/BLvbVfPmNo8r90wZL0TTnRJUtDwwmMaiCm1h5HBBUdGhNq3MA
         vqzb9DQw9N72j2eWV6wFWOAO72mtMNaHCWNRgkKmH8f+4QaNaGIWR3ARPjiQAMdJju7H
         u9iF63DGguvxesu5iC/mSHnVMdzJDm/vT2YP2jRq+nZjAomrWRC4POO9vocS7/7fhnc0
         73Gg==
X-Gm-Message-State: APjAAAU1IeK4vvdHazuC5KBi4V9+UWmcjnDSl7tbKaBuiixFVfCc/R+g
        8T0bcvad9jdunsJ9ZQTrTr0=
X-Google-Smtp-Source: APXvYqyNhDkK88kU/YBgyFnqiqM+IALD6scwl4EB1pOLviacqmF98EJLutrri66hmLAL2UzhZhXA7Q==
X-Received: by 2002:a1c:4341:: with SMTP id q62mr4268563wma.107.1582296388436;
        Fri, 21 Feb 2020 06:46:28 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id q1sm4147502wrw.5.2020.02.21.06.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:46:27 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next] enetc: remove "depends on (ARCH_LAYERSCAPE || COMPILE_TEST)"
Date:   Fri, 21 Feb 2020 16:46:24 +0200
Message-Id: <20200221144624.20289-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ARCH_LAYERSCAPE isn't needed for this driver, it builds and
sends/receives traffic without this config option just fine.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index fe942de19597..f86283411f4d 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config FSL_ENETC
 	tristate "ENETC PF driver"
-	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	depends on PCI && PCI_MSI
 	select FSL_ENETC_MDIO
 	select PHYLIB
 	help
@@ -13,7 +13,7 @@ config FSL_ENETC
 
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
-	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	depends on PCI && PCI_MSI
 	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
@@ -23,7 +23,7 @@ config FSL_ENETC_VF
 
 config FSL_ENETC_MDIO
 	tristate "ENETC MDIO driver"
-	depends on PCI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	depends on PCI
 	help
 	  This driver supports NXP ENETC Central MDIO controller as a PCIe
 	  physical function (PF) device.
-- 
2.17.1

