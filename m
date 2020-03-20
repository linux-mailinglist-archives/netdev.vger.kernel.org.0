Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A94518CBD9
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCTKlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:41:09 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51882 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbgCTKlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:41:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 75F781A0538;
        Fri, 20 Mar 2020 11:41:05 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5026C1A0543;
        Fri, 20 Mar 2020 11:40:59 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2ADB440305;
        Fri, 20 Mar 2020 18:40:50 +0800 (SGT)
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
Subject: [PATCH 4/6] net: mscc: ocelot: redefine PTP pins
Date:   Fri, 20 Mar 2020 18:37:24 +0800
Message-Id: <20200320103726.32559-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320103726.32559-1-yangbo.lu@nxp.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 5 PTP_PINS register groups on Ocelot switch.
Except the one used for TOD operations, there are still
4 register groups for programmable pins. So redefine the
4 programmable pins.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 include/soc/mscc/ocelot.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d9bad70..0ad61e3 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -440,10 +440,11 @@ enum ocelot_regfield {
 	REGFIELD_MAX
 };
 
-enum ocelot_clk_pins {
-	ALT_PPS_PIN	= 1,
-	EXT_CLK_PIN,
-	ALT_LDST_PIN,
+enum ocelot_ptp_pins {
+	PTP_PIN_0,
+	PTP_PIN_1,
+	PTP_PIN_2,
+	PTP_PIN_3,
 	TOD_ACC_PIN
 };
 
-- 
2.7.4

