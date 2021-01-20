Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C82FCB3F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbhATHCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:02:51 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:48301 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbhATHCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:02:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UMIoGpQ_1611126113;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMIoGpQ_1611126113)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 15:01:58 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     rajur@chelsio.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] cxgb4: Assign boolean values to a bool variable
Date:   Wed, 20 Jan 2021 15:01:51 +0800
Message-Id: <1611126111-22079-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:5142:2-33:
WARNING: Assignment of 0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a..b95c008 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5139,7 +5139,7 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 
 	/* See if FW supports FW_FILTER2 work request */
 	if (is_t4(adap->params.chip)) {
-		adap->params.filter2_wr_support = 0;
+		adap->params.filter2_wr_support = false;
 	} else {
 		params[0] = FW_PARAM_DEV(FILTER2_WR);
 		ret = t4_query_params(adap, adap->mbox, adap->pf, 0,
-- 
1.8.3.1

