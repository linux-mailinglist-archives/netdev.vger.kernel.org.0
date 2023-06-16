Return-Path: <netdev+bounces-11589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26BC4733A86
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D31BE280DB4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4F21F170;
	Fri, 16 Jun 2023 20:11:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672621ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3A6C433C0;
	Fri, 16 Jun 2023 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946290;
	bh=1RaylbAB8SiqqJwDPHj7Q6/W6G+kRwIIlvA6Ry9ubsQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cy/YSZ2QWYPt8sToIzvvL2sA48RJXmyfpmsU9FBMagWMj5/dkYIWHDG2md//RUzV4
	 vyAHm2tNfgek6taZsdBcHCSe0mIsq/b9jbS/joiAS4+ZhK6agEF/XqBQ/SGvKVv+3H
	 0P07rc/CksAtu9eoZLMOVmRQwPrFPbmxvkTQaUAG+b0h6enj77wrDYFhAXMSVs0AGb
	 C4ZyeHsoKaMV4tBDQqXMSmUEITJi9+cpf4+YCaA/tWG2E7AWKW6JIVRvue5vhvpi/m
	 pG3lgQgWo0jgpzyo8pZbzfnHhUmHj3xRIEVXESiab4z+GA6MCZK0XI30CXgMQZ075G
	 p/G8b9YPmOwDA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-06-16
Date: Fri, 16 Jun 2023 13:10:58 -0700
Message-Id: <20230616201113.45510-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series adds misc updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 5a6f6873606e03a0a95afe40ba5e84bb6e28a26f:

  ip, ip6: Fix splice to raw and ping sockets (2023-06-16 11:45:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-06-16

for you to fetch changes up to 5f2cf757f9c56255470c23a2a4a5574a34edad4b:

  net/mlx5: Remove unused ecpu field from struct mlx5_sf_table (2023-06-16 12:02:09 -0700)

----------------------------------------------------------------
mlx5-updates-2023-06-16

1) Added a new event handler to firmware sync reset, which is used to
   support firmware sync reset flow on smart NIC. Adding this new stage to
   the flow enables the firmware to ensure host PFs unload before ECPFs
   unload, to avoid race of PFs recovery.

2) Debugfs for mlx5 eswitch bridge offloads

3) Added two new counters for vport stats

4) Minor Fixups and cleanups for net-next branch

----------------------------------------------------------------
Daniel Jurgens (2):
      net/mlx5: Fix the macro for accessing EC VF vports
      net/mlx5: DR, update query of HCA caps for EC VFs

Gal Pressman (1):
      net/mlx5e: Remove mlx5e_dbg() and msglvl support

Jiri Pirko (1):
      net/mlx5: Remove unused ecpu field from struct mlx5_sf_table

Juhee Kang (1):
      net/mlx5: Add header file for events

Moshe Shemesh (4):
      net/mlx5: Ack on sync_reset_request only if PF can do reset_now
      net/mlx5: Expose timeout for sync reset unload stage
      net/mlx5: Check DTOR entry value is not zero
      net/mlx5: Handle sync reset unload event

Or Har-Toov (2):
      net/mlx5: Expose bits for local loopback counter
      net/mlx5e: Add local loopback counter to vport stats

Saeed Mahameed (1):
      net/mlx5: E-Switch, remove redundant else statements

Vlad Buslov (3):
      net/mlx5: Create eswitch debugfs root directory
      net/mlx5: Bridge, pass net device when linking vport to bridge
      net/mlx5: Bridge, expose FDB state via debugfs

 .../ethernet/mellanox/mlx5/counters.rst            |  10 ++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  10 --
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  44 +++---
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  26 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  18 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  25 +++-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  39 ++---
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |  12 +-
 .../mellanox/mlx5/core/esw/bridge_debugfs.c        |  89 ++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |   6 +
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 160 ++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/events.h   |  40 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  34 -----
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   7 +
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   1 -
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   6 -
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |  13 +-
 33 files changed, 435 insertions(+), 167 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_debugfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/events.h

