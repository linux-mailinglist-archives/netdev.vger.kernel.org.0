Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97652561A85
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiF3MkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3MkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:40:23 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C333EAA1;
        Thu, 30 Jun 2022 05:40:17 -0700 (PDT)
X-QQ-mid: bizesmtp62t1656592779tu3n0dl2
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 20:39:31 +0800 (CST)
X-QQ-SSF: 0100000000200090C000C00A0000000
X-QQ-FEAT: Gn2WL6ficKpFsIwOK/PwHqvIOvq88K3Ftl4lAAP0xOmT7FfgijX7y0Q+KU1N2
        Psc9kCtNjvRK0I2FQl/S7Ms1z9MnFVeNsClQYQVK2WbR6blka363NITzv4VJhAwbY1+X7Oa
        KhNpCbJF8v+nBUz0uxljS6pse/O9HSrF56xUyOPLJb6sqwoFo5yRgGxd+AoTZ/VTzQ1t8Na
        f0cDi3LMvuZiVnKTZq7Li4WxOLuVdUWjnOnDYVHGtI5hqZVYPmez4UKkOKrt2kHXEwcI9V0
        wBdrXzaz7uZt/9YyR8m4XYLeEaYEm/WhJZe/NB3MKeFiZJ2xRXE45cdPnQV1CtJgTRDTwQA
        +87vhfpGZpui4CwPuCyJjq9UUB1xg==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     aelior@marvell.com, manishc@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] qlogic/qed: fix repeated words in comments
Date:   Thu, 30 Jun 2022 20:39:24 +0800
Message-Id: <20220630123924.7531-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 82e74f62b677..d701ecd3ba00 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1110,7 +1110,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 								 bit_len);
 
 					/* Some bits represent more than a
-					 * a single interrupt. Correctly print
+					 * single interrupt. Correctly print
 					 * their name.
 					 */
 					if (ATTENTION_LENGTH(flags) > 2 ||
-- 
2.36.1

