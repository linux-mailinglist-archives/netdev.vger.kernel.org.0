Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828D639ABA0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhFCUNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhFCUNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B6761403;
        Thu,  3 Jun 2021 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751120;
        bh=sfXqg1C4aq7cyHIBUfUlzv3uOL2AM1Q5c9UeLrrFjBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5Nt5WoNAXoGCfGMCNG7Hfb+ru9FzvUrO0JDwgqPtXhl0XQiIBJGE99WGNFVIe0di
         NZYgM2nt37d7DUaiugci0Nd7vT0ywisewqNAmCiF3cQn56WHD0KncGRRv/i+6c8iw+
         kh9kmPFOiAcreLlj1ryY6dPgTBOwYMUlF3ESIa5TzvrR5lIsSqNZxNoJPuTVNZUHEA
         ETnMYUkKh6avQkAeo1Ky5GnWMWYJzCrm+QBzP9PwF/EbxCONWkI/4B1q9oy/67pamA
         uAQMV8PHimWGQ7NQqKc1x786+i5XLi3ZsMzLfEiX8J8MzhPnthYP8FuiJjm8wTedzn
         uEbPmb2RTFutA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/10] net/mlx5: Fix duplicate included vhca_event.h
Date:   Thu,  3 Jun 2021 13:11:47 -0700
Message-Id: <20210603201155.109184-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Clean up the following includecheck warning:

./drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c: vhca_event.h is
included more than once.

No functional change.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index ef5f892aafad..500c71fb6f6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -6,7 +6,6 @@
 #include "sf.h"
 #include "mlx5_ifc_vhca_event.h"
 #include "ecpf.h"
-#include "vhca_event.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
 
-- 
2.31.1

