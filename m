Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA5555226
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358735AbiFVRSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377410AbiFVRSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:18:40 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2DD1EADA;
        Wed, 22 Jun 2022 10:18:35 -0700 (PDT)
X-QQ-mid: bizesmtp77t1655918238tuso5z1q
Received: from ubuntu.localdomain ( [106.117.78.84])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 23 Jun 2022 01:17:13 +0800 (CST)
X-QQ-SSF: 01000000008000B0C000B00A0000000
X-QQ-FEAT: Nw/vDu2WDVA7O0siZPWF1CRMSkUbier2nbLlOrsrUy/N9WElWlqOGeZoD9p+H
        Rmkgyy0foCWBQqCgTvf0I1qtRuZuLoYvbNtvT4FdGAsi6N80AMx8GSPkv/Mk5y1blLy0NPr
        vMyjiqX0JSwurAtdCUwRz8d1kONVj1hnmoq9QQY3MK03uLBHRFeyA6xoVIInSzYmWEH9Z37
        q1Zt5l8Die+yZCEwFtMOII8hPx5xv0LTM0Qoo9ZXhI6SPnyfhPJsS+43KuXgdS1vB2Eh1hj
        LsgJap+yDldFeSCoTv1P0bnuUF97BH6p4Jf0S0yVmo0zWVkn4BMk15yXM5wYAdG0wOauGj8
        pxBQ4iU7Hpoe68Zs4o=
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jiangjian@cdjrlc.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sun: cassini: drop unexpected word 'is' in comments
Date:   Thu, 23 Jun 2022 01:17:11 +0800
Message-Id: <20220622171711.6969-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word 'is' in the comments that need to be dropped

file - drivers/net/ethernet/sun/cassini.h
line - 767

* value is is 0x6F.

changed to
* value is 0x6F.

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/ethernet/sun/cassini.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/cassini.h b/drivers/net/ethernet/sun/cassini.h
index ae5f05f03f88..2d91f4936d52 100644
--- a/drivers/net/ethernet/sun/cassini.h
+++ b/drivers/net/ethernet/sun/cassini.h
@@ -764,7 +764,7 @@
  * PAUSE thresholds defined in terms of FIFO occupancy and may be translated
  * into FIFO vacancy using RX_FIFO_SIZE. setting ON will trigger XON frames
  * when FIFO reaches 0. OFF threshold should not be > size of RX FIFO. max
- * value is is 0x6F.
+ * value is 0x6F.
  * DEFAULT: 0x00078
  */
 #define  REG_RX_PAUSE_THRESH               0x4020  /* RX pause thresholds */
-- 
2.17.1

