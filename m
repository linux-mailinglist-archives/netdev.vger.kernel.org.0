Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D56B5782FD
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiGRNCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiGRNCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:02:50 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D8E7651;
        Mon, 18 Jul 2022 06:02:45 -0700 (PDT)
X-QQ-mid: bizesmtp65t1658149342tf1ppvus
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 21:02:20 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: lp8jUtqYSiDoO+QpwGkaUbeYv7jk2c0USJBu0RONduT+RmdoJZTKcvfPP8aSV
        r8ckczkkKAv7rPwWQzC/SeYx6pk772LNvF3NkViHVnVodYGKWNEqt1AfaqKVznwo9WHhizb
        wAN2AJ8pok8WApRmBnLPRTC1DoQlF6xZQVuTyvM1hbs/hRqaoivvi9GI0RxUZwWdIsT4AH1
        iIRsMqtNQ9Gf+sbuRgs038MkV8XpmsjZcTAMQhs7Zae/nCY4o3dIRvFUEzohFq+KPOtLC58
        9m5CsWIbtIh5bmx4RN5bDBKO+IBWKWZb49W0bzHy84l3YZY87gfSm+nCpWAe8BRdNyNU5QK
        ICDVcBTfK5rZa2RPBTsdjXcyOmS+ys4pAruaLBEBoTFBqyREU6Li7dds7oE9kA7U6mFkRpC
        8H6YZwtgTV0m/GY044SxsA==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     siva8118@gmail.com
Cc:     amitkarwar@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] rsi: Fix comment typo
Date:   Fri, 15 Jul 2022 13:00:16 +0800
Message-Id: <20220715050016.24164-1-wangborong@cdjrlc.com>
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

The double `the' is duplicated in line 799, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 9f16128e4ffa..d09998796ac0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -796,7 +796,7 @@ static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
  * rsi_sdio_host_intf_read_pkt() - This function reads the packet
  *				   from the device.
  * @adapter: Pointer to the adapter data structure.
- * @pkt: Pointer to the packet data to be read from the the device.
+ * @pkt: Pointer to the packet data to be read from the device.
  * @length: Length of the data to be read from the device.
  *
  * Return: 0 on success, -1 on failure.
-- 
2.35.1

