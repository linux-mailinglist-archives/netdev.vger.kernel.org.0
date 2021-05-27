Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADECC3929E5
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhE0IuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbhE0Itv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72730C061342
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBge-00020H-Ky
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5420162D4F0
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 56D5F62D440;
        Thu, 27 May 2021 08:45:40 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1f50c894;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 21/21] can: m_can: fix whitespace in a few comments
Date:   Thu, 27 May 2021 10:45:32 +0200
Message-Id: <20210527084532.1384031-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

Fixes whitespace in comments titling sections of register masks.

Link: https://lore.kernel.org/r/20210504125123.500553-5-torin@maxiluxsystems.com
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ce7722229964..bba2a449ac70 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -101,7 +101,7 @@ enum m_can_reg {
 /* Test Register (TEST) */
 #define TEST_LBCK		BIT(4)
 
-/* CC Control Register(CCCR) */
+/* CC Control Register (CCCR) */
 #define CCCR_TXP		BIT(14)
 #define CCCR_TEST		BIT(7)
 #define CCCR_DAR		BIT(6)
@@ -147,18 +147,18 @@ enum m_can_reg {
 /* Timestamp Counter Value Register (TSCV) */
 #define TSCV_TSC_MASK		GENMASK(15, 0)
 
-/* Error Counter Register(ECR) */
+/* Error Counter Register (ECR) */
 #define ECR_RP			BIT(15)
 #define ECR_REC_MASK		GENMASK(14, 8)
 #define ECR_TEC_MASK		GENMASK(7, 0)
 
-/* Protocol Status Register(PSR) */
+/* Protocol Status Register (PSR) */
 #define PSR_BO		BIT(7)
 #define PSR_EW		BIT(6)
 #define PSR_EP		BIT(5)
 #define PSR_LEC_MASK	GENMASK(2, 0)
 
-/* Interrupt Register(IR) */
+/* Interrupt Register (IR) */
 #define IR_ALL_INT	0xffffffff
 
 /* Renamed bits for versions > 3.1.x */
@@ -250,7 +250,7 @@ enum m_can_reg {
 #define TXFQS_TFGI_MASK		GENMASK(12, 8)
 #define TXFQS_TFFL_MASK		GENMASK(5, 0)
 
-/* Tx Buffer Element Size Configuration(TXESC) */
+/* Tx Buffer Element Size Configuration (TXESC) */
 #define TXESC_TBDS_MASK		GENMASK(2, 0)
 #define TXESC_TBDS_64B		0x7
 
-- 
2.30.2


