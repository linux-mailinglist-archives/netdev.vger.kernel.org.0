Return-Path: <netdev+bounces-5216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAD571038C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06BC4280AB0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85CAAC12E;
	Thu, 25 May 2023 03:49:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02F6C132
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE55C433A0;
	Thu, 25 May 2023 03:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986565;
	bh=+GtXwL5y1lfdf/H2oov5liG6NYvFRIunK67c9yV1wd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CextybMoDE2s9tDIpouKY/OR8xB/bM7eD9z7XQkr6NpQciGc4msc4JXeJu4Zf0uE/
	 T5S5XxXcPivAPuB2YMrx2RFVHu6n6/TfU3nHuD94aQlPRFdlQd3ekEw7FafuWzR71r
	 I5DAGRydp9dGHfB7yXj5S3YSiwJkfOXeHHb0KRCQHL9kqURX2FhJ+hsqoJSfRZaH4W
	 KkmQ5qzu2Vh8giFjr5QMCz4i9lXjrYD/Cu7rZLtE5Y6T8kUtaX1wGIRCIrKocdJlZt
	 U5NqanwkXJpO6BrGnk01rQjISbdkDcoLnXiLaFdBpiXOfzL0XNQmbw1q7YPfK+WOpF
	 DtBqH5fhF0ZCA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [net 16/17] Documentation: net/mlx5: Add blank line separator before numbered lists
Date: Wed, 24 May 2023 20:48:46 -0700
Message-Id: <20230525034847.99268-17-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bagas Sanjaya <bagasdotme@gmail.com>

The doc forgets to add separator before numbered lists, which causes the
lists to be appended to previous paragraph inline instead.

Add the missing separator.

Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5/devlink.rst           | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 00687425d8b7..f962c0975d84 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -40,6 +40,7 @@ flow_steering_mode: Device flow steering mode
 ---------------------------------------------
 The flow steering mode parameter controls the flow steering mode of the driver.
 Two modes are supported:
+
 1. 'dmfs' - Device managed flow steering.
 2. 'smfs' - Software/Driver managed flow steering.
 
@@ -99,6 +100,7 @@ between representors and stacked devices.
 By default metadata is enabled on the supported devices in E-switch.
 Metadata is applicable only for E-switch in switchdev mode and
 users may disable it when NONE of the below use cases will be in use:
+
 1. HCA is in Dual/multi-port RoCE mode.
 2. VF/SF representor bonding (Usually used for Live migration)
 3. Stacked devices
-- 
2.40.1


