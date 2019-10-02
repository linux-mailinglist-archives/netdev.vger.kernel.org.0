Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD047C4B2D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 12:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJBKPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 06:15:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34817 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfJBKPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 06:15:22 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iFbfB-00009Y-Vb; Wed, 02 Oct 2019 10:15:18 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libertas: remove redundant assignment to variable ret
Date:   Wed,  2 Oct 2019 11:15:17 +0100
Message-Id: <20191002101517.10836-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being assigned a value that is never read and is
being re-assigned a little later on. The assignment is redundant and hence
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index 2747c957d18c..44c8a550da4c 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -1003,7 +1003,6 @@ static int lbs_add_mesh(struct lbs_private *priv)
 	if (priv->mesh_tlv) {
 		sprintf(mesh_wdev->ssid, "mesh");
 		mesh_wdev->mesh_id_up_len = 4;
-		ret = 1;
 	}
 
 	mesh_wdev->netdev = mesh_dev;
-- 
2.20.1

