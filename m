Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25A26B043
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgIOWGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgIOU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:00 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1E75218AC;
        Tue, 15 Sep 2020 20:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201556;
        bh=mnWL4epkwahZXwb5sMm7g3MNbSHtWRYyjgtoMAdPtsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZD03Qq5+VRe67FZ44ckksUMD0HDPBu/0nBT6VJ7DQTT75V/AI4jaJwwe9wKL916lG
         gPIrZQ1ijmT+9/vVgv2ociWXQ4XvWRy/E+zoivkMf71BEogOFn7kV9NHNXExi6T/oA
         uyntlLgTa/DFI+ObSDzDoRvJNevP/OEL9Pd/4qNI=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: Rename ptp clock info
Date:   Tue, 15 Sep 2020 13:25:21 -0700
Message-Id: <20200915202533.64389-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Fix a typo in ptp_clock_info naming: mlx5_p2p -> mlx5_ptp.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index a07aeb97d027..b62daf7b9a5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -441,7 +441,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
-	.name		= "mlx5_p2p",
+	.name		= "mlx5_ptp",
 	.max_adj	= 100000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
-- 
2.26.2

