Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE80561B07
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiF3NJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiF3NJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:09:56 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52062018E;
        Thu, 30 Jun 2022 06:09:50 -0700 (PDT)
X-QQ-mid: bizesmtp85t1656594566tf465dwr
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 21:09:23 +0800 (CST)
X-QQ-SSF: 0100000000200090C000B00A0000000
X-QQ-FEAT: pqOtrSRu7rgUfzKv/youfEcgC7ibWgG5pXDp/heAIehzNCz6k4+ffbWqRLRit
        49YVq2b4nyUuNP1rUrkC1ZTC7uARepKM68Fbd2OEbQEEJSeOxyz6O2El1pW4dMEYBm2bajv
        Z/2U0EzcyuJeAUMI8sqPkNiefIv5rXRBTyDegvPyJcTo30LLL6Ar8utjlsB8XlsjMA8ePPd
        0gGuicn+eN2XSfnylx8SaHm3u3OYV6x5PONsjFbFfq+Wm+B0ZBbRkVmQu3KzDnv4PbGnUmz
        wQ5OltvUfj1VxhjZkiOx39Co6A2cOMANFNlEHkFJSqg/jb4SOQQ42XByBtLtC49GMSgHXlO
        wlAYdZgjspItM+Ey+bSt2qy+pGivA==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/sun: fix repeated words in comments
Date:   Thu, 30 Jun 2022 21:09:16 +0800
Message-Id: <20220630130916.21074-1-yuanjilin@cdjrlc.com>
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
Delete the redundant word 'is'.
Delete the redundant word 'start'.
Delete the redundant word 'checking'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/sun/cassini.c | 2 +-
 drivers/net/ethernet/sun/cassini.h | 2 +-
 drivers/net/ethernet/sun/ldmvsw.c  | 2 +-
 drivers/net/ethernet/sun/sungem.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 435dc00d04e5..0b08b0e085e8 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -29,7 +29,7 @@
  *  -- on page reclamation, the driver swaps the page with a spare page.
  *     if that page is still in use, it frees its reference to that page,
  *     and allocates a new page for use. otherwise, it just recycles the
- *     the page.
+ *     page.
  *
  * NOTE: cassini can parse the header. however, it's not worth it
  *       as long as the network stack requires a header copy.
diff --git a/drivers/net/ethernet/sun/cassini.h b/drivers/net/ethernet/sun/cassini.h
index ae5f05f03f88..2d91f4936d52 100644
--- a/drivers/net/ethernet/sun/cassini.h
+++ b/drivers/net/ethernet/sun/cassini.h
@@ -764,7 +764,7 @@
  * PAUSE thresholds defined in terms of FIFO occupancy and may be translated
  * into FIFO vacancy using RX_FIFO_SIZE. setting ON will trigger XON frames
  * when FIFO reaches 0. OFF threshold should not be > size of RX FIFO. max
- * value is is 0x6F.
+ * value is 0x6F.
  * DEFAULT: 0x00078
  */
 #define  REG_RX_PAUSE_THRESH               0x4020  /* RX pause thresholds */
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 6b59b14e74b1..0cd8493b810f 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -335,7 +335,7 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	port->tsolen = 0;
 
 	/* Mark the port as belonging to ldmvsw which directs the
-	 * the common code to use the net_device in the vnet_port
+	 * common code to use the net_device in the vnet_port
 	 * rather than the net_device in the vnet (which is used
 	 * by sunvnet). This bit is used by the VNET_PORT_TO_NET_DEVICE
 	 * macro.
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 45bd89153de2..a14591b41acb 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1088,7 +1088,7 @@ static netdev_tx_t gem_start_xmit(struct sk_buff *skb,
 		netif_stop_queue(dev);
 
 		/* netif_stop_queue() must be done before checking
-		 * checking tx index in TX_BUFFS_AVAIL() below, because
+		 * tx index in TX_BUFFS_AVAIL() below, because
 		 * in gem_tx(), we update tx_old before checking for
 		 * netif_queue_stopped().
 		 */
-- 
2.36.1

