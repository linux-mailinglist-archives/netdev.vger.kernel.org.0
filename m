Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371AA46E19F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhLIEsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:48:08 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:11040 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhLIEsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:48:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=H64ILayGbyX7QYCOqwVQMsvPO71U8dZR6YHB4zg8EFs=;
        b=W/H0s5KkRii6Uw7QQR+WAr/CG/MgmONN3LqO1vksSjeAxzJmXX73zOe1E3YGhQ3JTn1p
        FQnIN3Ug6pGJQPYOJU4NQvKgap/bjEkVR6THJ6inymuLdhrw/+jfJEO2l+/HF+dhtblq1k
        HTaC2G2UCZdtq1uQ1dAEJDKaWhT7B98R5AX2LmVkUjfMv4Hhg52wnyfSard4k8AK+WKxJb
        K+HrZLUZHUydnNfANYb+/3aRBlYV2dspU6FbJVqe7rUhX6bkiqhiUUFarjjV7VphFc1wGS
        26bsZ+oMY+gmfAdB1NMSeM8DWAJ/80FaRXn+vWdVU90EclGWu/s9j5Vsl2YPt+sQ==
Received: by filterdrecv-656998cfdd-gwqfx with SMTP id filterdrecv-656998cfdd-gwqfx-1-61B189AB-4
        2021-12-09 04:44:27.295232665 +0000 UTC m=+6758200.701945321
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id cyYv14rSQAiel4p3-86dvA
        Thu, 09 Dec 2021 04:44:26.993 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 761D87002CB; Wed,  8 Dec 2021 21:44:26 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 1/4] wilc1000: Rename SPI driver from "WILC_SPI" to
 "wilc1000_spi"
Date:   Thu, 09 Dec 2021 04:44:27 +0000 (UTC)
Message-Id: <20211209044411.3482259-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209044411.3482259-1-davidm@egauge.net>
References: <20211209044411.3482259-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJwe83XFZyNCdpj6A?=
 =?us-ascii?Q?iavbJ9FB=2FH07BuKFsH9AsM2LPyuRo0GMdSmLegv?=
 =?us-ascii?Q?cRhC3B529egjWPSHs5u9p5=2F4DrFXqR=2F5V864vpi?=
 =?us-ascii?Q?WO14DYlJJP5ioRol3futan7N08biTsx563VUi+Q?=
 =?us-ascii?Q?QpgisEFAt9iTz0R8j7CfEA+IVjQJbbn=2Fj3oa3w?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The name "wilc1000_spi" follows normal Linux conventions and also is
analogous to the SDIO driver, which uses "wilc1000_sdio".

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c  | 4 +++-
 drivers/net/wireless/microchip/wilc1000/wlan.h | 2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 640850f989dd..69c901395329 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -12,6 +12,8 @@
 #include "netdev.h"
 #include "cfg80211.h"
 
+#define SPI_MODALIAS		"wilc1000_spi"
+
 static bool enable_crc7;	/* protect SPI commands with CRC7 */
 module_param(enable_crc7, bool, 0644);
 MODULE_PARM_DESC(enable_crc7,
@@ -205,7 +207,7 @@ MODULE_DEVICE_TABLE(of, wilc_of_match);
 
 static struct spi_driver wilc_spi_driver = {
 	.driver = {
-		.name = MODALIAS,
+		.name = SPI_MODALIAS,
 		.of_match_table = wilc_of_match,
 	},
 	.probe =  wilc_bus_probe,
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 13fde636aa0e..eb7978166d73 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -213,8 +213,6 @@
 #define WILC_RX_BUFF_SIZE	(96 * 1024)
 #define WILC_TX_BUFF_SIZE	(64 * 1024)
 
-#define MODALIAS		"WILC_SPI"
-
 #define NQUEUES			4
 #define AC_BUFFER_SIZE		1000
 
-- 
2.25.1

