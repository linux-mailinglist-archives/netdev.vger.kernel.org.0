Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4A42CCDE1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgLCEWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16588 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCEWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867ca0001>; Wed, 02 Dec 2020 20:21:30 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:29 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 11/15] net/mlx5e: Remove duplicated include
Date:   Wed, 2 Dec 2020 20:21:04 -0800
Message-ID: <20201203042108.232706-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969290; bh=dj8guV+wrgaT2jD/AtSbHDO3UKabZI3Hten1gHfEDnM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Vfdvv3Eg0z247iP22+5RCJdNPbm2DtwJNYrLsYxJ0QCK310mYlwRlhjOeHzavBTzx
         jYiufRABYxS/7Kn1tLn7W6fY+ezKG9FY6/czVUbgxEde77qeZ4PGjffpbjExT5NR9e
         iqus1Nc6RgHy4zTq8hzuzzeFkfbJ8Eo8lPA7jVd9NFBIQUvqHAjiamP2zrVTE4rYJo
         Q99EZRM3nHSMUbh21stgvMZiIALDKsWs9Itl2FChwGOzLR/k/vBJ/PxBTdhVxpWpGF
         RdfsJGFZvM/ONKmICKEaX08LMGY+ErmJfh56ldE4ByvYJX4PFNWQ2QLNjT7vopPbot
         6mHSNvD6IMNxg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 5c0015024f62..7f5851c61218 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -52,7 +52,6 @@
 #include "en/xsk/rx.h"
 #include "en/health.h"
 #include "en/params.h"
-#include "en/txrx.h"
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info=
 *wi,
--=20
2.26.2

