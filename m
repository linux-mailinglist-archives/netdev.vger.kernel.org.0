Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B265ED370
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 14:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfKCNPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 08:15:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43525 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfKCNPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 08:15:44 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iRFjG-0000uQ-Tu; Sun, 03 Nov 2019 13:15:39 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: remove unused macros
Date:   Sun,  3 Nov 2019 13:15:38 +0000
Message-Id: <20191103131538.25234-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The macros HCLGE_MPF_ENBALE and HCLGEVF_MPF_ENBALE are defined but never
used.  I was going to fix the spelling mistake "ENBALE" -> "ENABLE" but
found these macros are not used, so they can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9e59f0e074be..0b20b42f8ceb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -226,8 +226,6 @@ enum hclge_evt_cause {
 	HCLGE_VECTOR0_EVENT_OTHER,
 };
 
-#define HCLGE_MPF_ENBALE 1
-
 enum HCLGE_MAC_SPEED {
 	HCLGE_MAC_SPEED_UNKNOWN = 0,		/* unknown */
 	HCLGE_MAC_SPEED_10M	= 10,		/* 10 Mbps */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index ef86155de9e0..2f4c81bf4169 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -150,8 +150,6 @@ enum hclgevf_states {
 	HCLGEVF_STATE_CMD_DISABLE,
 };
 
-#define HCLGEVF_MPF_ENBALE 1
-
 struct hclgevf_mac {
 	u8 media_type;
 	u8 module_type;
-- 
2.20.1

