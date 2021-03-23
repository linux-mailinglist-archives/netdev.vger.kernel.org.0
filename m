Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A68345549
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhCWCGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:06:50 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:60042 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCWCGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:06:23 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 132D09802C6;
        Tue, 23 Mar 2021 10:06:20 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Wan Jiabing <wanjiabing@vivo.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Subject: [PATCH] net: ethernet: Remove duplicate include of vhca_event.h
Date:   Tue, 23 Mar 2021 10:05:48 +0800
Message-Id: <20210323020605.139644-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTkNNHUMYSxoYTxhMVkpNSk1PTU5KQ0tITE9VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OU06FSo4DD8IHjocLgs#Vio*
        SBBPFApVSlVKTUpNT01OSkNLTEhJVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKQktDNwY+
X-HM-Tid: 0a785cd53689d992kuws132d09802c6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhca_event.h has been included at line 4, so remove the 
duplicate one at line 8.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 58b6be0b03d7..3c8a00dd573a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -5,7 +5,6 @@
 #include "priv.h"
 #include "sf.h"
 #include "mlx5_ifc_vhca_event.h"
-#include "vhca_event.h"
 #include "ecpf.h"
 
 struct mlx5_sf_hw {
-- 
2.25.1

