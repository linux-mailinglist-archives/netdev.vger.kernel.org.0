Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC30516B8E
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiEBIDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383642AbiEBIC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:02:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D132CCA8
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:59:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQxn-0002Xc-M4
        for netdev@vger.kernel.org; Mon, 02 May 2022 09:59:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 42FA872E4E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:59:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D07AA72E18;
        Mon,  2 May 2022 07:59:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1e5b739c;
        Mon, 2 May 2022 07:59:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 7/9] can: ctucanfd: remove inline keyword from local static functions
Date:   Mon,  2 May 2022 09:59:12 +0200
Message-Id: <20220502075914.1905039-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502075914.1905039-1-mkl@pengutronix.de>
References: <20220502075914.1905039-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This patch removes the inline keywords from the local static functions
to make both checkpatch.pl and patchwork happy.

Link: https://lore.kernel.org/all/1fd684bcf5ddb0346aad234072f54e976a5210fb.1650816929.git.pisa@cmp.felk.cvut.cz
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
[mkl: split into separate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index be90136be442..10c2517a395b 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -132,13 +132,12 @@ static u32 ctucan_read32_be(struct ctucan_priv *priv,
 	return ioread32be(priv->mem_base + reg);
 }
 
-static inline void ctucan_write32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg,
-				  u32 val)
+static void ctucan_write32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg, u32 val)
 {
 	priv->write_reg(priv, reg, val);
 }
 
-static inline u32 ctucan_read32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg)
+static u32 ctucan_read32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg)
 {
 	return priv->read_reg(priv, reg);
 }
@@ -485,7 +484,7 @@ static int ctucan_do_set_mode(struct net_device *ndev, enum can_mode mode)
  *
  * Return: Status of TXT buffer
  */
-static inline enum ctucan_txtb_status ctucan_get_tx_status(struct ctucan_priv *priv, u8 buf)
+static enum ctucan_txtb_status ctucan_get_tx_status(struct ctucan_priv *priv, u8 buf)
 {
 	u32 tx_status = ctucan_read32(priv, CTUCANFD_TX_STATUS);
 	enum ctucan_txtb_status status = (tx_status >> (buf * 4)) & 0x7;
-- 
2.35.1


