Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87031846A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBKEua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhBKEu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 23:50:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFEA464E38;
        Thu, 11 Feb 2021 04:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613018974;
        bh=iIgyr2kw0+B80Sc9eFL6ZStoWwHESXfGwPcTfqFuvLA=;
        h=From:To:Cc:Subject:Date:From;
        b=K6WdX3Hy3hOKBcxiwD5AvO7kVnsWqHkHj4G473e7yc6octdAN+PFlSAD+EOKC9K87
         BwwroM6d52A4CNHS5d0Dm+YxfqlXUGUReGFrj8csTRwP0sWnuwIhgqyW8L3oliwWgY
         SL6/IcBWLN8aqxYjB5TcywCl4/lRe1TSI2BO+9hgBod4gvaez/Q/Apfaevypo5tUbN
         1aT990gf/zgqM61+J4Hm3NoLfCVlO0UZdLuBrF/K+IEYOG0abZsoF1eMxKpkI25CdE
         eWc+/EPIdVTLfYrM4+lwCjiurKOQPwMkfmqv5+rw44W6cbBDTbiO4xvDCstX5539rw
         I/kAOc0HfE1AA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/11] mlx5 for upstream 2021-02-10
Date:   Wed, 10 Feb 2021 20:49:17 -0800
Message-Id: <20210211044917.44574-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This pull request includes fixups and cleanups for net-next,
patches in this series were already reviewed on netdev mailing list.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit e4b62cf7559f2ef9a022de235e5a09a8d7ded520:

  net: mvpp2: add an entry to skip parser (2021-02-10 15:41:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-for-upstream-2021-02-10

for you to fetch changes up to b50c4892cb98417df96b73119c54520da34a3e88:

  net/mlx5: SF, Fix error return code in mlx5_sf_dev_probe() (2021-02-10 20:47:15 -0800)

----------------------------------------------------------------
mlx5-for-upstream-2021-02-10

Misc cleanups and trivial fixes for net-next

1) spelling mistakes
2) error path checks fixes
3) unused includes and struct fields cleanup
4) build error when MLX5_ESWITCH=no

----------------------------------------------------------------
Colin Ian King (3):
      net/mlx5: fix spelling mistake in Kconfig "accelaration" -> "acceleration"
      net/mlx5e: Fix spelling mistake "channles" -> "channels"
      net/mlx5e: Fix spelling mistake "Unknouwn" -> "Unknown"

Dan Carpenter (1):
      net/mlx5: Fix a NULL vs IS_ERR() check

Jiapeng Zhong (1):
      net/mlx5: Assign boolean values to a bool variable

Leon Romanovsky (1):
      net/mlx5: Delete device list leftover

Lukas Bulwahn (1):
      net/mlx5: docs: correct section reference in table of contents

Vlad Buslov (1):
      net/mlx5e: Fix tc_tun.h to verify MLX5_ESWITCH config

Wei Yongjun (2):
      net/mlx5e: Fix error return code in mlx5e_tc_esw_init()
      net/mlx5: SF, Fix error return code in mlx5_sf_dev_probe()

Zou Wei (1):
      net/mlx5_core: remove unused including <generated/utsrelease.h>

 Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig                    | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h                | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                   | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                    | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c            | 1 +
 include/linux/mlx5/driver.h                                        | 1 -
 10 files changed, 18 insertions(+), 13 deletions(-)
