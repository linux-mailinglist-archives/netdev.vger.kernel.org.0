Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B417C552D0E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347936AbiFUIeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345984AbiFUIeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:34:17 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3331C15A18;
        Tue, 21 Jun 2022 01:34:13 -0700 (PDT)
X-QQ-mid: bizesmtp84t1655800307tp96dari
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 16:31:42 +0800 (CST)
X-QQ-SSF: 01000000007000209000B00A0000000
X-QQ-FEAT: 0VgNaGdhy9i3VEgTjda6YTeTUjwUfOcImznDL6T2LXaZA2NbnSfXY1kzYj4wX
        t4P4vhDP0uFEgNKYWsiYzOWMCHw/oep9gTTRwmXEi+9fjX+I2c73H0oaXT3LQ4/fbPX8kDd
        48m7ZLETi83rkgCTaPCq5BbS5BmIlP29LhhA7xL5ua1kiuKqYg8lzawQ20Rtr0Uy0reliM2
        ndcX/2Luky4X4Pb9dsOIVx67CvUzjnLs5CWsFN47jR98iH8N3KLLGFgycF8usTl4QuS4dlK
        NOw5CnXyy2nqCB/fviIu1Rc5iqmHa6h7gMaS7k80Gyd4Ynti4HaNZWm3362I4A2QMxrWn99
        206wO8pIWtxTJWS/XI=
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
Subject: [PATCH] igb: remove unexpected word "the"
Date:   Tue, 21 Jun 2022 16:31:40 +0800
Message-Id: <20220621083140.54004-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam8
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
 drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index cbe92fd23a70..8d6e44ee1895 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2207,7 +2207,7 @@ s32 igb_write_phy_reg_82580(struct e1000_hw *hw, u32 offset, u16 data)
  *  igb_reset_mdicnfg_82580 - Reset MDICNFG destination and com_mdio bits
  *  @hw: pointer to the HW structure
  *
- *  This resets the the MDICNFG.Destination and MDICNFG.Com_MDIO bits based on
+ *  This resets the MDICNFG.Destination and MDICNFG.Com_MDIO bits based on
  *  the values found in the EEPROM.  This addresses an issue in which these
  *  bits are not restored from EEPROM after reset.
  **/
-- 
2.17.1

