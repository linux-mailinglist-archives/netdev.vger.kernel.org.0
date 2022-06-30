Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9793E5613D4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiF3H62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbiF3H61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:58:27 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05AB17E02;
        Thu, 30 Jun 2022 00:58:21 -0700 (PDT)
X-QQ-mid: bizesmtp89t1656575881tmsn8kr9
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 15:57:58 +0800 (CST)
X-QQ-SSF: 0100000000200070C000C00A0000000
X-QQ-FEAT: /gZs+pYOe4QtKWcpUPh0RUNkILiDmKzOemLUmT8vQZAH1EvZkAs5EG62QC3fV
        mRim4+TvzTUa+CTiRquV9X/5m0vO5obXUifoXV0ndxT28229uEaGcD6kGauwv16wnxwz6Jk
        dYBP3C3+nLKbtQwjGZ1e7VZCWVNSfi60dUqQB94M6lMrQDUT2vnw25Thaqrb52CRX5+yQYt
        J7UKwd+9gX5p36kmwsCnkO2MkRKSmVRxefyl9LmfFDQJrzO8hPz0VlqwCf+/+FLC4ZAEPFb
        yeddFP0MtMxPGxpv4m5e6NFc0CJFTDh9M1Ng2uWUlxP9z4v2XoM74adXDJ46e6JS2j5+EAF
        1o9FYp5YXKAfNVeH2A=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jdmason@kudzu.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/neterion: fix repeated words in comments
Date:   Thu, 30 Jun 2022 15:57:51 +0800
Message-Id: <20220630075751.21211-1-yuanjilin@cdjrlc.com>
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
Delete the redundant word 'a'.
Delete the redundant word 'frame'.
Delete the redundant word 'is'.
Delete the redundant word 'not'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/neterion/s2io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 6dd451adc331..30f955efa830 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2156,7 +2156,7 @@ static int verify_xena_quiescence(struct s2io_nic *sp)
 
 	/*
 	 * In PCI 33 mode, the P_PLL is not used, and therefore,
-	 * the the P_PLL_LOCK bit in the adapter_status register will
+	 * the P_PLL_LOCK bit in the adapter_status register will
 	 * not be asserted.
 	 */
 	if (!(val64 & ADAPTER_STATUS_P_PLL_LOCK) &&
@@ -3817,7 +3817,7 @@ static irqreturn_t s2io_test_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Test interrupt path by forcing a a software IRQ */
+/* Test interrupt path by forcing a software IRQ */
 static int s2io_test_msi(struct s2io_nic *sp)
 {
 	struct pci_dev *pdev = sp->pdev;
@@ -5492,7 +5492,7 @@ s2io_ethtool_gringparam(struct net_device *dev,
 }
 
 /**
- * s2io_ethtool_getpause_data -Pause frame frame generation and reception.
+ * s2io_ethtool_getpause_data -Pause frame generation and reception.
  * @dev: pointer to netdev
  * @ep : pointer to the structure with pause parameters given by ethtool.
  * Description:
@@ -7449,7 +7449,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
  *  @link : inidicates whether link is UP/DOWN.
  *  Description:
  *  This function stops/starts the Tx queue depending on whether the link
- *  status of the NIC is is down or up. This is called by the Alarm
+ *  status of the NIC is down or up. This is called by the Alarm
  *  interrupt handler whenever a link change interrupt comes up.
  *  Return value:
  *  void.
@@ -7732,7 +7732,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	 * Setting the device configuration parameters.
 	 * Most of these parameters can be specified by the user during
 	 * module insertion as they are module loadable parameters. If
-	 * these parameters are not not specified during load time, they
+	 * these parameters are not specified during load time, they
 	 * are initialized with default values.
 	 */
 	config = &sp->config;
-- 
2.36.1

