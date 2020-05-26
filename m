Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A011CBAC3
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgEHWdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:33:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53789 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgEHWdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:33:24 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXBYY-0008QO-3i; Fri, 08 May 2020 22:33:22 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/atheros: remove redundant assignment to variable size
Date:   Fri,  8 May 2020 23:33:21 +0100
Message-Id: <20200508223321.483485-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable size is being assigned with a value that is never read,
the assignment is redundant and cab be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 271e7034fa70..b35fcfcd692d 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1042,7 +1042,7 @@ static s32 atl1_setup_ring_resources(struct atl1_adapter *adapter)
 	 * each ring/block may need up to 8 bytes for alignment, hence the
 	 * additional 40 bytes tacked onto the end.
 	 */
-	ring_header->size = size =
+	ring_header->size =
 		sizeof(struct tx_packet_desc) * tpd_ring->count
 		+ sizeof(struct rx_free_desc) * rfd_ring->count
 		+ sizeof(struct rx_return_desc) * rrd_ring->count
-- 
2.25.1

