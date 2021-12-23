Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F231347E7DF
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244877AbhLWTEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34282 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244859AbhLWTEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7735B82183
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D36BC36AE5;
        Thu, 23 Dec 2021 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286286;
        bh=VHycsgQxSo6yz0Z86E/5I8a3q3waJmzaNwDY37n6/FA=;
        h=From:To:Cc:Subject:Date:From;
        b=m/LPmigGdYagCFxFJnNBu35bwnKjvjLbcl+34V2VfYK/aMLWmzvRwPT1iKdByesxZ
         P+lDZwtR17tJ3Co7N3nhvO7r9DO9rncMrjpNoTa86bSZTGjI+qyTprc5s5uulZKTy7
         M7LJ/wAR4MhPlPPYPDU65eH1w6pE4Y2YugYifT7tuFrlkIvAUw22ltxTCByIDTNMH6
         TIGXfa0B2o+FJzLgEXbGHtt9Q1yrtV1IYvqkGW4jyb++XxB/TjXz33JkH01Gi68xgL
         DjM1iQk3TsW+UgvYFLoxgR3hd4IJgs+4ZyWs4QVVjWht3w2qcFZ7u94uRPVVV3/cnl
         oOjGBTH/PMQTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][v2 net 00/12] mlx5 fixes 2021-12-22
Date:   Thu, 23 Dec 2021 11:04:29 -0800
Message-Id: <20211223190441.153012-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

I know I missed the train for this week, this is V2 just in case there
will be another rc pull later next week.

Note: I cherry-picked the patch from net-next and it applies cleanly,
let me know if you face any issues with this pull.

v1->v2:
 - Fixed missing space in commit message
 - Cherry-picked an important fix from net-next patch #12

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit d1652b70d07cc3eed96210c876c4879e1655f20e:

  asix: fix wrong return value in asix_check_host_enable() (2021-12-22 14:52:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-12-22

for you to fetch changes up to 4390c6edc0fb390e699d0f886f45575dfeafeb4b:

  net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()' (2021-12-22 20:38:49 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-12-22

----------------------------------------------------------------
Amir Tzin (1):
      net/mlx5e: Wrap the tx reporter dump callback to extract the sq

Chris Mi (2):
      net/mlx5: Fix tc max supported prio for nic mode
      net/mlx5e: Delete forward rule for ct or sample action

Christophe JAILLET (1):
      net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'

Gal Pressman (1):
      net/mlx5e: Fix skb memory leak when TC classifier action offloads are disabled

Maxim Mikityanskiy (2):
      net/mlx5e: Fix interoperability between XSK and ICOSQ recovery flow
      net/mlx5e: Fix ICOSQ recovery flow for XSK

Miaoqian Lin (1):
      net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources

Moshe Shemesh (1):
      net/mlx5: Fix SF health recovery flow

Shay Drory (2):
      net/mlx5: Use first online CPU instead of hard coded CPU
      net/mlx5: Fix error print in case of IRQ request failed

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix querying eswitch manager vport for ECPF

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  5 ++-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 35 +++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 16 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 37 ++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 31 +++++++++---------
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 11 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  6 ++--
 .../mellanox/mlx5/core/steering/dr_domain.c        |  9 +++---
 12 files changed, 121 insertions(+), 46 deletions(-)
