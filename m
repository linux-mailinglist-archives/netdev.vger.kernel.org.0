Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6417C57DC8F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiGVIkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiGVIkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:40:53 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E1DB1A824;
        Fri, 22 Jul 2022 01:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=6EDb4
        G5ADHDuyZVUrVAFI+dIgqEy+uJADjwZ1OKxSMg=; b=AO9j6XFLpM6Q89EvPRLbu
        4NqxNnPcpoI64UhR0HQ7BLDfnr4rXnywIgNAeReQeUzvFu1HlM64LfK19YWu6uoC
        sMElOzaafwRJ8UtwBE3GwfAFiwGezdUJFJQPF7J47YZkPAjB7885TJN30sCHbuA/
        K/gjSg3QvLzrUOZ4HaDAuo=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp4 (Coremail) with SMTP id HNxpCgB3HOxFYtpiVZl4QA--.20992S2;
        Fri, 22 Jul 2022 16:39:36 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] mwifiex: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:39:32 +0800
Message-Id: <20220722083932.75388-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgB3HOxFYtpiVZl4QA--.20992S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr13KF45WF48Gw1xKrg_yoWfJFgEgw
        1xuws3KrsxAwn7Kr4UZrWavr1vk3y8XFs7CFsxtrWfW3y0va9xurn5Zrs5J3s0kwsIvFnx
        Jrn8JFy7Jay5WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCE_KPUUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRwhGZFc7YxCiyAAAsY
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
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 1a886978ed5d..b8dc3b5c9ad9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1537,7 +1537,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 /*
  * This function decode sdio aggreation pkt.
  *
- * Based on the the data block size and pkt_len,
+ * Based on the data block size and pkt_len,
  * skb data will be decoded to few packets.
  */
 static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
-- 
2.25.1

