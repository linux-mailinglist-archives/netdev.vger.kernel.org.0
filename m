Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1159F1A4A2D
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDJTLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:11:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48118 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgDJTLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 15:11:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jMz4B-0002jz-32; Fri, 10 Apr 2020 19:11:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: neterion: remove redundant assignment to variable tmp64
Date:   Fri, 10 Apr 2020 20:11:50 +0100
Message-Id: <20200410191150.75588-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable tmp64 is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/neterion/s2io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 0ec6b8e8b549..67e62603fe3b 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -5155,7 +5155,7 @@ static int do_s2io_delete_unicast_mc(struct s2io_nic *sp, u64 addr)
 /* read mac entries from CAM */
 static u64 do_s2io_read_unicast_mc(struct s2io_nic *sp, int offset)
 {
-	u64 tmp64 = 0xffffffffffff0000ULL, val64;
+	u64 tmp64, val64;
 	struct XENA_dev_config __iomem *bar0 = sp->bar0;
 
 	/* read mac addr */
-- 
2.25.1

