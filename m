Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7776EB86A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjDVKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDVKLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:11:39 -0400
X-Greylist: delayed 380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Apr 2023 03:11:37 PDT
Received: from out203-205-251-88.mail.qq.com (out203-205-251-88.mail.qq.com [203.205.251.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8277E1729;
        Sat, 22 Apr 2023 03:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158295;
        bh=XE+xW4zcJKwa46DVTbWJWKZcEJQ/Q3+YX0ZLl0C0gvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=KaEvBaLQvIkgQVKMWMyZZG98KAUvh8BEuHoQdRZH13v+SqlJhVzBITnKTfUJHs0qs
         ehc4Ro9CxMhHkG3JshAChRCSfqOrHrrlXtYhqEwyZdRrsbbY1QophbfNh4oyE+tz+D
         ZKGjX3EC95ceolg11b4vSnPdpEtP6DN/K7EdxjDo=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157923tnl23habh
Message-ID: <tencent_4D24DA6FF46A2DB766C0483DD0143A51F309@qq.com>
X-QQ-XMAILINFO: MxcclqldyJbqxsleZ8/LdlokQ5tJqfinINGxg8sGGglaHQpKf+07EBR5uVeGzg
         ZtCrhYt7Q8zCgBKC0YPbuwbqoVYBgiY0e6zWMXbuCxpxwImp8iExx6jKA66qPkNxcaJVfofgG3dK
         5qjdyfn3WohMMI+spz9/oeyOs7OP3rZER7nL++Cx9QbHri1LejmV6MPPwJ9bNDz8qL3L30ZTrlVg
         5/HpOs0VDY1Mfh1vTgO1uhYAdoeOYPT0Li0wTPAf+C3NcT2yvMBiZkPbiZ5VVw9+v1d9gRC/3yb6
         q+ZyBcvcEHa6I6bwuVtSmT+FhdbD3+w+QU3/45F7S7eJO/QgRnjZ+Q+c5lTqIcdd60Tc15iju9zH
         z6dLSzgWBvEJ/4xuR8BXG03H2jRKvwazYrTZOmYQUUqH7L7mzbGV8sdgpR+n61TQdHNjiPX+rfW9
         xgjEr+xrm6J2MkdAfDsYFFIqfGgnvjWiuw2ezjqPV6f8aFG1wC/gszkGWzM4w0rFUgYgkQ/ClPz+
         rNujGIizELzfOSzO6EywXnCQshKqHWl1pRB363Pbd9XtSd4UYzf7kzVhaibovx3yA+US0YvfiiFQ
         +wR0Y6fHaZWyz9wmYAbR/w/H90stjf7osdFPCgZasFleWgax2C//CKVE9XHr1yc9tbqF5200xdK3
         2tIDt3KKbakNYPJzGL5cnQHTAwTb9B9IAjb1RJ8tnir8+wbi1EcSnw47Liia9AoKwvJl2NiGcF4o
         fcexnA0qgXCnikYOqWH+kXL2x7OeDiapj/wa/QLkNTWIafp19lWpdSL6wABDZ9YmAwG3sQxOgebP
         f8vU0o+M+QmCMTCkLgH0pBEnO77G0ZQoJqbb+hLMRFFfUMZ9MPUCvn7XFroDOUVy7BXUKbAOjKKq
         0z7fDK7d1wrs3TUoJQXG7Zc0Qtt237y3xhYetqsVBke2+cFm6muTPE2DuyQgjJzQolm58EM9I47F
         s1t6cnLbqKZs1EzwQYeA4H65+ojcfUzDDLIZRFV3jD8PANnhEioGUDPM6AhJtF+nhOKHmgJKoEzs
         ViqEoJe5lxt9u1aM7/1k3Irh9CxNqWuBX/7SFxLiZUhSa9HlmBb12xSbLuPCDBqGFLHOU43VrLBn
         pGz9QWX5iGlpcnX8o=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 04/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_single_input
Date:   Sat, 22 Apr 2023 18:04:48 +0800
X-OQ-MSGID: <5c743fefab84f1d490a73c61fe0a3cb0310a5677.1682156784.git.zhang_shurong@foxmail.com>
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

If there is a failure during copy_from_user, rtw_debugfs_set_single_input
should return negative error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index d8e872ae4dda..f721205185cf 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -320,8 +320,11 @@ static ssize_t rtw_debugfs_set_single_input(struct file *filp,
 	char tmp[32 + 1];
 	u32 input;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	num = kstrtoint(tmp, 0, &input);
 
-- 
2.40.0

