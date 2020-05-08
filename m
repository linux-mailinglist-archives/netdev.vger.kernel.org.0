Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD91CBAD3
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgEHWk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:40:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53839 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEHWk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:40:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXBfO-0000aA-Sy; Fri, 08 May 2020 22:40:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cnic: remove redundant assignment to variable ret
Date:   Fri,  8 May 2020 23:40:26 +0100
Message-Id: <20200508224026.483746-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being assigned with a value that is never read,
the assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/broadcom/cnic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 61ab7d21f6bd..c5cca63b8571 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -1918,7 +1918,6 @@ static int cnic_bnx2x_iscsi_ofld1(struct cnic_dev *dev, struct kwqe *wqes[],
 	ret = cnic_alloc_bnx2x_conn_resc(dev, l5_cid);
 	if (ret) {
 		atomic_dec(&cp->iscsi_conn);
-		ret = 0;
 		goto done;
 	}
 	ret = cnic_setup_bnx2x_ctx(dev, wqes, num);
-- 
2.25.1

