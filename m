Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E766EB86D
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDVKLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDVKLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:11:43 -0400
Received: from out203-205-251-88.mail.qq.com (out203-205-251-88.mail.qq.com [203.205.251.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BA119AD;
        Sat, 22 Apr 2023 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158299;
        bh=8leUxeAPv62+4h4KjkbMWeydD4pGRjvCLJYv5hfyOdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LFNKt0TV3shD5sVqSFrZPSkx32eBER9jc5o65n+qPhkNsDV+VFsQ3EIm2nI6k4jj3
         BokLxgbk1ygO4tJSD5n7VhDoa4bl/mMf/A6d06NQMthpy089yCbWrez6MoKpIwQFQf
         38h7LKYpwfjzsoHAs0p3DyQ0T7KEHsA+WDqE6b14=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157919tv67qvjy7
Message-ID: <tencent_82E5B6AAC09A3C801490519B242C6EE06A09@qq.com>
X-QQ-XMAILINFO: N2tj+8mvLUD9Zr+YZf8MLVneoWmGNe7bAJvx3TdjU5X4G/ck5bqc8zmpQC3sSs
         ++uTtyXJWhdC0Xd5wn62+mogphn9WXzr1oj5OsecEILBMa13EoZkHMFMCBPIcAZO8DcSTD1RkQZA
         Xup3ou9Ycr9UqQXAHTqziDiB2IbzwtWSKT2rKu0o8LfjOQB10zdPohGMvlWjEbHlBrqqWvZzu/rC
         XOdDltcCym9KnTnanngTq40B85Ryxj30uSrAEJpTt831HQyRO1WRl8wpNsTynF3JQUi2jE+muVB6
         AM1VAEWB6kFGgDdmB3mF3RnVh17jRUsvOjuHl7ZzHNcUxBXdChjMlc/6EUavIk3EeMP8DXkYyMp2
         H9AyJlstJLArrf9B0YfcVHmFBfezDLGg+9saIgy43F39zOx9nJbtj/wXBLX25oDokg3bNEYkCUwx
         nsKznqVZlVszss79FquMH/tp7ABZlozoLYy2enGr/DyOiM8rl7iLZzI1CxUvpOR6P+Y/2TvHL4ZT
         5YmppeNHzoxjb2VKs0thOmNrVgx9G7EMaZi5GoVM5Z5KZLdGQr9c437qyOzRjFKvnOXQxleMLQUp
         KtH8nm7Jb+hqD0lDZlGtGWSZzO75cKaiAGB1nkUInUaZeA2ps0BbCK0Hvx29nJuaeBZTsjaeX1oa
         FenmHEwiQqEi31uv2QJiMLetqFzGz/GWo+ugd2ww/VC9PT3VAPoAA32/EF9JQiEwfYDcYZr72R8H
         U4ymD438BWoW2ZRlI8xpApPYIW3JeOnaIs8C01mUfNd8ISLl7Hl3q/pzBjE30LEc0ljVCPTCeyqu
         +uoxTwkJVcF5CYtUCbwd6dMO3jrBqDdg+PEIwMAh2/900obhNmIx2In5GN7b5E6Rtm5P59kouN4l
         tVzNAqaX3dO+7qnfLXpAVOh9uHW5ltCNZlfNTY1EJNkgJMBkKiLplEXOOr3uEaVEIYUq+bBLqRoe
         Twyl1qb/InqUpYz3yC0oXUdil00sQLBa8709TFVO/4nbG2DzsL4Erzk6A2WqHoZciOh5IcCBrVAi
         MJJ91oD2syVWQgiSMohRgz8bnNTMAYzaTG7mkZwvIjD4RXICUCJequqBhI0RS3nVr+6gyfkg==
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 03/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_rsvd_page
Date:   Sat, 22 Apr 2023 18:04:47 +0800
X-OQ-MSGID: <38dcded193f4febdd0a7731229efe94e75d303ce.1682156784.git.zhang_shurong@foxmail.com>
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

If there is a failure during copy_from_user, rtw_debugfs_set_rsvd_page
should return negative error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 3c3350bb2855..d8e872ae4dda 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -291,8 +291,11 @@ static ssize_t rtw_debugfs_set_rsvd_page(struct file *filp,
 	char tmp[32 + 1];
 	u32 offset, page_num;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	if (ret < 0)
+		return ret;
 
 	num = sscanf(tmp, "%d %d", &offset, &page_num);
 
-- 
2.40.0

