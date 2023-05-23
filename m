Return-Path: <netdev+bounces-4534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2806370D33D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B099B1C20C53
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94651B8FE;
	Tue, 23 May 2023 05:42:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E8719914
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4D7C433EF;
	Tue, 23 May 2023 05:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820572;
	bh=r8FS+dpRfIIux0IhLlLJsWdFapYY0G3tat5xPtKD7Vg=;
	h=From:To:Cc:Subject:Date:From;
	b=AjvELoaaXYqbUVcMo5RslwOtMNhWiQ8g54Pl+w0+MrEgObip1Yqowr0R89dWg4Zmd
	 2JuuCgnNMjv+J2zKqpK01njyA5Q0nTDaEkuinsUHyvw/DlDYV5iBNyzse/rvfSzK2X
	 gnifL3Z9Lw4R9sYOVpmIRkU5yNdWVUGvjI3PmcvXHY2rZi3C9RP3tcvcvkB9bEmkQ/
	 pOw847x4U/cPcUfXJ8fOABK2SQ4DM02fbOi1ieCbOpkcpKf/z0DiFNnMUJb4/GEFgx
	 aoAO5qvgKJCRUSONuSdxg7/pLeEhEyIxrgLFBSxyxu2vJuHg5Q3cOiiPggAAN1BNGy
	 cqz25UqPikN3g==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 00/15] mlx5 fixes 2023-05-22
Date: Mon, 22 May 2023 22:42:27 -0700
Message-Id: <20230523054242.21596-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides bug fixes for the mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 18c40a1cc1d990c51381ef48cd93fdb31d5cd903:

  net/handshake: Fix sock->file allocation (2023-05-22 19:25:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-05-22

for you to fetch changes up to 1da438c0ae02396dc5018b63237492cb5908608d:

  net/mlx5: Fix indexing of mlx5_irq (2023-05-22 22:38:06 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-05-22

----------------------------------------------------------------
Erez Shitrit (1):
      net/mlx5: DR, Fix crc32 calculation to work on big-endian (BE) CPUs

Paul Blakey (1):
      net/mlx5e: TC, Fix using eswitch mapping in nic mode

Rahul Rameshbabu (1):
      net/mlx5e: Fix SQ wake logic in ptp napi_poll context

Roi Dayan (1):
      net/mlx5: Fix error message when failing to allocate device memory

Shay Drory (8):
      net/mlx5: Collect command failures data only for known commands
      net/mlx5: Handle pairing of E-switch via uplink un/load APIs
      net/mlx5: E-switch, Devcom, sync devcom events and devcom comp register
      net/mlx5: Devcom, fix error flow in mlx5_devcom_register_device
      net/mlx5: Devcom, serialize devcom registration
      net/mlx5: Free irqs only on shutdown callback
      net/mlx5: Fix irq affinity management
      net/mlx5: Fix indexing of mlx5_irq

Vlad Buslov (2):
      net/mlx5e: Use correct encap attribute during invalidation
      net/mlx5e: Fix deadlock in tc route query code

Yevgeny Kliteynik (1):
      net/mlx5: DR, Check force-loopback RC QP capability independently from RoCE

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  2 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 57 ++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 19 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  5 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 16 +++--
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   | 70 ++++++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 40 +++++++++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  3 +-
 include/linux/mlx5/mlx5_ifc.h                      |  4 +-
 17 files changed, 176 insertions(+), 59 deletions(-)

