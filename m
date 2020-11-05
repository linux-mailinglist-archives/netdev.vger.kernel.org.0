Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5B2A87C3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKEUM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:12:58 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18612 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEUM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:12:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45cce0000>; Thu, 05 Nov 2020 12:13:02 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:12:57 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 01/12] net/mlx5: DR, Remove unused member of action struct
Date:   Thu, 5 Nov 2020 12:12:31 -0800
Message-ID: <20201105201242.21716-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105201242.21716-1-saeedm@nvidia.com>
References: <20201105201242.21716-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607182; bh=4GQKcM14tDuVeMtQrmbo5SDv7m1IcwmRx3JFpApD58Y=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=IfFbfY+u9Cslw8YKnDhPMCH4dNHrqFlgO+ISwj1tQLmMyHKYgz47xTe06ln9AeA3Q
         Lhly9BLijtkX81dMtSQUWH3RaIOoGAcMb6JaATydIanWJr+oe57dk1Z+/TpCUXLiqT
         chPx13jTGApq3qy/ABvBtS6tEMcQy0zuTXvANA3ROcvHLaqvKQARgyXm2evRBgfT0I
         CY5kMbAhFWvkdMWg4daeZDnNq5ZrShCR/Jp9A/dSc7WcpOXkA5R3281Kp3X+av37ud
         bz0hZPXPdiobJ3Tqf4XCYYairxIu6/17GxjSR0Yko10xRubxcK5qnxZQUeFoNaBZV/
         tyXcGTUARxZWw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Struct mlx5dr_action doesn't use this member

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index f50f3b107aa3..5caf082b7000 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -731,7 +731,6 @@ struct mlx5dr_action {
 			struct mlx5dr_domain *dmn;
 			struct mlx5dr_icm_chunk *chunk;
 			u8 *data;
-			u32 data_size;
 			u16 num_of_actions;
 			u32 index;
 			u8 allow_rx:1;
--=20
2.26.2

