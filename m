Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8756C969
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGIMl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIMl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 08:41:26 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C41B4332B;
        Sat,  9 Jul 2022 05:41:21 -0700 (PDT)
X-QQ-mid: bizesmtp76t1657370446tzv1j8n5
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 20:40:43 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: 907spY4M0eOSt2O5UyoKCCzfRgkM3uUzgP5HH3sDfinARVBZ+lDgdOFty3LAv
        1FnNO6wzCFTzsqj9/J58ZHykARTM2D6itVkyzR9EdBoX9TMS76AVMcsYB/0/dm6p2GrcIQY
        n1U2tGql8Fx2JujO0yq13I1O92zZVSWn5XcLLk6YBFuXxCwwrcp74hPmOmkvnHs+rX21D74
        KHHsQSr9WIAkIOALcI3Rq4FNvWjoyGfiuYJ3C51IXV+mBe/P0ismTtXsX9Ra6Ph9W4U7myh
        TmPYUrZeFxLoKGPB1oK2HD3GsIS8gdS7Ncx0FtZrmarcgHOP2ugot3PXfZsO9KhqM5Kbj9j
        E1bcWe/F2a4xNLF6DUGLBADfJ28VZEB+do378QeJFuHP5/+Xlw=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: ath: fix repeated words in comments
Date:   Sat,  9 Jul 2022 20:40:36 +0800
Message-Id: <20220709124036.49674-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'have'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index b53ebb3ac9a2..85955572a705 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -48,7 +48,7 @@
  * the MAC address to obtain the relevant bits and compare the result with
  * (frame's BSSID & mask) to see if they match.
  *
- * Simple example: on your card you have have two BSSes you have created with
+ * Simple example: on your card you have two BSSes you have created with
  * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
  * There is another BSSID-03 but you are not part of it. For simplicity's sake,
  * assuming only 4 bits for a mac address and for BSSIDs you can then have:
-- 
2.36.1

