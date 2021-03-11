Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B47336CEB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhCKHKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhCKHJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51ADC65021;
        Thu, 11 Mar 2021 07:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446580;
        bh=6kejXXHLYCIsl1/508ZhXZvXg+EIfdiZsCx6NyVsR6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3UM3UggbYSSUgtKrSmLcOEZ8DZxPdy/jFi0FICeW0i+t4N9sHY8wJKICAu2SlwLZ
         wFAlO5krJCKkIO1rHVXOsO/xS0JTjbbs7FhsMQMmnzfN+/NWqrdJqv5U8uOZWr8pTd
         C1Y5iD6+pxwk5D+cq3Mdwd7on8T7fZmInbW8I9S02ManXRWolpO85VOBAJYHjb59Kx
         kpShx58Sbn4zJk8EWBtfoedLBxQowfG08cvbN1+k2PHV0dpFAhHTj8v2HVcmTyw9B1
         GJ+T0nLnfSmZM0hEpT4wiaiR8QNlKCb/6w9Tc+ibvh1fNNTpx3PQtdxwnesncWhM0I
         MVLNelR/sogAQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Mikhael Goikhman <migo@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 3/9] net/mlx5: Remove unused mlx5_core_health member recover_work
Date:   Wed, 10 Mar 2021 23:09:09 -0800
Message-Id: <20210311070915.321814-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mikhael Goikhman <migo@nvidia.com>

The code related to health->recover_work was removed in
commit 63cbc552eebf ("net/mlx5: Handle SW reset of FW in error flow")

Fix struct mlx5_core_health accordingly.

Signed-off-by: Mikhael Goikhman <migo@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/driver.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 53b89631a1d9..8fe51b4a781e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -438,7 +438,6 @@ struct mlx5_core_health {
 	unsigned long			flags;
 	struct work_struct		fatal_report_work;
 	struct work_struct		report_work;
-	struct delayed_work		recover_work;
 	struct devlink_health_reporter *fw_reporter;
 	struct devlink_health_reporter *fw_fatal_reporter;
 };
-- 
2.29.2

