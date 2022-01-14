Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A678148EAD0
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbiANNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:35:55 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:59040 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236727AbiANNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 08:35:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1pArLL_1642167345;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1pArLL_1642167345)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 21:35:52 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: Remove unused function declaration
Date:   Fri, 14 Jan 2022 21:35:45 +0800
Message-Id: <1642167345-77338-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The declaration of smc_wr_tx_dismiss_slots() is unused.
So remove it.

Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_wr.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 47512cc..a54e90a 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -125,10 +125,6 @@ int smc_wr_tx_v2_send(struct smc_link *link,
 int smc_wr_tx_send_wait(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
 			unsigned long timeout);
 void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context);
-void smc_wr_tx_dismiss_slots(struct smc_link *lnk, u8 wr_rx_hdr_type,
-			     smc_wr_tx_filter filter,
-			     smc_wr_tx_dismisser dismisser,
-			     unsigned long data);
 void smc_wr_tx_wait_no_pending_sends(struct smc_link *link);
 
 int smc_wr_rx_register_handler(struct smc_wr_rx_handler *handler);
-- 
1.8.3.1

