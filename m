Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889DB3F9097
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243722AbhHZWTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhHZWTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 176F860FDC;
        Thu, 26 Aug 2021 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016292;
        bh=ZkVeDgpNN5uGmS6M7UVSXal84xsIh8wVkIJdcRK2IoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=YY8bdHWrAD5KgQQkpCAkGpd3SjZKo4SLf1lgrtZYO4n4p6pVU2xsdRyduvkGLgN6X
         WhqRXk7v57TvLTFDx2us9hpLEcttvk+hQrM3W+wGkf+iFJ0AvflKpP8VDBb6Jd+Rqg
         iDfwFldym3ZsPM50roP84nHCWPj8+i/2fXdgJUgL7/cISHyb6COt9cwmuD6PgRzQsF
         5HcV1gkU/vHhmnS/jAuCafWdKRjXLI2OzDr7uZAaKacsDZxuIf9wsWofw5XCmfHNSM
         Vnd95HOQ092r2bQz6Zwr4atCGJRhds/7jYPzSxrvlbVVjEkvZm8ZMEJ3QBuJwg3e9R
         AY6kufoNVv+Ow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/6] mlx5 fixes 2021-08-26
Date:   Thu, 26 Aug 2021 15:18:04 -0700
Message-Id: <20210826221810.215968-1-saeed@kernel.org>
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
The following changes since commit 73367f05b25dbd064061aee780638564d15b01d1:

  Merge tag 'nfsd-5.14-1' of git://linux-nfs.org/~bfields/linux (2021-08-26 13:26:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-08-26

for you to fetch changes up to 6cc64770fb386b10a64a1fe09328396de7bb5262:

  net/mlx5: DR, fix a potential use-after-free bug (2021-08-26 15:15:42 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-08-26

----------------------------------------------------------------
Dima Chumak (1):
      net/mlx5: Lag, fix multipath lag activation

Dmytro Linkin (1):
      net/mlx5e: Use correct eswitch for stack devices with lag

Leon Romanovsky (1):
      net/mlx5: Remove all auxiliary devices at the unregister event

Maor Dickman (1):
      net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group

Roi Dayan (1):
      net/mlx5e: Fix possible use-after-free deleting fdb rule

Wentao_Liang (1):
      net/mlx5: DR, fix a potential use-after-free bug

 drivers/net/ethernet/mellanox/mlx5/core/dev.c          |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        | 18 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c          |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c       |  8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h       |  2 ++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_rule.c |  2 +-
 8 files changed, 34 insertions(+), 4 deletions(-)
