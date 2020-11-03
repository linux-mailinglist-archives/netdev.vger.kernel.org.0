Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D2E2A5058
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgKCTr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:47:59 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9507 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbgKCTr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:47:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b3f10002>; Tue, 03 Nov 2020 11:48:01 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:47:58 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/12] net/mlx5: DR, Remove unused member of action struct
Date:   Tue, 3 Nov 2020 11:47:27 -0800
Message-ID: <20201103194738.64061-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432881; bh=4GQKcM14tDuVeMtQrmbo5SDv7m1IcwmRx3JFpApD58Y=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=jvMUYncMCKzNjN+lLgQ+wwmrdRSv2iADntiLcTgS2zaDheWbzq0Dm3/uJfUoEGatv
         H1KRrqDXoTf3vK5GEX2cH3E3LwJXkBtNLpnFMpxPWZ8K8i1hDC11kPQ217QAcKEww3
         40n2QbbFU1WzDaEtBIROb0eGluHLIp7bDq58GkqkYuzHbc8MLvd3bkmO7gG0uftou/
         EDHjLbnDyRYRZbdz7oL42ktPUidhC+D4Q/MXodfMJI/g1IV88zrDIjuKVau/9Dv2x5
         VDKPWv4aV9SsbddieA47UCVCgtf88nLrfbZk9rfuRL5SZo4w5b6J2+ij6V0eFGRT+l
         sB/dGz2bbPI+Q==
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

