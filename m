Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF09642AE39
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhJLUzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhJLUza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBFB460E90;
        Tue, 12 Oct 2021 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634072008;
        bh=ZK5afDqe+6fFHZnrv+m69huaaZA9EU0QRjix0Zhg8Cw=;
        h=From:To:Cc:Subject:Date:From;
        b=ZN1qcKAVBnSUgsXo6g4b5rnvKf/nkFfSxgZzDj88EGMOgFUT4CW+5eThpXaCqoM6t
         LQEz3jHQb36UkZil4c633kmm5PiY0qrrnb/2hU0nlQdKDH0AKHcf+umCZ9RQShunsh
         vp9THsHSy/BOfLO4txSXuVXaOC476hYOE30d60DXwh2PbNnVwuV+OW30UHg3fMPxEU
         TA+uaqu01ka8Rp+kfHhZKSKNhTMEvFTGz2bgucCrS39SgEqV2LI4eYJwfXaB+kpEQQ
         Ls5keM9IZcVn1c98gINfTUMzE3q3pdGBLpkukpE9m4RP11HZc/h9dcxjfGcTdvJMNC
         Mh+zXQi2oFmew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/6] mlx5 fixes 2021-10-12
Date:   Tue, 12 Oct 2021 13:53:17 -0700
Message-Id: <20211012205323.20123-1-saeed@kernel.org>
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
The following changes since commit 4d4a223a86afe658cd878800f09458e8bb54415d:

  ice: fix locking for Tx timestamp tracking flush (2021-10-12 12:10:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-10-12

for you to fetch changes up to 84c8a87402cf073ba7948dd62d4815a3f4a224c8:

  net/mlx5e: Fix division by 0 in mlx5e_select_queue for representors (2021-10-12 13:52:03 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-10-12

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Maxim Mikityanskiy (1):
      net/mlx5e: Fix division by 0 in mlx5e_select_queue for representors

Saeed Mahameed (1):
      net/mlx5e: Switchdev representors are not vlan challenged

Shay Drory (1):
      net/mlx5: Fix cleanup of bridge delayed work

Tariq Toukan (1):
      net/mlx5e: Allow only complete TXQs partition in MQPRIO channel mode

Valentine Fatiev (1):
      net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path

 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  7 ++-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  8 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 61 +++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  6 ++-
 include/linux/mlx5/mlx5_ifc.h                      | 10 +++-
 5 files changed, 74 insertions(+), 18 deletions(-)
