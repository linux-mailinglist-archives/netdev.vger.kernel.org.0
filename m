Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A3157DCA4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbiGVIpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiGVIpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:45:07 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4DB29FE11;
        Fri, 22 Jul 2022 01:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=zd5zt
        uKFxSlU46KHfm8UjZg8ZTcN8/GC4Ij8c++zMk0=; b=moI1hF1TyGRjuzDEKkPjv
        ANCxkuQZTi9nZYyJKkq6xMkgNzpld7MSsPIIGHzQA/5yOVrGnhvajA1LzcKaWZxs
        D1Sw/4hbq7IhKy3OvpC60XMlRMYpBzH+8MdYXRf68ZweVJMbiMedWCtBzcWUyQr8
        WGPRB63SFfJPFmpG/jGOps=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp1 (Coremail) with SMTP id GdxpCgD32+VtY9piI6wiPw--.6757S2;
        Fri, 22 Jul 2022 16:44:31 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] rsi: sdio: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:44:17 +0800
Message-Id: <20220722084417.75880-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgD32+VtY9piI6wiPw--.6757S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr13KFWUuw4DZF4Utwb_yoWfZrg_ur
        1FqFs5Gw1kJ3WxKFW5CFW3ArZak343WFn5A3yYgFySkrZaqrZ3Xr1Skr45Jwn5WryFyF17
        JwnxXFW8ta4UWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRZOzs7UUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRxlGZFc7YxCqBwABsP
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
2.25.1

