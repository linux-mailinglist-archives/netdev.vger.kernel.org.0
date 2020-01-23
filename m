Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE97145FA3
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAWAHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:07:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52117 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWAHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:07:12 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQ1b-00023W-PA; Thu, 23 Jan 2020 00:07:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 00:07:07 +0000
Message-Id: <20200123000707.2831321-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a netif_printk message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ef8037d0b52e..115dfa2ffabd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1758,7 +1758,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL) {
 		if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-				     "Header in small, %d bytes in large. Chain large to small!\n",
+				     "Header in small, %d bytes in large. Chain large too small!\n",
 				     length);
 			/*
 			 * The data is in a single large buffer.  We
-- 
2.24.0

