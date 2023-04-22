Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E219E6EB867
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjDVKLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjDVKLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:11:37 -0400
Received: from out203-205-221-247.mail.qq.com (out203-205-221-247.mail.qq.com [203.205.221.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0644D1719;
        Sat, 22 Apr 2023 03:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158293;
        bh=EQcI1oQzOcwyIUTiPaU4z5ZWBJcC45jiOUD5qZyZ8qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZFKHFL0x2jt7a8fqABJRiRcZDSx2+zUCH3cVwk/nZK1TFhL1j22FeDLlYGBkB6Nox
         YHK0QjANRG2hehWxAR5NWL4bz4n5x5bwHdgN04KjpYNg25xR+F1EIWB1+cukr5pqKV
         dKlYn/s9ATTacozbqN9PA0qw71CC4zXZr36ptAK4=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157904txdh4nayd
Message-ID: <tencent_6E21370EB57D5B7060611EB60A96A88B1208@qq.com>
X-QQ-XMAILINFO: MBevfmvnd9Bm7qkJHv82gkUqkDXzB26eRF0RU1XiyOd/jpJbPsMPcUL3t3Hl81
         8id8ZTbMA1hzi+/LU/z2h7C3v6IVQnhhVKcgNW5hDuMXvVTZI1AxBWEqOT3WKIWPEwjsBV6ueaPy
         8cG3k9ULMKL2iL4BP5Ul3YhfPo6FHVjLyFM38VAt6cJ8Sp7LZ6WheoAqjlW2oM1hCRupCsljOMqA
         Ixb92uqJT1eFS2A96gcTXCl1KrmFY5KQAB4NO+Kn9a/ZmdvnJrnhDYx2A2ViJxNvL7zeEuWwHXuM
         HITLYX4Fwo8NuErT0ThQe2cv80qDt8lPIm/Vp66ef3/Jn1g1x2un6SdCrUABHu+8Tfk8opobXjhE
         llO8asMkexg8Pu7nOFNICIQY975J//WJPx3yP5y8KnS8Bvmf3CUTlEvKqQ3e+RnEwfzF2VzsnvFq
         lu2W9+oOoh+HcbZsZoaqUavWIIbR2KN9Ma93ZQqtILLyfVA99hYbcd5dHIQREbmVv77YiMDiMhD4
         wZ6Ua6shffJTC5wNVS9y+0Ob1NyxQd5SRgcJCncLNZfzEJDrTcnNUOTONMrkrVe+BLmu0h1eBJXG
         GtmAh7OoBOsxrRkZ7UUnmizW1NcYVvCSNZ8MyIXBuIolPw4A75ZpBRCNcyuZ0wmfh7uUerCyGZUe
         zw6YZWB5K9mJczanebWFjHSEbDDWV6MVtwbSPazPiTsQI87kM2zVk45FQvR6rp1McZmCJj79IQ0S
         jDxglGVIQ1cbG0Z0BGV46bh+PxtCKq4bai/5M5Cm2aCQsJbT+6f20u/GKSJi2oMtlB0Wo2nkIDlt
         yTUOHsE6y4eCF2inr2vKYVDCLL6/oQZmU0xE9hqCgJc14sCFgb+TXb1kTaMgFdhGx8iHKtYOyCXn
         XtRvOV4oP/fvyLLsgZN1YfLraY2FsFmyOTZMi5Q5ocKnIZwYetB/PasYc7SaR/3HwjFPsiFW5rK7
         vS+fAjZSYXJbR6VIS9RoEAzRfFWdNrqAKLAjMuFFWoVlocLMW96FQgHWzP2R3sZTcCAuqtsDqgJH
         OotENqAvUX2EtlBOh2nOPdmllnx2Y=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_write_reg
Date:   Sat, 22 Apr 2023 18:04:45 +0800
X-OQ-MSGID: <77cd82492eeb02a587a3da903a3824228ee21ab9.1682156784.git.zhang_shurong@foxmail.com>
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
buffer is invalid, rtw_debugfs_set_write_reg should return negative
error code instead of a positive value count.

Fix this bug by returning correct error code. Moreover, the check
of buffer against null is removed since it will be handled by
copy_from_user.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index fa3d73b333ba..bc41c5a7acaf 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -183,8 +183,8 @@ static int rtw_debugfs_copy_from_user(char tmp[], int size,
 
 	tmp_len = (count > size - 1 ? size - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -338,14 +338,17 @@ static ssize_t rtw_debugfs_set_write_reg(struct file *filp,
 	char tmp[32 + 1];
 	u32 addr, val, len;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	if (ret < 0)
+		return ret;
 
 	/* write BB/MAC register */
 	num = sscanf(tmp, "%x %x %x", &addr, &val, &len);
 
 	if (num !=  3)
-		return count;
+		return -EINVAL;
 
 	switch (len) {
 	case 1:
-- 
2.40.0

