Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DB435212
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhJTR6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhJTR6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EBF961130;
        Wed, 20 Oct 2021 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634752589;
        bh=KkSF2WNdSJaXYBEF6G7FxCovOP/H3m2VCTciInlrxnE=;
        h=From:To:Cc:Subject:Date:From;
        b=slW9OQQFI0rSmTbibLUn/AekBhTM6JAg6mqQAx5dQMBUvdI/JR7AtDHwzFjsZfd1s
         CWYSwRQmO/D8l1uo84IO0zB34Bmo4b90xnSVX9U5JW2JdrjZA4CsrAOp12l+r9kyAF
         srjtNHE/n00shjTEgmWHdVohyFLvqUNLWLWbMJBtyXkgqJMhu+9po9SRcOuiOC1pzS
         7P2g3i9WVDehtz6J23arkBTgwLP29yHEMFR9YdLrc0Jd70GedL8ECunaxEbkoUHkOX
         W2lQrtLY6IwFdaxJ+TxmBLl4kOFC89nnhNgPL4MNuxVwT6nE7633aPjKSz+Z2qlsoH
         DEL0TXvfPEdNw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/5] mlx5 fixes 2021-10-20
Date:   Wed, 20 Oct 2021 10:56:22 -0700
Message-Id: <20211020175627.269138-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 4225fea1cb28370086e17e82c0f69bec2779dca0:

  ptp: Fix possible memory leak in ptp_clock_register() (2021-10-20 14:44:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-10-20

for you to fetch changes up to 1d000323940137332d4d62c6332b6daf5f07aba7:

  net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags (2021-10-20 10:42:51 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-10-20

----------------------------------------------------------------
Dmytro Linkin (1):
      net/mlx5: E-switch, Return correct error code on group creation failure

Emeel Hakim (2):
      net/mlx5e: IPsec: Fix a misuse of the software parser's fields
      net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags

Maor Dickman (1):
      net/mlx5: Lag, change multipath and bonding to be mutually exclusive

Moshe Shemesh (1):
      net/mlx5e: Fix vlan data lost during suspend flow

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 51 ++++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 28 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  7 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 20 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  7 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  4 ++
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   | 13 +++---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |  2 +
 include/linux/mlx5/driver.h                        |  1 -
 12 files changed, 85 insertions(+), 55 deletions(-)
