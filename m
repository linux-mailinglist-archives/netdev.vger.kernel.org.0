Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B0847D88D
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbhLVVMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54728 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhLVVMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDBD2B81E57
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D60C36AE8;
        Wed, 22 Dec 2021 21:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207524;
        bh=mKeKXMKo3SCheDRHf61x01RXq/2bdJpJdxUVl0F2cuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Qa8fOFB7fArrYQHJrBX2wuwLalq7oE3QJoVvOFcMG716pb4gdGwJe824/fI0jXpp7
         NFuDRos0H8BPmpzcKMdyKY05EdBh8COP5culTIbsuONNn7RdvjA1taOKTS+TB9/xLs
         2RxPcU5lRW+RklTQO3iCULdRTeU45cFNABJx0Egx4HJzoElYaD0+EbvB1p4ZvelLNh
         hA8fKZk18+XTD5mgsDFId8hN4ePIWJx1+ykDIqSbQ41vb9zocinY2pr6M8aWce5B68
         rfZ7JvIuRfPrA+wNYpsNy6INaVfQlHqNVo0gIcNmDUwxaM6fFEfAG57m5WQEvgrtUJ
         3NRSLknEETddg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/11] mlx5 fixes 2021-12-22
Date:   Wed, 22 Dec 2021 13:11:50 -0800
Message-Id: <20211222211201.77469-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Additionally and unrelated to this pull, I would like to kindly request
to cherry-pick the following fix commit from net-next branch into net:
31108d142f36 ("net/mlx5: Fix some error handling paths in ...")

Thanks,
Saeed.


The following changes since commit 9b8bdd1eb5890aeeab7391dddcf8bd51f7b07216:

  sfc: falcon: Check null pointer of rx_queue->page_ring (2021-12-22 12:25:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-12-22

for you to fetch changes up to 3a67257323fc284bc50d0cd7e849f3c141087169:

  net/mlx5e: Delete forward rule for ct or sample action (2021-12-22 13:02:24 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-12-22

----------------------------------------------------------------
Amir Tzin (1):
      net/mlx5e: Wrap the tx reporter dump callback to extract the sq

Chris Mi (2):
      net/mlx5: Fix tc max supported prio for nic mode
      net/mlx5e: Delete forward rule for ct or sample action

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
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 17 ++++------
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 11 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  6 ++--
 .../mellanox/mlx5/core/steering/dr_domain.c        |  9 +++---
 12 files changed, 112 insertions(+), 41 deletions(-)
