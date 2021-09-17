Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7AD40F90F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbhIQN1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:27:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:65396 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240304AbhIQN1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885180; x=1663421180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZteNawmbv4Sdi7TpSPUuM6H+rJRUfsfKEZUdQxRqnqk=;
  b=ZW686R7Q5jCdvkQ9wOzgehFwOGNogV/bBpB7M98RmWfcmIkJGwKOr8Ve
   /XNXeZFITvoc3c8TXJkqX3X8b1EXSPsDPUK+pPVdKUZsuzpPu1STzXnGk
   vOtI3JS5M8HbcQ8qjxQMuu89wENtFSb65bAbPVx39dBrqaQI/M2D1nWT+
   nYhSBGzGfZDSzSpsKhqvAIUtcs7Qvbq/UfPDsSTYOxDqkFj+dTbNUim26
   fsGNpOZ1XvfLecCJ0grNll4NE16OjRmhSCfTN9S+EFd7SUsHMiTmLuOhv
   XvY9N1rthro7KbXFUKQI1yalbTtjyEdXtQOdFrdxroA4SHAG6xR1uwFtc
   A==;
IronPort-SDR: oBM2aeHs9Eaereman5ljk3Gp2QD7DasB+Okndk/TBxyZG/lmpTtdrll7cqFtBK4Zbq4CIJ8inT
 klkzR6YZbM1Dmw2qjylhLcrsZkgmzJpyZwl+59cKpqBoDUkSWErbJXrWq4q8sPvRYB2T9N0Cdr
 Gdqs+icqH5HtJA6fPd50VV8E+t51GDT5p1qkr7BvvxAaVZfef7umprA1r93bkr02RFCt6qxfhb
 jIjpg3w7w4GLMfFGEZcBp8Kd9NI/GOB2iI4Z1hNsNZEmPVNimWLwbT9tRETdwDWGj2wTDTiK2c
 AsVuWWZP2b2e8v0QWtgPsDK7
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="144542055"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:26:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:26:20 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 17 Sep 2021 06:26:18 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 1/4] net: macb: add description for SRTSM
Date:   Fri, 17 Sep 2021 16:26:12 +0300
Message-ID: <20210917132615.16183-2-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210917132615.16183-1-claudiu.beznea@microchip.com>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for SRTSM bit.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
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

