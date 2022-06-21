Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B6A552D06
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348169AbiFUIby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiFUIbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:31:53 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2C415727;
        Tue, 21 Jun 2022 01:31:48 -0700 (PDT)
X-QQ-mid: bizesmtp72t1655800158tfnrwfs8
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 16:29:13 +0800 (CST)
X-QQ-SSF: 01000000007000109000B00A0000000
X-QQ-FEAT: Mzskoac49Og1pKkwi0Uw9GzgjMlyWLwT52H3OZ9eWzOYvgJmdAskrojWW4fK3
        4HQXdpqsjdOdcQBHh6i1463QxybshHDWihyQ4BOrdDP4W+GL5bhlWAm8BIy+bodH9cvuAiE
        e/HoK3VgBrdIpVA/mvyMNC3k0S/HSI+bT0ya13s2cbDcV+CzRNe58Qku55jjIUe7WjMjPw3
        o5O6RMdEXZy5+vTstBiW6H8szwjJg5zcT0tcPrhFOhG8qEx0a4vMgYBF7kTNTn+UlBqWVW9
        UP1HBIzF8sjWHS6r1xQWvvUR4YdQWbVdbcxgtKC7Rew/FzABzJ2/zgk11LntTSHLUiT3F1s
        x0nL7HULGOIbqnc0Ic=
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
Subject: [PATCH] fm10k: remove unexpected word "the"
Date:   Tue, 21 Jun 2022 16:29:11 +0800
Message-Id: <20220621082911.53165-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word "the" in the comments that need to be removed

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index f2fba6e1d0f7..87fa5874f16e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -809,7 +809,7 @@ static s32 fm10k_mbx_read(struct fm10k_hw *hw, struct fm10k_mbx_info *mbx)
  *  @hw: pointer to hardware structure
  *  @mbx: pointer to mailbox
  *
- *  This function copies the message from the the message array to mbmem
+ *  This function copies the message from the message array to mbmem
  **/
 static void fm10k_mbx_write(struct fm10k_hw *hw, struct fm10k_mbx_info *mbx)
 {
-- 
2.17.1

