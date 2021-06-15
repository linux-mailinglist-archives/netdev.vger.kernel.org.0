Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DC23A7585
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFOEDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhFOEDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 468B06140D;
        Tue, 15 Jun 2021 04:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729691;
        bh=IvyFx0Ci1cj9ahO05kgPwUJ6RtNchnZ+NpXMvwBS9Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfOkXFex/hvX7sRDvw3h2Rp3lIe42L5KuqI0d/+JjF341L4WiEFF6PJxxmC3ZN47T
         uy+a7VLJ+ZwHnx8AbTLEdqpMjmi40uEtwQfpX0q9gOb7izSjUByY9wQbu6yj1h5rLG
         HKzZyxlr4vbAF5+YQDfOBr71ekvK+lsmYEw0IsUR44jPygbCuAr4mlXeH55X/z4hHZ
         PWomHMeh8fANk75HHrmA5VldcOWgz+RalldO2SfrZcQDJ2onMlc3mTpGxMt5zOJqnH
         OEVxPUW0510Ly+UXuCxxxMx5kERo4e9rWLb93cEBnTKoMMfWtVLnx2qUVus/y/UtH+
         VCuzAaVUAZeBg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Clean license text in eq.[c|h] files
Date:   Mon, 14 Jun 2021 21:01:15 -0700
Message-Id: <20210615040123.287101-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The eq.[c|h] files are under major rewrite. so use this opportunity and
update their copyright and license texts.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 31 ++-----------------
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 +-
 2 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 5a88887c1a58..ef0fe499eaed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
- * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
+ * Copyright (c) 2013-2021, Mellanox Technologies inc.  All rights reserved.
  */
 
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index f618cf95e030..624cedebb510 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2018 Mellanox Technologies */
+/* Copyright (c) 2018-2021, Mellanox Technologies inc.  All rights reserved. */
 
 #ifndef __LIB_MLX5_EQ_H__
 #define __LIB_MLX5_EQ_H__
-- 
2.31.1

