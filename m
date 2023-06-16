Return-Path: <netdev+bounces-11568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5345E733A3D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA1D1C20B0D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06211ED3B;
	Fri, 16 Jun 2023 20:01:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED251C773
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3D0C433C8;
	Fri, 16 Jun 2023 20:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945683;
	bh=5mRledKh+xVDFrSydSOsccwixFGH6mr5sWOAM4haoOI=;
	h=From:To:Cc:Subject:Date:From;
	b=mIlt+WBHaO4jLlaV4H7/EGuSIwScNCWD2fe+RifqT7Tnk5nlOFr1u2uSiBbgIgZI6
	 Pbote1c4G2rH8Ek2E3/k9DbB4IzLd1OjrPE8ksUfZZD98Ovl27a+jqHwofB3cknfAh
	 sCLKie/IT6KdBWc/ifpMnG4cbWC2YbQUDWqyt8Q5wLf2IRZ8BaBkAo1E+ina4q8+ee
	 NoLkLv25LVrCCo1St1KrPAYZHsS1ui8wmBDM48wcFYkE60p7LjpkJ5kxfUnyBZVCs7
	 usNbK/Ob6O0g/il55pBipSWt1lgSGU9d8NFrXYtShoRWJhFb7N6vkNNf8hb0efj8KJ
	 ziJ4lExikqiOQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2023-06-16
Date: Fri, 16 Jun 2023 13:01:07 -0700
Message-Id: <20230616200119.44163-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit d4e067287b41b9eba278533d32afda35b25fbdd5:

  Merge branch 'check-if-fips-mode-is-enabled-when-running-selftests' (2023-06-15 22:24:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-06-16

for you to fetch changes up to a128f9d4c1227dfcf7f2328070760cb7ed1ec08d:

  net/mlx5e: Fix scheduling of IPsec ASO query while in atomic (2023-06-16 12:59:20 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-06-16

----------------------------------------------------------------
Chris Mi (2):
      net/mlx5e: TC, Add null pointer check for hardware miss support
      net/mlx5e: TC, Cleanup ct resources for nic flow

Eli Cohen (1):
      net/mlx5: Fix driver load with single msix vector

Leon Romanovsky (3):
      net/mlx5e: Don't delay release of hardware objects
      net/mlx5e: Drop XFRM state lock when modifying flow steering
      net/mlx5e: Fix scheduling of IPsec ASO query while in atomic

Maxim Mikityanskiy (2):
      net/mlx5e: XDP, Allow growing tail for XDP multi buffer
      net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ

Patrisious Haddad (1):
      net/mlx5e: Fix ESN update kernel panic

Saeed Mahameed (1):
      net/mlx5: Free IRQ rmap and notifier on kernel shutdown

Yevgeny Kliteynik (2):
      net/mlx5: DR, Support SW created encap actions for FW table
      net/mlx5: DR, Fix wrong action data allocation in decap action

 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  8 +++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 22 +++++++---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    | 17 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  7 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   | 50 ++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  7 +++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 33 +++++++++++---
 .../mellanox/mlx5/core/steering/dr_action.c        | 13 +++++-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   | 27 +++++++++++-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.h   |  7 +++
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  2 +
 15 files changed, 163 insertions(+), 36 deletions(-)

