Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FD35782DB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiGRM7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbiGRM7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:59:10 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB902726;
        Mon, 18 Jul 2022 05:59:04 -0700 (PDT)
X-QQ-mid: bizesmtp66t1658149110te6osiag
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 20:58:28 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: 9E3Ddn8eo0Ir/TAsJSsCKAcE96jed3OfcR+pklTVuob7Ys9mOHe9t480id+8A
        Q3zhQaTDZV0DcUNgQgRGdAE/ZO7VSdfFsoFwprNnGG3wjrMYyMUKx6MHslI8v6v1zGmgTrV
        GdyqTo74x99Wnw9fZYua1cG7cG3U0PCwAGNeTyhr22X1+9s4jo04M8K5yaBhIS0QOV5NolQ
        st5/NaJBQHwN3fUaN/xghov1yCDHKXVJRBeyxJfigT/Zj4okhFcKrcu1urUry8FAt2ggooZ
        OPS+6F/VLy6kP8+jPeorj2W515DyMSWOyEeKKipbQMser0n0zT7AdDUftkxJWI+OdIR853o
        mL8E26o//6QNVv4QLp4sL+O6/qxWoADE3h1Ov17qQ86VFNJ64qny2sN6mUkVeTdUnaWfxzw
        sF2g++nbdRc8gTpVE9otgg==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] bnx2x: Fix comment typo
Date:   Fri, 15 Jul 2022 12:56:30 +0800
Message-Id: <20220715045630.22682-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in line 13847, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 7071604f9984..02808513ffe4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -13844,7 +13844,7 @@ static void bnx2x_check_kr2_wa(struct link_params *params,
 
 	/* Once KR2 was disabled, wait 5 seconds before checking KR2 recovery
 	 * Since some switches tend to reinit the AN process and clear the
-	 * the advertised BP/NP after ~2 seconds causing the KR2 to be disabled
+	 * advertised BP/NP after ~2 seconds causing the KR2 to be disabled
 	 * and recovered many times
 	 */
 	if (vars->check_kr2_recovery_cnt > 0) {
-- 
2.35.1

