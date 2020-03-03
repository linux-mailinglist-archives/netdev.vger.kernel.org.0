Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E07B177088
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbgCCHym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:54:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33258 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgCCHym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 02:54:42 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1j92Nx-0000Eq-QV; Tue, 03 Mar 2020 07:54:37 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: fix spelling mistake "backpessure" -> "backpressure"
Date:   Tue,  3 Mar 2020 07:54:37 +0000
Message-Id: <20200303075437.6704-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 80b1e39b0768..36953d4f51c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -393,7 +393,7 @@ int rvu_mbox_handler_nix_bp_enable(struct rvu *rvu,
 
 	for (chan = chan_base; chan < (chan_base + req->chan_cnt); chan++) {
 		if (bpid < 0) {
-			dev_warn(rvu->dev, "Fail to enable backpessure\n");
+			dev_warn(rvu->dev, "Fail to enable backpressure\n");
 			return -EINVAL;
 		}
 
-- 
2.25.0

