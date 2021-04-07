Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B135623F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhDGEGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhDGEGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:06:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957A46124C;
        Wed,  7 Apr 2021 04:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617768400;
        bh=tYzi6odQOBXJ1zHSblh6CgRouVe1ST56Md/BqAuaE30=;
        h=From:To:Cc:Subject:Date:From;
        b=AjI3IAB+n2sp81PyuSfrGruFqzV5o/VU47CclZe4LpwZGs9HC4nV+euhYyfPYVKfF
         QTEYpZWcGKwK1G+8FAvfzAEbdqCr+s3oRHIqrCmzc34fhLqWICDtbccv7tJu+FZorU
         JrFaoFPvEwuqmYFt4BFl0ADplMwlijK5oUPATwiVC/O2hfKAPkclVrhjtVfWc0tCsd
         0CYllXlOTWmreXmXqFSu15AMFRUyc/9WgsrmJfE/cSRXetoFv67kLO/gExNosZDuT2
         bDdU8sr09abh9YWkm4YNyntVGKAUf4iB5FdXyw/OVbolns5xKfSh/ikbkEotkBXlMd
         lSv86dtVBIrkw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/5] mlx5 fixes 2021-04-06
Date:   Tue,  6 Apr 2021 21:06:15 -0700
Message-Id: <20210407040620.96841-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 5219d6012d46ec1fa3397e50bfeb7b8c16df72cf:

  docs: ethtool: fix some copy-paste errors (2021-04-06 16:55:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-04-06

for you to fetch changes up to d5f9b005c3062d6d96872896b695e5116b921f52:

  net/mlx5: fix kfree mismatch in indir_table.c (2021-04-06 21:04:36 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-04-06

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Fix PPLM register mapping
      net/mlx5: Fix PBMC register mapping

Eli Cohen (1):
      net/mlx5: Fix HW spec violation configuring uplink

Raed Salem (1):
      net/mlx5: Fix placement of log_max_flow_counter

Xiaoming Ni (1):
      net/mlx5: fix kfree mismatch in indir_table.c

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c          |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c | 10 +++++-----
 include/linux/mlx5/mlx5_ifc.h                             | 10 ++++++----
 3 files changed, 14 insertions(+), 11 deletions(-)
