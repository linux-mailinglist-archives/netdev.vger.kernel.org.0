Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D5C6EB883
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjDVKRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDVKRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:17:07 -0400
Received: from out203-205-251-85.mail.qq.com (out203-205-251-85.mail.qq.com [203.205.251.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69071E70;
        Sat, 22 Apr 2023 03:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158320;
        bh=S1YnfUryk0L2ZsYdhjekcoTp3feYwxUkk3NnwN11E5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=z0zMRTcVXte0BGrwzwElt40Jtg/TF0YfxVEB7KytNXRJlVTRWWh4mC8LPAWhD/eUv
         RDxMcmfPI8cN8LNuknx3VSCn7FHOzPIMUe2Ee33Di6NN2l46/s+8ham6vuc39wxAW+
         NJIjFEjoVwXbBcAkmg5Wziv1RlBJqifOHYnXZt2U=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157937to9uve8j0
Message-ID: <tencent_60D59E6EE9816978182B3CA30E4B48DD000A@qq.com>
X-QQ-XMAILINFO: NkHKfw09D6j8DzDFrl8OZ8DLAowJ2S27fJ6TyiQednlgwnWrGZ7po7Z1NK7DM2
         1gB15xje0WgS3HC8cyXMDnzwd+xfnkdHWxX0XeAfCR5TXfV8ymB2ZSvBGuSImdd8tlzoM92UEPqY
         P60PuepCEDQsKAcMzQl20IFWMEkdWHwqBrsult5Uga+qtfZtAFEyORgaCtnOpg6uEJH/6yfdNl+f
         C9x/jIodWfAnRpljF5wfSPO8i1MCgHCtkfqGHWZMzW23/JxKxJm9GFRHm6Awdr2QdgOdTloi9VIJ
         nY8eD0/NYBW3ETa3U8IZbmWYa+nO9Cw62j/cDhm3ECkB2WUrVnUoy9YYYi2n2FE6KLs5I4wLnndy
         dUW9q1NCYSR1W7Qqx6AfNOliqCnkntQ5sVZzMVQs4TZt8Y3JuEPNWGqSlN14nCFWmibi0WUVBUjk
         55AE2XuAtf2EYn9baNYf1SxPIUbTeMfwyaq25ywekxZqBmiNq56zqM5YI3qKpnrTydKTNr2TO+mo
         LnOAm2EDNdJ9JbhhkikOnk0Fvb/AilsKjGOoMniBgnJNrMsUB3vkmzfP8MZXuIEZjoBSPwMjVFbK
         Y0f4Ll+6HDzgRm0E5S3NWYgcR1kSeeXRCDN61KI0m5wv0BnFQNPPkZC5sLsbQHKofIkuq/0S+TYI
         lZM7UJS5qNYf9I0vQZHtD8s0vfHzos9AcuDY/1RLOHt1fVTsD6lzYHjPnAGBIAnaTYR8BRkaSDs6
         kKnaLuUN4qPDmLUug6lmliKJU26oqjnrK9YWEpZT9ixbQBsQpyaVoT7ImCab29j0LOoaM4ZfeiS+
         dyAM1hMT9k2M0bjurm9CNfdUkqUMa7YFYvyg+59/bhdaBXed+yDqWFql5F/+c809BTCgOR0G9cO2
         ZoEfyr3dj4c1NIGJc8ZE7e/PT3xBo02U1A6j7vhO6kTVfYErMjfBQh20Gc5XExqsc/Bny9iFCfdy
         528BABRkuwWI4QSyQv1ueRYj7zFZItJwQ3XSuYkX9uJx13MsLIJXLi7rRikexO0vNd8nLTlXZCy2
         ETbQWJEL5wwcTLiBWLMjv/NkfmN8aiVBc1OnGAoNqJ5erPzIOe
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 10/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_fw_crash
Date:   Sat, 22 Apr 2023 18:04:54 +0800
X-OQ-MSGID: <e5c786a4f5594388b4af17f545f072121316a410.1682156784.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682156784.git.zhang_shurong@foxmail.com>
References: <cover.1682156784.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_SBL_CSS,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user, rtw_debugfs_set_fw_crash
should return negative error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index f9bcb44b42ac..700d5183d62a 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -955,7 +955,9 @@ static ssize_t rtw_debugfs_set_fw_crash(struct file *filp,
 	bool input;
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	ret = kstrtobool(tmp, &input);
 	if (ret)
-- 
2.40.0

