Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5963556C9A9
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiGINrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGINrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 09:47:33 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C0913F12;
        Sat,  9 Jul 2022 06:47:27 -0700 (PDT)
X-QQ-mid: bizesmtp64t1657374431t5x46dhh
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:47:07 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: rl11S5XfjRO0Z3ufbNJiRL7GACXFatUrhqqduKNHbkPNgUMGU4WQ3vePMdTJ2
        I71azC/QP36YIrBGCZq7cp15wA9gQKrbKcXIZHULdrgrc3Eey9py9Ev8IbI/jK5po4WJNQu
        T/jHr7kqLalgHeztNO56QuuHKTl2FoKnTrJrPY3BvmDtLMWz6CJc+14wxyaMHmaAcZ9AnzL
        TXqWB/JCh8HuibbxFjdjkUUqMsNQEdEGhY328HqPGtKnCL3ZNza2g2s98QuUqGmNAaLrk2X
        FcxZtBWU14XTy/tArOqMMxFrv2/852YvDxAwkeAW78BGFqF1zihLrkNiIrs0eFvlZSMhgf6
        KiIGXABqByXjsq2FthMeC809N9qpRi/oHDcpoYbyXDtGttzMdg=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     stas.yakovlev@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: ipw2x00: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:47:01 +0800
Message-Id: <20220709134701.36081-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ed343d4fb9d5..029dacebe751 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -2584,7 +2584,7 @@ static int ipw_send_retry_limit(struct ipw_priv *priv, u8 slimit, u8 llimit)
  * through a couple of memory mapped registers.
  *
  * The following is a simplified implementation for pulling data out of the
- * the eeprom, along with some helper functions to find information in
+ * eeprom, along with some helper functions to find information in
  * the per device private data's copy of the eeprom.
  *
  * NOTE: To better understand how these functions work (i.e what is a chip
-- 
2.36.1

