Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83CC3AA6B4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhFPWml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233245AbhFPWmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4553613E2;
        Wed, 16 Jun 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883226;
        bh=be1sm6Y+dD9DCXxiJD5JFNczRi+zoToS/8Id6L4dchk=;
        h=From:To:Cc:Subject:Date:From;
        b=DQk0VduGzdJPZ/YCBw7ehieY7bEiU7tzea2FCagw5yXzoQwYWl141gErN1AvVALn9
         gPNBTeDa4jNEdy7o6UMTBmThfiAfGJGtIkAo6S8st2nxMqFxMEi1HpD+GIxXbt/w4E
         MnkpRFzRZIAWOMnnfhyuLR1P8uKtG2fBmqqNYb793T0I3ZaIkOS3s3mCIOuJ021v0T
         A+pD6SLQ4qBjuLVHOPLUsPunkzsyxgTANDqXj70uiN+ER0YbRIFvi8uri0xpgedmf9
         X7VaUkBp8uIVzHkz1IzigQI22txo+2MtnIxJGlDcm+/BtsJn786DLMGXzA7krvk9LL
         0+CVUDSJNdYtg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/8] mlx5 fixes 2021-06-16
Date:   Wed, 16 Jun 2021 15:40:07 -0700
Message-Id: <20210616224015.14393-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit da5ac772cfe2a03058b0accfac03fad60c46c24d:

  r8169: Avoid memcpy() over-reading of ETH_SS_STATS (2021-06-16 13:02:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-06-16

for you to fetch changes up to 0232fc2ddcf4ffe01069fd1aa07922652120f44a:

  net/mlx5: Reset mkey index on creation (2021-06-16 15:36:49 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-06-16

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding

Aya Levin (1):
      net/mlx5: Reset mkey index on creation

Dmytro Linkin (1):
      net/mlx5e: Don't create devices during unload flow

Leon Romanovsky (2):
      net/mlx5: Fix error path for set HCA defaults
      net/mlx5: Check that driver was probed prior attaching the device

Parav Pandit (3):
      net/mlx5: E-Switch, Read PF mac address
      net/mlx5: E-Switch, Allow setting GUID for host PF vport
      net/mlx5: SF_DEV, remove SF device on invalid state

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 19 ++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  6 +++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  2 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 26 +++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  2 --
 include/linux/mlx5/driver.h                        |  4 ++++
 8 files changed, 49 insertions(+), 14 deletions(-)
