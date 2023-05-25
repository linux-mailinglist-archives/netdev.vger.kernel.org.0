Return-Path: <netdev+bounces-5215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B98871038B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E79E51C20E62
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CE4C136;
	Thu, 25 May 2023 03:49:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC01C12E
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0A0C4339E;
	Thu, 25 May 2023 03:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986564;
	bh=yzCTv1N/GekGCVxIOAy1SBV+DJp1IXHRmLY/VdOTR2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvIbc+v8AdUR3srQ+bwykzKfKt4am7+uHOzhEVJwCgYwwuISvxpvsj90QP8lR69jG
	 VLWxPJ2b24CmB9nffss98A34BRtzBLvVzsujuBc2rhbswQ9qo4koBYaTj2lblKUw31
	 cBIQ7Hauxpwp1KWb0WvXInvopWGMw04CUw0rBonJyNGizTuE+ruNS2efTJ72MqQ1Nj
	 HJ5B7+ZsGf4wn08uQJhikSO/ijg6zrZP7q1d72o51tNR0PZl0V3Dzc887DrTP9MkuU
	 ipgns43R1arkqkOVJmZJ+UvnFGSFJ2HD3l47uTX6MwZVJj3x5DFEB6NZkr4qwh/Z24
	 Z6WEK8tEgqdAA==
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
	Simon Horman <simon.horman@corigine.com>,
	Daniel Machon <daniel.machon@microchip.com>
Subject: [net 15/17] Documentation: net/mlx5: Use bullet and definition lists for vnic counters description
Date: Wed, 24 May 2023 20:48:45 -0700
Message-Id: <20230525034847.99268-16-saeed@kernel.org>
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

"vnic reporter" section contains unformatted description for vnic
counters, which is rendered as one long paragraph instead of list.

Use bullet and definition lists to match other lists.

Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst        | 36 ++++++++++---------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 0f0598caea14..00687425d8b7 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -265,22 +265,26 @@ It is responsible for querying the vnic diagnostic counters from fw and displayi
 them in realtime.
 
 Description of the vnic counters:
-total_q_under_processor_handle: number of queues in an error state due to
-an async error or errored command.
-send_queue_priority_update_flow: number of QP/SQ priority/SL update
-events.
-cq_overrun: number of times CQ entered an error state due to an
-overflow.
-async_eq_overrun: number of times an EQ mapped to async events was
-overrun.
-comp_eq_overrun: number of times an EQ mapped to completion events was
-overrun.
-quota_exceeded_command: number of commands issued and failed due to quota
-exceeded.
-invalid_command: number of commands issued and failed dues to any reason
-other than quota exceeded.
-nic_receive_steering_discard: number of packets that completed RX flow
-steering but were discarded due to a mismatch in flow table.
+
+- total_q_under_processor_handle
+        number of queues in an error state due to
+        an async error or errored command.
+- send_queue_priority_update_flow
+        number of QP/SQ priority/SL update events.
+- cq_overrun
+        number of times CQ entered an error state due to an overflow.
+- async_eq_overrun
+        number of times an EQ mapped to async events was overrun.
+        comp_eq_overrun number of times an EQ mapped to completion events was
+        overrun.
+- quota_exceeded_command
+        number of commands issued and failed due to quota exceeded.
+- invalid_command
+        number of commands issued and failed dues to any reason other than quota
+        exceeded.
+- nic_receive_steering_discard
+        number of packets that completed RX flow
+        steering but were discarded due to a mismatch in flow table.
 
 User commands examples:
 
-- 
2.40.1


