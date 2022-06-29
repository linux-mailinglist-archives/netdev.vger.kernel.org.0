Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28FD560265
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiF2ORp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiF2ORo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:17:44 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5EB3152D;
        Wed, 29 Jun 2022 07:17:39 -0700 (PDT)
X-QQ-mid: bizesmtp83t1656512237tjzkwm5b
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:17:14 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: dLvv507TVpQIdL/x1ynPIdYqh6JthnLEqmtvph9RisMObet0dM2sNVX/jylm1
        QZca3Y4gSGvPO5ZZAdzDnJvziKtQ7OYo4kdUrkEX7iM5G7OOuvcG0K+3tah9eUtxCopP0d7
        oC4Jv5ydP8ZtCDPteglIWbEPjPUj97i8+Ri9ptm5dZv8LpnbSCENnhQGuz6XqPGEPHxk1Ce
        axK54lvVY+DOOXfitZqbb4TEY0VtKllR7ZgL/8QJRwgQw0t7mAsuTodhNP8WqYhMQmEoJho
        ms590Gl0hZSvYzPYmd+K9p2Ppb61e8iq7zUj5/J8dDGwa5fHDhD1I9OzLyR9aFwl4uNrNzL
        4246+LHzORggWq1Xxg=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/igb:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:17:08 +0800
Message-Id: <20220629141708.13292-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,RCVD_IN_VALIDITY_RPBL,
        RDNS_DYNAMIC,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.
Delete the redundant word 'frames'.
Delete the redundant word 'set'.
Delete the redundant word 'slot'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c   | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

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
diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index 1277c5c7d099..205d577bdbba 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -854,7 +854,7 @@ s32 igb_force_mac_fc(struct e1000_hw *hw)
 	 *      1:  Rx flow control is enabled (we can receive pause
 	 *          frames but not send pause frames).
 	 *      2:  Tx flow control is enabled (we can send pause frames
-	 *          frames but we do not receive pause frames).
+	 *          but we do not receive pause frames).
 	 *      3:  Both Rx and TX flow control (symmetric) is enabled.
 	 *  other:  No other values should be possible at this point.
 	 */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 68be2976f539..85e8de511d35 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1945,7 +1945,7 @@ static void igb_setup_tx_mode(struct igb_adapter *adapter)
 		 * However, when we do so, no frame from queue 2 and 3 are
 		 * transmitted.  It seems the MAX_TPKT_SIZE should not be great
 		 * or _equal_ to the buffer size programmed in TXPBS. For this
-		 * reason, we set set MAX_ TPKT_SIZE to (4kB - 1) / 64.
+		 * reason, we set MAX_ TPKT_SIZE to (4kB - 1) / 64.
 		 */
 		val = (4096 - 1) / 64;
 		wr32(E1000_I210_DTXMXPKTSZ, val);
@@ -9519,7 +9519,7 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
 		igb_down(adapter);
 	pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.36.1

