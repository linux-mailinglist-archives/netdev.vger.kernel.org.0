Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1775A6D96F
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 05:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfGSDoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 23:44:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfGSDoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 23:44:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5956F1411CC2B;
        Thu, 18 Jul 2019 20:44:21 -0700 (PDT)
Date:   Thu, 18 Jul 2019 20:44:20 -0700 (PDT)
Message-Id: <20190718.204420.2101649864834371997.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 20:44:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix AF_XDP cq entry leak, from Ilya Maximets.

2) Fix handling of PHY power-down on RTL8411B, from Heiner Kallweit.

3) Add some new PCI IDs to iwlwifi, from Ihab Zhaika.

4) Fix handling of neigh timers wrt. entries added by userspace,
   from Lorenzo Bianconi.

5) Various cases of missing of_node_put(), from Nishka Dasgupta.

6) The new NET_ACT_CT needs to depend upon NF_NAT, from Yue Haibing.

7) Various RDS layer fixes, from Gerd Rausch.

8) Fix some more fallout from TCQ_F_CAN_BYPASS generalization, from
   Cong Wang.

9) Fix FIB source validation checks over loopback, also from Cong
   Wang.

10) Use promisc for unsupported number of filters, from Justin Chen.

11) Missing sibling route unlink on failure in ipv6, from Ido
    Schimmel.

Please pull, thanks a lot!

The following changes since commit 192f0f8e9db7efe4ac98d47f5fa4334e43c1204d:

  Merge tag 'powerpc-5.3-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2019-07-13 16:08:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to 8d650cdedaabb33e85e9b7c517c0c71fcecc1de9:

  tcp: fix tcp_set_congestion_control() use from bpf hook (2019-07-18 20:33:48 -0700)

----------------------------------------------------------------
Andrii Nakryiko (9):
      bpf: fix precision bit propagation for BPF_ST instructions
      libbpf: fix ptr to u64 conversion warning on 32-bit platforms
      bpf: fix BTF verifier size resolution logic
      selftests/bpf: add trickier size resolution tests
      selftests/bpf: use typedef'ed arrays as map values
      selftests/bpf: remove logic duplication in test_verifier
      libbpf: fix another GCC8 warning for strncpy
      selftests/bpf: fix test_verifier/test_maps make dependencies
      selftests/bpf: structure test_{progs, maps, verifier} test runners uniformly

Arnd Bergmann (1):
      ath10k: work around uninitialized vht_pfr variable

Benjamin Poirier (1):
      be2net: Signal that the device cannot transmit during reconfiguration

Chuhong Yuan (3):
      liquidio: Replace vmalloc + memset with vzalloc
      net/mlx5: Replace kfree with kvfree
      gve: replace kfree with kvfree

Cong Wang (3):
      net_sched: unset TCQ_F_CAN_BYPASS when adding filters
      fib: relax source validation check for loopback packets
      selftests: add a test case for rp_filter

Daniel Borkmann (2):
      Merge branch 'bpf-btf-size-verification-fix'
      Merge branch 'bpf-fix-wide-loads-sockaddr'

Daniel T. Lee (1):
      tools: bpftool: add raw_tracepoint_writable prog type to header

David Ahern (1):
      ipv6: rt6_check should return NULL if 'from' is NULL

David S. Miller (6):
      Merge tag 'mlx5-fixes-2019-07-15' of git://git.kernel.org/.../saeed/linux
      Merge branch 'net-rds-RDMA-fixes'
      Merge branch 'mlxsw-Two-fixes'
      Merge branch 'ipv4-relax-source-validation-check-for-loopback-packets'
      Merge tag 'wireless-drivers-for-davem-2019-07-18' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge git://git.kernel.org/.../bpf/bpf

Denis Efremov (1):
      gve: Remove the exporting of gve_probe

Eli Cohen (1):
      net/mlx5e: Verify encapsulation is supported

Eric Dumazet (1):
      tcp: fix tcp_set_congestion_control() use from bpf hook

Fuqian Huang (4):
      atm: idt77252: Remove call to memset after dma_alloc_coherent
      ethernet: remove redundant memset
      hippi: Remove call to memset after pci_alloc_consistent
      vmxnet3: Remove call to memset after dma_alloc_coherent

Gerd Rausch (7):
      net/rds: Give fr_state a chance to transition to FRMR_IS_FREE
      net/rds: Get rid of "wait_clean_list_grace" and add locking
      net/rds: Wait for the FRMR_IS_FREE (or FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
      net/rds: Fix NULL/ERR_PTR inconsistency
      net/rds: Set fr_state only to FRMR_IS_FREE if IB_WR_LOCAL_INV had been successful
      net/rds: Keep track of and wait for FRWR segments in use upon shutdown
      net/rds: Initialize ic->i_fastreg_wrs upon allocation

Gustavo A. R. Silva (1):
      bpf: verifier: avoid fall-through warnings

Haishuang Yan (1):
      sit: use dst_cache in ipip6_tunnel_xmit

Hariprasad Kelam (1):
      net: sctp: fix warning "NULL check before some freeing functions is not needed"

Heiner Kallweit (1):
      r8169: fix issue with confused RX unit after PHY power-down on RTL8411b

Ido Schimmel (2):
      mlxsw: spectrum: Do not process learned records with a dummy FID
      ipv6: Unlink sibling route in case of failure

Ihab Zhaika (1):
      iwlwifi: add new cards for 9000 and 20000 series

Ilias Apalodimas (1):
      MAINTAINERS: update netsec driver

Ilya Leoshkevich (15):
      selftests/bpf: fix bpf_target_sparc check
      selftests/bpf: do not ignore clang failures
      selftests/bpf: compile progs with -D__TARGET_ARCH_$(SRCARCH)
      selftests/bpf: fix s930 -> s390 typo
      selftests/bpf: make PT_REGS_* work in userspace
      selftests/bpf: fix compiling loop{1, 2, 3}.c on s390
      selftests/bpf: fix attach_probe on s390
      selftests/bpf: make directory prerequisites order-only
      selftests/bpf: put test_stub.o into $(OUTPUT)
      samples/bpf: build with -D__TARGET_ARCH_$(SRCARCH)
      selftests/bpf: fix "alu with different scalars 1" on s390
      selftests/bpf: skip nmi test when perf hw events are disabled
      selftests/bpf: fix perf_buffer on s390
      selftests/bpf: fix "valid read map access into a read-only array 1" on s390
      selftests/bpf: fix test_xdp_noinline on s390

Ilya Maximets (2):
      xdp: fix possible cq entry leak
      xdp: fix potential deadlock on socket mutex

Jon Maloy (1):
      tipc: initialize 'validated' field of received packets

Justin Chen (1):
      net: bcmgenet: use promisc for unsupported filters

Lorenzo Bianconi (1):
      net: neigh: fix multiple neigh timer scheduling

Luca Coelho (1):
      iwlwifi: pcie: add support for qu c-step devices

Michael Chan (1):
      bnxt_en: Fix VNIC accounting when enabling aRFS on 57500 chips.

Nishka Dasgupta (3):
      net: ethernet: ti: cpsw: Add of_node_put() before return and break
      net: ethernet: mscc: ocelot_board: Add of_node_put() before return
      net: ethernet: mediatek: mtk_eth_soc: Add of_node_put() before goto

Petr Machata (1):
      mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed

Phong Tran (1):
      ISDN: hfcsusb: checking idx of ep configuration

Qian Cai (1):
      skbuff: fix compilation warnings in skb_dump()

Rogan Dawes (1):
      usb: qmi_wwan: add D-Link DWM-222 A2 device ID

Rosen Penev (1):
      net: ag71xx: Add missing header

Sergej Benilov (1):
      sis900: correct a few typos

Soeren Moch (1):
      rt2x00usb: fix rx queue hang

Stanislav Fomichev (5):
      bpf: rename bpf_ctx_wide_store_ok to bpf_ctx_wide_access_ok
      bpf: allow wide aligned loads for bpf_sock_addr user_ip6 and msg_src_ip6
      selftests/bpf: rename verifier/wide_store.c to verifier/wide_access.c
      selftests/bpf: add selftests for wide loads
      bpf: sync bpf.h to tools/

Su Yanjun (1):
      udp: Fix typo in net/ipv4/udp.c

Taehee Yoo (1):
      caif-hsi: fix possible deadlock in cfhsi_exit_module()

Tasos Sahanidis (1):
      sky2: Disable MSI on P5W DH Deluxe

Vasily Gorbik (1):
      MAINTAINERS: update BPF JIT S390 maintainers

Vedang Patel (1):
      fix: taprio: Change type of txtime-delay parameter to u32

Vincent Bernat (1):
      bonding: add documentation for peer_notif_delay

Vlad Buslov (2):
      net/mlx5e: Rely on filter_dev instead of dissector keys for tunnels
      net/mlx5e: Allow dissector meta key in tc flower

Wei Yongjun (3):
      net: dsa: sja1105: Fix missing unlock on error in sk_buff()
      ag71xx: fix error return code in ag71xx_probe()
      ag71xx: fix return value check in ag71xx_probe()

YueHaibing (1):
      net/sched: Make NET_ACT_CT depends on NF_NAT

 Documentation/networking/bonding.txt                         |  16 ++++++++--
 MAINTAINERS                                                  |   3 +-
 drivers/atm/idt77252.c                                       |   1 -
 drivers/isdn/hardware/mISDN/hfcsusb.c                        |   3 ++
 drivers/net/caif/caif_hsi.c                                  |   2 +-
 drivers/net/ethernet/atheros/ag71xx.c                        |   9 ++++--
 drivers/net/ethernet/atheros/atlx/atl1.c                     |   2 --
 drivers/net/ethernet/atheros/atlx/atl2.c                     |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                    |   9 +++---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c               |  57 ++++++++++++++++------------------
 drivers/net/ethernet/cavium/liquidio/request_manager.c       |   6 ++--
 drivers/net/ethernet/chelsio/cxgb4/sched.c                   |   1 -
 drivers/net/ethernet/emulex/benet/be_main.c                  |   6 +++-
 drivers/net/ethernet/freescale/fec_main.c                    |   2 --
 drivers/net/ethernet/google/gve/gve_main.c                   |  23 +++++++-------
 drivers/net/ethernet/google/gve/gve_rx.c                     |   4 +--
 drivers/net/ethernet/jme.c                                   |   5 ---
 drivers/net/ethernet/marvell/skge.c                          |   2 --
 drivers/net/ethernet/marvell/sky2.c                          |   7 +++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                  |   4 ++-
 drivers/net/ethernet/mellanox/mlx4/eq.c                      |   2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              |  13 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c            |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   |   3 --
 drivers/net/ethernet/mellanox/mlx5/core/health.c             |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c                    |   1 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h               |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c           |  16 +++++-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c           |  10 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c     |   6 ++++
 drivers/net/ethernet/mscc/ocelot_board.c                     |   5 ++-
 drivers/net/ethernet/neterion/s2io.c                         |   1 -
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c          |   3 --
 drivers/net/ethernet/realtek/r8169_main.c                    | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sis/sis900.c                            |   6 ++--
 drivers/net/ethernet/ti/cpsw.c                               |  26 +++++++++++-----
 drivers/net/ethernet/ti/tlan.c                               |   1 -
 drivers/net/hippi/rrunner.c                                  |   2 --
 drivers/net/usb/qmi_wwan.c                                   |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                            |   1 -
 drivers/net/wireless/ath/ath10k/mac.c                        |   2 ++
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c               |  53 +++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h              |   7 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                 |   2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                |  23 ++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c               |  12 ++++----
 include/linux/filter.h                                       |   2 +-
 include/net/tcp.h                                            |   3 +-
 include/uapi/linux/bpf.h                                     |   4 +--
 include/uapi/linux/pkt_sched.h                               |   2 +-
 kernel/bpf/btf.c                                             |  19 +++++++-----
 kernel/bpf/verifier.c                                        |  13 ++++----
 net/core/filter.c                                            |  26 +++++++++++-----
 net/core/neighbour.c                                         |   2 ++
 net/core/skbuff.c                                            |   2 +-
 net/dsa/tag_sja1105.c                                        |   1 +
 net/ipv4/fib_frontend.c                                      |   5 +++
 net/ipv4/tcp.c                                               |   4 ++-
 net/ipv4/tcp_cong.c                                          |   6 ++--
 net/ipv4/udp.c                                               |   2 +-
 net/ipv6/ip6_fib.c                                           |  18 ++++++++++-
 net/ipv6/route.c                                             |   2 +-
 net/ipv6/sit.c                                               |  13 +++++---
 net/rds/ib.h                                                 |   1 +
 net/rds/ib_cm.c                                              |   9 +++++-
 net/rds/ib_frmr.c                                            |  84 +++++++++++++++++++++++++++++++++++++++++++++-----
 net/rds/ib_mr.h                                              |   4 +++
 net/rds/ib_rdma.c                                            |  60 ++++++++++++------------------------
 net/sched/Kconfig                                            |   2 +-
 net/sched/cls_api.c                                          |   1 +
 net/sched/sch_fq_codel.c                                     |   2 --
 net/sched/sch_sfq.c                                          |   2 --
 net/sched/sch_taprio.c                                       |   6 ++--
 net/sctp/sm_make_chunk.c                                     |  12 +++-----
 net/tipc/node.c                                              |   1 +
 net/xdp/xdp_umem.c                                           |  16 ++++------
 net/xdp/xsk.c                                                |  13 ++++----
 samples/bpf/Makefile                                         |   2 +-
 tools/bpf/bpftool/main.h                                     |   1 +
 tools/include/uapi/linux/bpf.h                               |   4 +--
 tools/lib/bpf/libbpf.c                                       |   4 +--
 tools/lib/bpf/xsk.c                                          |   3 +-
 tools/testing/selftests/bpf/Makefile                         |  64 +++++++++++++++++++-------------------
 tools/testing/selftests/bpf/bpf_helpers.h                    |  89 ++++++++++++++++++++++++++++++++++++----------------
 tools/testing/selftests/bpf/prog_tests/attach_probe.c        |  10 ++----
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c         |   8 +----
 tools/testing/selftests/bpf/prog_tests/send_signal.c         |  33 +++++++++++++++++++-
 tools/testing/selftests/bpf/progs/loop1.c                    |   2 +-
 tools/testing/selftests/bpf/progs/loop2.c                    |   2 +-
 tools/testing/selftests/bpf/progs/loop3.c                    |   2 +-
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c     |   3 +-
 tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c |   3 +-
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c      |   2 +-
 tools/testing/selftests/bpf/progs/test_xdp_noinline.c        |  17 +++++-----
 tools/testing/selftests/bpf/test_btf.c                       |  88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h                     |   8 +++++
 tools/testing/selftests/bpf/test_verifier.c                  |  35 +++++++++------------
 tools/testing/selftests/bpf/verifier/array_access.c          |   2 +-
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c       |   2 +-
 tools/testing/selftests/bpf/verifier/wide_access.c           |  73 +++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/wide_store.c            |  36 ----------------------
 tools/testing/selftests/net/fib_tests.sh                     |  35 ++++++++++++++++++++-
 102 files changed, 965 insertions(+), 400 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/wide_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
