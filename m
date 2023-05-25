Return-Path: <netdev+bounces-5200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E55C71036C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BCFB281470
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2601FB4;
	Thu, 25 May 2023 03:48:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E27B19C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3222FC433D2;
	Thu, 25 May 2023 03:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986530;
	bh=oI8Tbtg74hv0TFqZp1TH5Ee9ChO80OPzTdLpJqRmHrw=;
	h=From:To:Cc:Subject:Date:From;
	b=DX3iGHlz7tV44jtbNuu5nKvqob7+fT3b91PsHaLfn1gY4c13jEWf5h9DdOik+X15x
	 +jd7aqCmV00nHU/93Eq8G0IvfrN0xpFVEzEPgO7g/kuvgSQBXAzRF5w3eSF1Xx87IF
	 ibhDZnvFd+lRu8rxR8m58c1E0AwsVNP22yDk03zURU7LFzK+hiTmYJkhOCsDckQTMS
	 yQdP31Tj1jt+nY+fOfmOlNU2oXrDdDicnQzGCKSNo8QlvR7jIHadaNefmOexxFS7gk
	 HI+avI64ZIF83UAPDkPpPy5gCzeSUhYgOKdjdfKuwcbpya1FQQkfxalVUMVnenQ50T
	 Gb46s4yDZ64Zw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/17] mlx5 fixes 2023-05-24
Date: Wed, 24 May 2023 20:48:30 -0700
Message-Id: <20230525034847.99268-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This series includes bug fixes for the mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 878ecb0897f4737a4c9401f3523fd49589025671:

  ipv6: Fix out-of-bounds access in ipv6_find_tlv() (2023-05-24 08:43:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-05-24

for you to fetch changes up to bb72b94c659f5032850e9ab070d850bc743e3a0e:

  Documentation: net/mlx5: Wrap notes in admonition blocks (2023-05-24 20:44:20 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-05-24

----------------------------------------------------------------
Bagas Sanjaya (4):
      Documentation: net/mlx5: Wrap vnic reporter devlink commands in code blocks
      Documentation: net/mlx5: Use bullet and definition lists for vnic counters description
      Documentation: net/mlx5: Add blank line separator before numbered lists
      Documentation: net/mlx5: Wrap notes in admonition blocks

Chris Mi (2):
      net/mlx5e: Extract remaining tunnel encap code to dedicated file
      net/mlx5e: Prevent encap offload when neigh update is running

Dan Carpenter (1):
      net/mlx5: Fix check for allocation failure in comp_irqs_request_pci()

Dmytro Linkin (1):
      net/mlx5e: Don't attach netdev profile while handling internal error

Dragos Tatulea (1):
      net/mlx5e: Use query_special_contexts cmd only once per mdev

Jianbo Liu (1):
      net/mlx5e: Move Ethernet driver debugfs to profile init callback

Maher Sanalla (2):
      net/mlx5e: Consider internal buffers size in port buffer calculations
      net/mlx5e: Do not update SBCM when prio2buffer command is invalid

Shay Drory (3):
      net/mlx5: Drain health before unregistering devlink
      net/mlx5: SF, Drain health before removing device
      net/mlx5: fw_tracer, Fix event handling

Vlad Buslov (1):
      net/mlx5: Fix post parse infra to only parse every action once

Yevgeny Kliteynik (1):
      net/mlx5: DR, Add missing mutex init/destroy in pattern manager

 .../ethernet/mellanox/mlx5/devlink.rst             |  60 +++++++----
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  46 +++++---
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |   8 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 120 ++++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   9 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  69 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   6 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  97 ++---------------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  21 ++++
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ptrn.c |   3 +
 include/linux/mlx5/driver.h                        |   1 +
 19 files changed, 279 insertions(+), 190 deletions(-)

