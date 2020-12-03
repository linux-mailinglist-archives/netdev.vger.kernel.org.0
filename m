Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93AA2CDFE8
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgLCUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbgLCUpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 15:45:42 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.10-rc7
Date:   Thu,  3 Dec 2020 12:44:59 -0800
Message-Id: <20201203204459.3963776-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit c84e1efae022071a4fcf9f1899bf71777c49943a:

  Merge tag 'asm-generic-fixes-5.10-2' of git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic (2020-11-27 15:00:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc7

for you to fetch changes up to 6f076ce6ab1631abf566a6fb830c02fe5797be9a:

  Merge branch 'mlx5-fixes-2020-12-01' (2020-12-03 11:18:38 -0800)

----------------------------------------------------------------
Networking fixes for 5.10-rc7, including fixes from bpf, netfilter,
wireless drivers, wireless mesh and can.

Current release - regressions:

 - mt76: usb: fix crash on device removal

Current release - always broken:

 - xsk: Fix umem cleanup from wrong context in socket destruct

Previous release - regressions:

 - net: ip6_gre: set dev->hard_header_len when using header_ops

 - ipv4: Fix TOS mask in inet_rtm_getroute()

 - net, xsk: Avoid taking multiple skbuff references

Previous release - always broken:

 - net/x25: prevent a couple of overflows

 - netfilter: ipset: prevent uninit-value in hash_ip6_add

 - geneve: pull IP header before ECN decapsulation

 - mpls: ensure LSE is pullable in TC and openvswitch paths

 - vxlan: respect needed_headroom of lower device

 - batman-adv: Consider fragmentation for needed packet headroom

 - can: drivers: don't count arbitration loss as an error

 - netfilter: bridge: reset skb->pkt_type after POST_ROUTING
              traversal

 - inet_ecn: Fix endianness of checksum update when setting ECT(1)

 - ibmvnic: fix various corner cases around reset handling

 - net/mlx5: fix rejecting unsupported Connect-X6DX SW steering

 - net/mlx5: Enforce HW TX csum offload with kTLS

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Antoine Tenart (2):
      netfilter: bridge: reset skb->pkt_type after NF_INET_POST_ROUTING traversal
      net: ip6_gre: set dev->hard_header_len when using header_ops

Björn Töpel (1):
      net, xsk: Avoid taking multiple skbuff references

Dan Carpenter (3):
      net/x25: prevent a couple of overflows
      rtw88: debug: Fix uninitialized memory in debugfs code
      chelsio/chtls: fix a double free in chtls_setkey()

Dany Madden (7):
      ibmvnic: handle inconsistent login with reset
      ibmvnic: stop free_all_rwi on failed reset
      ibmvnic: avoid memset null scrq msgs
      ibmvnic: restore adapter state on failed reset
      ibmvnic: send_login should check for crq errors
      ibmvnic: no reset timeout for 5 seconds after reset
      ibmvnic: reduce wait for completion time

David S. Miller (1):
      Merge branch 'ibmvnic-Bug-fixes-for-queue-descriptor-processing'

Davide Caratti (4):
      selftests: tc-testing: enable CONFIG_NET_SCH_RED as a module
      net: skbuff: ensure LSE is pullable before decrementing the MPLS ttl
      net: openvswitch: ensure LSE is pullable before reading it
      net/sched: act_mpls: ensure LSE is pullable before reading it

Eran Ben Elisha (1):
      net/mlx5: Fix wrong address reclaim when command interface is down

Eric Dumazet (2):
      netfilter: ipset: prevent uninit-value in hash_ip6_add
      geneve: pull IP header before ECN decapsulation

Florian Westphal (1):
      netfilter: nf_tables: avoid false-postive lockdep splat

Golan Ben Ami (1):
      iwlwifi: pcie: add some missing entries for AX210

Guillaume Nault (1):
      ipv4: Fix tos mask in inet_rtm_getroute()

Hoang Le (1):
      tipc: fix incompatible mtu of transmission

Jakub Kicinski (7):
      Merge tag 'batadv-net-pullrequest-20201127' of git://git.open-mesh.org/linux-merge
      Merge https://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'ibmvnic-assorted-bug-fixes'
      Merge tag 'linux-can-fixes-for-5.10-20201130' of git://git.kernel.org/.../mkl/linux-can
      Merge tag 'wireless-drivers-2020-12-03' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'mlx5-fixes-2020-12-01'

Jeroen Hofstee (2):
      can: sja1000: sja1000_err(): don't count arbitration lose as an error
      can: sun4i_can: sun4i_can_err(): don't count arbitration lose as an error

Jesper Dangaard Brouer (1):
      MAINTAINERS: Update XDP and AF_XDP entries

Johannes Berg (1):
      iwlwifi: update MAINTAINERS entry

KP Singh (1):
      bpf: Add MAINTAINERS entry for BPF LSM

Krzysztof Kozlowski (1):
      dt-bindings: net: correct interrupt flags in examples

Luca Coelho (2):
      iwlwifi: pcie: add one missing entry for AX210
      iwlwifi: pcie: invert values of NO_160 device config entries

Magnus Karlsson (1):
      xsk: Fix umem cleanup bug at socket destruct

Marc Kleine-Budde (1):
      can: m_can: tcan4x5x_can_probe(): fix error path: remove erroneous clk_disable_unprepare()

Marek Majtyka (1):
      xsk: Fix incorrect netdev reference count

Pablo Neira Ayuso (2):
      netfilter: nftables_offload: set address type in control dissector
      netfilter: nftables_offload: build mask based from the matching bytes

Randy Dunlap (2):
      net: broadcom CNIC: requires MMU
      net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled

Stanislaw Gruszka (1):
      mt76: usb: fix crash on device removal

Sukadev Bhattiprolu (2):
      ibmvnic: delay next reset if hard reset fails
      ibmvnic: track pending login

Sven Eckelmann (5):
      batman-adv: Consider fragmentation for needed_headroom
      batman-adv: Reserve needed_*room for fragments
      batman-adv: Don't always reallocate the fragmentation skb head
      vxlan: Add needed_headroom for lower device
      vxlan: Copy needed_tailroom from lowerdev

Tariq Toukan (1):
      net/mlx5e: kTLS, Enforce HW TX csum offload with kTLS

Thomas Falcon (2):
      ibmvnic: Ensure that SCRQ entry reads are correctly ordered
      ibmvnic: Fix TX completion error handling

Toke Høiland-Jørgensen (1):
      inet_ecn: Fix endianness of checksum update when setting ECT(1)

Vinay Kumar Yadav (1):
      chelsio/chtls: fix panic during unload reload chtls

Wang Hai (2):
      ipvs: fix possible memory leak in ip_vs_control_net_init
      net: mvpp2: Fix error return code in mvpp2_open()

Yangbo Lu (1):
      dpaa_eth: copy timestamp fields to new skb in A-050385 workaround

Yevgeny Kliteynik (1):
      net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering

Zhang Changzhong (3):
      cxgb3: fix error return code in t3_sge_alloc_qset()
      net: pasemi: fix error return code in pasemi_mac_open()
      vxlan: fix error return code in __vxlan_dev_create()

Zhang Qilong (2):
      can: c_can: c_can_power_up(): fix error handling
      can: kvaser_pciefd: kvaser_pciefd_open(): fix error handling

Zhen Lei (1):
      bpftool: Fix error return value in build_btf_type_table

 .../devicetree/bindings/net/can/tcan4x5x.txt       |   2 +-
 .../devicetree/bindings/net/nfc/nxp-nci.txt        |   2 +-
 .../devicetree/bindings/net/nfc/pn544.txt          |   2 +-
 MAINTAINERS                                        |  26 ++-
 drivers/net/can/c_can/c_can.c                      |  18 +-
 drivers/net/can/kvaser_pciefd.c                    |   4 +-
 drivers/net/can/m_can/tcan4x5x.c                   |  11 +-
 drivers/net/can/sja1000/sja1000.c                  |   1 -
 drivers/net/can/sun4i_can.c                        |   1 -
 drivers/net/ethernet/broadcom/Kconfig              |   1 +
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |   1 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   1 +
 .../chelsio/inline_crypto/chtls/chtls_hw.c         |   1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  10 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 190 +++++++++++++--------
 drivers/net/ethernet/ibm/ibmvnic.h                 |   3 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   1 +
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  22 ++-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  21 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   1 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |   5 +
 .../mellanox/mlx5/core/steering/dr_types.h         |   1 +
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   8 +-
 drivers/net/geneve.c                               |  20 ++-
 drivers/net/vxlan.c                                |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   6 +
 drivers/net/wireless/mediatek/mt76/usb.c           |  17 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   2 +
 include/linux/mlx5/mlx5_ifc.h                      |   9 +-
 include/linux/netdevice.h                          |  14 +-
 include/net/inet_ecn.h                             |   2 +-
 include/net/netfilter/nf_tables_offload.h          |   7 +
 include/net/xdp_sock.h                             |   1 +
 net/batman-adv/fragmentation.c                     |  26 +--
 net/batman-adv/hard-interface.c                    |   3 +
 net/bridge/br_netfilter_hooks.c                    |   7 +-
 net/core/dev.c                                     |   8 +-
 net/core/skbuff.c                                  |   3 +
 net/ipv4/route.c                                   |   7 +-
 net/ipv6/ip6_gre.c                                 |  16 +-
 net/netfilter/ipset/ip_set_core.c                  |   3 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  31 +++-
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/netfilter/nf_tables_offload.c                  |  17 ++
 net/netfilter/nft_cmp.c                            |   8 +-
 net/netfilter/nft_meta.c                           |  16 +-
 net/netfilter/nft_payload.c                        |  70 ++++++--
 net/openvswitch/actions.c                          |   3 +
 net/sched/act_mpls.c                               |   3 +
 net/tipc/node.c                                    |   2 +
 net/x25/af_x25.c                                   |   6 +-
 net/xdp/xdp_umem.c                                 |  19 ++-
 net/xdp/xdp_umem.h                                 |   2 +-
 net/xdp/xsk.c                                      |  10 +-
 net/xdp/xsk_buff_pool.c                            |   6 +-
 tools/bpf/bpftool/btf.c                            |   1 +
 tools/testing/selftests/tc-testing/config          |   1 +
 59 files changed, 496 insertions(+), 199 deletions(-)
