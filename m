Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1881BF12E
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfIZLW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:22:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53503 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfIZLW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:22:58 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iDRrI-0004LY-Ky; Thu, 26 Sep 2019 11:22:52 +0000
From:   Colin King <colin.king@canonical.com>
To:     Netanel Belgazal <netanel@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ena: clean up indentation issue
Date:   Thu, 26 Sep 2019 12:22:52 +0100
Message-Id: <20190926112252.21498-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There memset is indented incorrectly, remove the extraneous tabs.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 38046bf0ff44..2845ac277724 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -211,8 +211,8 @@ static int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
 
 		pkt_ctrl->curr_bounce_buf =
 			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);
-			memset(io_sq->llq_buf_ctrl.curr_bounce_buf,
-			       0x0, llq_info->desc_list_entry_size);
+		memset(io_sq->llq_buf_ctrl.curr_bounce_buf,
+		       0x0, llq_info->desc_list_entry_size);
 
 		pkt_ctrl->idx = 0;
 		if (unlikely(llq_info->desc_stride_ctrl == ENA_ADMIN_SINGLE_DESC_PER_ENTRY))
-- 
2.20.1

