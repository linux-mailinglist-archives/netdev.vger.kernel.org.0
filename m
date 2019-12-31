Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A194312D72C
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfLaI5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 03:57:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfLaI5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 03:57:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DE3B1519DF3C;
        Tue, 31 Dec 2019 00:57:48 -0800 (PST)
Date:   Tue, 31 Dec 2019 00:57:47 -0800 (PST)
Message-Id: <20191231.005747.1636874751558818158.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Dec 2019 00:57:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix big endian overflow in nf_flow_table, from Arnd Bergmann.

2) Fix port selection on big endian in nft_tproxy, from Phil Sutter.

3) Fix precision tracking for unbound scalars in bpf verifier, from
   Daniel Borkmann.

4) Fix integer overflow in socket rcvbuf check in UDP, from Antonio
   Messina.

5) Do not perform a neigh confirmation during a pmtu update over
   a tunnel, from Hangbin Liu.

6) Fix DMA mapping leak in dpaa_eth driver, from Madalin Bucur.

7) Various PTP fixes for sja1105 dsa driver, from Vladimir Oltean.

8) Add missing to dummy definition of of_mdiobus_child_is_phy(),
   from Geert Uytterhoeven.

Please pull, thanks a lot!

The following changes since commit c60174717544aa8959683d7e19d568309c3a0c65:

  Merge tag 'xfs-5.5-fixes-2' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux (2019-12-22 10:59:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 04b69426d846cd04ca9acefff1ea39e1c64d2714:

  hsr: fix slab-out-of-bounds Read in hsr_debugfs_rename() (2019-12-30 20:36:27 -0800)

----------------------------------------------------------------
Alexandra Winter (3):
      s390/qeth: fix false reporting of VNIC CHAR config failure
      s390/qeth: Fix vnicc_is_in_use if rx_bcast not set
      s390/qeth: vnicc Fix init to default

Amit Cohen (1):
      mlxsw: spectrum_router: Skip loopback RIFs during MAC validation

Antonio Messina (1):
      udp: fix integer overflow while computing available space in sk_rcvbuf

Arnd Bergmann (1):
      netfilter: nf_flow_table: fix big-endian integer overflow

Cambda Zhu (1):
      tcp: Fix highest_sack and highest_sack_seq

Daniel Borkmann (1):
      bpf: Fix precision tracking for unbounded scalars

David Howells (3):
      rxrpc: Unlock new call in rxrpc_new_incoming_call() rather than the caller
      rxrpc: Don't take call->user_mutex in rxrpc_new_incoming_call()
      rxrpc: Fix missing security check on incoming calls

David S. Miller (8):
      Merge tag 'rxrpc-fixes-20191220' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'disable-neigh-update-for-tunnels-during-pmtu-update'
      Merge branch 's390-qeth-fixes'
      Merge branch 'hsr-fix-several-bugs-in-hsr-module'
      Merge git://git.kernel.org/.../pablo/nf
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'bnx2x-Bug-fixes'
      Merge branch 'mlxsw-fixes'

Davide Caratti (1):
      net/sched: add delete_empty() to filters and use it in cls_flower

Eric Dumazet (1):
      net_sched: sch_fq: properly set sk->sk_pacing_status

Florian Fainelli (1):
      net: dsa: bcm_sf2: Fix IP fragment location and behavior

Florian Westphal (2):
      selftests: netfilter: extend flowtable test script with dnat rule
      netfilter: ebtables: compat: reject all padding in matches/watchers

Geert Uytterhoeven (1):
      of: mdio: Add missing inline to of_mdiobus_child_is_phy() dummy

Hangbin Liu (8):
      net: add bool confirm_neigh parameter for dst_ops.update_pmtu
      ip6_gre: do not confirm neighbor when do pmtu update
      gtp: do not confirm neighbor when do pmtu update
      net/dst: add new function skb_dst_update_pmtu_no_confirm
      tunnel: do not confirm neighbor when do pmtu update
      vti: do not confirm neighbor when do pmtu update
      sit: do not confirm neighbor when do pmtu update
      net/dst: do not confirm neighbor for vxlan and geneve pmtu update

Ido Schimmel (1):
      mlxsw: spectrum: Use dedicated policer for VRRP packets

Julian Wiedmann (3):
      s390/qeth: fix qdio teardown after early init error
      s390/qeth: lock the card while changing its hsuid
      s390/qeth: fix initialization on old HW

Madalin Bucur (2):
      dpaa_eth: fix DMA mapping leak
      net: phy: aquantia: add suspend / resume ops for AQR105

Manish Chopra (2):
      bnx2x: Use appropriate define for vlan credit
      bnx2x: Fix accounting of vlan resources among the PFs

Marcelo Ricardo Leitner (1):
      sctp: fix err handling of stream initialization

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs

Namhyung Kim (1):
      libbpf: Fix build on read-only filesystems

Netanel Belgazal (1):
      MAINTAINERS: Add additional maintainers to ENA Ethernet driver

Phil Sutter (1):
      netfilter: nft_tproxy: Fix port selector on Big Endian

Rahul Lakkireddy (1):
      cxgb4/cxgb4vf: fix flow control display for auto negotiation

Shmulik Ladkani (1):
      net/sched: act_mirred: Pull mac prior redir to non mac_header_xmit device

Taehee Yoo (7):
      hsr: avoid debugfs warning message when module is remove
      hsr: fix error handling routine in hsr_dev_finalize()
      hsr: add hsr root debugfs directory
      hsr: rename debugfs file when interface name is changed
      hsr: fix a race condition in node list insertion and deletion
      hsr: reset network header when supervision frame is created
      hsr: fix slab-out-of-bounds Read in hsr_debugfs_rename()

Vladimir Oltean (5):
      net: dsa: sja1105: Take PTP egress timestamp by port, not mgmt slot
      net: dsa: sja1105: Really make the PTP command read-write
      net: dsa: sja1105: Remove restriction of zero base-time for taprio offload
      Documentation: net: dsa: sja1105: Remove text about taprio base-time limitation
      net: dsa: sja1105: Reconcile the meaning of TPID and TPID2 for E/T and P/Q/R/S

Vladis Dronov (1):
      ptp: fix the race between the release of ptp_clock and cdev

Vladyslav Tarasiuk (1):
      net/mlxfw: Fix out-of-memory error in mfa2 flash burning

 Documentation/networking/dsa/sja1105.rst              |  6 ------
 MAINTAINERS                                           |  2 ++
 drivers/net/dsa/bcm_sf2_cfp.c                         |  6 +++---
 drivers/net/dsa/sja1105/sja1105_main.c                | 10 +++++-----
 drivers/net/dsa/sja1105/sja1105_ptp.c                 |  6 +++---
 drivers/net/dsa/sja1105/sja1105_static_config.c       |  7 +++++--
 drivers/net/dsa/sja1105/sja1105_tas.c                 |  5 -----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h        |  5 ++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h            |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c            | 21 +++++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h    |  1 +
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c        | 18 +++++++++++-------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 39 ++++++++++++++++++++-------------------
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c      |  7 ++++---
 drivers/net/ethernet/mellanox/mlxsw/reg.h             |  1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |  9 +++++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |  3 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c   | 14 +++++++++++---
 drivers/net/gtp.c                                     |  2 +-
 drivers/net/phy/aquantia_main.c                       |  2 ++
 drivers/ptp/ptp_clock.c                               | 31 ++++++++++++++-----------------
 drivers/ptp/ptp_private.h                             |  2 +-
 drivers/s390/net/qeth_core_main.c                     | 29 +++++++++--------------------
 drivers/s390/net/qeth_l2_main.c                       | 10 +++++-----
 drivers/s390/net/qeth_l3_main.c                       |  2 +-
 drivers/s390/net/qeth_l3_sys.c                        | 40 ++++++++++++++++++++++++++++------------
 include/linux/of_mdio.h                               |  2 +-
 include/linux/posix-clock.h                           | 19 +++++++++++--------
 include/net/dst.h                                     | 13 +++++++++++--
 include/net/dst_ops.h                                 |  3 ++-
 include/net/sch_generic.h                             |  5 +++++
 kernel/bpf/verifier.c                                 | 43 ++++++++++++++++++++++---------------------
 kernel/time/posix-clock.c                             | 31 +++++++++++++------------------
 net/bridge/br_nf_core.c                               |  3 ++-
 net/bridge/netfilter/ebtables.c                       | 33 ++++++++++++++++-----------------
 net/decnet/dn_route.c                                 |  6 ++++--
 net/hsr/hsr_debugfs.c                                 | 52 ++++++++++++++++++++++++++++++++++++++++------------
 net/hsr/hsr_device.c                                  | 28 ++++++++++++++++------------
 net/hsr/hsr_framereg.c                                | 73 ++++++++++++++++++++++++++++++++++++++++++++++---------------------------
 net/hsr/hsr_framereg.h                                |  6 ++----
 net/hsr/hsr_main.c                                    |  7 ++++++-
 net/hsr/hsr_main.h                                    | 22 +++++++++++++++-------
 net/hsr/hsr_netlink.c                                 |  1 +
 net/ipv4/inet_connection_sock.c                       |  2 +-
 net/ipv4/ip_tunnel.c                                  |  2 +-
 net/ipv4/ip_vti.c                                     |  2 +-
 net/ipv4/route.c                                      |  9 ++++++---
 net/ipv4/tcp_output.c                                 |  3 +++
 net/ipv4/udp.c                                        |  2 +-
 net/ipv4/xfrm4_policy.c                               |  5 +++--
 net/ipv6/inet6_connection_sock.c                      |  2 +-
 net/ipv6/ip6_gre.c                                    |  2 +-
 net/ipv6/ip6_tunnel.c                                 |  4 ++--
 net/ipv6/ip6_vti.c                                    |  2 +-
 net/ipv6/route.c                                      | 22 +++++++++++++++-------
 net/ipv6/sit.c                                        |  2 +-
 net/ipv6/xfrm6_policy.c                               |  5 +++--
 net/netfilter/ipvs/ip_vs_xmit.c                       |  2 +-
 net/netfilter/nf_flow_table_offload.c                 |  2 +-
 net/netfilter/nft_tproxy.c                            |  4 ++--
 net/rxrpc/ar-internal.h                               | 10 +++++++---
 net/rxrpc/call_accept.c                               | 60 +++++++++++++++++++++++++++++++++++++-----------------------
 net/rxrpc/conn_event.c                                | 16 +---------------
 net/rxrpc/conn_service.c                              |  4 ++++
 net/rxrpc/input.c                                     | 18 ------------------
 net/rxrpc/rxkad.c                                     |  5 +++--
 net/rxrpc/security.c                                  | 70 +++++++++++++++++++++++++++++++++-------------------------------------
 net/sched/act_mirred.c                                | 22 ++++++++++++----------
 net/sched/cls_api.c                                   | 31 +++++--------------------------
 net/sched/cls_flower.c                                | 12 ++++++++++++
 net/sched/cls_u32.c                                   | 25 -------------------------
 net/sched/sch_fq.c                                    | 17 ++++++++---------
 net/sctp/stream.c                                     | 30 +++++++++++++++---------------
 net/sctp/transport.c                                  |  2 +-
 tools/lib/bpf/Makefile                                | 15 ++++++++-------
 tools/testing/selftests/bpf/.gitignore                |  1 +
 tools/testing/selftests/bpf/Makefile                  |  6 +++---
 tools/testing/selftests/netfilter/nft_flowtable.sh    | 39 ++++++++++++++++++++++++++++++++++-----
 80 files changed, 600 insertions(+), 489 deletions(-)
