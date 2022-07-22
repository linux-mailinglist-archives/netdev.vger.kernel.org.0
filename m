Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A0457DC63
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiGVIbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbiGVIbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:31:19 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 239009E29B;
        Fri, 22 Jul 2022 01:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Nghlr
        KZkH0NYuWIqRuK2hPVDdKPQR2Iuie7oV+kNzYk=; b=JvGWNrMYP1Gl9yDZcqKKG
        f/R+PCq2MIweOVpGucQvnJypQNntMDaXEsDE0RrhbLPVcbBz8shVwfcXhHcVxev2
        f47ZiG4ubtHhyVdYFoYUnDFLVIJsn/sD8oZOZQPJpINhPJVB4D48wZ5XnBq26LZD
        Kpxst4oJJ17esLGpzdN+Pg=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp4 (Coremail) with SMTP id HNxpCgDHG4wpYNpiJGZ3QA--.6838S2;
        Fri, 22 Jul 2022 16:30:35 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] brcmsmac: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:30:31 +0800
Message-Id: <20220722083031.74847-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgDHG4wpYNpiJGZ3QA--.6838S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr13Kw18Gw4DCFyrtFb_yoWfZwb_KF
        n5Zan7J34F9FnakryvgwsFvrW0y3yjqwn7WFnFqrWfW3yjqrW5Awsava13Xw17WFsFqasr
        urn0y34UA3yqqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCtCFPUUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRwxGZFc7YxCG6wAAsb
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
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 8ddfc3d06687..11b33e78127c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -3800,7 +3800,7 @@ static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 }
 
 /*
- * Suspend the the MAC and update the slot timing
+ * Suspend the MAC and update the slot timing
  * for standard 11b/g (20us slots) or shortslot 11g (9us slots).
  */
 static void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
-- 
2.25.1

