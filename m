Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4814128C3D
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfLVCJR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 21 Dec 2019 21:09:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfLVCJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:09:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70C991516B543;
        Sat, 21 Dec 2019 18:09:16 -0800 (PST)
Date:   Sat, 21 Dec 2019 18:09:14 -0800 (PST)
Message-Id: <20191221.180914.601367701836089009.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Dec 2019 18:09:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Several nf_flow_table_offload fixes from Pablo Neira Ayuso, including
   adding a missing ipv6 match description.

2) Several heap overflow fixes in mwifiex from qize wang and Ganapathi Bhat.

3) Fix uninit value in bond_neigh_init(), from Eric Dumazet.

4) Fix non-ACPI probing of nxp-nci, from Stephan Gerhold.

5) Fix use after free in tipc_disc_rcv(), from Tuong Lien.

6) Enforce limit of 33 tail calls in mips and riscv JIT, from Paul
   Chaignon.

7) Multicast MAC limit test is off by one in qede, from Manish Chopra.

8) Fix established socket lookup race when socket goes from TCP_ESTABLISHED
   to TCP_LISTEN, because there lacks an intervening RCU grace period.
   From Eric Dumazet.

9) Don't send empty SKBs from tcp_write_xmit(), also from Eric Dumazet.

10) Fix active backup transition after link failure in bonding, from
    Mahesh Bandewar.

11) Avoid zero sized hash table in gtp driver, from Taehee Yoo.

12) Fix wrong interface passed to ->mac_link_up(), from Russell King.

13) Fix DSA egress flooding settings in b53, from Florian Fainelli.

14) Memory leak in gmac_setup_txqs(), from Navid Emamdoost.

15) Fix double free in dpaa2-ptp code, from Ioana Ciornei.

16) Reject invalid MTU values in stmmac, from Jose Abreu.

17) Fix refcount leak in error path of u32 classifier, from Davide
    Caratti.

18) Fix regression causing iwlwifi firmware crashes on boot, from Anders
    Kaseorg.

19) Fix inverted return value logic in llc2 code, from Chan Shu Tak.

20) Disable hardware GRO when XDP is attached to qede, frm Manish
    Chopra.

21) Since we encode state in the low pointer bits, dst metrics must be
    at least 4 byte aligned, which is not necessarily true on m68k.  Add
    annotations to fix this, from Geert Uytterhoeven.

Please pull, thanks a lot!

The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 4bfeadfc0712bbc8a6556eef6d47cbae1099dea3:

  Merge branch 'sfc-fix-bugs-introduced-by-XDP-patches' (2019-12-20 21:56:48 -0800)

----------------------------------------------------------------
Aditya Pakki (2):
      rfkill: Fix incorrect check to avoid NULL pointer dereference
      nfc: s3fwrn5: replace the assertion with a WARN_ON

Alexander Lobakin (1):
      net, sysctl: Fix compiler warning when only cBPF is present

Alexei Starovoitov (2):
      bpf: Make BPF trampoline use register_ftrace_direct() API
      selftests/bpf: Test function_graph tracer and bpf trampoline together

Anders Kaseorg (1):
      Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ detection"

Antoine Tenart (2):
      of: mdio: export of_mdiobus_child_is_phy
      net: macb: fix probing of PHY not described in the dt

Arnd Bergmann (5):
      bpf: Fix build in minimal configurations, again
      ptp: clockmatrix: add I2C dependency
      net: ethernet: ti: select PAGE_POOL for switchdev driver
      net: ethernet: ti: build cpsw-common for switchdev
      net: dsa: ocelot: add NET_VENDOR_MICROSEMI dependency

Arthur Kiyanovski (2):
      net: ena: fix default tx interrupt moderation interval
      net: ena: fix issues in setting interrupt moderation params in ethtool

Ben Dooks (Codethink) (1):
      net: dsa: make unexported dsa_link_touch() static

Ben Hutchings (1):
      net: qlogic: Fix error paths in ql_alloc_large_buffers()

Chan Shu Tak, Alex (1):
      llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c)

Charles McLachlan (1):
      sfc: Include XDP packet headroom in buffer step size.

Christian Lamparter (1):
      ath9k: use iowrite32 over __raw_writel

Chuhong Yuan (1):
      fjes: fix missed check in fjes_acpi_add

Cristian Birsan (2):
      net: usb: lan78xx: Fix suspend/resume PHY register access error
      net: usb: lan78xx: Fix error message format specifier

Dan Carpenter (1):
      mac80211: airtime: Fix an off by one in ieee80211_calc_rx_airtime()

Dan Murphy (4):
      MAINTAINERS: Add myself as a maintainer for MMIO m_can
      MAINTAINERS: Add myself as a maintainer for TCAN4x5x
      dt-bindings: tcan4x5x: Make wake-gpio an optional gpio
      can: tcan45x: Make wake-up GPIO an optional GPIO

Daniel Borkmann (5):
      bpf: Fix missing prog untrack in release_maps
      bpf: Fix cgroup local storage prog tracking
      Merge branch 'bpf-fix-xsk-wakeup'
      bpf: Fix record_func_key to perform backtracking on r3
      bpf: Add further test_verifier cases for record_func_key

Daniel T. Lee (2):
      samples: bpf: Replace symbol compare of trace_event
      samples: bpf: fix syscall_tp due to unused syscall

David S. Miller (15):
      Merge tag 'linux-can-fixes-for-5.5-20191208' of git://git.kernel.org/.../mkl/linux-can
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'bnxt_en-Error-recovery-fixes'
      Merge branch 'tipc-fix-some-issues'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'vsock-fixes'
      Merge tag 'mac80211-for-net-2019-10-16' of git://git.kernel.org/.../jberg/mac80211
      Merge tag 'wireless-drivers-2019-12-17' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'stmmac-fixes'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'macb-fix-probing-of-PHY-not-described-in-the-dt'
      Merge branch 'cls_u32-fix-refcount-leak'
      Merge branch 's390-fixes'
      Merge branch 'ena-fixes-of-interrupt-moderation-bugs'
      Merge branch 'sfc-fix-bugs-introduced-by-XDP-patches'

Davide Caratti (3):
      tc-testing: unbreak full listing of tdc testcases
      net/sched: cls_u32: fix refcount leak in the error path of u32_change()
      tc-testing: initial tdc selftests for cls_u32

Edward Cree (1):
      sfc: fix channel allocation with brute force

Eric Dumazet (9):
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
      neighbour: remove neigh_cleanup() method
      bonding: fix bond_neigh_init()
      tcp/dccp: fix possible race __inet_lookup_established()
      6pack,mkiss: fix possible deadlock
      tcp: do not send empty skb from tcp_write_xmit()
      tcp: refine tcp_write_queue_empty() implementation
      tcp: refine rule to allow EPOLLOUT generation under mem pressure
      net: annotate lockless accesses to sk->sk_pacing_shift

Florian Fainelli (1):
      net: dsa: b53: Fix egress flooding settings

Florian Westphal (3):
      netfilter: ctnetlink: netns exit must wait for callbacks
      netfilter: conntrack: tell compiler to not inline nf_ct_resolve_clash
      selftests: netfilter: use randomized netns names

Fredrik Olofsson (1):
      mac80211: fix TID field in monitor mode transmit

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Geert Uytterhoeven (1):
      net: dst: Force 4-byte alignment of dst_metrics

Grygorii Strashko (1):
      net: ethernet: ti: davinci_cpdma: fix warning "device driver frees DMA memory with different size"

Haiyang Zhang (2):
      hv_netvsc: Fix tx_table init in rndis_set_subchannel()
      hv_netvsc: Fix unwanted rx_table reset

Hangbin Liu (2):
      ipv6/addrconf: only check invalid header values when NETLINK_F_STRICT_CHK is set
      selftests: pmtu: fix init mtu value in description

Ido Schimmel (2):
      mlxsw: spectrum_router: Remove unlikely user-triggerable warning
      selftests: forwarding: Delete IPv6 address at the end

Ioana Ciornei (1):
      dpaa2-ptp: fix double free of the ptp_qoriq IRQ

Jakub Kicinski (3):
      Merge branch 'tcp-take-care-of-empty-skbs-in-write-queue'
      Merge branch 'bnx2x-bug-fixes'
      Merge branch 'gtp-fix-several-bugs-in-gtp-module'

Jia-Ju Bai (1):
      net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart_tty_receive()

Jiangfeng Xiao (1):
      net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Joakim Zhang (2):
      can: flexcan: add low power enter/exit acknowledgment helper
      can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment

John Hurley (1):
      nfp: flower: fix stats id allocation

Jonathan Lemon (1):
      bnxt: apply computed clamp value for coalece parameter

Jose Abreu (9):
      net: stmmac: selftests: Needs to check the number of Multicast regs
      net: stmmac: Determine earlier the size of RX buffer
      net: stmmac: Do not accept invalid MTU values
      net: stmmac: Only the last buffer has the FCS field
      net: stmmac: xgmac: Clear previous RX buffer size
      net: stmmac: RX buffer size must be 16 byte aligned
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size
      net: stmmac: Always arm TX Timer at end of transmission start

Jouni Hogander (1):
      net-sysfs: Call dev_hold always in rx_queue_add_kobject

Julian Wiedmann (3):
      s390/qeth: handle error due to unsupported transport mode
      s390/qeth: fix promiscuous mode after reset
      s390/qeth: don't return -ENOTSUPP to userspace

Karsten Graul (1):
      net/smc: unregister ib devices in reboot_event

Lorenz Bauer (1):
      bpf: Clear skb->tstamp in bpf_redirect when necessary

Lorenzo Bianconi (1):
      mt76: mt76x0: fix default mac address overwrite

Luca Coelho (1):
      iwlwifi: pcie: move power gating workaround earlier in the flow

Mahesh Bandewar (1):
      bonding: fix active-backup transition after link failure

Manish Chopra (4):
      qede: Fix multicast mac configuration
      bnx2x: Do not handle requests from VFs after parity
      bnx2x: Fix logic to get total no. of PFs per engine
      qede: Disable hardware gro when xdp prog is installed

Mao Wenan (1):
      af_packet: set defaule value for tmo

Marc Kleine-Budde (1):
      can: j1939: fix address claim code example

Marcelo Ricardo Leitner (1):
      sctp: fix memleak on err handling of stream initialization

Marco Oliverio (1):
      netfilter: nf_queue: enqueue skbs with NULL dst

Martin Schiller (1):
      net/x25: add new state X25_STATE_5

Maxim Mikityanskiy (4):
      xsk: Add rcu_read_lock around the XSK wakeup
      net/mlx5e: Fix concurrency issues between config flow and XSK
      net/i40e: Fix concurrency issues between config flow and XSK
      net/ixgbe: Fix concurrency issues between config flow and XSK

Michael Chan (2):
      bnxt_en: Fix MSIX request logic for RDMA driver.
      bnxt_en: Free context memory in the open path if firmware has been reset.

Michael Grzeschik (1):
      net: dsa: ksz: use common define for tag len

Nathan Chancellor (1):
      netfilter: nf_flow_table_offload: Don't use offset uninitialized in flow_offload_port_{d,s}nat

Navid Emamdoost (1):
      net: gemini: Fix memory leak in gmac_setup_txqs

Netanel Belgazal (1):
      net: ena: fix napi handler misbehavior when the napi budget is zero

Oleksij Rempel (2):
      can: j1939: j1939_sk_bind(): take priv after lock is held
      net: ag71xx: fix compile warnings

Pablo Neira Ayuso (7):
      netfilter: nf_flow_table_offload: add IPv6 match description
      netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements in named sets
      netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
      netfilter: nf_tables: skip module reference count bump on object updates
      netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no actions
      netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle()

Padmanabhan Rajanbabu (1):
      net: stmmac: platform: Fix MDIO init for platforms without PHY

Paul Chaignon (2):
      bpf, riscv: Limit to 33 tail calls
      bpf, mips: Limit to 33 tail calls

Paul Durrant (1):
      xen-netback: avoid race that can lead to NULL pointer dereference

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Rahul Lakkireddy (1):
      cxgb4: fix refcount init for TC-MQPRIO offload

Randy Dunlap (1):
      net: fix kernel-doc warning in <linux/netdevice.h>

Russell King (4):
      net: marvell: mvpp2: phylink requires the link interrupt
      net: phylink: fix interface passed to mac_link_up
      mod_devicetable: fix PHY module format
      net: phy: ensure that phy IDs are correctly typed

Sean Nyekjaer (3):
      can: flexcan: fix possible deadlock and out-of-order reception after wakeup
      can: m_can: tcan4x5x: add required delay after reset
      dt-bindings: can: tcan4x5x: reset pin is active high

Srinivas Neeli (1):
      can: xilinx_can: Fix missing Rx can packets on CANFD2.0

Stefan Bühler (1):
      cfg80211: fix double-free after changing network namespace

Stefano Garzarella (2):
      vsock/virtio: fix null-pointer dereference in virtio_transport_recv_listen()
      vsock/virtio: add WARN_ON check on virtio_transport_get_ops()

Stephan Gerhold (1):
      NFC: nxp-nci: Fix probing without ACPI

Subash Abhinov Kasiviswanathan (1):
      MAINTAINERS: Add maintainers for rmnet

Taehee Yoo (4):
      gtp: do not allow adding duplicate tid and ms_addr pdp context
      gtp: fix wrong condition in gtp_genl_dump_pdp()
      gtp: fix an use-after-free in ipv4_pdp_find()
      gtp: avoid zero size hashtable

Thadeu Lima de Souza Cascardo (1):
      selftests: net: tls: remove recv_rcvbuf test

Thomas Falcon (1):
      net/ibmvnic: Fix typo in retry check

Toke Høiland-Jørgensen (2):
      bpftool: Don't crash on missing jited insns or ksyms
      mac80211: Turn AQL into an NL80211_EXT_FEATURE

Tuong Lien (4):
      tipc: fix name table rbtree issues
      tipc: fix potential hanging after b/rcast changing
      tipc: fix retrans failure due to wrong destination
      tipc: fix use-after-free in tipc_disc_rcv()

Ursula Braun (1):
      net/smc: add fallback check to connect()

Vasundhara Volam (5):
      bnxt_en: Return error if FW returns more data than dump length
      bnxt_en: Fix bp->fw_health allocation and free logic.
      bnxt_en: Remove unnecessary NULL checks for fw_health
      bnxt_en: Fix the logic that creates the health reporters.
      bnxt_en: Add missing devlink health reporters for VFs.

Vishal Kulkarni (1):
      cxgb4: Fix kernel panic while accessing sge_info

Vivien Didelot (1):
      mailmap: add entry for myself

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Xin Long (1):
      sctp: fully initialize v4 addr in some functions

qize wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()

wenxu (3):
      netfilter: nf_flow_table_offload: Fix block setup as TC_SETUP_FT cmd
      netfilter: nf_flow_table_offload: Fix block_cb tc_setup_type as TC_SETUP_CLSFLOWER
      netfilter: nf_tables_offload: Check for the NETDEV_UNREGISTER event

 .mailmap                                                       |   1 +
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt         |   4 +-
 Documentation/networking/j1939.rst                             |   2 +-
 MAINTAINERS                                                    |  17 ++++++
 arch/mips/net/ebpf_jit.c                                       |   9 +--
 arch/riscv/net/bpf_jit_comp.c                                  |   4 +-
 drivers/net/bonding/bond_main.c                                |  42 ++++++-------
 drivers/net/can/flexcan.c                                      |  73 +++++++++++-----------
 drivers/net/can/m_can/tcan4x5x.c                               |  26 ++++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c               |   6 +-
 drivers/net/can/xilinx_can.c                                   |   7 +++
 drivers/net/dsa/b53/b53_common.c                               |  21 +++++--
 drivers/net/dsa/ocelot/Kconfig                                 |   1 +
 drivers/net/ethernet/amazon/ena/ena_com.h                      |   2 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c                  |  24 ++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.c                   |  10 +++-
 drivers/net/ethernet/atheros/ag71xx.c                          |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c               |  12 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h              |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c               |  12 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |  63 ++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c              |  93 +++++++++++++++++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h              |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c              |  38 +++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h              |   4 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c                  |   8 ++-
 drivers/net/ethernet/cadence/macb_main.c                       |  27 +++++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |   4 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c           |  12 ++--
 drivers/net/ethernet/cortina/gemini.c                          |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c               |  14 +++--
 drivers/net/ethernet/hisilicon/hip04_eth.c                     |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                             |   2 +-
 drivers/net/ethernet/intel/i40e/i40e.h                         |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |  10 +++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                     |   4 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   7 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                   |   8 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h                   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h               |  22 +++----
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |  19 +-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c          |   7 ++-
 drivers/net/ethernet/netronome/nfp/flower/metadata.c           |  12 ++--
 drivers/net/ethernet/qlogic/qede/qede_filter.c                 |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c                   |   4 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                          |   8 +--
 drivers/net/ethernet/sfc/efx.c                                 |  37 ++++++------
 drivers/net/ethernet/sfc/net_driver.h                          |   4 +-
 drivers/net/ethernet/sfc/rx.c                                  |  14 ++---
 drivers/net/ethernet/stmicro/stmmac/common.h                   |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h                 |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c             |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |  53 +++++++++-------
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c          |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c         |   4 ++
 drivers/net/ethernet/ti/Kconfig                                |   1 +
 drivers/net/ethernet/ti/Makefile                               |   1 +
 drivers/net/ethernet/ti/davinci_cpdma.c                        |   5 +-
 drivers/net/fjes/fjes_main.c                                   |   3 +
 drivers/net/gtp.c                                              | 109 +++++++++++++++++++--------------
 drivers/net/hamradio/6pack.c                                   |   4 +-
 drivers/net/hamradio/mkiss.c                                   |   4 +-
 drivers/net/hyperv/hyperv_net.h                                |   3 +-
 drivers/net/hyperv/netvsc_drv.c                                |   4 +-
 drivers/net/hyperv/rndis_filter.c                              |  16 +++--
 drivers/net/phy/phy_device.c                                   |   8 +--
 drivers/net/phy/phylink.c                                      |   3 +-
 drivers/net/usb/lan78xx.c                                      |   3 +-
 drivers/net/wireless/ath/ath10k/mac.c                          |   1 +
 drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                  |  24 ++++----
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c           |  25 --------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                |  30 ++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c               |  13 +++-
 drivers/net/wireless/marvell/mwifiex/tdls.c                    |  70 ++++++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c             |   5 +-
 drivers/net/xen-netback/interface.c                            |  24 ++++----
 drivers/nfc/nxp-nci/i2c.c                                      |   2 +-
 drivers/nfc/s3fwrn5/firmware.c                                 |   5 +-
 drivers/of/of_mdio.c                                           |   3 +-
 drivers/ptp/Kconfig                                            |   2 +-
 drivers/s390/net/qeth_core_main.c                              |  14 ++---
 drivers/s390/net/qeth_core_mpc.h                               |   5 ++
 drivers/s390/net/qeth_core_sys.c                               |   2 +-
 drivers/s390/net/qeth_l2_main.c                                |   1 +
 drivers/s390/net/qeth_l2_sys.c                                 |   3 +-
 drivers/s390/net/qeth_l3_main.c                                |   1 +
 include/linux/bpf-cgroup.h                                     |   8 +--
 include/linux/bpf.h                                            |   3 +
 include/linux/mod_devicetable.h                                |   4 +-
 include/linux/netdevice.h                                      |   2 +-
 include/linux/of_mdio.h                                        |   6 ++
 include/linux/phy.h                                            |   2 +-
 include/linux/rculist_nulls.h                                  |  37 ++++++++++++
 include/net/dst.h                                              |   2 +-
 include/net/inet_hashtables.h                                  |  12 +++-
 include/net/neighbour.h                                        |   1 -
 include/net/sock.h                                             |   9 ++-
 include/net/tcp.h                                              |  11 +++-
 include/net/x25.h                                              |   3 +-
 include/uapi/linux/netfilter/xt_sctp.h                         |   6 +-
 include/uapi/linux/nl80211.h                                   |   5 ++
 kernel/bpf/btf.c                                               |   1 +
 kernel/bpf/core.c                                              |  17 ++++--
 kernel/bpf/local_storage.c                                     |  24 ++++----
 kernel/bpf/trampoline.c                                        |  64 ++++++++++++++++++--
 kernel/bpf/verifier.c                                          |  24 ++++----
 net/bridge/br_netfilter_hooks.c                                |   3 +
 net/can/j1939/socket.c                                         |  10 +++-
 net/core/filter.c                                              |   1 +
 net/core/neighbour.c                                           |   3 -
 net/core/net-sysfs.c                                           |   7 ++-
 net/core/sock.c                                                |   2 +-
 net/core/sysctl_net_core.c                                     |   2 +
 net/dsa/dsa2.c                                                 |   3 +-
 net/dsa/tag_ksz.c                                              |   8 +--
 net/ipv4/inet_diag.c                                           |   3 +-
 net/ipv4/inet_hashtables.c                                     |  16 ++---
 net/ipv4/tcp.c                                                 |   6 +-
 net/ipv4/tcp_bbr.c                                             |   3 +-
 net/ipv4/tcp_ipv4.c                                            |   7 ++-
 net/ipv4/tcp_output.c                                          |  17 ++++--
 net/ipv6/addrconf.c                                            |   8 +--
 net/llc/llc_station.c                                          |   4 +-
 net/mac80211/airtime.c                                         |   2 +-
 net/mac80211/debugfs_sta.c                                     |  76 +++++++++++++++++------
 net/mac80211/main.c                                            |   4 +-
 net/mac80211/sta_info.c                                        |   3 +
 net/mac80211/sta_info.h                                        |   1 -
 net/mac80211/tx.c                                              |  13 +++-
 net/netfilter/nf_conntrack_core.c                              |   7 ++-
 net/netfilter/nf_conntrack_netlink.c                           |   3 +
 net/netfilter/nf_flow_table_offload.c                          |  83 ++++++++++++++------------
 net/netfilter/nf_queue.c                                       |   2 +-
 net/netfilter/nf_tables_api.c                                  |  18 ++++--
 net/netfilter/nf_tables_offload.c                              |   6 ++
 net/netfilter/nft_bitwise.c                                    |   4 +-
 net/netfilter/nft_cmp.c                                        |   6 ++
 net/netfilter/nft_range.c                                      |  10 ++++
 net/netfilter/nft_set_rbtree.c                                 |  21 +++++--
 net/nfc/nci/uart.c                                             |   2 +-
 net/packet/af_packet.c                                         |   3 +-
 net/rfkill/core.c                                              |   7 ++-
 net/sched/cls_u32.c                                            |  25 ++++++++
 net/sctp/protocol.c                                            |   5 ++
 net/sctp/stream.c                                              |   8 ++-
 net/smc/af_smc.c                                               |  14 +++--
 net/smc/smc_core.c                                             |   2 +-
 net/tipc/bcast.c                                               |  24 +++++---
 net/tipc/discover.c                                            |   6 +-
 net/tipc/name_table.c                                          | 279 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 net/tipc/socket.c                                              |  32 +++++-----
 net/vmw_vsock/virtio_transport_common.c                        |  25 ++++++--
 net/wireless/core.c                                            |   1 +
 net/x25/af_x25.c                                               |   8 +++
 net/x25/x25_in.c                                               |  32 ++++++++++
 net/xdp/xsk.c                                                  |  22 ++++---
 samples/bpf/syscall_tp_kern.c                                  |  18 +++++-
 samples/bpf/trace_event_user.c                                 |   4 +-
 tools/bpf/bpftool/prog.c                                       |   2 +-
 tools/bpf/bpftool/xlated_dumper.c                              |   2 +-
 tools/testing/selftests/bpf/test_ftrace.sh                     |  39 ++++++++++++
 tools/testing/selftests/bpf/test_verifier.c                    |  43 ++++++-------
 tools/testing/selftests/bpf/verifier/ref_tracking.c            |   6 +-
 tools/testing/selftests/bpf/verifier/runtime_jit.c             | 151 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/net/forwarding/router_bridge_vlan.sh   |   2 +-
 tools/testing/selftests/net/pmtu.sh                            |   6 +-
 tools/testing/selftests/net/tls.c                              |  28 ---------
 tools/testing/selftests/netfilter/nft_nat.sh                   | 332 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------
 tools/testing/selftests/tc-testing/tc-tests/filters/basic.json |   2 +-
 tools/testing/selftests/tc-testing/tc-tests/filters/tests.json |  22 -------
 tools/testing/selftests/tc-testing/tc-tests/filters/u32.json   | 205 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 176 files changed, 2138 insertions(+), 1005 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_ftrace.sh
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
