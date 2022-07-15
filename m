Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EAC578302
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiGRNDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiGRNDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:03:16 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68156BF53;
        Mon, 18 Jul 2022 06:03:11 -0700 (PDT)
X-QQ-mid: bizesmtp68t1658149373tewd1ljf
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 21:02:50 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000000
X-QQ-FEAT: MbRi8nWEoaZu3SJ8oD7aDH5D4190Q3e+iCesuFvAspGXqe/14tFEbxCAUGyN6
        LBqqJdZkl3XiGuWP+qip5Wg8JaamUv/zn5NWIkvBlmU+On9A6c1gjED4mprB+sNWbL7Ei+d
        8HLUqzLAfYbZ6y1ADftEBykpze43svum1QubwSXCGIOJAHU1xe/UgNDkyMrE5NNeMA/un2g
        WuyhOELLBZOH+8nrLYc9/bliCaB5dP2qdZlmrXnxjmxl3Xxov3LGKRkmjV/oXBzgQEUWiDE
        xgRBAyXy/hwSTBZKWcy7sRDIuCg6MRyzZNZTVsdzqNpmkqk7lWphNbwky4ax5SN6BzA/4W7
        NGFsQNAEC9bsxFcmOarCh9XV2NvdGG6sI+TO9+6N2g+yTahwdn0ROSaeN6bwABQ+3gd5Oca
        AVjcGGIzBAQ=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     ganapathi017@gmail.com
Cc:     amitkarwar@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] mwifiex: Fix comment typo
Date:   Fri, 15 Jul 2022 13:00:53 +0800
Message-Id: <20220715050053.24382-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in line 1540, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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
2.35.1

