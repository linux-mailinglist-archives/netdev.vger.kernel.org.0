Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1CF40BFCB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhIOGtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:49:01 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36058 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbhIOGst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 02:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631688451; x=1663224451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=28X2xpvIOdgLnziUslbEgcO+e/pbWRNhpGCAyEVvh0Q=;
  b=kC1YnQqW1CwQmpjjiXCIeRZsCLZFpgTnbChG6bsUDkREqgMEfazl7Y1+
   ymIXe3t7kyhhGaghfpbr6eh1UajX9ZKjhN/Uiu2jrLLU5aUO5nFawHfV1
   SHcubkNyP6IFD/kg6W5glLTDJdTA1gTdDxngGRhOjldCtw8GHteh4Q7rP
   6z4IZHWkCtPhJpRQlowC7GT69f6m2pM7zN0CyHR9P6mKpeqSd51AjgzA6
   c4uSp5VM+/UBdKj+voT6M7JTPp4ARvMvA6U0WOo+dWibOQqyKxL2bX+l3
   hXm0aIlbrlrJEGqiqm50heuXW5GPlhooqztZRxlU5VZVnDEOBlYVez2k9
   w==;
IronPort-SDR: hfWe0cDWsZRkvWBfrU2xgtmXQYpQB+nuC+Y9k580tiRy17HK4gGbk+vowKd/ORJP/p+zbp1Vjo
 m60YRM0E3aNz+WVV6UFhPmkLnHHptyB5trSWFRZJC1LKcpaiLC2vDjMD4xZTvyDpznUHnO6wX3
 MPDgb4RmyaxWK6/vEz0nA5hkFJGCqv53CQtZTHFWQcDph2uxQKg4lBvcz0kuFDggP7cyMlD/Ry
 z/D65NrzIaLO8OcfgEq7R8YFoFg6EN6RvkSKGDI0I6RIjFuTrCeWUa2ID425enLxwC/77gCZUM
 UmSnLaCK46EJgde/0+OOdkHa
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="136592254"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Sep 2021 23:47:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 14 Sep 2021 23:47:28 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 14 Sep 2021 23:47:27 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 2/3] net: macb: align for OSSMODE offset
Date:   Wed, 15 Sep 2021 09:47:20 +0300
Message-ID: <20210915064721.5530-3-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210915064721.5530-1-claudiu.beznea@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align for OSSMODE offset.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
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

