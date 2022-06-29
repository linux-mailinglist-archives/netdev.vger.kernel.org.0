Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A6A560229
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiF2OJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiF2OJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:09:19 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F862CE04;
        Wed, 29 Jun 2022 07:09:13 -0700 (PDT)
X-QQ-mid: bizesmtp81t1656511724tmnezqd5
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:08:41 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: y2OO40a4AzmIkPvMMO+8zp90V7tISQjlfMlK8bG+VXPAGbG+CmCTdIJtZ39e+
        BNrwSfITeV/DWkRTKp9r5mCteLOeiTIW4v5OxMfy0ggwa6vKkYwSLa/0YIcryEc1iRATj0R
        hxkbzXDekwzETCqRx41FsIv6Wc3upXmUC+tR+edTxo1kgZmtDiWXR/l282G1cW90GHUBniw
        x+poVA+T/sM6FADE50vvekN+b+M/7yrIX4++osPVzBEDs712stcqsrHJvCZR+I5PeBTU8hF
        59zfW5qHwPOhjh0fMlYZiuE82RexfcE9e8eZNgukkBv4FWmy4SGinHAkhYSGLxdwzW1HW05
        ENaN8De0tBUTkI2cBg=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/ice:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:08:24 +0800
Message-Id: <20220629140824.6064-1-yuanjilin@cdjrlc.com>
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
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index c73cdab44f70..ada5198b5b16 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2639,7 +2639,7 @@ ice_ptg_remove_ptype(struct ice_hw *hw, enum ice_block blk, u16 ptype, u8 ptg)
  *
  * This function will either add or move a ptype to a particular PTG depending
  * on if the ptype is already part of another group. Note that using a
- * a destination PTG ID of ICE_DEFAULT_PTG (0) will move the ptype to the
+ * destination PTG ID of ICE_DEFAULT_PTG (0) will move the ptype to the
  * default PTG.
  */
 static int
-- 
2.36.1


