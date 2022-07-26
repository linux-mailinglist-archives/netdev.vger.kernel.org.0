Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5858D580A0C
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 05:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbiGZDiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 23:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiGZDis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 23:38:48 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DC0327FFB;
        Mon, 25 Jul 2022 20:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=8O/tq
        JsxyJeQtUCLEx0AXW4yjYk92BjxsCSHv3FeVbI=; b=XNN1852+NORDtyEukDseK
        fKFRYmon7LUkv1vKz+ICGPB9x8xh4QqfgHnZViIFAkHv28qYgClqQbXERk90Z7x4
        qMtGkgvPIPGJetb4atSoeFsuxLBOM8lXU3o1COMpdnlMU4HO8UQl75JLRAgoRmM5
        BMKCdkeWt5aFsHyMux//3I=
Received: from localhost.localdomain (unknown [43.134.191.38])
        by smtp9 (Coremail) with SMTP id DcCowAAnLq6jYd9iljkbSg--.4713S2;
        Tue, 26 Jul 2022 11:38:13 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     toke@toke.dk, kvalo@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH v2] wireless: ath: Fix typo 'the the' in comment
Date:   Tue, 26 Jul 2022 11:38:10 +0800
Message-Id: <20220726033810.18168-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAAnLq6jYd9iljkbSg--.4713S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFyDArWUZr17WF1UGr4kJFb_yoWDJrX_Wr
        WUWa1fJw40yw1F9r45CF47Z3ySk3s5WFZ7ZwsFqrZxWa1xZrWDZ3yDWrWUury7uw4xCF9x
        Cr1kJ3WxA3WqqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRWq2tUUUUUU==
X-Originating-IP: [43.134.191.38]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRwZKZFc7Y0E-wwAAsd
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
v2: UPdate patch based on ath.git
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
2.25.1

