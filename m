Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B624F552D02
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbiFUI1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiFUI1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:27:50 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F00CA444;
        Tue, 21 Jun 2022 01:27:41 -0700 (PDT)
X-QQ-mid: bizesmtp63t1655799963tih337vy
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 16:25:56 +0800 (CST)
X-QQ-SSF: 01000000007000109000B00A0000000
X-QQ-FEAT: EbWlFiDChHPYfU5yL6223QxbRZgfR1rtB43QG8V5Y7Z2MVodubW05u6ah+dI/
        3d49daniGvuu5+3qEQ8bNjMDL1XKeplZV0Lb/zJQmboLN3Hj3g3Je/aGanv0f/cAdxj05KR
        63khFKXwieh3DmbsQQg1jOzH4izzfk90u/P00FNaMVeA+Rj3y/Fcc57uQ89tfcm/LjXACen
        zIAfl/3M1Q3iqx3vFRIQodrB3BPJx4yxQf1UE40yWQN4nxShLBuY+ruDPxub4Tdt+jgetVT
        ZWjMDmWYJPO9G3MC5PTRCFqA8XXcwKWAuJq69kri2qkARwW+32zwuf6OMdAWWHwTsNG1iht
        w1dXSIC
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
Subject: [PATCH] ixgbe: remove unexpected word "the"
Date:   Tue, 21 Jun 2022 16:25:54 +0800
Message-Id: <20220621082554.52380-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word "the" in the comments that need to be removed

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index e4b50c7781ff..35c2b9b8bd19 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1737,7 +1737,7 @@ static s32 ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
  * @speed: link speed
  * @autoneg_wait_to_complete: unused
  *
- * Configure the the integrated PHY for native SFP support.
+ * Configure the integrated PHY for native SFP support.
  */
 static s32
 ixgbe_setup_mac_link_sfp_n(struct ixgbe_hw *hw, ixgbe_link_speed speed,
@@ -1786,7 +1786,7 @@ ixgbe_setup_mac_link_sfp_n(struct ixgbe_hw *hw, ixgbe_link_speed speed,
  * @speed: link speed
  * @autoneg_wait_to_complete: unused
  *
- * Configure the the integrated PHY for SFP support.
+ * Configure the integrated PHY for SFP support.
  */
 static s32
 ixgbe_setup_mac_link_sfp_x550a(struct ixgbe_hw *hw, ixgbe_link_speed speed,
-- 
2.17.1

