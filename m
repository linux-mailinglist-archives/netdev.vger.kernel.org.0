Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053A86EB86F
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjDVKLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjDVKLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:11:43 -0400
Received: from out203-205-221-250.mail.qq.com (out203-205-221-250.mail.qq.com [203.205.221.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA7F1BFD;
        Sat, 22 Apr 2023 03:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158299;
        bh=+zF5ZlaKbkUYHZkMcIxweuJFjgybfbIGNceQyR/6yOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JqamWBG9qFXnGhfDexZn6fhgbtx8eB4mAhNiER0WfO1eS3o0zD7ry6lHbDmgbHcd0
         AAPhAFf0syu0My3qXof4XFMoLGphWJwpWydWU+TlELWfBW4K6TDxZVQCFwgvxNl0R7
         thql9OAw7rzNpZTsZe/RKFliPsTZT/mUv2R7Dqr0=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157914tdf7je7xz
Message-ID: <tencent_C77B782B54A36A4930DC5CD7666E19801D0A@qq.com>
X-QQ-XMAILINFO: MinfFaxlAYcM0RJte8UTAwCpK8CHhwh1mVhAx1PxW7IeQK9fn0LNG49yG6nzl+
         oBXdg5m3bIygJYj566WC1R2u9MQpfNqOKs1payC/ZShXEnf+2KXQMn8P9XLpHfVa62covOljfJT/
         7wrEBuGALruX/XSGPkA5+kA8m9Bt69YnvSlgC5oI/BO5LikNmy2+HT+WZL35SqCmHVcWeB+fR7k3
         6yFSxtWr4CMImmBB7lZjyDvcWSDJsKJ08lmasCdY+/lGLeRTMw9Af4DHnhBFiG5l9JPf/Ezbicbj
         EGh0iSQ1Ai1NS0PMkApBhp7rejIUkEQ0cNl5WCfxUsGMLAiN2LZn65Xz1QG65ObVZNRpcwswZhjQ
         lzZpvg8LYa3wywvAbhef/LvSkKASbVvS/ZdTG1VJ7/05CbjUBK+IoglW5f81BFfIP2R9+/x/E4XD
         twBeLlA+si3OmNubg73/lDY37qXY2aM+rqKZtH20W8ksUHIdnCuV8JkOSRiyMS7vOrYPI+mZZKgt
         4HxU7lRgLiajjRsayl5gOiuTCR4m7AXdZ+F+lf8UhWmadNc8IcGp/cQarSJ5J/2UEaluaNEEDgPz
         qDX/rgHAbGK1FlwxGM/bPVZtEU9gLVW4YbgVUMqae9/lQc9984TIrrGL/Ppn8rJG9N9mv6/s2WMf
         o1Vo2MrJjLZGKoAUCXfdT1XXfJuKFEYGPjZQVNuQ9IMBGk5TGMyYm77JMChGZy51Ii7nI0ljQjHx
         tYLVMZDtrxhCayusX4SobIXzdaCG2cjsungpi0H75NxSphvSLZkTpOINN3L4shUS2+mBcI3wFGK5
         xZ3EodWEc/c4Op9qPzsCBeE64wqUJGJzybGyWLDY3zO/kDqL+LyPpoF7F45Y4IK2IcimQLJKqPEv
         FxUCyZv/dMRr8C4Rp9AJJnlqv1Gor8UWmUAINTEZlOfyRpqeqZqoW3bLQveRUP7AnA82W6Zdqn64
         SGWZLHFrPEn17DU7Q1RbU5zuqmtXh/+Oa/VWxekH0b4es3/PiDZW0iG5Ld0tsvhwv4bBL2CZFpmU
         M03t2kdeiuspZJZ2OPkk2fwXuKcKBvgxjPNn/ZqFInh0gIMDzb4oIjdJ0P3dA=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 02/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_read_reg
Date:   Sat, 22 Apr 2023 18:04:46 +0800
X-OQ-MSGID: <502797e3be90fce642692156898586dc93e7755e.1682156784.git.zhang_shurong@foxmail.com>
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

If there is a failure during copy_from_user or user-provided data
buffer is invalid, rtw_debugfs_set_read_reg should return negative
error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index bc41c5a7acaf..3c3350bb2855 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -201,13 +201,16 @@ static ssize_t rtw_debugfs_set_read_reg(struct file *filp,
 	char tmp[32 + 1];
 	u32 addr, len;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	if (ret < 0)
+		return ret;
 
 	num = sscanf(tmp, "%x %x", &addr, &len);
 
 	if (num !=  2)
-		return count;
+		return -EINVAL;
 
 	if (len != 1 && len != 2 && len != 4) {
 		rtw_warn(rtwdev, "read reg setting wrong len\n");
-- 
2.40.0

