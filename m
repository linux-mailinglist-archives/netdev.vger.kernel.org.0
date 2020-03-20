Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BBD18CBE2
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgCTKlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:41:04 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51760 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgCTKlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:41:02 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 94B451A056A;
        Fri, 20 Mar 2020 11:41:01 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6F5341A0551;
        Fri, 20 Mar 2020 11:40:55 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id AA975402FC;
        Fri, 20 Mar 2020 18:40:47 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH 2/6] MAINTAINERS: add entry for Microsemi Ocelot PTP driver
Date:   Fri, 20 Mar 2020 18:37:22 +0800
Message-Id: <20200320103726.32559-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320103726.32559-1-yangbo.lu@nxp.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entry for Microsemi Ocelot PTP driver.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5dbee41..8da6fc1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11115,6 +11115,15 @@ S:	Supported
 F:	drivers/net/ethernet/mscc/
 F:	include/soc/mscc/ocelot*
 
+MICROSEMI OCELOT PTP CLOCK DRIVER
+M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
+M:	Yangbo Lu <yangbo.lu@nxp.com>
+M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/ptp/ptp_ocelot.c
+F:	include/soc/mscc/ptp_ocelot.h
+
 MICROSOFT SURFACE PRO 3 BUTTON DRIVER
 M:	Chen Yu <yu.c.chen@intel.com>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.7.4

