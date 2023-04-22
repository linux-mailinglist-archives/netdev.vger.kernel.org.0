Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7A46EB872
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjDVKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDVKMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:12:07 -0400
Received: from out203-205-251-88.mail.qq.com (out203-205-251-88.mail.qq.com [203.205.251.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CE91FCE;
        Sat, 22 Apr 2023 03:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158307;
        bh=UnrqfxT/+f0yl1p9/78VwA5lXrGvNaLj9i7u4tCZz+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JIu8f4DOmrPVFwOM4tx2J0+80lU0Y5cdbAzd+6IpTFvYW3J1DIwRWj2LAGHBUchi/
         kJGEBA2CAhvGzuKm2ZpMB7a2XMrhoyzcErc9dS9jyjS5lvQYJWC4YIwDibxkIWNwLK
         Y3ulMMWxgwPPxSxEDx417DNAlyKIF4uZGQSTmHOA=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157930tdj6u3chr
Message-ID: <tencent_0AA8A35A4948DED8D5826DDD83F179A4290A@qq.com>
X-QQ-XMAILINFO: OYKvv92VoppH1v1SwCCPgzeLXkAzqSlswXWrMCRw5pizllEsRyzjCMDwd5BBtC
         z3+vNYVqQotAg4iS1/sWFP70rLO6MlJb0GZxBEq4OMX8Uvd8pCkWkIMx2KzsspMHMjZduN4Kfzwv
         2lRsydsI1E6P2fpOI3UTiDEqScB0orELn/t7qD93xwEXXkjnTA6hrz4ktGXdUBBTekw0ITVl6cQT
         kPMO7cHuRIZcxJtqaeFbbDXnz3ZeS6BaEPXA6idPTmsMNdzbpyVMjkVbz8/UYm8HWgU9O+vQbA/Y
         tLJNAy2ZpbeRakK0e9iMHS9UDGtu345eFhcqfPwbT12lsbjZdlhR8JSe0xo7bOaanitwsQw5Z+g2
         Rf4sEG1WyqgBPuUgYXCwqTwLOtiQk54i53QuenhJPXdjmYR+BieoiYaa5J2sU+C8f3lO/7X1m5DO
         JffX4AOpD9nBuDA7duQowrYmrdp1iPJZ3e6RUMPh3NRO8DgkIrX1JUNE7aYmW8pepbD8r1RpH4Po
         Z8GYS+8YWIlufbGfnogrNb34+XITKI4GWhm05QFzFXEkjGzLm/rGGQ+cvAdrukwu8UP38/2yS/RD
         0fIVwiCY1Xi8Cp0LQMigPzCWEY5T5yA/GXArbjr4Zgc6F1ffCtLdsFltWz0Xn4wZdRgwATSP+Xxu
         5xfRt6SMOT3Y7d+bLY++vaQaPNXLVnTnsoJo/usQwrD7xwbxVO9C/HVnAy7sQvjbO7Lu8aDJkP73
         lmF9ANmomkQxLHpo2JUDHqAESJbF+EARdfY7abXEHawQFPEUxPA/9DBJtrsFCOXD+Esi1f/8yX51
         TjOKv1ZnpBNj1UZhWW7bRx855EV5n+sBQQAYJRMZrSkhjEqO+dQZPpMh9xTTUzpaHc4tX4xbv7qa
         1I60t8TrdeU0LGTRJCmfGhI10/nLh6alMHQVRebs09oGYPaDlGye+27xumZsjCOw32E2c8UHkuxb
         lOtf34UJWsbyBsaRYxbhNgAwtn7MVIjBtcmhAt/+gl31hJZZCTdVewX5leZYM9ZD+901KmgXPeFp
         tjr0G2OgNsmdzQh3m3Z28sInM22hglVQcfqO70GT+ixiETI9qgD/tdXnySK50V5bhycPy49g==
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 07/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_rf_read
Date:   Sat, 22 Apr 2023 18:04:51 +0800
X-OQ-MSGID: <69640619f8704e67059944eb29332a0a1d2d3d6e.1682156784.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682156784.git.zhang_shurong@foxmail.com>
References: <cover.1682156784.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user or user-provided data
buffer is invalid, rtw_debugfs_set_rf_read should return negative
error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 259e6c15bc78..e033077d49b0 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -456,14 +456,17 @@ static ssize_t rtw_debugfs_set_rf_read(struct file *filp,
 	char tmp[32 + 1];
 	u32 path, addr, mask;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	if (ret < 0)
+		return ret;
 
 	num = sscanf(tmp, "%x %x %x", &path, &addr, &mask);
 
 	if (num !=  3) {
 		rtw_warn(rtwdev, "invalid args, [path] [addr] [mask] [val]\n");
-		return count;
+		return -EINVAL;
 	}
 
 	debugfs_priv->rf_path = path;
-- 
2.40.0

