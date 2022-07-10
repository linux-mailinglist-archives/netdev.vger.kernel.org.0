Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBC256CCE3
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 06:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGJEao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 00:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGJEam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 00:30:42 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6119422BDA;
        Sat,  9 Jul 2022 21:30:37 -0700 (PDT)
X-QQ-mid: bizesmtp63t1657427417trobi5o2
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 12:30:13 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: ind57RUHy5Y7m40K32kqMvuzR/TQHfArAAfNhHD50Xq3SbxgLvA1cerduuIUh
        YOQlbs5jKUgNEePQJ4wwKU6hduTQqfL4qwahFx6S+slBPbgm679FrdkAKdDrvSvowhRvae0
        0rW57nWHdwK1pHOdpjJf4mp7iYk13r+4c8BlJbncu3PySBYktyF2lz0qUpxH05FnMPTPnaC
        kMXLNIglV9PJAyr9QaligCTXnhbDik6181wQFdjkP6SKI5b3dMWl77QgxO15pylLm3xrM75
        5hd9Y63sECn/Hj4M3Zhr+qyplM1ERotJNP5WqNlZ6Hy/U45+ags+Q74+axgRV7oeVRmXknc
        vvZUMyAGdc7WVWuBfAQjiEbqAvU8NBfawUbKOCIQh1bX+ntJ5U=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: rsi: fix repeated words in comments
Date:   Sun, 10 Jul 2022 12:30:07 +0800
Message-Id: <20220710043007.33288-1-yuanjilin@cdjrlc.com>
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
2.36.1


