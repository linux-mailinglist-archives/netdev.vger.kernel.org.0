Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CDB1978A8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 12:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgC3KQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 06:16:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53612 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgC3KQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 06:16:43 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jIrTD-00028t-B3; Mon, 30 Mar 2020 10:16:39 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: ethernet: ti: fix spelling mistake "rundom" -> "random"
Date:   Mon, 30 Mar 2020 11:16:39 +0100
Message-Id: <20200330101639.161268-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 97f7385c6741..f71c15c39492 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1627,7 +1627,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							   port->slave.mac_addr) ||
 			   !is_valid_ether_addr(port->slave.mac_addr)) {
 			random_ether_addr(port->slave.mac_addr);
-			dev_err(dev, "Use rundom MAC address\n");
+			dev_err(dev, "Use random MAC address\n");
 		}
 	}
 	of_node_put(node);
-- 
2.25.1

