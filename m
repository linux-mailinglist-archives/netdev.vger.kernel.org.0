Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A1C56CC99
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 06:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiGJEPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 00:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiGJEPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 00:15:33 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CC01057B;
        Sat,  9 Jul 2022 21:15:28 -0700 (PDT)
X-QQ-mid: bizesmtp86t1657426491t4ddiweg
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 12:14:48 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: EBK0Xn0IPVit/hKYiLQnKuTt9ew4nX4f4hP3LG2pxqo7NPEvv6ADGy5L4OI23
        rdSJnjo2c7//D8nnqAknFusMfQxJ5wRauRlU+VwMHbxn0kw7XBF9YUWoyVbDMZQeFluxBtA
        vnBiaP/54XRtioaZhBy+ZOmbVHenxHF5iOFVOTh6cbdxxhyMidu539iPtXrRqxNFle+12zC
        ntpdUh4LyIH46FP3OZH226S5etuwwn7uybr749zaWQSCGPSsK95CGIvb7z81blZ6T2Mhezj
        7zJ5HRnFNLXy4TigTEGVQ+X+UXDLBsK2TJWy4sRHDdtVG1dySx2MrCaJoJDRfYvCzQ4mS83
        RkFSY02I9+09plpSWeFkoRog5IImLlDDONMpnFw
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     stf_xl@wp.pl, helmut.schaa@googlemail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: rt2x00: fix repeated words in comments
Date:   Sun, 10 Jul 2022 12:14:42 +0800
Message-Id: <20220710041442.16177-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'is'.
 Delete the redundant word 'with'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 9f6fc40649be..7927fb10b8a8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -232,7 +232,7 @@ struct link_qual {
 	 * VGC levels
 	 * Hardware driver will tune the VGC level during each call
 	 * to the link_tuner() callback function. This vgc_level is
-	 * is determined based on the link quality statistics like
+	 * determined based on the link quality statistics like
 	 * average RSSI and the false CCA count.
 	 *
 	 * In some cases the drivers need to differentiate between
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index dea5babd30fe..6b1ad4e268d6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -325,7 +325,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 */
 	rt2x00queue_stop_queue(rt2x00dev->rx);
 
-	/* Do not race with with link tuner. */
+	/* Do not race with link tuner. */
 	mutex_lock(&rt2x00dev->conf_mutex);
 
 	/*
-- 
2.36.1

