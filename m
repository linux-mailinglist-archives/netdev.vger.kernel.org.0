Return-Path: <netdev+bounces-11604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29629733AA3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7DB728190D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC47722617;
	Fri, 16 Jun 2023 20:11:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F9922625
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31987C433B6;
	Fri, 16 Jun 2023 20:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946310;
	bh=nXPgkbwrNlifiS7qCBawmvzF7ohYUg1L5v/ibjQUijo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfExPCFflRjLaVOs/FTbD6ZGDwgSXkt0OELjbZmvxXT3cQ68aWcZnFGlnJ3FvzJG/
	 //SRnmPRAtXUcXlE+b6bgRCrEn9GAvD55B+GYQ0u8ytkUOIPkkMOMfV5gEjSQ1jell
	 pWP0o0fI+uU1WCul72BChO3MWHK6ujcRf30OPspQsFqJNP64032twG266QYXauUAfh
	 KnHO6fq7kv1oKauai/Dg3bYXufWZjh9o6dQ2wcHpr15JQGeUBAaXnmiZ+PX2OD0Dwc
	 KgfnwiPY3U3rKvNbm7ET5RY3amV108jUjuhNxez8DZhBPW4oo8C0lxCt8azpSprDNG
	 qQQkojipkFjZg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Remove unused ecpu field from struct mlx5_sf_table
Date: Fri, 16 Jun 2023 13:11:13 -0700
Message-Id: <20230616201113.45510-16-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

"ecpu" field in struct mlx5_sf_table is not used anywhere. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 9c02e5ea797c..6a3fa30b2bf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -28,7 +28,6 @@ struct mlx5_sf_table {
 	struct mutex sf_state_lock; /* Serializes sf state among user cmds & vhca event handler. */
 	struct notifier_block esw_nb;
 	struct notifier_block vhca_nb;
-	u8 ecpu: 1;
 };
 
 static struct mlx5_sf *
-- 
2.40.1


