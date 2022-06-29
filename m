Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA15602FA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiF2ObL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiF2Oah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:30:37 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF41EC55;
        Wed, 29 Jun 2022 07:30:32 -0700 (PDT)
X-QQ-mid: bizesmtp86t1656513011th4nq7cj
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:30:09 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: ACkb0FcbxRk3MGc6ImTK9UmnAVdZePcX1z96KWehZyPgYCmwgwh4XGH0SK2vf
        qQnDDf2BildBdjrHleiBlFKBB3otwxfXqb9gKI9UA0TeO1rvBd7wc4LUGIKswbKXozxVmcN
        Y3X9btPWLkVVoF3+IzaSz2EH5BG3I7xkQN/CrEJ17zv6yGw5wbiEb6M72OU6111pi6x9cDs
        00YhsHRbTtHx050+5bXFjt1OuiobZkfBeWXzKWJvebSnyguR7cSLSdkScGbpdRhY5ZRrYYn
        Qn4b8dU9lTYyuuqsXkP5WfqpACzD6vovaIh9ESeTQL2AQLqYkjDMGmDLBp3dSnA8aKG6pTj
        vTd36H/Nk/pswRq0hk=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/ixgbe:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:29:52 +0800
Message-Id: <20220629142952.18664-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'for'.
Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 77c2e70b0860..23b7e1d9652e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5161,7 +5161,7 @@ static int ixgbe_hpbthresh(struct ixgbe_adapter *adapter, int pb)
 }
 
 /**
- * ixgbe_lpbthresh - calculate low water mark for for flow control
+ * ixgbe_lpbthresh - calculate low water mark for flow control
  *
  * @adapter: board private structure to calculate for
  * @pb: packet buffer to calculate
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
2.36.1

