Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FD0466ED3
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhLCA7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60570 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhLCA7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 991F96291C
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C0C00446;
        Fri,  3 Dec 2021 00:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492985;
        bh=ClyDPE3AhT9iiNPpQlJd66T1LHVJ5zqufpSAXCmnASo=;
        h=From:To:Cc:Subject:Date:From;
        b=n8nmXy2EDIZmfq5oggVXnm2rk0wlsaXlkhrxk0z9ITVUMX/JS1EBCHcDpAi0i2R/g
         Qdhtw/A8Vq9fnj8r7e/SVOSmbnadAmm5Q9Nvyy5M0DjzG09PZMlzwqc7COj5LTjYzl
         cCiKJCBq/T2XthDG9geffX3smVg3u0bJTj6sRZt2ilxACuaymO6SCj1GnytvqyR38F
         f/pR0PdlYQrlvbry5KfU532nm1cg6f6tMl/yMekwMjCTbPcMaRd0exe43PT0afFQaN
         BIZcs95gBLarqlUlj912GQJkbmGvMXBQ6YIJzJcWW7mRXEbyDxpkqh9wF8xAoxTDDS
         92Y/bVXJJrodg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next v0 00/14] mlx5 updates 2021-12-02
Date:   Thu,  2 Dec 2021 16:56:08 -0800
Message-Id: <20211203005622.183325-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit fc993be36f9ea7fc286d84d8471a1a20e871aad4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-12-02 11:44:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-12-02

for you to fetch changes up to b247f32aecad09e6cf7edff7739e6f2c9dc5fca9:

  net/mlx5: Dynamically resize flow counters query buffer (2021-12-02 16:53:16 -0800)

----------------------------------------------------------------
mlx5-updates-2021-12-02

Misc updates to mlx5 driver

1) Various code cleanups
2) Error path handling fixes of latest features
3) Print more information on pci error handling
4) Dynamically resize flow counters query buffer

----------------------------------------------------------------
Arnd Bergmann (2):
      mlx5: fix psample_sample_packet link error
      mlx5: fix mlx5i_grp_sw_update_stats() stack usage

Avihai Horon (1):
      net/mlx5: Dynamically resize flow counters query buffer

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, clean MLX5E_MAX_KLM_PER_WQE macro

Christophe JAILLET (1):
      net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'

Dan Carpenter (1):
      net/mlx5: SF, silence an uninitialized variable warning

Roi Dayan (5):
      net/mlx5e: TC, Remove redundant action stack var
      net/mlx5e: Remove redundant actions arg from validate_goto_chain()
      net/mlx5e: Remove redundant actions arg from vlan push/pop funcs
      net/mlx5e: TC, Move common flow_action checks into function
      net/mlx5e: TC, Set flow attr ip_version earlier

Saeed Mahameed (1):
      net/mlx5: Print more info on pci error handlers

Tariq Toukan (1):
      net/mlx5e: Hide function mlx5e_num_channels_changed

Wei Yongjun (1):
      net/mlx5: Fix error return code in esw_qos_create()

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 175 ++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  74 +++++++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  51 ++++--
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |   2 +-
 include/linux/mlx5/driver.h                        |   4 +
 12 files changed, 202 insertions(+), 127 deletions(-)
