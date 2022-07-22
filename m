Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6768B57DC9B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiGVInl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiGVIng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:43:36 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ED389F079;
        Fri, 22 Jul 2022 01:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=JfuV2
        PZM6BGmJIiT2+wkgWDCU9AtRs4V53MwLY+f49k=; b=YKSJ4z97X5jZ/zqKK1+0n
        25jIdrrYyfzNBjCtBDcodZ4Bgbt2S0bbcBPJJjH7+sD6KLRY8XM1Or5wfnl+lFRf
        XuZahAoyp7CjPJArUM4eYVZdJkZ7hYHFec6mR27IQ0p1G4idFHISDetpXiRV3T3e
        GFEQ5nnMLVB8679vn4uHv0=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp5 (Coremail) with SMTP id HdxpCgDH1jrXYtpiqkKtPg--.6895S2;
        Fri, 22 Jul 2022 16:42:01 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     imitsyanko@quantenna.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, geomatsi@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] qtnfmac: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:41:58 +0800
Message-Id: <20220722084158.75647-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgDH1jrXYtpiqkKtPg--.6895S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr13KFyUuw15XF47Jwb_yoWkGwc_Wr
        W0q3WfAw40v34qkrs3ZFy8XryIkryjyrnagwn3t3y293s8AayfGrZYyF1Duw1xu3W3GFn8
        W398X3W3J34YqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCE_KPUUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRxlGZFc7YxCqBgAAsP
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
 drivers/net/wireless/quantenna/qtnfmac/qlink.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 2dda4c5d7427..674461fa7fb3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1721,8 +1721,8 @@ enum qlink_chan_stat {
  * @time_on: amount of time radio operated on that channel.
  * @time_tx: amount of time radio spent transmitting on the channel.
  * @time_rx: amount of time radio spent receiving on the channel.
- * @cca_busy: amount of time the the primary channel was busy.
- * @cca_busy_ext: amount of time the the secondary channel was busy.
+ * @cca_busy: amount of time the primary channel was busy.
+ * @cca_busy_ext: amount of time the secondary channel was busy.
  * @time_scan: amount of radio spent scanning on the channel.
  * @chan_noise: channel noise.
  */
-- 
2.25.1

