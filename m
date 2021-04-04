Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F183353673
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhDDEU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236644AbhDDEUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A4961364;
        Sun,  4 Apr 2021 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510011;
        bh=0sQk2rED7ua4Zv1AmLu5MFEokAQzvO+gTl07wNQfyAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6wDkwRADPZkAEXbMMQ5pUfgCxNCffbla4zr+GM6BeMS+wlMvCzjNfFwcz0AEdNN0
         c+2/0WuPkowWAtJch/5wUuvz4IXtfDExAgtjFtxUiQio5VNdK9Fhtr6oI9cSsxo2qN
         XdG9GKZ0+IYEXeE+2IzXNV/MHHZNjv/QTBTLRNyRIczIk7zKi8sQVasHriOmUOE1lR
         IcakKZIxFt7xUtSq7zjojuPAFNNywAToygDcrvGzQY/l4eIvSb7quFKneazNVFz7Tf
         XSjYAGxml/s3y0y/OPp4kgJjLfCvW50jAVVHVlkmv152FObbO3CZcZEEEDI7Em5q84
         NjbOfRqxIOv+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5: E-Switch, move QoS specific fields to existing qos struct
Date:   Sat,  3 Apr 2021 21:19:50 -0700
Message-Id: <20210404041954.146958-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Function QoS related fields are already defined in qos related struct.
min and max rate are left out to mlx5_vport_info struct.

Move them to existing qos struct.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 5d50b127f81a..64db903068c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -120,8 +120,6 @@ struct mlx5_vport_info {
 	u16                     vlan;
 	u64                     node_guid;
 	int                     link_state;
-	u32                     min_rate;
-	u32                     max_rate;
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
-- 
2.30.2

