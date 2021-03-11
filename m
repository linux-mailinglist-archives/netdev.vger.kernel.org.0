Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4C3380B2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhCKWh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhCKWhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B378864F8D;
        Thu, 11 Mar 2021 22:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502260;
        bh=HlHrgscsKX/ddrJhgdxGdqWExn4GZ0IQemK587HclyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLuYvE7+3akyl9KBZYgFSTOANC3Sjk+liUqP1Sy2SHkAdYKlII/f1CB0dw3L9atNH
         P5ZLyx0wBeuxHknRKeM/d5dzSRrMziRw768EujlGecXGR0MMzWK3ZlE/5q56U4OpTS
         Sfu11Qjl2ad3/O79yAtpQwwhXN2Nz4ySpUKVpsOzHW8tBJKe67pzHANOFw4FuHc2r9
         S1IQO4a5if3Lsp07sZqz6FEsHJqAeo0NoFjyPxvrDesne8Yw9c3B6nEkKn2iSh3pcu
         9xWWZLonDRtIFnCpxvUzengycdhC1wrey8h1HBz8WMLNhRi8PfQMh95IXIuXGQB2Gk
         sLEwqNFPTOS/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: SF, Fix return type
Date:   Thu, 11 Mar 2021 14:37:20 -0800
Message-Id: <20210311223723.361301-13-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Fix the following coccicheck warnings:

drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h:50:8-9: WARNING:
return of 0/1 in function 'mlx5_sf_dev_allocated' with return type bool

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
index 4de02902aef1..149fd9e698cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -47,7 +47,7 @@ static inline void mlx5_sf_driver_unregister(void)
 
 static inline bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
 {
-	return 0;
+	return false;
 }
 
 #endif
-- 
2.29.2

