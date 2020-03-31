Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797E0198B0A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 06:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgCaEPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 00:15:09 -0400
Received: from inva020.nxp.com ([92.121.34.13]:39262 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgCaEPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 00:15:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4D1DA1A07D3;
        Tue, 31 Mar 2020 06:15:06 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1A28D1A07DB;
        Tue, 31 Mar 2020 06:15:00 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 409D5402B1;
        Tue, 31 Mar 2020 12:14:52 +0800 (SGT)
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
Subject: [v2, 3/7] net: mscc: ocelot: redefine PTP pins
Date:   Tue, 31 Mar 2020 12:11:09 +0800
Message-Id: <20200331041113.15873-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331041113.15873-1-yangbo.lu@nxp.com>
References: <20200331041113.15873-1-yangbo.lu@nxp.com>
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

