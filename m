Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0861646473A
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346957AbhLAGks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346930AbhLAGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F1FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D684CE1D49
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F65C53FAD;
        Wed,  1 Dec 2021 06:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340641;
        bh=GFD0EyDC8x/7LxOfTc140uTc32cz/8y1rPb/CSriJT4=;
        h=From:To:Cc:Subject:Date:From;
        b=Eyiz4z2FvQLjVegOAswahNaJEvXlVv9kCHPHzPkEpHgAC3LcwI23w1UfhGUaSD9ea
         HPzNdd7rvqZ9v8yPPtYrBIUPKZr0hneJ45GHLYpKQLqbqcIhV29jGej4/tYq4jcSoQ
         H+zwXeMmBLWEH0aXDP6tUFUEJ9QEq1+10BmSjY316dY0Eu/Xlh8oOKd74Wy8rvD43q
         DPd8aRrD4YHq2wPPpXfyNR/2eyzBwCmpKpB/yEFD6cj6gO34SAjHVl8m2Gak3sB9i+
         rcdMu2QiL3b41z905CqBga0cDZlC4I6L5BppkSPrgGuT+TeSY4m5XVrs0jkyL0jyNT
         ibev9n02zzI3w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/13] mlx5 fixes 2021-11-30
Date:   Tue, 30 Nov 2021 22:36:56 -0800
Message-Id: <20211201063709.229103-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit b0f38e15979fa8851e88e8aa371367f264e7b6e9:

  natsemi: xtensa: fix section mismatch warnings (2021-11-30 18:13:37 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-11-30

for you to fetch changes up to 8c8cf0382257b28378eeff535150c087a653ca19:

  net/mlx5e: SHAMPO, Fix constant expression result (2021-11-30 22:35:06 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-11-30

----------------------------------------------------------------
Amir Tzin (1):
      net/mlx5: Fix use after free in mlx5_health_wait_pci_up

Aya Levin (1):
      net/mlx5: Fix access to a non-supported register

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, Fix constant expression result

Dmytro Linkin (2):
      net/mlx5: E-switch, Respect BW share of the new group
      net/mlx5: E-Switch, Check group pointer before reading bw_share value

Gal Pressman (1):
      net/mlx5: Fix too early queueing of log timestamp work

Maor Dickman (1):
      net/mlx5: E-Switch, Use indirect table only if all destinations support it

Maor Gottlieb (1):
      net/mlx5: Lag, Fix recreation of VF LAG

Mark Bloch (1):
      net/mlx5: E-Switch, fix single FDB creation on BlueField

Moshe Shemesh (1):
      net/mlx5: Move MODIFY_RQT command to ignore list in internal error state

Raed Salem (2):
      net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
      net/mlx5e: Fix missing IPsec statistics on uplink representor

Tariq Toukan (1):
      net/mlx5e: Sync TIR params updates against concurrent create/modify

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    | 41 +++++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |  6 ++--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 24 +------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  8 ++---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  4 +--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 20 ++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  5 +--
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |  5 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 30 ++++++++--------
 include/linux/mlx5/mlx5_ifc.h                      |  5 ++-
 15 files changed, 97 insertions(+), 61 deletions(-)
