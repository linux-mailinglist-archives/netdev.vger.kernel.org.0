Return-Path: <netdev+bounces-5214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C53FA710388
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81644281473
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2785ABE68;
	Thu, 25 May 2023 03:49:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C492EBE40
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A63CC433D2;
	Thu, 25 May 2023 03:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986562;
	bh=pzYW7/TO5TfOkL06J55kcW9SGcbzX4VWmdZOM5BMZFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYQyclc6JYiStMXIRpr8/WBqBvuFc+VHUl+OHY+YgTacborpUg2amSXgaGDaIdP7l
	 fMMoQjdKZCi+EzbvxLB7MKZXQuuech2dNlGLb6yMRIOkq/s0yvEss++G4NhW/lCekH
	 5h/PuNRc5Jvgvyo7VfjYlWeg0TiN+fS8oiseR+btXBVAuMkNz2TwAtKOs4tUcYpt50
	 kGO2aqa0f9il8CgM2RmGed19cj+vW1e0OZ7X7+3JUIE81MIg/8lR0REAgX+ulC5xHd
	 dhDwymxbcXG2qyOXZUASGLJTuvia2mBs3inZLcY2CBoiwqiHZl8lVkM/leFPuHM3ne
	 iDK7JwJkTo1lA==
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
Subject: [net 14/17] Documentation: net/mlx5: Wrap vnic reporter devlink commands in code blocks
Date: Wed, 24 May 2023 20:48:44 -0700
Message-Id: <20230525034847.99268-15-saeed@kernel.org>
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

Sphinx reports htmldocs warnings:

Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:287: WARNING: Unexpected indentation.
Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:288: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:290: WARNING: Unexpected indentation.

Fix above warnings by wrapping diagnostic devlink commands in "vnic
reporter" section in code blocks to be consistent with other devlink
command snippets.

Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5/devlink.rst     | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 3a7a714cc08f..0f0598caea14 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -283,10 +283,14 @@ nic_receive_steering_discard: number of packets that completed RX flow
 steering but were discarded due to a mismatch in flow table.
 
 User commands examples:
-- Diagnose PF/VF vnic counters
+
+- Diagnose PF/VF vnic counters::
+
         $ devlink health diagnose pci/0000:82:00.1 reporter vnic
+
 - Diagnose representor vnic counters (performed by supplying devlink port of the
-  representor, which can be obtained via devlink port command)
+  representor, which can be obtained via devlink port command)::
+
         $ devlink health diagnose pci/0000:82:00.1/65537 reporter vnic
 
 NOTE: This command can run over all interfaces such as PF/VF and representor ports.
-- 
2.40.1


