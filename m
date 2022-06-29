Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7B456017A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiF2Nhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiF2Nhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:37:35 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED6931529;
        Wed, 29 Jun 2022 06:37:30 -0700 (PDT)
X-QQ-mid: bizesmtp81t1656509824tvs0y8f4
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 21:37:00 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: 3uawQE1sH+3ZQG+P4dpIlTThLsViaVNLrg63S+DmjqidZwD1nNStyHd9TKyYQ
        yy9OBnVc9ztDf1IC9Xnu6b6p/Z0Q8gSdTDc/AyPJkrCZFOPRGvbjwGFa1nb/ahHvfFmmPDa
        k8PAw1glZTverFLoXbQKeS+wwBLDCs7M4qwbx+mmzcE6vT7IxVXWngW5+R2QprxQeHEUPWP
        9gmaSiQQJZH5n4eLQUZQYTnlD+OR4sDWkgOLIbDSTquiFwDpO5630upvOo0rz6wCl46YJ1u
        0lGEmYYf3v3+udaH4Xfx788uKTzN5uD05D3+75gW3ZKtuj2wtd6+FPvXLOX0nIGWB85QASV
        5oa1UdD
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/fm10k:fix repeated words in comments
Date:   Wed, 29 Jun 2022 21:36:54 +0800
Message-Id: <20220629133654.42134-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'the'.
Delete the redundant word 'by'.
Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index 30ca9ee1900b..c499b62b49b1 100644
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
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
index f6d56867f857..75cbdf2dbbe3 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
@@ -78,7 +78,7 @@ static s32 fm10k_tlv_attr_put_null_string(u32 *msg, u16 attr_id,
  *  @string: Pointer to location of destination string
  *
  *  This function pulls the string back out of the attribute and will place
- *  it in the array pointed by by string.  It will return success if provided
+ *  it in the array pointed by string.  It will return success if provided
  *  with a valid pointers.
  **/
 static s32 fm10k_tlv_attr_get_null_string(u32 *attr, unsigned char *string)
@@ -584,7 +584,7 @@ s32 fm10k_tlv_msg_parse(struct fm10k_hw *hw, u32 *msg,
  *  @mbx: Unused mailbox pointer
  *
  *  This function is a default handler for unrecognized messages.  At a
- *  a minimum it just indicates that the message requested was
+ *  minimum it just indicates that the message requested was
  *  unimplemented.
  **/
 s32 fm10k_tlv_msg_error(struct fm10k_hw __always_unused *hw,
-- 
2.36.1

