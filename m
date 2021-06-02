Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C956E397E1B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFBBjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhFBBjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A824C613CD;
        Wed,  2 Jun 2021 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597851;
        bh=pDFoW9Oher6l8zFb6n80K5VmIXGJwsy638ZUGLyKBIo=;
        h=From:To:Cc:Subject:Date:From;
        b=eT90HyN7MShoq5G7mBLS/gjSH4edSwmyxSrcJZnDi+PCrW/dezzJxevg8kcA8KlKz
         I/kFF5Oc0YFypHmrz7erOarsGtlu+D/3UriJQSGLxfjAYMtH93MeqEWVZPUMwFqHyA
         +qw96VWOHypzdvHukQB0idUr4xUJ2ND7zom4RXXtjeptVq8lY2cHHi37vUmkF/44Fq
         DylimsoXNQ2Z70t1p7BdrEfvok6l3vLn7hpnTqGqno0wj11WALt40KUW6iPCgkgrpC
         qSVg7UlWOexnvVGp/n+FReevmQUqIc++sQwiIUzAr/H7WsdzbpxTjqNuFgPxZCrHdj
         oruRqEwdxbnPA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/8] mlx5 fixes 2021-06-01
Date:   Tue,  1 Jun 2021 18:37:15 -0700
Message-Id: <20210602013723.1142650-1-saeed@kernel.org>
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
The following changes since commit b000372627ce9dbbe641dafbf40db0718276ab77:

  MAINTAINERS: nfc mailing lists are subscribers-only (2021-06-01 17:09:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-06-01

for you to fetch changes up to 216214c64a8c1cb9078c2c0aec7bb4a2f8e75397:

  net/mlx5: DR, Create multi-destination flow table with level less than 64 (2021-06-01 18:30:21 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-06-01

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix incompatible casting
      net/mlx5e: Fix HW TS with CQE compression according to profile
      net/mlx5e: Fix conflict with HW TS and CQE compression

Moshe Shemesh (1):
      net/mlx5: Check firmware sync reset requested is set before trying to abort it

Roi Dayan (3):
      net/mlx5e: Disable TLS offload for uplink representor
      net/mlx5e: Check for needed capability for cvlan matching
      net/mlx5e: Fix adding encap rules to slow path

Yevgeny Kliteynik (1):
      net/mlx5: DR, Create multi-destination flow table with level less than 64

 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 12 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 77 +++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  9 +++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  3 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |  5 ++
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |  3 +-
 include/linux/mlx5/mlx5_ifc.h                      |  2 +
 9 files changed, 96 insertions(+), 20 deletions(-)
