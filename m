Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6812356BD65
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbiGHPQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbiGHPQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:16:17 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D2D33A27;
        Fri,  8 Jul 2022 08:16:10 -0700 (PDT)
X-QQ-mid: bizesmtp69t1657293348t6s3famc
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:15:44 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: y7VdHXLcy7CsmIVhVBlYtNJVJnsh9ScX8bhg2g9VQhhgvZHksjAJMX13kBThG
        dfBIz1bsti9GmwgR2po4MYMOH0JpYw5ojUCNE5x9TggoJg9uIhOOYOtJsg7YcW3J6z/lVfs
        E0FkBQt7HF1OEetYJ1ZnO5Cm3mTr5+uND4Z3/tB6VQcwF/g/CL6muqFLfJNoeIR4LcbInQD
        Y5WxWljpFZlbIwrnMzYkcu+s6+iaMnE1y7QjE094xr+M9nbGvU9k8ScMfIk+oAfqbJGUuGO
        CglpGBx37J4Xw2UGD7XjbU8b0U4fqnYs+nsDOKG3+1y6v3elH2G56dHwu3Eclz2EpgXPC6e
        a4jXCYxZmNuuH22lYaJD6Tf2cPRfO6SnzRvzZ249nzFxo7Fki4=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net/ieee802154: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:15:38 +0800
Message-Id: <20220708151538.51483-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'was'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 42c0b451088d..450b16ad40a4 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2293,7 +2293,7 @@ static int ca8210_set_csma_params(
  * @retries:  Number of retries
  *
  * Sets the number of times to retry a transmission if no acknowledgment was
- * was received from the other end when one was requested.
+ * received from the other end when one was requested.
  *
  * Return: 0 or linux error code
  */
-- 
2.36.1

