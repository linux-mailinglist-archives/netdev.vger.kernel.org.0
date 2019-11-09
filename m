Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28E9F5CC0
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 02:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfKIBef convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 20:34:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41894 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfKIBef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 20:34:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E847B153C2BAB;
        Fri,  8 Nov 2019 17:34:34 -0800 (PST)
Date:   Fri, 08 Nov 2019 17:34:32 -0800 (PST)
Message-Id: <20191108.173432.1139057558916119461.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 17:34:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) BPF sample build fixes from Björn Töpel

2) Fix powerpc bpf tail call implementation, from Eric Dumazet.

3) DCCP leaks jiffies on the wire, fix also from Eric Dumazet.

4) Fix crash in ebtables when using dnat target, from Florian
   Westphal.

5) Fix port disable handling whne removing bcm_sf2 driver, from
   Florian Fainelli.

6) Fix kTLS sk_msg trim on fallback to copy mode, from Jakub Kicinski.

7) Various KCSAN fixes all over the networking, from Eric Dumazet.

8) Memory leaks in mlx5 driver, from Alex Vesker.

9) SMC interface refcounting fix, from Ursula Braun.

10) TSO descriptor handling fixes in stmmac driver, from Jose Abreu.

11) Add a TX lock to synchonize the kTLS TX path properly with crypto
    operations.  From Jakub Kicinski.

12) Sock refcount during shutdown fix in vsock/virtio code, from
    Stefano Garzarella.

13) Infinite loop in Intel ice driver, from Colin Ian King.

Please pull, thanks a lot!

The following changes since commit 1204c70d9dcba31164f78ad5d8c88c42335d51f8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-11-01 17:48:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to a2582cdc32f071422e0197a6c59bd1235b426ce2:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue (2019-11-08 16:50:14 -0800)

----------------------------------------------------------------
Ahmed Zaki (1):
      mac80211: fix station inactive_time shortly after boot

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for DW5821e with eSIM support

Alex Vesker (2):
      net/mlx5: DR, Fix memory leak in modify action destroy
      net/mlx5: DR, Fix memory leak during rule creation

Alexander Sverdlin (1):
      net: ethernet: octeon_mgmt: Account for second possible VLAN header

Appana Durga Kedareswara rao (1):
      can: xilinx_can: Fix flags field initialization for axi can

Arkadiusz Kubalewski (1):
      i40e: Fix for ethtool -m issue on X722 NIC

Björn Töpel (3):
      perf tools: Make usage of test_attr__* optional for perf-sys.h
      samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
      bpf: Change size to u64 for bpf_map_{area_alloc, charge_init}()

Chuhong Yuan (1):
      net: fec: add missed clk_disable_unprepare in remove

Claudiu Manoil (2):
      net: mscc: ocelot: don't handle netdev events for other netdevs
      net: mscc: ocelot: fix NULL pointer on LAG slave removal

Colin Ian King (2):
      can: j1939: fix resource leak of skb on error return paths
      ice: fix potential infinite loop because loop counter being too small

Dan Carpenter (1):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Daniel Borkmann (1):
      bpf, doc: Add Andrii as official reviewer to BPF subsystem

David Ahern (1):
      ipv4: Fix table id reference in fib_sync_down_addr

David S. Miller (10):
      Merge tag 'linux-can-fixes-for-5.4-20191105' of git://git.kernel.org/.../mkl/linux-can
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'net-bcmgenet-restore-internal-EPHY-support'
      Merge branch 'Bonding-fixes-for-Ocelot-switch'
      Merge branch 'net-tls-add-a-TX-lock'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'stmmac-fixes'
      Merge tag 'mlx5-fixes-2019-11-06' of git://git.kernel.org/.../saeed/linux
      Merge tag 'mac80211-for-net-2019-11-08' of git://git.kernel.org/.../jberg/mac80211
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/net-queue

Dmytro Linkin (1):
      net/mlx5e: Use correct enum to determine uplink port

Dotan Barak (1):
      mlx4_core: fix wrong comment about the reason of subtract one from the max_cqes

Doug Berger (3):
      net: bcmgenet: use RGMII loopback for MAC reset
      Revert "net: bcmgenet: soft reset 40nm EPHYs before MAC init"
      net: bcmgenet: reapply manual settings to the PHY

Eric Dumazet (5):
      powerpc/bpf: Fix tail call implementation
      dccp: do not leak jiffies on the wire
      net: prevent load/store tearing on sk->sk_stamp
      ipv6: fixes rt6_probe() and fib6_nh->last_probe init
      net: fix data-race in neigh_event_send()

Fernando Fernandez Mancera (1):
      netfilter: nf_tables: fix unexpected EOPNOTSUPP error

Florian Fainelli (1):
      net: dsa: bcm_sf2: Fix driver removal

Florian Westphal (1):
      bridge: ebtables: don't crash when using dnat target in output chains

Heiner Kallweit (1):
      r8169: fix page read in r8168g_mdio_read

Huazhong Tan (1):
      net: hns3: add compatible handling for command HCLGE_OPC_PF_RST_DONE

Ilya Leoshkevich (1):
      bpf: Allow narrow loads of bpf_sysctl fields with offset > 0

Ivan Khoronzhuk (1):
      taprio: fix panic while hw offload sched list swap

Jacob Keller (1):
      igb/igc: use ktime accessors for skb->tstamp

Jakub Kicinski (4):
      net/tls: fix sk_msg trim on fallback to copy mode
      net/tls: don't pay attention to sk_write_pending when pushing partial records
      net/tls: add a TX lock
      selftests/tls: add test for concurrent recv and send

Jay Vosburgh (1):
      bonding: fix state transition issue in link monitoring

Jeroen Hofstee (10):
      can: peak_usb: report bus recovery as well
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open
      can: c_can: C_CAN: add bus recovery events
      can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on error
      can: ti_hecc: ti_hecc_stop(): stop the CPK on down
      can: ti_hecc: keep MIM and MD set
      can: ti_hecc: release the mailbox a bit earlier
      can: ti_hecc: add fifo overflow error reporting
      can: ti_hecc: properly report state changes
      can: ti_hecc: add missing state changes

Joakim Zhang (1):
      can: flexcan: disable completely the ECC mechanism

Johan Hovold (3):
      can: mcba_usb: fix use-after-free on disconnect
      can: usb_8dev: fix use-after-free on disconnect
      can: peak_usb: fix slab info leak

Johannes Berg (1):
      mac80211: fix ieee80211_txq_setup_flows() failure path

John Hurley (1):
      net: sched: prevent duplicate flower rules from tcf_proto destroy race

Jose Abreu (11):
      net: stmmac: gmac4: bitrev32 returns u32
      net: stmmac: xgmac: bitrev32 returns u32
      net: stmmac: selftests: Prevent false positives in filter tests
      net: stmmac: xgmac: Only get SPH header len if available
      net: stmmac: xgmac: Fix TSA selection
      net: stmmac: xgmac: Fix AV Feature detection
      net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in AV
      net: stmmac: xgmac: Disable MMC interrupts by default
      net: stmmac: Fix the packet count in stmmac_rx()
      net: stmmac: Fix TSO descriptor with Enhanced Addressing
      net: stmmac: Fix the TX IOC in xmit path

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Magnus Karlsson (2):
      i40e: need_wakeup flag might not be set for Tx
      ixgbe: need_wakeup flag might not be set for Tx

Manish Chopra (1):
      qede: fix NULL pointer deref in __qede_remove()

Marc Kleine-Budde (8):
      can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, avoid skb mem leak
      can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avoid skb mem leak
      can: rx-offload: can_rx_offload_offload_one(): do not increase the skb_queue beyond skb_queue_len_max
      can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_errors on queue overflow or OOM
      can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propagate error value in case of errors
      can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error
      can: flexcan: increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails
      can: ti_hecc: ti_hecc_error(): increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails

Navid Emamdoost (1):
      can: gs_usb: gs_can_open(): prevent memory leak

Nicholas Nunley (1):
      iavf: initialize ITRN registers with correct values

Nishad Kamdar (1):
      net: hns3: Use the correct style for SPDX License Identifier

Oleksij Rempel (3):
      can: j1939: fix memory leak if filters was set
      can: j1939: transport: j1939_session_fresh_new(): make sure EOMA is send with the total message size set
      can: j1939: transport: j1939_xtp_rx_eoma_one(): Add sanity check for correct total message size

Oliver Neukum (1):
      CDC-NCM: handle incomplete transfer of MTU

Pablo Neira Ayuso (4):
      netfilter: nf_tables_offload: check for register data length mismatches
      netfilter: nf_tables: bogus EOPNOTSUPP on basechain update
      netfilter: nf_tables_offload: skip EBUSY on chain update
      Merge branch 'master' of git://blackhole.kfki.hu/nf

Pan Bian (3):
      NFC: fdp: fix incorrect free object
      NFC: st21nfca: fix double free
      nfc: netlink: fix double device reference drop

Roi Dayan (1):
      net/mlx5e: Fix eswitch debug print of max fdb flow

Salil Mehta (1):
      net: hns: Fix the stray netpoll locks causing deadlock in NAPI path

Sean Tranchetti (1):
      net: qualcomm: rmnet: Fix potential UAF when unregistering

Stefano Brivio (1):
      netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 sets

Stefano Garzarella (1):
      vsock/virtio: fix sock refcnt holding during the shutdown

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Tariq Toukan (1):
      Documentation: TLS: Add missing counter description

Timo Schlüßler (1):
      can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_quit race condition

Toke Høiland-Jørgensen (1):
      net/fq_impl: Switch to kvmalloc() for memory allocation

Ursula Braun (1):
      net/smc: fix ethernet interface refcounting

Vladimir Oltean (1):
      net: mscc: ocelot: fix __ocelot_rmw_ix prototype

Wen Yang (1):
      can: dev: add missing of_node_put() after calling of_get_child_by_name()

Yegor Yefremov (1):
      can: don't use deprecated license identifiers

 Documentation/networking/tls-offload.rst                           |   4 ++
 MAINTAINERS                                                        |   1 +
 arch/powerpc/net/bpf_jit_comp64.c                                  |  13 +++++
 drivers/net/bonding/bond_main.c                                    |  44 +++++++--------
 drivers/net/can/c_can/c_can.c                                      |  71 +++++++++++++++++++++---
 drivers/net/can/c_can/c_can.h                                      |   1 +
 drivers/net/can/dev.c                                              |   1 +
 drivers/net/can/flexcan.c                                          |  11 +++-
 drivers/net/can/rx-offload.c                                       | 102 +++++++++++++++++++++++++++++------
 drivers/net/can/spi/mcp251x.c                                      |   2 +-
 drivers/net/can/ti_hecc.c                                          | 232 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/net/can/usb/gs_usb.c                                       |   1 +
 drivers/net/can/usb/mcba_usb.c                                     |   3 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c                            |  32 +++++++----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                       |   2 +-
 drivers/net/can/usb/usb_8dev.c                                     |   3 +-
 drivers/net/can/xilinx_can.c                                       |   1 -
 drivers/net/dsa/bcm_sf2.c                                          |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                     |  35 ++++++------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                     |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c                       | 145 +++++++++++++++++++++++++++++++------------------
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c                   |   2 +-
 drivers/net/ethernet/freescale/fec_main.c                          |   2 +
 drivers/net/ethernet/hisilicon/hns/hnae.c                          |   1 -
 drivers/net/ethernet/hisilicon/hns/hnae.h                          |   3 --
 drivers/net/ethernet/hisilicon/hns/hns_enet.c                      |  22 +-------
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                        |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h                    |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h             |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h             |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c            |  18 ++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h            |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h            |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h              |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h                  |   2 +
 drivers/net/ethernet/intel/i40e/i40e_common.c                      |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                         |  10 +---
 drivers/net/ethernet/intel/iavf/iavf_main.c                        |   4 +-
 drivers/net/ethernet/intel/ice/ice_sched.c                         |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c                          |   4 +-
 drivers/net/ethernet/intel/igc/igc_main.c                          |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                       |  10 +---
 drivers/net/ethernet/mellanox/mlx4/main.c                          |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c       |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c         |   2 +
 drivers/net/ethernet/mscc/ocelot.c                                 |   9 ++--
 drivers/net/ethernet/mscc/ocelot.h                                 |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c                       |  12 ++++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c                 |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c                          |   3 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c                |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c               |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c                 |   4 +-
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c                     |   6 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |  70 +++++++++++++-----------
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c             | 134 ++++++++++++++++++++++++++++++++--------------
 drivers/net/usb/cdc_ncm.c                                          |   6 +--
 drivers/net/usb/qmi_wwan.c                                         |   1 +
 drivers/nfc/fdp/i2c.c                                              |   2 +-
 drivers/nfc/st21nfca/core.c                                        |   1 +
 include/linux/bpf.h                                                |   4 +-
 include/linux/skmsg.h                                              |   9 ++--
 include/net/bonding.h                                              |   3 +-
 include/net/fq_impl.h                                              |   4 +-
 include/net/neighbour.h                                            |   4 +-
 include/net/netfilter/nf_tables.h                                  |   3 +-
 include/net/sch_generic.h                                          |   4 ++
 include/net/sock.h                                                 |   4 +-
 include/net/tls.h                                                  |   5 ++
 include/uapi/linux/can.h                                           |   2 +-
 include/uapi/linux/can/bcm.h                                       |   2 +-
 include/uapi/linux/can/error.h                                     |   2 +-
 include/uapi/linux/can/gw.h                                        |   2 +-
 include/uapi/linux/can/j1939.h                                     |   2 +-
 include/uapi/linux/can/netlink.h                                   |   2 +-
 include/uapi/linux/can/raw.h                                       |   2 +-
 include/uapi/linux/can/vxcan.h                                     |   2 +-
 kernel/bpf/cgroup.c                                                |   4 +-
 kernel/bpf/syscall.c                                               |   7 ++-
 net/bridge/netfilter/ebt_dnat.c                                    |  19 +++++--
 net/can/j1939/socket.c                                             |   9 +++-
 net/can/j1939/transport.c                                          |  20 ++++++-
 net/core/skmsg.c                                                   |  20 +++++--
 net/dccp/ipv4.c                                                    |   2 +-
 net/ipv4/fib_semantics.c                                           |   2 +-
 net/ipv6/route.c                                                   |  13 +++--
 net/mac80211/main.c                                                |   2 +-
 net/mac80211/sta_info.c                                            |   3 +-
 net/netfilter/ipset/ip_set_core.c                                  |  49 +++++++++++------
 net/netfilter/ipset/ip_set_hash_ipmac.c                            |   2 +-
 net/netfilter/ipset/ip_set_hash_net.c                              |   1 +
 net/netfilter/ipset/ip_set_hash_netnet.c                           |   1 +
 net/netfilter/nf_tables_api.c                                      |   7 ++-
 net/netfilter/nf_tables_offload.c                                  |   3 +-
 net/netfilter/nft_bitwise.c                                        |   5 +-
 net/netfilter/nft_cmp.c                                            |   2 +-
 net/nfc/netlink.c                                                  |   2 -
 net/sched/cls_api.c                                                |  83 ++++++++++++++++++++++++++--
 net/sched/sch_taprio.c                                             |   5 +-
 net/smc/smc_pnet.c                                                 |   2 -
 net/tls/tls_device.c                                               |  10 +++-
 net/tls/tls_main.c                                                 |   2 +
 net/tls/tls_sw.c                                                   |  30 ++++-------
 net/vmw_vsock/virtio_transport_common.c                            |   8 +--
 samples/bpf/Makefile                                               |   1 +
 tools/perf/perf-sys.h                                              |   6 ++-
 tools/testing/selftests/bpf/test_sysctl.c                          |   8 ++-
 tools/testing/selftests/net/tls.c                                  | 108 +++++++++++++++++++++++++++++++++++++
 111 files changed, 1093 insertions(+), 483 deletions(-)
