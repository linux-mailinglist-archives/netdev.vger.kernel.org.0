Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4669A18324E
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgCLOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:05:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39599 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLOF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:05:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jCOSh-0003r3-17; Thu, 12 Mar 2020 14:05:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sameeh Jubran <sameehj@amazon.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ena: ethtool: clean up minor indentation issue
Date:   Thu, 12 Mar 2020 14:05:22 +0000
Message-Id: <20200312140522.1125768-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented incorrectly, remove a space.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 552d4cbf6dbd..9cc28b4b2627 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -221,7 +221,7 @@ static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 
 			snprintf(*data, ETH_GSTRING_LEN,
 				 "queue_%u_tx_%s", i, ena_stats->name);
-			 (*data) += ETH_GSTRING_LEN;
+			(*data) += ETH_GSTRING_LEN;
 		}
 		/* Rx stats */
 		for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
-- 
2.25.1

