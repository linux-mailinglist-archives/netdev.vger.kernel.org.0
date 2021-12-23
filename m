Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BB947DD2A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346324AbhLWBQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:17 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27388 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346247AbhLWBOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=O3ZizfkdwvjAFL0IllFWvZYbWlz/CPB//NPk13szDnA=;
        b=XTCcYYMiXOfOO8UZtTG2f4+h7DnLy2umVMF+CdELsqaDItfv4WYfrK+AW4TM2ZY7Wiz5
        hc3RNIYrxa5LoCQedwb+b4jaEdcBZJYqBWbR4RQ8qhU01QPzbUblFv4RAINGa0R6UPBXr6
        accQA7xeA371StT45tuT9cpy/iWPU8Cc1EdmRZPoG56rEypnktm6AM3IilMihvm75KNBEl
        IYvFNEPcfLHWEJxS/lqNTlroQHVDUvrDRGPQMaB1D4AHnh2U4hQjkmVZ5g0sJmVEvTrB2J
        bH8gzmyLyFuYSgzbupsRv9Fozsi72vtPL1ZnYAQrsXhBhPwVXMFITMWAGBNyENTg==
Received: by filterdrecv-64fcb979b9-6vbpf with SMTP id filterdrecv-64fcb979b9-6vbpf-1-61C3CD5F-5
        2021-12-23 01:14:07.110980273 +0000 UTC m=+8644638.115216542
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id TsQv68ysQ0ubKGaRoRZ4qw
        Thu, 23 Dec 2021 01:14:06.927 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id E53EE701518; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 45/50] wilc1000: move struct wilc_spi declaration
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-46-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvH9Cvv=2F5ehKJw4467?=
 =?us-ascii?Q?7quhFIAFUnbiUWmbmmTg6+hqXGuYJ3ieEzuxpbm?=
 =?us-ascii?Q?7Je+yt+BbiVHKqzw5OrYGLhvWgBHh5iFYbiOKoa?=
 =?us-ascii?Q?T9Lc3HHGTe5NKhhGGIfgrOKPpZWo0VeMGXrxV9W?=
 =?us-ascii?Q?dVgZMTdlixNLnUgewIND5u0bkSeFVA1Psh2BuO?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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

Just move the structure down by a few lines so that a later patch can
be understood more easily.  No functional change.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 2c2ed4b09efd5..5f73b3d2d2112 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -41,17 +41,6 @@ MODULE_PARM_DESC(enable_crc16,
  */
 #define WILC_SPI_RSP_HDR_EXTRA_DATA	8
 
-struct wilc_spi {
-	bool isinit;		/* true if SPI protocol has been configured */
-	bool probing_crc;	/* true if we're probing chip's CRC config */
-	bool crc7_enabled;	/* true if crc7 is currently enabled */
-	bool crc16_enabled;	/* true if crc16 is currently enabled */
-	struct wilc_gpios {
-		struct gpio_desc *enable;	/* ENABLE GPIO or NULL */
-		struct gpio_desc *reset;	/* RESET GPIO or NULL */
-	} gpios;
-};
-
 static const struct wilc_hif_func wilc_hif_spi;
 
 static int wilc_spi_reset(struct wilc *wilc);
@@ -109,6 +98,17 @@ static int wilc_spi_reset(struct wilc *wilc);
 #define WILC_SPI_COMMAND_STAT_SUCCESS		0
 #define WILC_GET_RESP_HDR_START(h)		(((h) >> 4) & 0xf)
 
+struct wilc_spi {
+	bool isinit;		/* true if SPI protocol has been configured */
+	bool probing_crc;	/* true if we're probing chip's CRC config */
+	bool crc7_enabled;	/* true if crc7 is currently enabled */
+	bool crc16_enabled;	/* true if crc16 is currently enabled */
+	struct wilc_gpios {
+		struct gpio_desc *enable;	/* ENABLE GPIO or NULL */
+		struct gpio_desc *reset;	/* RESET GPIO or NULL */
+	} gpios;
+};
+
 struct wilc_spi_cmd {
 	u8 cmd_type;
 	union {
-- 
2.25.1

