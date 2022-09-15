Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD075B92DB
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiIODCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIODCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:02:39 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E345082D2C;
        Wed, 14 Sep 2022 20:02:36 -0700 (PDT)
X-QQ-mid: bizesmtp87t1663210930tjzhd6id
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 15 Sep 2022 11:02:08 +0800 (CST)
X-QQ-SSF: 01000000000000E0G000000A0000000
X-QQ-FEAT: TXoNPSSaW4mVgLg2YDrhMFuGn4LzoBRZT1PkMkucYEJKxuewN7194FuIfGHsz
        dlB0DvX4VRj+9QPmtnk2Fmpe8v88SzHT9u9gg6jeXADNFcwePDZxHxvImBPJmihlrX3D9vO
        vX0TXJSx6yErl+6mI9/jhoi7yC3t3vNE1UsYfXxZcHMYqhSlxBGYU117Wwon6WQU2JTkjvM
        YWPiI5Yet3Wbb3cshtbcrNLa1EPn7YOysSze9nii+ijMxCAXC9pNnuIF8TeuM8rfjUmoJFN
        RVxlF+8o8SCSgmeXvsT2gPNLS1l42HyGEgvvlI9oGGRhZw/I/XSaxsNX8PlmXy2le5xhvVG
        7UYNHS8tjJQmX5KShKjJtBKpxajmuU/TZ6xd/2xoXr9Wjtpy0M=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] orinoco: fix repeated words in comments
Date:   Thu, 15 Sep 2022 11:02:01 +0800
Message-Id: <20220915030201.35984-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'this'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intersil/orinoco/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/main.h b/drivers/net/wireless/intersil/orinoco/main.h
index 5a8fec26136e..852e1643dad2 100644
--- a/drivers/net/wireless/intersil/orinoco/main.h
+++ b/drivers/net/wireless/intersil/orinoco/main.h
@@ -12,7 +12,7 @@
 /* Compile time configuration and compatibility stuff               */
 /********************************************************************/
 
-/* We do this this way to avoid ifdefs in the actual code */
+/* We do this way to avoid ifdefs in the actual code */
 #ifdef WIRELESS_SPY
 #define SPY_NUMBER(priv)	(priv->spy_data.spy_number)
 #else
-- 
2.36.1

