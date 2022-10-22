Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE86084AE
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJVFnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJVFnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:43:13 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187802B0933;
        Fri, 21 Oct 2022 22:43:11 -0700 (PDT)
X-QQ-mid: bizesmtp62t1666417371t3sr5ka6
Received: from localhost.localdomain ( [182.148.15.254])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Oct 2022 13:42:50 +0800 (CST)
X-QQ-SSF: 01000000000000C0E000000A0000000
X-QQ-FEAT: /+iK7ZpVlLRnZYf9ZV4xBBazYX0WBMAdPSgrhKjq0hmEMiq1VQ8q+a0dtmaBf
        MKJPfrNEmcKt7+seP6av5ZWQEyw5IQJgTtmJn1Y5WL3NwYKaKge+p+hqAt3ipffzDpGDqag
        nc+rUPcXIYMhMjfD4rEQpdfTsj/XjbJarNi38tejUN3Z0ETGKYrT7Hsx71aLi+8kEblB7tz
        cISLi2p2xTth74HS+ecBMHmSnV1WmPzXQw1Qz3zaolk6ZuChutWtt1zbtGTY1DVQVitzCY4
        IomNINk2Dfr841O9IlHxJ4KpvQ2HiWlPODOoOGGKCz2GtYwwC76LJ8Ke/76kGsv7zRStZ5p
        E/ng1q9z7AbdS4g2LTOCVYPuu54aZe0N7MYiwr0NQCzjxtPzjY=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] iwlwifi/mvm: fix repeated words in comments
Date:   Sat, 22 Oct 2022 13:42:44 +0800
Message-Id: <20221022054244.31996-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index a3cefbc43e80..abf8585bf3bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -29,7 +29,7 @@ u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 
 /*
  * Maps the driver specific control channel position (relative to the center
- * freq) definitions to the the fw values
+ * freq) definitions to the fw values
  */
 u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 {
-- 
2.36.1

