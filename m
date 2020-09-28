Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E9227B031
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgI1Oot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:44:49 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42772 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1Oor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:44:47 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SEijx2051840;
        Mon, 28 Sep 2020 09:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601304285;
        bh=4PDDHe8YAddwmsgT2I2nO59jg0/pGqD5FvTJwjbJtIU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Hn0qTFnN0cfTOSFznRbztDwLMp2NmQagsghepLgcTHVzuXFqAAIHH3+ftyUy4DcFU
         lLYzxFCaDKfdHdYHgc80jv7zaRR1Nk5dffXivbZC4hgUm3pIWzm9l+9+Xne6DX12Xw
         UEyVtxQohOz+RLasf6l3qeEJ/+vYj4czJygoaKOY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08SEij8E033260
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 09:44:45 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 09:44:44 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 09:44:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEiiV1097400;
        Mon, 28 Sep 2020 09:44:44 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH ethtool v3 2/3] update UAPI header copies
Date:   Mon, 28 Sep 2020 09:44:02 -0500
Message-ID: <20200928144403.19484-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200928144403.19484-1-dmurphy@ti.com>
References: <20200928144403.19484-1-dmurphy@ti.com>
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

