Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D403F678CA
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 08:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfGMGRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 02:17:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37426 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfGMGRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 02:17:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3E3714EF7473;
        Fri, 12 Jul 2019 23:17:04 -0700 (PDT)
Date:   Fri, 12 Jul 2019 23:17:04 -0700 (PDT)
Message-Id: <20190712.231704.904072376124323665.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 23:17:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix excessive stack usage in cxgb4, from Arnd Bergmann.

2) Missing skb queue lock init in tipc, from Chris Packham.

3) Fix some regressions in ipv6 flow label handling, from Eric Dumazet.

4) Elide flow dissection of local packets in FIB rules, from Petar
   Penkov.

5) Fix TLS support build failure in mlx5, from Tariq Toukab.

Please pull, thanks a lot.

The following changes since commit a131c2bf165684315f606fdd88cf80be22ba32f3:

  Merge tag 'acpi-5.3-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2019-07-11 11:17:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to 25a09ce79639a8775244808c17282c491cff89cf:

  ppp: mppe: Revert "ppp: mppe: Add softdep to arc4" (2019-07-12 22:58:49 -0700)

----------------------------------------------------------------
Arnd Bergmann (2):
      davinci_cpdma: don't cast dma_addr_t to pointer
      cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()

Aya Levin (3):
      net/mlx5e: Fix return value from timeout recover function
      net/mlx5e: Fix error flow in tx reporter diagnose
      net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn

Chris Packham (1):
      tipc: ensure head->lock is initialised

Christian Lamparter (1):
      net: dsa: qca8k: replace legacy gpio include

Cong Wang (1):
      hsr: switch ->dellink() to ->ndo_uninit()

David S. Miller (4):
      Merge branch 'mlx5-build-fixes'
      Merge tag 'mlx5-fixes-2019-07-11' of git://git.kernel.org/.../saeed/linux
      Merge branch 'net/rds-fixes' of git://git.kernel.org/.../ssantosh/linux
      Merge branch 'nfp-flower-bugs'

Denis Efremov (1):
      net: phy: make exported variables non-static

Eli Britstein (1):
      net/mlx5e: Fix port tunnel GRE entropy control

Eric Biggers (1):
      ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"

Eric Dumazet (3):
      ipv6: tcp: fix flowlabels reflection for RST packets
      ipv6: fix potential crash in ip6_datagram_dst_update()
      ipv6: fix static key imbalance in fl_create()

Gerd Rausch (3):
      Revert "RDS: IB: split the mr registration and invalidation path"
      rds: Accept peer connection reject messages due to incompatible version
      rds: Return proper "tos" value to user-space

Jiangfeng Xiao (1):
      net: hisilicon: Use devm_platform_ioremap_resource

Joe Perches (2):
      net: ethernet: mediatek: Fix misuses of GENMASK macro
      net: stmmac: Fix misuses of GENMASK macro

John Hurley (2):
      nfp: flower: fix ethernet check on match fields
      nfp: flower: ensure ip protocol is specified for L4 matches

Maor Gottlieb (1):
      net/mlx5: E-Switch, Fix default encap mode

Nathan Chancellor (1):
      net/mlx5e: Convert single case statement switch statements into if statements

Petar Penkov (1):
      net: fib_rules: do not flow dissect local packets

Roman Mashak (1):
      tc-tests: updated skbedit tests

Saeed Mahameed (3):
      net/mlx5e: Rx, Fix checksum calculation for new hardware
      net/mlx5e: Fix unused variable warning when CONFIG_MLX5_ESWITCH is off
      net/mlx5: E-Switch, Reduce ingress acl modify metadata stack usage

Santosh Shilimkar (2):
      rds: fix reordering with composite message notification
      rds: avoid version downgrade to legitimate newer peer connections

Taehee Yoo (1):
      net: openvswitch: do not update max_headroom if new headroom is equal to old headroom

Tariq Toukan (1):
      net/mlx5e: Fix compilation error in TLS code

Vlad Buslov (2):
      net: sched: Fix NULL-pointer dereference in tc_indr_block_ing_cmd()
      net/mlx5e: Provide cb_list pointer when setting up tc block on rep

yangxingwu (1):
      ipv6: Use ipv6_authlen for len

 drivers/net/dsa/qca8k.c                                          |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c                   |  19 ++++++---
 drivers/net/ethernet/hisilicon/hip04_eth.c                       |   7 +---
 drivers/net/ethernet/hisilicon/hisi_femac.c                      |   7 +---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                    |   7 +---
 drivers/net/ethernet/hisilicon/hns_mdio.c                        |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                      |   2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c                        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h              |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h                     |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c         |  10 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c       |  34 +++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                |   8 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                 |   5 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                  |   7 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                |   5 ---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c       |   9 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c            |   9 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c           |  23 ++---------
 drivers/net/ethernet/netronome/nfp/flower/offload.c              |  28 +++++--------
 drivers/net/ethernet/stmicro/stmmac/descs.h                      |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c                |   4 +-
 drivers/net/ethernet/ti/davinci_cpdma.c                          |  26 ++++++------
 drivers/net/phy/phy_device.c                                     |   6 +--
 drivers/net/ppp/ppp_mppe.c                                       |   1 -
 include/linux/mlx5/mlx5_ifc.h                                    |   3 +-
 include/linux/phy.h                                              |   3 ++
 include/net/fib_rules.h                                          |   4 +-
 include/net/pkt_cls.h                                            |  10 +++++
 net/hsr/hsr_device.c                                             |  18 ++++-----
 net/hsr/hsr_device.h                                             |   1 -
 net/hsr/hsr_netlink.c                                            |   7 ----
 net/ipv6/ah6.c                                                   |   4 +-
 net/ipv6/datagram.c                                              |   2 +-
 net/ipv6/exthdrs_core.c                                          |   2 +-
 net/ipv6/ip6_flowlabel.c                                         |   9 +++--
 net/ipv6/ip6_tunnel.c                                            |   2 +-
 net/ipv6/netfilter/ip6t_ah.c                                     |   2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c                             |   2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c                          |   2 +-
 net/ipv6/netfilter/nf_log_ipv6.c                                 |   2 +-
 net/ipv6/tcp_ipv6.c                                              |   7 +++-
 net/openvswitch/datapath.c                                       |  39 +++++++++++++-----
 net/rds/connection.c                                             |   1 +
 net/rds/ib.h                                                     |   4 +-
 net/rds/ib_cm.c                                                  |   9 +----
 net/rds/ib_frmr.c                                                |  11 +++--
 net/rds/ib_send.c                                                |  29 ++++++-------
 net/rds/rdma.c                                                   |  10 -----
 net/rds/rdma_transport.c                                         |  11 +++--
 net/rds/rds.h                                                    |   1 -
 net/rds/send.c                                                   |   4 +-
 net/sched/cls_api.c                                              |   2 +-
 net/tipc/name_distr.c                                            |   2 +-
 tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json | 117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 55 files changed, 328 insertions(+), 222 deletions(-)
