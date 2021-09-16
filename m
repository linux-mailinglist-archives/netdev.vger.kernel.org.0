Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3C40EB44
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhIPUFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236143AbhIPUFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 16:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BACE611CA;
        Thu, 16 Sep 2021 20:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631822626;
        bh=K2/IYK3f5mKm0AEkz7hJo/JvywGprQ+Kz7GDL3+LfHg=;
        h=From:To:Cc:Subject:Date:From;
        b=t/N4Himv0gd/oG+ggOzCHyu//zv4iT3xT47pMF+TeuD65m1QR98S4Od54tJTR/E1i
         QWaJH57HFCQMyTzCgFCIVbPmKy7qWnaT7uwDCgOhd78dbYcoc1JEsYLRAx5+P+kB67
         yk64gt+Agl4MOqDZeWZblHVdnkYEtD+Msnj7DwmI0pcmsvuea0QEa0dmSkMl1WCrnX
         ctwaE5xYU1FBHGZpn59B4/TSUuhwJiCXAcEtzKWW309QqKtegTv94B4e5H5smoPvq7
         o6pFOtrH4sMv/otsPMEi3Qdg5RAuxmT7yrqmBtKvhp61CU4iW8opiY+fsHcwG6ZWen
         Aj0UhxUNbbJcg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.15-rc2
Date:   Thu, 16 Sep 2021 13:03:45 -0700
Message-Id: <20210916200345.3840415-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 626bf91a292e2035af5b9d9cce35c5c138dfe06d:

  Merge tag 'net-5.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-07 14:02:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc2

for you to fetch changes up to ee8a9600b5391f434905c46bec7f77d34505083e:

  mlxbf_gige: clear valid_polarity upon open (2021-09-16 14:31:58 +0100)

----------------------------------------------------------------
Networking fixes for 5.15-rc2, including fixes from bpf.

Current release - regressions:

 - vhost_net: fix OoB on sendmsg() failure

 - mlx5: bridge, fix uninitialized variable usage

 - bnxt_en: fix error recovery regression

Current release - new code bugs:

 - bpf, mm: fix lockdep warning triggered by stack_map_get_build_id_offset()

Previous releases - regressions:

 - r6040: restore MDIO clock frequency after MAC reset

 - tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

 - dsa: flush switchdev workqueue before tearing down CPU/DSA ports

Previous releases - always broken:

 - ptp: dp83640: don't define PAGE0, avoid compiler warning

 - igc: fix tunnel segmentation offloads

 - phylink: update SFP selected interface on advertising changes

 - stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume

 - mlx5e: fix mutual exclusion between CQE compression and HW TS

Misc:

 - bpf, cgroups: fix cgroup v2 fallback on v1/v2 mixed mode

 - sfc: fallback for lack of xdp tx queues

 - hns3: add option to turn off page pool feature

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Adam Borowski (1):
      net: wan: wanxl: define CROSS_COMPILE_M68K

Adrian Bunk (1):
      bnx2x: Fix enabling network interfaces without VFs

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: Add 200ms assert delay

Alex Elder (1):
      net: ipa: initialize all filter table slots

Andrea Claudi (1):
      selftest: net: fix typo in altname test

Ansuel Smith (1):
      net: dsa: qca8k: fix kernel panic with legacy mdio mapping

Arnd Bergmann (1):
      ne2000: fix unused function warning

Aya Levin (3):
      net/mlx5e: Fix mutual exclusion between CQE compression and HW TS
      net/mlx5e: Fix condition when retrieving PTP-rqn
      udp_tunnel: Fix udp_tunnel_nic work-queue type

Baruch Siach (1):
      net/packet: clarify source of pr_*() messages

Bixuan Cui (1):
      bpf: Add oversize check before call kvcalloc()

Colin Ian King (1):
      qlcnic: Remove redundant initialization of variable ret

Daniel Borkmann (4):
      bpf: Relicense disassembler as GPL-2.0-only OR BSD-2-Clause
      bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
      bpf, selftests: Add cgroup v1 net_cls classid helpers
      bpf, selftests: Add test case for mixed cgroup v1/v2

Dave Ertman (1):
      ice: Correctly deal with PFs that do not support RDMA

David S. Miller (5):
      Merge tag 'mlx5-fixes-2021-09-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'sfx-xdp-fallback-tx-queues'
      Merge branch 'bnxt_en-fixes'
      Merge branch 'hns3-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

David Thompson (1):
      mlxbf_gige: clear valid_polarity upon open

Edwin Peer (1):
      bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()

Eli Cohen (1):
      net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert

Eric Dumazet (3):
      net/af_unix: fix a data-race in unix_dgram_poll
      net-caif: avoid user-triggerable WARN_ON(1)
      Revert "Revert "ipv4: fix memory leaks in ip_cmsg_send() callers""

Florian Fainelli (1):
      r6040: Restore MDIO clock frequency after MAC reset

Guenter Roeck (1):
      net: ni65: Avoid typecast of pointer to u32

Hoang Le (1):
      tipc: increase timeout in tipc_sk_enqueue()

Jean-Philippe Brucker (1):
      selftests/bpf: Fix build of task_pt_regs test for arm64

Jeremy Kerr (1):
      mctp: perform route destruction under RCU read lock

Jesper Nilsson (1):
      net: stmmac: allow CSR clock of 300MHz

Jiaran Zhang (2):
      net: hns3: fix the exception when query imp info
      net: hns3: fix the timing issue of VF clearing interrupt sources

Joakim Zhang (2):
      net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume
      net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP

Len Baker (1):
      net: mana: Prefer struct_size over open coded arithmetic

Lin, Zhenpeng (1):
      dccp: don't duplicate ccid when cloning dccp sock

Maor Gottlieb (1):
      net/mlx5: Fix potential sleeping in atomic context

Mark Bloch (1):
      net/mlx5: Lag, don't update lag if lag isn't supported

Michael Chan (2):
      bnxt_en: Fix error recovery regression
      bnxt_en: Clean up completion ring page arrays completely

Nathan Rossi (1):
      net: phylink: Update SFP selected interface on advertising changes

Paolo Abeni (2):
      vhost_net: fix OoB on sendmsg() failure.
      igc: fix tunnel offloading

Parav Pandit (1):
      net/mlx5: Fix rdma aux device on devlink reload

Randy Dunlap (1):
      ptp: dp83640: don't define PAGE0

Saeed Mahameed (1):
      net/mlx5: FWTrace, cancel work on alloc pd error flow

Samuel Holland (1):
      dt-bindings: net: sun8i-emac: Add compatible for D1

Shai Malin (1):
      qed: Handle management FW error

Sukadev Bhattiprolu (2):
      ibmvnic: check failover_pending in login response
      ibmvnic: check failover_pending in login response

Tong Zhang (1):
      net: macb: fix use after free on rmmod

Vlad Buslov (1):
      net/mlx5: Bridge, fix uninitialized variable usage

Vladimir Oltean (3):
      net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
      Revert "net: phy: Uniform PHY driver access"
      net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports

Xiang wangx (1):
      selftests: nci: replace unsigned int with int

Xiyu Yang (1):
      net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Yajun Deng (1):
      Revert "ipv4: fix memory leaks in ip_cmsg_send() callers"

Yonghong Song (1):
      bpf, mm: Fix lockdep warning triggered by stack_map_get_build_id_offset()

Yufeng Mo (3):
      net: hns3: pad the short tunnel frame before sending to hardware
      net: hns3: change affinity_mask to numa node range
      net: hns3: disable mac in flr process

Yunsheng Lin (1):
      net: hns3: add option to turn off page pool feature

zhang kai (1):
      ipv6: delay fib6_sernum increase in fib6_add

zhenggy (1):
      tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

Íñigo Huguet (2):
      sfc: fallback for lack of xdp tx queues
      sfc: last resort fallback for lack of xdp tx queues

 .../bindings/net/allwinner,sun8i-a83t-emac.yaml    |   4 +-
 drivers/net/dsa/lantiq_gswip.c                     |   6 +
 drivers/net/dsa/qca8k.c                            |  30 +++--
 drivers/net/ethernet/8390/ne.c                     |  22 ++--
 drivers/net/ethernet/amd/ni65.c                    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  33 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   3 -
 drivers/net/ethernet/cadence/macb_pci.c            |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  14 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  19 +--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  16 +++
 drivers/net/ethernet/intel/ice/ice.h               |   2 +
 drivers/net/ethernet/intel/ice/ice_idc.c           |   6 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   7 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   3 -
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  10 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |   7 ++
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   4 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   3 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   6 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   2 +-
 drivers/net/ethernet/rdc/r6040.c                   |   9 +-
 drivers/net/ethernet/sfc/efx_channels.c            | 106 +++++++++++-----
 drivers/net/ethernet/sfc/net_driver.h              |   8 ++
 drivers/net/ethernet/sfc/tx.c                      |  29 +++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  16 +--
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  44 +++++++
 drivers/net/ipa/ipa_table.c                        |   3 +-
 drivers/net/phy/dp83640_reg.h                      |   2 +-
 drivers/net/phy/phy_device.c                       |   4 +-
 drivers/net/phy/phylink.c                          |  30 ++++-
 drivers/net/wan/Makefile                           |   2 +
 drivers/vhost/net.c                                |  11 +-
 include/linux/cgroup-defs.h                        | 107 ++++------------
 include/linux/cgroup.h                             |  22 +---
 include/linux/mmap_lock.h                          |   9 --
 include/linux/skbuff.h                             |   2 +-
 include/net/dsa.h                                  |   5 +
 kernel/bpf/disasm.c                                |   2 +-
 kernel/bpf/disasm.h                                |   2 +-
 kernel/bpf/stackmap.c                              |  10 +-
 kernel/bpf/verifier.c                              |   2 +
 kernel/cgroup/cgroup.c                             |  50 ++------
 net/caif/chnl_net.c                                |  19 +--
 net/core/netclassid_cgroup.c                       |   7 +-
 net/core/netprio_cgroup.c                          |  10 +-
 net/dccp/minisocks.c                               |   2 +
 net/dsa/dsa.c                                      |   5 +
 net/dsa/dsa2.c                                     |  46 ++++---
 net/dsa/dsa_priv.h                                 |   1 +
 net/dsa/slave.c                                    |  12 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv6/ip6_fib.c                                 |   3 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/mctp/route.c                                   |   2 +
 net/packet/af_packet.c                             |   2 +
 net/tipc/socket.c                                  |   2 +-
 net/unix/af_unix.c                                 |   2 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       | 137 +++++++++++++++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h       |  16 ++-
 tools/testing/selftests/bpf/network_helpers.c      |  27 +++-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../testing/selftests/bpf/prog_tests/cgroup_v1v2.c |  79 ++++++++++++
 .../selftests/bpf/prog_tests/task_pt_regs.c        |   1 -
 .../testing/selftests/bpf/progs/connect4_dropper.c |  26 ++++
 .../selftests/bpf/progs/test_task_pt_regs.c        |  19 ++-
 tools/testing/selftests/nci/nci_dev.c              |   2 +-
 tools/testing/selftests/net/altnames.sh            |   2 +-
 80 files changed, 770 insertions(+), 384 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect4_dropper.c
