Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0468277816
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgIXR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 13:56:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39492 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgIXR4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 13:56:19 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08OHuH7h005726;
        Thu, 24 Sep 2020 12:56:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600970177;
        bh=4PDDHe8YAddwmsgT2I2nO59jg0/pGqD5FvTJwjbJtIU=;
        h=From:To:CC:Subject:Date;
        b=AtMD4OvJdrO55i5RqAi5ibwUw3lQeYAx45VfO6idQBlsCx+Lip1fZAopaV1uxGBva
         bKnSHgiXixpiry0hqvnEUFAeqnGOY7RFbhC8Ay8xDK7tjzRG4fM9GELX4tLMaeO3/Q
         GxqCllN7M9d9iKPT71HmA0nMoyfaxV7KodXucOHc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08OHuHbM054963
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 12:56:17 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 24
 Sep 2020 12:56:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 24 Sep 2020 12:56:16 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08OHuG0c051545;
        Thu, 24 Sep 2020 12:56:16 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH ethtool v2 1/2] update UAPI header copies
Date:   Thu, 24 Sep 2020 12:56:09 -0500
Message-ID: <20200924175610.22381-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 55f13311785c

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 uapi/linux/ethtool.h         |  2 ++
 uapi/linux/ethtool_netlink.h | 19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 847ccd0b1fce..052689bcc90c 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1615,6 +1615,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT = 87,
 	ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT	 = 88,
 	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
+	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
+	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index cebdb52e6a05..c022883cdb22 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -79,6 +79,7 @@ enum {
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
+	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -91,9 +92,12 @@ enum {
 #define ETHTOOL_FLAG_COMPACT_BITSETS	(1 << 0)
 /* provide optional reply for SET or ACT requests */
 #define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
+/* request statistics, if supported by the driver */
+#define ETHTOOL_FLAG_STATS		(1 << 2)
 
 #define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
-			  ETHTOOL_FLAG_OMIT_REPLY)
+			  ETHTOOL_FLAG_OMIT_REPLY | \
+			  ETHTOOL_FLAG_STATS)
 
 enum {
 	ETHTOOL_A_HEADER_UNSPEC,
@@ -376,12 +380,25 @@ enum {
 	ETHTOOL_A_PAUSE_AUTONEG,			/* u8 */
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
+	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
 	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_PAUSE_STAT_UNSPEC,
+	ETHTOOL_A_PAUSE_STAT_PAD,
+
+	ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
+	ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
+
+	/* add new constants above here */
+	__ETHTOOL_A_PAUSE_STAT_CNT,
+	ETHTOOL_A_PAUSE_STAT_MAX = (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
+};
+
 /* EEE */
 
 enum {
-- 
2.28.0.585.ge1cfff676549

