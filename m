Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D571A1B0002
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgDTCvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:51:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50324 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgDTCvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:51:17 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id ACE6B2006AC;
        Mon, 20 Apr 2020 04:51:14 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BF9982006A7;
        Mon, 20 Apr 2020 04:51:09 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9CF94402E6;
        Mon, 20 Apr 2020 10:51:03 +0800 (SGT)
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
Subject: [v3, 3/7] net: mscc: ocelot: redefine PTP pins
Date:   Mon, 20 Apr 2020 10:46:47 +0800
Message-Id: <20200420024651.47353-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420024651.47353-1-yangbo.lu@nxp.com>
References: <20200420024651.47353-1-yangbo.lu@nxp.com>
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
Changes for v2:
	- None.
Changes for v3:
	- None.
---
 include/soc/mscc/ocelot.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fe301794..a588b6372 100644
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

