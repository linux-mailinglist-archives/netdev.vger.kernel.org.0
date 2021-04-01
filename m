Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91443351B49
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhDASHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:07:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15461 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbhDASAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:00:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FB3QS6vfnzqSHM;
        Thu,  1 Apr 2021 21:08:16 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 21:10:12 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 0/3] net/mlx5: Fix some coding-style issues
Date:   Thu, 1 Apr 2021 21:07:40 +0800
Message-ID: <1617282463-47124-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just make some cleanups according to the coding style of kernel.

Wenpeng Liang (3):
  net/mlx5: Add a blank line after declarations.
  net/mlx5: Remove return statement exist at the end of void function
  net/mlx5: Replace spaces with tab at the start of a line

 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c        | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c    | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c       | 1 -
 6 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.8.1

