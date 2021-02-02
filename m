Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93530B866
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhBBHIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232494AbhBBHHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 971E564EC3;
        Tue,  2 Feb 2021 07:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612249631;
        bh=4Kjt6/St7hl1ZdRqujPfivjIoqVdtTMsxLOblJLd7C8=;
        h=From:To:Cc:Subject:Date:From;
        b=uPzKDXjl3nCQlZxJpEz99UiNCLFj/WxqEiBUoFAE9BdpYh69jCydxxribRQJHnwyR
         HX43BswN/nX38r12yAT2Cw+G4GYPfYUWWwAAF9L2pYJxE4/OhmJRHLf2rtcQwHN4nr
         b5RYYCy2SjtQAcZeuFDUP554ZNFZ1XhgYlS/teHmuMHMkwtFzuRrkG5mWOtxOG2dzD
         agJX4IImwPiJB2+ZeVHhXmPhpfgjPVWWuAZOSQe8wNuBumtv8W4qV7eiY+HDuPqEyt
         qSRl1B+r5crT3BvLv23/fp6P2U0UhyjMo5cTveCFu9ggrBbG2PcUJvXO567ZIbukkJ
         W7YYv0F9SVnDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/4] mlx5 fixes 2021-02-01
Date:   Mon,  1 Feb 2021 23:06:59 -0800
Message-Id: <20210202070703.617251-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Please note the first patch in this series
("Fix function calculation for page trees") is fixing a regression
due to previous fix in net which you didn't include in your previous rc
pr. So I hope this series will make it into your next rc pr,
so mlx5 won't be broken in the next rc.

Thanks,
Saeed.

---
The following changes since commit 188fa104f2ba93887777ded2e600ce16d60bc3d7:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2021-02-01 20:23:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-02-01

for you to fetch changes up to a34ffec8af8ff1c730697a99e09ec7b74a3423b6:

  net/mlx5e: Release skb in case of failure in tc update skb (2021-02-01 23:02:02 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-02-01

----------------------------------------------------------------
Daniel Jurgens (1):
      net/mlx5: Fix function calculation for page trees

Maor Dickman (1):
      net/mlx5e: Release skb in case of failure in tc update skb

Maor Gottlieb (1):
      net/mlx5: Fix leak upon failure of rule creation

Maxim Mikityanskiy (1):
      net/mlx5e: Update max_opened_tc also when channels are closed

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  6 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 16 ++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c   |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c |  2 +-
 4 files changed, 20 insertions(+), 9 deletions(-)
