Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBA940BFC9
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhIOGsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:48:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49620 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbhIOGsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 02:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631688447; x=1663224447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UmuYHmTNzTwV9vDkC+JmtSlR6vT++q3IeQidaO5JmMI=;
  b=KdTX6XIelU9BB2xyd3zAHgDw5D0x6lk2sIpTTbv+kQjh301MoaubGope
   ymBEk7l3+9OLZy0qbhMT5/fKLfriMHzobWolV0wvMVbpWkLdj34lFaXKh
   Q8IVpicXp60Ovtb0RK/HAfdGSYkS1gowuSFsTlA6Lsc9a1+eSXLWt2Wgo
   UfcDAx1BB4cy9Bq/fjO5QU4ZSDbEeQaM28SfKaJXnfX95CG1bddlzznXj
   myOMlXireJcC3QvCEUvCPjqIbu+vCZGzk/AQNPpD2hg6ikq8HWe5UjgKB
   cyUZI3Z5gYLz+oIHuNZeK7Jp24mUhlb2d/jkpRwWbMJc0rW6r+eq+Zu61
   g==;
IronPort-SDR: cm6QVWT4dt9j3CP/W7akqYSj5u0VYlBLTP+xLyIbBchSP1q1WS1b3iuulNnHFtoKjag9jkr0Xh
 DWuJu6nQzRTS5xgSgq8qZhShRcd12s7+0ANmFmMrFJiF5TpnBEusBf+cvxg1XiH2guWHnB6gON
 JPWZbkSDnyAj7UGLEEVU0zRHk8nIO44tw++CinEZH3r28QTJol51AWNaq1huE7XFpCKpObJXuY
 LYPxnJi9GTIbh3ejo3I/tMMqHmG7MpXUSV13S/Z/bNrdAlGo1Vj5YRbN6+C2kvC8tiO1vZq5dj
 0lGPjRYcQTNhKbUvU9JahAvf
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="136018094"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Sep 2021 23:47:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 14 Sep 2021 23:47:26 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 14 Sep 2021 23:47:25 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 1/3] net: macb: add description for SRTSM
Date:   Wed, 15 Sep 2021 09:47:19 +0300
Message-ID: <20210915064721.5530-2-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210915064721.5530-1-claudiu.beznea@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for SRTSM bit.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index d8d87213697c..d1e0e116b976 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -243,7 +243,7 @@
 #define MACB_NCR_TPF_SIZE	1
 #define MACB_TZQ_OFFSET		12 /* Transmit zero quantum pause frame */
 #define MACB_TZQ_SIZE		1
-#define MACB_SRTSM_OFFSET	15
+#define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
 #define MACB_OSSMODE_OFFSET 24 /* Enable One Step Synchro Mode */
 #define MACB_OSSMODE_SIZE	1
 
-- 
2.25.1

