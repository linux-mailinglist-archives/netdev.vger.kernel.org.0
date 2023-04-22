Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8086EB860
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDVKGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjDVKG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:06:29 -0400
X-Greylist: delayed 79 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Apr 2023 03:06:25 PDT
Received: from out203-205-221-250.mail.qq.com (out203-205-221-250.mail.qq.com [203.205.221.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACECC1BC3;
        Sat, 22 Apr 2023 03:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682157983;
        bh=ZVHvqzotBOxirfSKO82CUWP0DLUkcEMYWq+fWqQiZB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SuY4vanW9TbMyICI++qkAq6DzG3fF22ubN9xzEUm1B+uQ9Tex/TfLLJCeO/Jr7PYp
         ykj4f7ivsWN+RXLVUS6ZT187BiHGuSdzjs2UOoHSyhWgTtQRC1w4I6BRuZJ/6FcHUE
         Hggdo8xMtBe++HpC6NiniuKW4uSSXhKZapkuzjDw=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157933to0osbp60
Message-ID: <tencent_306E6B046CCAA35C6108D54002E486A0D605@qq.com>
X-QQ-XMAILINFO: MD2XmhJtctJJ3gS85vJgQKMDe6cZJ7mql9xOyhdCfdIqT6eFBmkvs5RW94dkFK
         +7WiWR3W2UG72X+SfWM0JnXjwhEq9AH3ndDivFvSecOOXaXSctjXq2k8URPLYRQvPnBoc5kHJk4a
         eTxwAflOj+7X25ENUnTDYBRmiw25DiqJOZ5G1AHi0Ohcz7lOW/KiOLB03dhYKunY2qEkE49OaZTQ
         3caNJ6vT5tod7wRi0+8mHt4JIfAa4fXaVp8kArPfsq6oGbSPqaeIorZ/O0Ua2zmEqVNAqIY+kB38
         gbqIFO9uaS0LHzT+JopdDm8Fd+86dnhD3Vo3Sz3Cakl+bNu6WB8k8GOWusp+Ml7FWGM6JPq8Ti41
         TJ2iZxGYqSjF0vrBZwrqY3nCso00B+vBfkD3T0mWrsR0eVwQBZB6KECx7Adn9OnIP4vAAYxI84qE
         YgIRu99UoJSFjSa2kfosHM62WnJ0capbpzZvaITKypwh/vCT0C2HXgK2k6XyPpbU9heSB+p/h9XT
         eX2OKgt1kngaxz5aidD8P7HaTmb2IUWaUc8Y6W02fOtIK48KpxcNJ0UseLIqpAAP/KUp6k/MD1cC
         R2QtGWDaQpeVSncWb/I6bPpVpLuOAA2Cq/f7DylFTSzPM/gRpwuXMXaTYvMSMlupUW7ewC4qckv+
         RTevKmnj/RNJpY8FwKLm4qGDf2bSKRzgQA3Xn1fuCJE8NM2dMFYuan1LojQw72m2HMTdZVNNYKbk
         VUyv0OJw0DX8gt3tn9e7kGCEeLugA51vIvLdmtjqo5XTKNP5kKbSizzt2dWB1g+6BDEdNfg4tCgl
         AzGMkTQA/IjBu0tGZWn9kgP/JNMI+oaS9mPJg8V3HUeUnpxDST+v5q9Q1xRObbXzzkEPIYWkH+m6
         hc1qYOXbx7Tk86s9tcRMnXHMS+CmmTk3DFfZ6S/noMm+VDEBgPwWirJpRL1GMNmPgiDcmFtL/4cB
         zthBXknJiXBjM+Zgmxrq5Z8ZUgiBps9rYQX3TB0tGd/cE9Oinbzq6kJVL6O/3m4ZxqWYKrOoNRT5
         ceOly5i1lqXNEyQ1QIEaNuLJaJTg3NDZb143+UfKltabY9QNom
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 08/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_fix_rate
Date:   Sat, 22 Apr 2023 18:04:52 +0800
X-OQ-MSGID: <a3b0b5746c3ea8d0fb196284528038d56f225a9d.1682156784.git.zhang_shurong@foxmail.com>
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

If there is a failure during copy_from_user, rtw_debugfs_set_fix_rate
should return negative error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index e033077d49b0..aef43f3ca364 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -488,7 +488,9 @@ static ssize_t rtw_debugfs_set_fix_rate(struct file *filp,
 	char tmp[32 + 1];
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	ret = kstrtou8(tmp, 0, &fix_rate);
 	if (ret) {
-- 
2.40.0

