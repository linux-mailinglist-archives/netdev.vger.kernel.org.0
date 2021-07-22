Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D685E3D2462
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhGVMbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:31:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59482 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhGVMbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:31:10 -0400
Received: from localhost (unknown [51.219.3.84])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 005424D9C2E33;
        Thu, 22 Jul 2021 06:11:44 -0700 (PDT)
Date:   Thu, 22 Jul 2021 06:11:39 -0700 (PDT)
Message-Id: <20210722.061139.1666314878301149027.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     netdev@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 22 Jul 2021 06:11:45 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1) Fix type of bind option flag in af_xdp, from Baruch Siach.

2) Fix use after free in bpf_xdp_link_release(), from Xuan Zhao.

3) PM refcnt imbakance in r8152, from Takashi Iwai.

4) Sign extension ug in liquidio, from Colin Ian King.

5) Mising range check in s390 bpf jit, from Colin Ian King.

6) Uninit value in caif_seqpkt_sendmsg(), from Ziyong Xuan.

7) Fix skb page recycling race, from Ilias Apalodimas.

8) Fix memory leak in tcindex_partial_destroy_work, from Pave Skripkin.

9) netrom timer sk refcnt issues, from Nguyen Dinh Phi.

10) Fix data races aroun tcp's tfo_active_disable_stamp, from Eric Dumazet.

11) act_skbmod should only operate on ethernet packets, from Peilin Ye.

12) Fix slab out-of-bpunds in fib6_nh_flush_exceptions(),, from Psolo Abeni.

13) Fix sparx5 dependencies, from Yajun Deng.

Please pull, thanks a lot!

The following changes since commit 8096acd7442e613fad0354fc8dfdb2003cceea0b:

  Merge tag 'net-5.14-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-07-14 09:24:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 7aaa0f311e2df2704fa8ddb8ed681a3b5841d0bf:

  dpaa2-switch: seed the buffer pool after allocating the swp (2021-07-22 05:46:57 -0700)

----------------------------------------------------------------
Arnd Bergmann (1):
      net: ixp46x: fix ptp build failure

Baruch Siach (1):
      doc, af_xdp: Fix bind flags option typo

Biju Das (2):
      ravb: Fix a typo in comment
      ravb: Remove extra TAB

Chengwen Feng (1):
      net: hns3: fix possible mismatches resp of mailbox

Colin Ian King (2):
      liquidio: Fix unintentional sign extension issue on left shift of u16
      s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Daniel Borkmann (1):
      bpf: Fix tail_call_reachable rejection for interpreter when jit failed

David S. Miller (7):
      Merge branch 'r8152-pm-fixxes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'bnxt_en-fixes'
      Merge branch 'dt-bindinga-dwmac'
      Merge branch 'octeon-DMAC'
      Merge branch 'pmtu-esp'
      Merge branch 'ksz-dsa-fixes'

Dongliang Mu (1):
      usb: hso: fix error handling code of hso_create_net_device

Edwin Peer (1):
      bnxt_en: reject ETS settings that will starve a TC

Eric Dumazet (2):
      net/tcp_fastopen: fix data races around tfo_active_disable_stamp
      net/tcp_fastopen: remove obsolete extern

Eric Woudstra (2):
      mt7530 fix mt7530_fdb_write vid missing ivl bit
      mt7530 mt7530_fdb_write only set ivl bit vid larger than 1

Geert Uytterhoeven (1):
      net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX

Ilias Apalodimas (1):
      skbuff: Fix a potential race while recycling page_pool packets

Ioana Ciornei (1):
      dpaa2-switch: seed the buffer pool after allocating the swp

Jakub Kicinski (1):
      Merge branch 'net-hns3-fixes-for-net'

Jakub Sitnicki (1):
      bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats

Jia He (2):
      qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
      Revert "qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()"

Jian Shen (2):
      net: hns3: disable port VLAN filter when support function level VLAN filter control
      net: hns3: fix rx VLAN offload state inconsistent issue

Joakim Zhang (3):
      dt-bindings: net: snps,dwmac: add missing DWMAC IP version
      dt-bindings: net: imx-dwmac: convert imx-dwmac bindings to yaml
      arm64: dts: imx8mp: change interrupt order per dt-binding

John Fastabend (2):
      bpf, sockmap: Fix potential memory leak on unlikely error case
      bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats

Kalesh AP (1):
      bnxt_en: don't disable an already disabled PCI device

Landen Chao (1):
      net: Update MAINTAINERS for MediaTek switch driver

Lino Sanfilippo (2):
      net: dsa: ensure linearized SKBs in case of tail taggers
      net: dsa: tag_ksz: dont let the hardware process the layer 4 checksum

Mahesh Bandewar (1):
      bonding: fix build issue

Markus Boehme (1):
      ixgbe: Fix packet corruption due to missing DMA sync

Maxim Kochetkov (1):
      fsl/fman: Add fibre support

Michael Chan (5):
      bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()
      bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()
      bnxt_en: Validate vlan protocol ID on RX packets
      bnxt_en: Move bnxt_ptp_init() to bnxt_open()
      bnxt_en: Fix PTP capability discovery

Nguyen Dinh Phi (1):
      netrom: Decrease sock refcount when sock timers expire

Paolo Abeni (1):
      ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

Pavel Skripkin (1):
      net: sched: fix memory leak in tcindex_partial_destroy_work

Peilin Ye (1):
      net/sched: act_skbmod: Skip non-Ethernet packets

Peng Li (1):
      net: hns3: add match_id to check mailbox response from PF to VF

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Qitao Xu (3):
      net: use %px to print skb address in trace_netif_receive_skb
      net_sched: use %px to print skb address in trace_qdisc_dequeue()
      net_sched: introduce tracepoint trace_qdisc_enqueue()

Randy Dunlap (2):
      net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition
      net: sparx5: fix unmet dependencies warning

Sayanta Pattanayak (1):
      r8169: Avoid duplicate sysfs entry creation error

Somnath Kotur (2):
      bnxt_en: fix error path of FW reset
      bnxt_en: Check abort error state in bnxt_half_open_nic()

Subbaraya Sundeep (3):
      octeontx2-af: Enable transmit side LBK link
      octeontx2-af: Prepare for allocating MCAM rules for AF
      octeontx2-af: Introduce internal packet switching

Sukadev Bhattiprolu (1):
      ibmvnic: Remove the proper scrq flush

Takashi Iwai (2):
      r8152: Fix potential PM refcount imbalance
      r8152: Fix a deadlock by doubly PM resume

Tobias Klauser (1):
      bpftool: Check malloc return value in mount_bpffs_for_pin

Vadim Fedorenko (2):
      udp: check encap socket in __udp_lib_err
      selftests: net: add ESP-in-UDP PMTU test

Vasily Averin (1):
      ipv6: ip6_finish_output2: set sk into newly allocated nskb

Vladimir Oltean (2):
      net: bridge: do not replay fdb entries pointing towards the bridge twice
      net: dsa: sja1105: make VID 4095 a bridge VLAN too

Wei Wang (1):
      tcp: disable TFO blackhole logic by default

Xin Long (3):
      sctp: trim optlen when it's a huge value in sctp_setsockopt
      sctp: update active_key for asoc when old key is being replaced
      sctp: do not update transport pathmtu if SPP_PMTUD_ENABLE is not set

Xuan Zhuo (2):
      bpf, test: fix NULL pointer dereference on invalid expected_attach_type
      xdp, net: Fix use-after-free in bpf_xdp_link_release

Yajun Deng (2):
      net: decnet: Fix sleeping inside in af_decnet
      net: sched: cls_api: Fix the the wrong parameter

Ziyang Xuan (1):
      net: fix uninit-value in caif_seqpkt_sendmsg

 Documentation/devicetree/bindings/net/imx-dwmac.txt       |  56 ---------
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml  |  93 +++++++++++++++
 Documentation/devicetree/bindings/net/snps,dwmac.yaml     |   3 +
 Documentation/networking/af_xdp.rst                       |   6 +-
 Documentation/networking/ip-sysctl.rst                    |   2 +-
 MAINTAINERS                                               |   1 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                 |   6 +-
 arch/s390/net/bpf_jit_comp.c                              |   2 +-
 drivers/net/bonding/bond_main.c                           |   2 +
 drivers/net/dsa/mt7530.c                                  |   2 +
 drivers/net/dsa/mt7530.h                                  |   1 +
 drivers/net/dsa/mv88e6xxx/Kconfig                         |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c                    |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |  85 ++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c             |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c             |  24 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h             |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c             |   9 +-
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c   |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c       |  16 +--
 drivers/net/ethernet/freescale/fman/mac.c                 |   1 +
 drivers/net/ethernet/hisilicon/hip04_eth.c                |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h           |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |  10 ++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  |  19 ++++
 drivers/net/ethernet/ibm/ibmvnic.c                        |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c             |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/Makefile        |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c           |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h           |  21 ++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c       |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c   |  48 ++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c       |  36 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c       |  47 ++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c    |  29 +++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c    | 258 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/microchip/sparx5/Kconfig             |   1 +
 drivers/net/ethernet/realtek/r8169_main.c                 |   3 +-
 drivers/net/ethernet/renesas/ravb.h                       |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c                  |   2 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c                  |   2 +
 drivers/net/usb/hso.c                                     |  33 ++++--
 drivers/net/usb/r8152.c                                   |  30 +++--
 include/net/tcp.h                                         |   1 -
 include/trace/events/net.h                                |   2 +-
 include/trace/events/qdisc.h                              |  28 ++++-
 kernel/bpf/verifier.c                                     |   2 +
 net/bpf/test_run.c                                        |   3 +
 net/bridge/br_fdb.c                                       |   2 +-
 net/caif/caif_socket.c                                    |   3 +-
 net/core/dev.c                                            |  34 ++++--
 net/core/skbuff.c                                         |  18 ++-
 net/core/skmsg.c                                          |  16 ++-
 net/decnet/af_decnet.c                                    |  27 ++---
 net/dsa/slave.c                                           |  14 ++-
 net/dsa/tag_ksz.c                                         |   9 ++
 net/ipv4/tcp_bpf.c                                        |   2 +-
 net/ipv4/tcp_fastopen.c                                   |  28 ++++-
 net/ipv4/tcp_ipv4.c                                       |   2 +-
 net/ipv4/udp.c                                            |  25 +++-
 net/ipv4/udp_bpf.c                                        |   2 +-
 net/ipv6/ip6_output.c                                     |   2 +-
 net/ipv6/route.c                                          |   2 +-
 net/ipv6/udp.c                                            |  25 +++-
 net/netrom/nr_timer.c                                     |  20 ++--
 net/sched/act_skbmod.c                                    |  12 +-
 net/sched/cls_api.c                                       |   2 +-
 net/sched/cls_tcindex.c                                   |   5 +-
 net/sctp/auth.c                                           |   2 +
 net/sctp/output.c                                         |   4 +-
 net/sctp/socket.c                                         |   4 +
 tools/bpf/bpftool/common.c                                |   5 +
 tools/testing/selftests/net/nettest.c                     |  55 ++++++++-
 tools/testing/selftests/net/pmtu.sh                       | 212 +++++++++++++++++++++++++++++++++-
 77 files changed, 1217 insertions(+), 269 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/imx-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
