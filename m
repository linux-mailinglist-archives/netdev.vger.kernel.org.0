Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0904C84B0F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 13:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbfHGLwF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Aug 2019 07:52:05 -0400
Received: from skedge04.snt-world.com ([91.208.41.69]:33990 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbfHGLwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 07:52:04 -0400
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 3C1BC67A7C5;
        Wed,  7 Aug 2019 13:44:13 +0200 (CEST)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 7 Aug 2019
 13:44:12 +0200
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Wed, 7 Aug 2019 13:44:12 +0200
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "Schrempf Frieder" <frieder.schrempf@kontron.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: fec: Allow the driver to be built for ARM64 SoCs such as
 i.MX8
Thread-Topic: [PATCH] net: fec: Allow the driver to be built for ARM64 SoCs
 such as i.MX8
Thread-Index: AQHVTRVujOeFcyg/q0+D2PWjkrvdsQ==
Date:   Wed, 7 Aug 2019 11:44:12 +0000
Message-ID: <20190807114332.13312-2-frieder.schrempf@kontron.de>
References: <20190807114332.13312-1-frieder.schrempf@kontron.de>
In-Reply-To: <20190807114332.13312-1-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 3C1BC67A7C5.AEB1D
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: claudiu.manoil@nxp.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, tglx@linutronix.de, yangbo.lu@nxp.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The FEC ethernet controller is used in some ARM64 SoCs such as i.MX8.
To make use of it, append ARM64 to the list of dependencies.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 drivers/net/ethernet/freescale/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 6a7e8993119f..f7f4e073d955 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -23,7 +23,7 @@ if NET_VENDOR_FREESCALE
 config FEC
 	tristate "FEC ethernet controller (of ColdFire and some i.MX CPUs)"
 	depends on (M523x || M527x || M5272 || M528x || M520x || M532x || \
-		   ARCH_MXC || SOC_IMX28 || COMPILE_TEST)
+		   ARCH_MXC || ARM64 || SOC_IMX28 || COMPILE_TEST)
 	default ARCH_MXC || SOC_IMX28 if ARM
 	select PHYLIB
 	imply PTP_1588_CLOCK
-- 
2.17.1
