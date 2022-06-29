Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C7756005E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiF2Mrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiF2Mrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:47:40 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFFF34B90;
        Wed, 29 Jun 2022 05:47:35 -0700 (PDT)
X-QQ-mid: bizesmtp63t1656506829tlw7dycw
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 20:47:03 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: RYjIlEO/dKXILS7Mwcomwvt2ApQtkrmK3AaeRV+X+OLEjCkJyJNqY1tdtsa2Q
        3Nisxl78mkHVZOQm13r82wxPKJxsi7rrd5IZjEvkMAI4kVslOHxR7seJ4W7SBlxzkkeSwhF
        8qckGamynQCYkxp/9fmRGg2aCWjOfp4Swe6IkGQqxptHN9okyO9HXiuIob3+g+3IlaF9vbw
        dc9w0hv6JKhkeQ66ECQ+igwhap+ZjI1MNF08tXTKtbnwkUdSQoTRP07msaBSrLJ7ctQ02GO
        pgHjvFqAblgN3ytZ8+w/1nC1xXJ/+mR45GxwS9jnN4ICM2ph7fk5EudK2EmxOLJAYwNbFKm
        MmTjPHTdP1ecsjHmps=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.ne, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/freescale:fix repeated words in comments
Date:   Wed, 29 Jun 2022 20:46:56 +0800
Message-Id: <20220629124656.55575-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,RCVD_IN_VALIDITY_RPBL,
        RDNS_DYNAMIC,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'next'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 7d49c28215f3..ba0d8c613ac9 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -544,7 +544,7 @@ static irqreturn_t fec_pps_interrupt(int irq, void *dev_id)
 
 	val = readl(fep->hwp + FEC_TCSR(channel));
 	if (val & FEC_T_TF_MASK) {
-		/* Write the next next compare(not the next according the spec)
+		/* Write the next compare(not the next according the spec)
 		 * value to the register
 		 */
 		writel(fep->next_counter, fep->hwp + FEC_TCCR(channel));
-- 
2.36.1

