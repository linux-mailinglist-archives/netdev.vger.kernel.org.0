Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72C256C985
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 15:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGIN1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 09:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIN13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 09:27:29 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6049205D0;
        Sat,  9 Jul 2022 06:27:24 -0700 (PDT)
X-QQ-mid: bizesmtp80t1657373207tp7gr7ih
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:26:44 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: d4yYKjzTqZmxUWS7nWLcpHG+HSH/OW35E9vz4fDMob+7RLy4Mv8tni9DbyKOO
        KlRv3Sph6z2TCcX9g0fBTpLZtShvkEP+AqRs0E4tPhl3zjXbnbCH1hfZyl1plnqbPHpATOO
        VZ688TTa875QVbDPFc2rgbSzWvr4S3DWovQuexTsQcyrBhha4vcDxEuF8ewk9MuPnoc0dAS
        jLpHdKv8P9Jzwd8g9tyKbD55VReVG2wmzwXwJCWU27tXOiFTbBzpCA4tH0Q4c2Wrm7r6bKq
        ZXYIAAgXCL3+boRcKwwkrzk0YbeCbUBM/LzLG25mS6o7cDwhhtavsSxpqS4qe/jl+PB7w6C
        LQdy9OpeUrREtzfsir5nQPMnDn9349krPyaiCm6Fx2ishF5i1TYdM9IPKTn3A==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     simon@thekelleys.org.uk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: atmel: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:26:37 +0800
Message-Id: <20220709132637.16717-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'long'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/atmel/atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 35c2e798d98b..0361c8eb2008 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -3353,7 +3353,7 @@ static void atmel_management_frame(struct atmel_private *priv,
 					priv->beacons_this_sec++;
 					atmel_smooth_qual(priv);
 					if (priv->last_beacon_timestamp) {
-						/* Note truncate this to 32 bits - kernel can't divide a long long */
+						/* Note truncate this to 32 bits - kernel can't divide a long */
 						u32 beacon_delay = timestamp - priv->last_beacon_timestamp;
 						int beacons = beacon_delay / (beacon_interval * 1000);
 						if (beacons > 1)
-- 
2.36.1


