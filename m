Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890F06EB862
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDVKHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDVKHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:07:09 -0400
Received: from out203-205-221-249.mail.qq.com (out203-205-221-249.mail.qq.com [203.205.221.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D721BCD;
        Sat, 22 Apr 2023 03:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158025;
        bh=SnfImROfHHS8oLIFhAcHzEgotoQ5IZ5awfUwJVXBhm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WmKYODdefrAXogqZ2E1TDxf8x+7ivr587ESi2J6qIzBaW2XNpZy0ADm1lpX2t3cYK
         Q3Q7WqNebdfuDc+I6z9wNN1xRcYuO+dAR37eDX5j4QKpmJNvzWrlzYbImfsOIoH5aE
         Fei4Fl9EUx6BnDHNdwHnRP5Sv90sh7HzDbACrx3k=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157935tafy4oywe
Message-ID: <tencent_226E4B142CC7835E6109554EE2E0C6A01605@qq.com>
X-QQ-XMAILINFO: N346zIWbcZWrh6GwbAB/RhXbRnBNeGy8D4mcWDU5A0oWJTNGp3xQRbWDyHXAne
         NkemPljTmnWGdUj5dlybke3PwNcM78HgNAiapyNHkJu/5EjxuceHvvHxQe24rcsb7QH0EGbriNdc
         +9r9GMPOMBLpKKZXDR6rvrYct0ZoLyyMZV+MhSDEpQBQJ9k4THjt51qxhcfCV/4i+ejs9YM3cqUq
         xiu6TneNeV6rNq/uUFREWsK2JChyI/xyR+ZXgfxix/TtWHWxD8p5z3pNNdrIL9hOK3SQyxXXVVBQ
         Rh/gOF6zUFK65ll8UwrOQKrLk2E/VNlWjaL/Ixt7ToqRGqxwunaMEYZZ1VebHJfNV02WWPtzsFfo
         OZu+F5XirtD4z7wapB5fTqiMa9a2TIWMUmpY+8l0b/FuRh9lrEqJXHIgO3kvLFkkGWPZ09C4H6GW
         Vd2U+yzCyfWuRM/L194BpMl8oVMUKJnNLpCFCDxF3t1ftxsuCOpzXRSO1HFDi9/8PLnba5QlSePr
         zzhto8k27kwXRZDEAGVHkW445Gvq52QHNkUc71HR+kauUqRSq0xGfCudFHzPeWeUSVVB2hWIovpe
         L1VVeHQ5plnA5W7mip2oFHgRXLv29qWcVF2Rd9iQbzsMWZVx6+43LCONcJEnLIHjGmKbnUNGfABT
         AF82Y7E1ZY2V5/6PALonCvynHmh4j10QFWqMAN/q4mJEO0Fepy1I2JBLvoH8q2nd0HP+sIZ0vLeb
         cRFZjuC2uB0Aaq2ZPB9pYYoIN9Dzl3W9iEPnpmMEvCenIFqeuVyR9WG0hIfvICkHgIhOxv996qDi
         6nuRgIjmzQcAC+Qlil/HTKxs3U/4ASXtFCHB0ox/tLkjiWpzDyyFuoeb50e4mOy87hf0LHj2bXTU
         2tfKJYPkGHC4MDJngYvSGiGjgSweEwBYBj/wMh5cBhCcRR7B2R0gBDfQqt2Zr4aocBT+dg6fiz5F
         A4qkph9G4GAW6wascsrqMi0H6LjnmndXEOhFVXsiXxzKJlKTRUEU9dTnAwd0iyCdHBEUFr9Uki+5
         M0AfDuMxyOTTgV26MX2Z2v3AZIGoQPGvkegiKWrUNcgiFYhvf80L532EeSUL2arWCWE+0IgstU3C
         kGebNQDQTIN+c6Z/vk+tDVDVAhJQ==
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 09/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_coex_enable
Date:   Sat, 22 Apr 2023 18:04:53 +0800
X-OQ-MSGID: <4948f7c2aca708649f1acccbce71dae00e18b2a7.1682156784.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682156784.git.zhang_shurong@foxmail.com>
References: <cover.1682156784.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user, rtw_debugfs_set_coex_enable
should return negative error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index aef43f3ca364..f9bcb44b42ac 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -883,7 +883,9 @@ static ssize_t rtw_debugfs_set_coex_enable(struct file *filp,
 	bool enable;
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	ret = kstrtobool(tmp, &enable);
 	if (ret) {
-- 
2.40.0

