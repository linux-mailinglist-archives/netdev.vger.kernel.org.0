Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DC440F911
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241492AbhIQN1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:27:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:65396 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240673AbhIQN1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885182; x=1663421182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z5kUp4BlYTrUwk27Td3SSTmyT60LQbedlrzEo2pwH6A=;
  b=iv6koHkDR2tQF5MYUN0i4aVHvvaKwvf2QcO0RCZ8dmOmQMzXojQsmv4R
   ap84ky7z+MgcSY1SXD0zyIT5zC5njYsiqOJgYmsbeK6GrxxpP4+w2HkR0
   yNDm/leO0xKGvkPtoGRFD1QBHJjOit33VJdcNN3kmXweuKeenPHKl3PhX
   X09WiT/OX//2JpTpyYKyQshmTJK+vm7fFSoSN68DM+ZSB45g+tEB2mwTw
   UtQAEaVq81xz30PD+5TRjYIDnESPY9kcvE5cqh1AO5FwxZZ2gexztfuVa
   enVqc/8e4lXznYCiz2AzK8vG6y7Vtcrvz+L1z613IMnQS6X/kVd5h6kwN
   Q==;
IronPort-SDR: 3tD0c1bPxPQ0fqJQ28psQVJ0w1qat2O0pJw2AsllyrwNIcWYX+WROr72mVpyQmqYx+LqswEsjV
 0RdqxFVbvAy5S/WW99cqN07GsRHxU1RTjq6bNnBG8Y672TiL+IVZ+E0eHOUyzPuAfKm/sNWbbd
 M7WCE3NMmnmIPOpZCGyMqkOvFfSbgAiKxJqG58K4NIH4TJkLEJctgdeFQJcBlkxisCSuAyxwlQ
 z+lJ37uCl4KMhRi4Q8FH5gANxS00BXgf+islwcJYZvSa7f6uQF95Q7cM5lc16MW8MNIZ4y8lT6
 gJtBAkGbvQtOSh5laR7BrBw0
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="144542062"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:26:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:26:21 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 17 Sep 2021 06:26:20 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 2/4] net: macb: align for OSSMODE offset
Date:   Fri, 17 Sep 2021 16:26:13 +0300
Message-ID: <20210917132615.16183-3-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210917132615.16183-1-claudiu.beznea@microchip.com>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align for OSSMODE offset.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index d1e0e116b976..c33e98bfa5e8 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -244,7 +244,7 @@
 #define MACB_TZQ_OFFSET		12 /* Transmit zero quantum pause frame */
 #define MACB_TZQ_SIZE		1
 #define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
-#define MACB_OSSMODE_OFFSET 24 /* Enable One Step Synchro Mode */
+#define MACB_OSSMODE_OFFSET	24 /* Enable One Step Synchro Mode */
 #define MACB_OSSMODE_SIZE	1
 
 /* Bitfields in NCFGR */
-- 
2.25.1

