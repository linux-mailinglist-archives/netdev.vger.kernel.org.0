Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5378F465C64
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhLBDHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:07:01 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:39114 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355118AbhLBDEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:04:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uz76wRn_1638414085;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uz76wRn_1638414085)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Dec 2021 11:01:27 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] wireless: Clean up some inconsistent indenting
Date:   Thu,  2 Dec 2021 11:01:16 +0800
Message-Id: <1638414076-53227-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warnings:

drivers/net/wireless/marvell/mwifiex/pcie.c:3376
mwifiex_unregister_dev() warn: inconsistent indenting
drivers/net/wireless/marvell/mwifiex/uap_event.c:285
mwifiex_process_uap_event() warn: inconsistent indenting
drivers/net/wireless/marvell/mwifiex/sta_event.c:797
mwifiex_process_sta_event() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c      | 2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index d5fb294..43bdcbc 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3373,7 +3373,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	} else {
 		mwifiex_dbg(adapter, INFO,
 			    "%s(): calling free_irq()\n", __func__);
-	       free_irq(card->dev->irq, &card->share_irq_ctx);
+		free_irq(card->dev->irq, &card->share_irq_ctx);
 
 		if (card->msi_enable)
 			pci_disable_msi(pdev);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 80e5d44..9a3fbfb 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -794,7 +794,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					 MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
 						adapter->ps_state =
 							PS_STATE_SLEEP;
-					return 0;
+				return 0;
 			}
 		}
 		adapter->ps_state = PS_STATE_AWAKE;
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index 2e25d72..e31de7a 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -282,7 +282,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 					 MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
 						adapter->ps_state =
 							PS_STATE_SLEEP;
-					return 0;
+				return 0;
 			}
 		}
 		adapter->ps_state = PS_STATE_AWAKE;
-- 
1.8.3.1

