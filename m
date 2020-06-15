Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F071F916B
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFOI3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:29:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59096 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgFOI3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:29:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jkkUS-0001Hr-70; Mon, 15 Jun 2020 08:29:12 +0000
From:   Colin King <colin.king@canonical.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: axienet: fix spelling mistake in comment "Exteneded" -> "extended"
Date:   Mon, 15 Jun 2020 09:29:11 +0100
Message-Id: <20200615082911.7252-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a comment. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index fbaf3c987d9c..f34c7903ff52 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -186,7 +186,7 @@
 #define XAE_RAF_TXVSTRPMODE_MASK	0x00000180 /* Tx VLAN STRIP mode */
 #define XAE_RAF_RXVSTRPMODE_MASK	0x00000600 /* Rx VLAN STRIP mode */
 #define XAE_RAF_NEWFNCENBL_MASK		0x00000800 /* New function mode */
-/* Exteneded Multicast Filtering mode */
+/* Extended Multicast Filtering mode */
 #define XAE_RAF_EMULTIFLTRENBL_MASK	0x00001000
 #define XAE_RAF_STATSRST_MASK		0x00002000 /* Stats. Counter Reset */
 #define XAE_RAF_RXBADFRMEN_MASK		0x00004000 /* Recv Bad Frame Enable */
-- 
2.27.0.rc0

