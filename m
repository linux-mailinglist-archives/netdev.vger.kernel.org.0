Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8553213F3EC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389897AbgAPRKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389884AbgAPRKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8174F24683;
        Thu, 16 Jan 2020 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194617;
        bh=3wY1eNIDBl00qk/vjDIBuNUlA3VgGOqLlLdRJU7xOIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plbH3aQMaEjLLK/blVseJ2hZT9fL59A6jyvkxzHZpayWU77LEs4kFBZb3M7ajp/Dm
         wIMHxp64kJ5AikJW8Qf526tcKj9BZtqDBY87FCrsD16Pgy/+DCaNau2Fjw9CLRT7XA
         uwfLY2Kb30W4FZuFH5kjxwQ3Gq8I8+WEKO0pbVLc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Zhang <markz@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 480/671] net/mlx5: Fix mlx5_ifc_query_lag_out_bits
Date:   Thu, 16 Jan 2020 12:01:58 -0500
Message-Id: <20200116170509.12787-217-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit ea77388b02270b0af8dc57f668f311235ea068f0 ]

Remove the "reserved_at_40" field to match the device specification.

Fixes: 84df61ebc69b ("net/mlx5: Add HW interfaces used by LAG")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 177f11c96187..76b76b6aa83d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9053,8 +9053,6 @@ struct mlx5_ifc_query_lag_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
-
 	struct mlx5_ifc_lagc_bits ctx;
 };
 
-- 
2.20.1

