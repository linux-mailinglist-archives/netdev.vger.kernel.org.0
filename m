Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B95360846
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 13:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhDOLbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 07:31:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44831 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDOLbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 07:31:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lX0Cw-00061I-L2; Thu, 15 Apr 2021 11:30:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] can: etas_es58x: Fix a couple of spelling mistakes
Date:   Thu, 15 Apr 2021 12:30:50 +0100
Message-Id: <20210415113050.1942333-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in netdev_dbg and netdev_dbg messages,
fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 57e5f94468e9..8e9102482c52 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -688,7 +688,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 
 	case ES58X_ERR_PROT_STUFF:
 		if (net_ratelimit())
-			netdev_dbg(netdev, "Error BITSUFF\n");
+			netdev_dbg(netdev, "Error BITSTUFF\n");
 		if (cf)
 			cf->data[2] |= CAN_ERR_PROT_STUFF;
 		break;
@@ -1015,7 +1015,7 @@ int es58x_rx_cmd_ret_u32(struct net_device *netdev,
 			int ret;
 
 			netdev_warn(netdev,
-				    "%s: channel is already opened, closing and re-openning it to reflect new configuration\n",
+				    "%s: channel is already opened, closing and re-opening it to reflect new configuration\n",
 				    ret_desc);
 			ret = ops->disable_channel(es58x_priv(netdev));
 			if (ret)
-- 
2.30.2

