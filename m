Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA258FBDA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiHKMDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiHKMDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:03:05 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2327795687;
        Thu, 11 Aug 2022 05:03:02 -0700 (PDT)
X-QQ-mid: bizesmtp66t1660219366tkwinvgj
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 20:02:44 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: TLc+rbMvNaH0DMiRPoBlTJzrhKh//0s/PBbtYYXGTWlp7cPz+/IBq4vG7L6hS
        rZGeOJcFwH1KNPzYCb3r64YPTODM5Giga33wKOScHqy/jv9X7zq4Rt/WBQWksqtDksxSziB
        8638X4vC/8D2RngfpEHHwiZWHe5+z7Gi/Lqh7WUBnWlaisBknHwnfjLOOB6G6TxNTUavxuX
        DquAJKtgFbB6DsOQ8iN1ngiadTYoOj2RFgHDfxeJ7al2865AWHGycWMikaupeLKZJx4n6NN
        /EA0IFlfXRen/x/QwZC0R2NZuR8qiRbvQTsn5arU+hzVpfECcynC64F70vj51+ADtwdBxfs
        SCymIECrWitNus28fIJDullcZNQGAM4a6SxtIA2s7cCa30iw0uQ4CGf4AH12C1TMSw/THWq
        zOSfM/R4Mok=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kvalo@kernel.org
Cc:     toke@toke.dk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] ath9k: Fix comment typo
Date:   Thu, 11 Aug 2022 20:02:38 +0800
Message-Id: <20220811120238.11493-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index dc0e5ea25673..090ff0600c81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1744,7 +1744,7 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
-	/* on AR93xx and newer, count = 0 will make the the chip send
+	/* on AR93xx and newer, count = 0 will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
-- 
2.36.1

