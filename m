Return-Path: <netdev+bounces-5217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF407710393
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87AF72814B7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5EBD2E1;
	Thu, 25 May 2023 03:49:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB4C2E9
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34E2C433D2;
	Thu, 25 May 2023 03:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986566;
	bh=H11KldRUjV1rLQsTgyRXfZhU+ufcs0+6LW2u3vSBaIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSFsfJ9sRYpFaCHGmW62/vRpzb9RJUAJzRLbXcNOsj+aYjg/RCB6fb3F2kJr7oBJ6
	 vvAxzbZ2meZ9KO3b1p6kajkUNKwvesCFAW8CELMJmAlR6l6fhI/mNf2PZBfOq2vyCk
	 lt5DpQbB4cdY+2z1Qb6fFBRASqX6zL9OvBTfQsDd0s4hMOlxX0KWvaeknzbfHUjqEQ
	 Guntj3570ITlhCw2ZnM653aJNLoG4KDhxZ1GYaoiU34vNdaYIdYg7/g8Ir0QSEMvhn
	 zpijeLZ/GO+Hb9744e4r7SG5oM8BkWkQA2VT6GR19TL/U8+CNsWU0M3g8f0An0WiaH
	 s5S7hX7FgpZmQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [net 17/17] Documentation: net/mlx5: Wrap notes in admonition blocks
Date: Wed, 24 May 2023 20:48:47 -0700
Message-Id: <20230525034847.99268-18-saeed@kernel.org>
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

Wrap note paragraphs in note:: directive as it better fit for the
purpose of noting devlink commands.

Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst             | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index f962c0975d84..3354ca3608ee 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -182,7 +182,8 @@ User commands examples:
 
     $ devlink health diagnose pci/0000:82:00.0 reporter tx
 
-NOTE: This command has valid output only when interface is up, otherwise the command has empty output.
+.. note::
+   This command has valid output only when interface is up, otherwise the command has empty output.
 
 - Show number of tx errors indicated, number of recover flows ended successfully,
   is autorecover enabled and graceful period from last recover::
@@ -234,8 +235,9 @@ User commands examples:
 
     $ devlink health dump show pci/0000:82:00.0 reporter fw
 
-NOTE: This command can run only on the PF which has fw tracer ownership,
-running it on other PF or any VF will return "Operation not permitted".
+.. note::
+   This command can run only on the PF which has fw tracer ownership,
+   running it on other PF or any VF will return "Operation not permitted".
 
 fw fatal reporter
 -----------------
@@ -258,7 +260,8 @@ User commands examples:
 
     $ devlink health dump show pci/0000:82:00.1 reporter fw_fatal
 
-NOTE: This command can run only on PF.
+.. note::
+   This command can run only on PF.
 
 vnic reporter
 -------------
@@ -299,4 +302,5 @@ User commands examples:
 
         $ devlink health diagnose pci/0000:82:00.1/65537 reporter vnic
 
-NOTE: This command can run over all interfaces such as PF/VF and representor ports.
+.. note::
+   This command can run over all interfaces such as PF/VF and representor ports.
-- 
2.40.1


