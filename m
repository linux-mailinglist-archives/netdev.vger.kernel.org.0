Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4E7476CA5
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhLPI67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:58:59 -0500
Received: from smtpbg126.qq.com ([106.55.201.22]:44013 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235249AbhLPI6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 03:58:40 -0500
X-QQ-mid: bizesmtp53t1639645085tcm67hr0
Received: from wangx.lan (unknown [218.88.124.63])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 16 Dec 2021 16:57:58 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: ZHWZeLXy+8ff8fu/Fx+nUICP+lBEnQne9UGNjNsge/rmbsQCgZfett1MDtfcE
        HmnXUxW3Kog+ifBaTXPPwxSVm1H906TF0LjkmpsnsffthqXo4sFS/ZKtB4KFBZ6ywQlZx81
        bGj/Bh1WUVAmemZdEqtsUgL5OvHQIr/5U1C6L56CQH3d0KBTEGBY12AOELyFVvce9CbfmeT
        OqHdRHyAD7AEpj4BkYs0cJ2XusiIJHw3WOGSFeMqtM+JSYEd2dgRhnx85UMVZ5idVc1Slwy
        zXo+odghONTCbSZC9ZEZx4n1NE6QgUvXzyIxo1pXgJkVwBIiN5K94Yj+M5puS3wK7LRGeIa
        3dL2Os4k7lTjiuiqLIsDM4ZwBNLH0p+W5eU/Pc8
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     kvalo@codeaurora.org
Cc:     luciano.coelho@intel.com, davem@davemloft.net, kuba@kernel.org,
        ilan.peer@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] iwlwifi: Fix syntax errors in comments
Date:   Thu, 16 Dec 2021 16:57:56 +0800
Message-Id: <20211216085756.11053-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 14602d6d6699..119910d9bc6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1954,7 +1954,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
 		}
 		/* Sending RX interrupt require many steps to be done in the
-		 * the device:
+		 * device:
 		 * 1- write interrupt to current index in ICT table.
 		 * 2- dma RX frame.
 		 * 3- update RX shared data to indicate last write index.
-- 
2.20.1

