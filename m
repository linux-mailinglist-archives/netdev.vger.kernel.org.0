Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BDE564BF7
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 05:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiGDDAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 23:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGDDAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 23:00:12 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4CCA3888;
        Sun,  3 Jul 2022 20:00:10 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 313B71E80CD1;
        Mon,  4 Jul 2022 10:58:17 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gsuYchCKhMV0; Mon,  4 Jul 2022 10:58:14 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id D42631E80CCF;
        Mon,  4 Jul 2022 10:58:13 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] ath11k: Fix typo in comments
Date:   Mon,  4 Jul 2022 11:00:04 +0800
Message-Id: <20220704030004.16484-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a typo(isn't') in comments.
It maybe 'isn't' instead of 'isn't''.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/net/wireless/ath/ath11k/hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index 1dba7b9e0bda..bda71ab5a1f2 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1165,7 +1165,7 @@ void ath11k_hal_srng_shadow_update_hp_tp(struct ath11k_base *ab,
 	lockdep_assert_held(&srng->lock);
 
 	/* check whether the ring is emptry. Update the shadow
-	 * HP only when then ring isn't' empty.
+	 * HP only when then ring isn't empty.
 	 */
 	if (srng->ring_dir == HAL_SRNG_DIR_SRC &&
 	    *srng->u.src_ring.tp_addr != srng->u.src_ring.hp)
-- 
2.34.1

