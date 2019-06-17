Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A348BC2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfFQSRk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jun 2019 14:17:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFQSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:17:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80AD0150B74C8;
        Mon, 17 Jun 2019 11:17:38 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:17:38 -0700 (PDT)
Message-Id: <20190617.111738.2016163932115402710.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 11:17:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lots of bug fixes here:

1) Out of bounds access in __bpf_skc_lookup, from Lorenz Bauer.

2) Fix rate reporting in cfg80211_calculate_bitrate_he(), from
   John Crispin.

3) Use after free in psock backlog workqueue, from John Fastabend.

4) Fix source port matching in fdb peer flow rule of mlx5, from
   Raed Salem.

5) Use atomic_inc_not_zero() in fl6_sock_lookup(), from Eric Dumazet.

6) Network header needs to be set for packet redirect in nfp, from
   John Hurley.

7) Fix udp zerocopy refcnt, from Willem de Bruijn.

8) Don't assume linear buffers in vxlan and geneve error handlers,
   from Stefano Brivio.

9) Fix TOS matching in mlxsw, from Jiri Pirko.

10) More SCTP cookie memory leak fixes, from Neil Horman.

11) Fix VLAN filtering in rtl8366, from Linus Walluij.

12) Various TCP SACK payload size and fragmentation memory limit fixes
    from Eric Dumazet.

13) Use after free in pneigh_get_next(), also from Eric Dumazet.

14) LAPB control block leak fix from Jeremy Sowden.

Please pull, thanks a lot!

The following changes since commit 1e1d926369545ea09c98c6c7f5d109aa4ee0cd0b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2019-06-07 09:29:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to 4fddbf8a99ee5a65bdd31b3ebbf5a84b9395d496:

  Merge branch 'tcp-fixes' (2019-06-17 10:39:56 -0700)

----------------------------------------------------------------
Alaa Hleihel (2):
      net/mlx5: Avoid reloading already removed devices
      net/mlx5e: Avoid detaching non-existing netdev under switchdev mode

Alakesh Haloi (1):
      selftests: bpf: fix compiler warning in flow_dissector test

Alexander Dahl (1):
      can: usb: Kconfig: Remove duplicate menu entry

Alexei Starovoitov (3):
      Merge branch 'reuseport-fixes'
      Merge branch 'fix-unconnected-udp'
      bpf, x64: fix stack layout of JITed bpf code

Anders Roxell (1):
      net: dsa: fix warning same module names

Andy Strohman (1):
      nl80211: fix station_info pertid memory leak

Anssi Hannula (1):
      can: xilinx_can: use correct bittiming_const for CAN FD core

Arthur Fabre (1):
      bpf: Fix out of bounds memory access in bpf_sk_storage

Avraham Stern (1):
      cfg80211: report measurement start TSF correctly

Björn Töpel (2):
      bpf, riscv: clear target register high 32-bits for and/or/xor on ALU32
      selftests: bpf: add zero extend checks for ALU32 and/or/xor

Chang-Hsien Tsai (1):
      samples, bpf: fix to change the buffer size for read()

Chris Mi (1):
      net/mlx5e: Add ndo_set_feature for uplink representor

Daniel Borkmann (8):
      Merge branch 'bpf-subreg-tests'
      bpf: fix unconnected udp hooks
      bpf: sync tooling uapi header
      bpf, libbpf: enable recvmsg attach types
      bpf, bpftool: enable recvmsg attach types
      bpf: more msg_name rewrite tests to test_sock_addr
      bpf: expand section tests for test_section_names
      Merge branch 'bpf-ppc-div-fix'

David S. Miller (14):
      Merge tag 'wireless-drivers-for-davem-2019-06-07' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'linux-can-fixes-for-5.2-20190607' of git://git.kernel.org/.../mkl/linux-can
      Merge tag 'mlx5-fixes-2019-06-07' of git://git.kernel.org/.../saeed/linux
      Merge branch 'ibmvnic-Fixes-for-device-reset-handling'
      Merge branch 'vxlan-geneve-linear'
      Merge branch 'mlxsw-Various-fixes'
      Merge branch 'net-mvpp2-prs-Fixes-for-VID-filtering'
      Merge tag 'mac80211-for-davem-2019-06-14' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'qmi_wwan-fix-QMAP-handling'
      Merge branch 'tcp-add-three-static-keys'
      Revert "net: phylink: set the autoneg state in phylink_phy_change"
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'tcp-fixes'

Dexuan Cui (1):
      hv_sock: Suppress bogus "may be used uninitialized" warnings

Edward Srouji (1):
      net/mlx5: Update pci error handler entries and command translation

Eli Britstein (1):
      net/mlx5e: Support tagged tunnel over bond

Emmanuel Grumbach (1):
      iwlwifi: fix load in rfkill flow for unified firmware

Enrico Weigelt (1):
      net: ipv4: fib_semantics: fix uninitialized variable

Eric Biggers (1):
      cfg80211: fix memory leak of wiphy device name

Eric Dumazet (12):
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      sysctl: define proc_do_static_key()
      tcp: add tcp_rx_skb_cache sysctl
      tcp: add tcp_tx_skb_cache sysctl
      net: add high_order_alloc_disable sysctl/static key
      tcp: limit payload size of sacked skbs
      tcp: tcp_fragment() should apply sane memory limits
      tcp: add tcp_min_snd_mss sysctl
      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
      tcp: fix compile error if !CONFIG_SYSCTL
      neigh: fix use-after-free read in pneigh_get_next
      ax25: fix inconsistent lock state in ax25_destroy_timer

Eugen Hristev (1):
      can: m_can: implement errata "Needless activation of MRAF irq"

Fabio Estevam (1):
      can: flexcan: Remove unneeded registration message

George Wilkie (1):
      mpls: fix warning with multi-label encap

Govindarajulu Varadarajan (1):
      net: handle 802.1P vlan 0 packets properly

Gustavo A. R. Silva (1):
      mac80211_hwsim: mark expected switch fall-through

Haiyang Zhang (1):
      hv_netvsc: Set probe mode to sync

Hangbin Liu (1):
      selftests/bpf: move test_lirc_mode2_user to TEST_GEN_PROGS_EXTENDED

Ido Schimmel (4):
      mlxsw: spectrum: Use different seeds for ECMP and LAG hash
      mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead
      selftests: mlxsw: Test nexthop offload indication
      mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed

Ilya Maximets (1):
      xdp: check device pointer before clearing

Ioana Ciornei (1):
      net: phylink: set the autoneg state in phylink_phy_change

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing

Jakub Sitnicki (1):
      bpf: sockmap, restore sk_write_space when psock gets dropped

Jeremy Sowden (1):
      lapb: fixed leak of control-blocks.

Jia-Ju Bai (1):
      iwlwifi: Fix double-free problems in iwl_req_fw_callback()

Jiong Wang (2):
      selftests: bpf: move sub-register zero extension checks into subreg.c
      selftests: bpf: complete sub-register zero extension checks

Jiri Pirko (2):
      mlxsw: spectrum_flower: Fix TOS matching
      selftests: tc_flower: Add TOS matching test

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Johannes Berg (3):
      nl80211: fill all policy .type entries
      iwlwifi: mvm: remove d3_sram debugfs file
      mac80211: drop robust management frames from unknown TA

John Crispin (1):
      mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()

John Fastabend (2):
      bpf: sockmap, fix use after free from sleep in psock backlog workqueue
      net: tls, correctly account for copied bytes with multiple sk_msgs

John Hurley (1):
      nfp: ensure skb network header is set for packet redirect

Jonathan Lemon (1):
      bpf: lpm_trie: check left child of last leftmost node for NULL

Jouni Malinen (1):
      mac80211: Do not use stack memory with scatterlist for GMAC

Krzesimir Nowak (1):
      tools: bpftool: Fix JSON output when lookup fails

Linus Walleij (1):
      net: dsa: rtl8366: Fix up VLAN filtering

Lior Cohen (1):
      iwlwifi: mvm: change TLC config cmd sent by rs to be async

Lorenz Bauer (1):
      bpf: fix out-of-bounds read in __bpf_skc_lookup

Luca Coelho (1):
      cfg80211: use BIT_ULL in cfg80211_parse_mbssid_data()

Luke Nelson (1):
      bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh

Manikanta Pubbisetty (1):
      {nl,mac}80211: allow 4addr AP operation on crypto controlled devices

Martin KaFai Lau (4):
      bpf: Check sk_fullsock() before returning from bpf_sk_lookup()
      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err
      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
      bpf: net: Set sk_bpf_storage back to NULL for cloned sk

Martynas Pumputis (2):
      bpf: simplify definition of BPF_FIB_LOOKUP related flags
      bpf: sync BPF_FIB_LOOKUP flag changes with BPF uapi

Masanari Iida (1):
      linux-next: DOC: RDS: Fix a typo in rds.txt

Matt Chen (1):
      iwlwifi: fix AX201 killer sku loading firmware issue

Matt Mullins (1):
      bpf: fix nested bpf tracepoints with per-cpu data

Matteo Croce (3):
      samples, bpf: suppress compiler warning
      mpls: fix af_mpls dependencies
      mpls: fix af_mpls dependencies for real

Maxim Mikityanskiy (1):
      wireless: Skip directory when generating certificates

Maxime Chevallier (3):
      net: ethtool: Allow matching on vlan DEI bit
      net: mvpp2: prs: Fix parser range for VID filtering
      net: mvpp2: prs: Use the correct helpers when removing all VID filters

Michael Schmitz (1):
      net: phy: rename Asix Electronics PHY driver

Michal Rostecki (1):
      libbpf: Return btf_fd for load_sk_storage_btf

Mordechay Goodstein (1):
      cfg80211: util: fix bit count off by one

Naftali Goldstein (1):
      mac80211: do not start any work during reconfigure flow

Nathan Chancellor (1):
      rsi: Properly initialize data in rsi_sdio_ta_reset

Naveen N. Rao (2):
      bpf: fix div64 overflow tests to properly detect errors
      powerpc/bpf: use unsigned division instruction for 64-bit operations

Neil Horman (1):
      sctp: Free cookie before we memdup a new one

Petr Machata (1):
      mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2

Pradeep Kumar Chitrapu (1):
      mac80211: free peer keys before vif down in mesh

Raed Salem (1):
      net/mlx5e: Fix source port matching in fdb peer flow rule

Randy Dunlap (1):
      Documentation/networking: fix af_xdp.rst Sphinx warnings

Reinhard Speyerer (4):
      qmi_wwan: add support for QMAP padding in the RX path
      qmi_wwan: add network device usage statistics for qmimux devices
      qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
      qmi_wwan: extend permitted QMAP mux_id value range

Robert Hancock (1):
      net: dsa: microchip: Don't try to read stats for unused ports

Russell King - ARM Linux admin (1):
      net: phylink: further mac_config documentation improvements

Sean Nyekjaer (2):
      dt-bindings: can: mcp251x: add mcp25625 support
      can: mcp251x: add support for mcp25625

Shahar S Matityahu (2):
      iwlwifi: clear persistence bit according to device family
      iwlwifi: print fseq info upon fw assert

Shay Agroskin (1):
      net/mlx5e: Replace reciprocal_scale in TX select queue function

Stanislaw Gruszka (2):
      rtw88: fix subscript above array bounds compiler warning
      rtw88: avoid circular locking between local->iflist_mtx and rtwdev->mutex

Stefano Brivio (2):
      vxlan: Don't assume linear buffers in error handler
      geneve: Don't assume linear buffers in error handler

Stephen Barber (1):
      vsock/virtio: set SOCK_DONE on peer shutdown

Stephen Suryaputra (1):
      vrf: Increment Icmp6InMsgs on the original netdev

Taehee Yoo (1):
      net: openvswitch: do not free vport if register_netdevice() is failed.

Takashi Iwai (3):
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
      mwifiex: Abort at too short BSS descriptor element
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()

Thomas Falcon (3):
      ibmvnic: Do not close unopened driver during reset
      ibmvnic: Refresh device multicast list after reset
      ibmvnic: Fix unchecked return codes of memory allocations

Thomas Pedersen (1):
      mac80211: mesh: fix RCU warning

Toshiaki Makita (3):
      bpf, devmap: Fix premature entry free on destroying map
      bpf, devmap: Add missing bulk queue free
      bpf, devmap: Add missing RCU read lock on flush

Vlad Buslov (1):
      net: sched: flower: don't call synchronize_rcu() on mask creation

Willem de Bruijn (2):
      can: purge socket error queue on sock destruct
      net: correct udp zerocopy refcnt also when zerocopy only on append

Xin Long (1):
      tipc: purge deferredq list for each grp member in tipc_group_delete

Yan-Hsuan Chuang (1):
      rtw88: fix unassigned rssi_level in rtw_sta_info

Yibo Zhao (1):
      mac80211: only warn once on chanctx_conf being NULL

Young Xiao (1):
      nfc: Ensure presence of required attributes in the deactivate_target handler

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

Yuchung Cheng (1):
      tcp: fix undo spurious SYNACK in passive Fast Open

YueHaibing (3):
      mac80211: remove set but not used variable 'old'
      rtw88: Make some symbols static
      can: af_can: Fix error path of can_init()

 Documentation/ABI/testing/sysfs-class-net-qmi      |   4 +-
 .../bindings/net/can/microchip,mcp251x.txt         |   1 +
 Documentation/networking/af_xdp.rst                |   8 +-
 Documentation/networking/ip-sysctl.txt             |  16 +
 Documentation/networking/rds.txt                   |   2 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   1 +
 arch/powerpc/net/bpf_jit.h                         |   2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   8 +-
 arch/riscv/net/bpf_jit_comp.c                      |  24 +
 arch/x86/net/bpf_jit_comp.c                        |  74 +--
 drivers/net/can/flexcan.c                          |   5 +-
 drivers/net/can/m_can/m_can.c                      |  21 +
 drivers/net/can/spi/Kconfig                        |   5 +-
 drivers/net/can/spi/mcp251x.c                      |  25 +-
 drivers/net/can/usb/Kconfig                        |   6 -
 drivers/net/can/xilinx_can.c                       |   2 +-
 drivers/net/dsa/Makefile                           |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   3 +
 .../net/dsa/{realtek-smi.c => realtek-smi-core.c}  |   2 +-
 .../net/dsa/{realtek-smi.h => realtek-smi-core.h}  |   0
 drivers/net/dsa/rtl8366.c                          |   9 +-
 drivers/net/dsa/rtl8366rb.c                        |   2 +-
 drivers/net/ethernet/8390/Kconfig                  |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  19 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  25 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  73 ++-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   1 +
 drivers/net/geneve.c                               |   2 +-
 drivers/net/hyperv/netvsc_drv.c                    |   2 +-
 drivers/net/phy/Kconfig                            |   2 +-
 drivers/net/phy/Makefile                           |   2 +-
 drivers/net/phy/{asix.c => ax88796b.c}             |   0
 drivers/net/usb/qmi_wwan.c                         | 103 +++-
 drivers/net/vxlan.c                                |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  39 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  22 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  57 ---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  53 +-
 drivers/net/wireless/mac80211_hwsim.c              |   1 +
 drivers/net/wireless/marvell/mwifiex/ie.c          |  47 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  19 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   6 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   3 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  22 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  21 +-
 include/linux/bpf-cgroup.h                         |   8 +
 include/linux/bpf.h                                |   1 -
 include/linux/phylink.h                            |  13 +-
 include/linux/skmsg.h                              |   2 +
 include/linux/sysctl.h                             |   3 +
 include/linux/tcp.h                                |   4 +
 include/net/addrconf.h                             |  16 +
 include/net/cfg80211.h                             |   3 +-
 include/net/flow_dissector.h                       |   1 +
 include/net/netns/ipv4.h                           |   1 +
 include/net/sock.h                                 |  12 +-
 include/net/tcp.h                                  |   2 +
 include/uapi/linux/bpf.h                           |   6 +-
 include/uapi/linux/snmp.h                          |   1 +
 kernel/bpf/core.c                                  |   1 -
 kernel/bpf/devmap.c                                |   9 +-
 kernel/bpf/lpm_trie.c                              |   9 +-
 kernel/bpf/syscall.c                               |   8 +
 kernel/bpf/verifier.c                              |  12 +-
 kernel/sysctl.c                                    |  44 +-
 kernel/trace/bpf_trace.c                           | 100 +++-
 net/ax25/ax25_route.c                              |   2 +
 net/can/af_can.c                                   |  25 +-
 net/core/bpf_sk_storage.c                          |   3 +-
 net/core/dev.c                                     |  30 +-
 net/core/ethtool.c                                 |   5 +
 net/core/filter.c                                  |  26 +-
 net/core/neighbour.c                               |   7 +
 net/core/skbuff.c                                  |   1 +
 net/core/sock.c                                    |   7 +-
 net/core/sysctl_net_core.c                         |   7 +
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/proc.c                                    |   1 +
 net/ipv4/sysctl_net_ipv4.c                         |  23 +
 net/ipv4/tcp.c                                     |   6 +
 net/ipv4/tcp_input.c                               |  28 +-
 net/ipv4/tcp_ipv4.c                                |   1 +
 net/ipv4/tcp_output.c                              |  10 +-
 net/ipv4/tcp_timer.c                               |   1 +
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/icmp.c                                    |  17 +-
 net/ipv6/ip6_flowlabel.c                           |   7 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/reassembly.c                              |   4 +-
 net/ipv6/udp.c                                     |   8 +-
 net/lapb/lapb_iface.c                              |   1 +
 net/mac80211/ieee80211_i.h                         |  12 +-
 net/mac80211/key.c                                 |   2 -
 net/mac80211/mesh.c                                |   6 +-
 net/mac80211/mlme.c                                |  12 +-
 net/mac80211/rx.c                                  |   2 +
 net/mac80211/tdls.c                                |  23 +
 net/mac80211/util.c                                |   8 +-
 net/mac80211/wpa.c                                 |   7 +-
 net/mpls/Kconfig                                   |   1 +
 net/mpls/mpls_iptunnel.c                           |   2 +-
 net/nfc/netlink.c                                  |   3 +-
 net/openvswitch/vport-internal_dev.c               |  18 +-
 net/sched/cls_flower.c                             |  34 +-
 net/sctp/sm_make_chunk.c                           |   8 +
 net/tipc/group.c                                   |   1 +
 net/tls/tls_sw.c                                   |   1 -
 net/vmw_vsock/hyperv_transport.c                   |   4 +-
 net/vmw_vsock/virtio_transport_common.c            |   4 +-
 net/wireless/Makefile                              |   1 +
 net/wireless/core.c                                |   8 +-
 net/wireless/nl80211.c                             |  99 +++-
 net/wireless/pmsr.c                                |   4 +-
 net/wireless/scan.c                                |   4 +-
 net/wireless/util.c                                |   4 +-
 net/xdp/xdp_umem.c                                 |  11 +-
 samples/bpf/bpf_load.c                             |   2 +-
 samples/bpf/task_fd_query_user.c                   |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   6 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   5 +-
 tools/bpf/bpftool/cgroup.c                         |   5 +-
 tools/bpf/bpftool/map.c                            |   2 +
 tools/bpf/bpftool/prog.c                           |   3 +-
 tools/include/uapi/linux/bpf.h                     |   6 +-
 tools/lib/bpf/libbpf.c                             |  32 +-
 tools/lib/bpf/libbpf_internal.h                    |   4 +-
 tools/lib/bpf/libbpf_probes.c                      |  13 +-
 tools/testing/selftests/bpf/Makefile               |   7 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   1 +
 tools/testing/selftests/bpf/test_lpm_map.c         |  41 +-
 tools/testing/selftests/bpf/test_section_names.c   |  10 +
 tools/testing/selftests/bpf/test_sock_addr.c       | 213 +++++++-
 .../testing/selftests/bpf/verifier/div_overflow.c  |  14 +-
 tools/testing/selftests/bpf/verifier/subreg.c      | 533 +++++++++++++++++++++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh       |  47 ++
 .../testing/selftests/net/forwarding/tc_flower.sh  |  36 +-
 161 files changed, 2139 insertions(+), 539 deletions(-)
 rename drivers/net/dsa/{realtek-smi.c => realtek-smi-core.c} (99%)
 rename drivers/net/dsa/{realtek-smi.h => realtek-smi-core.h} (100%)
 rename drivers/net/phy/{asix.c => ax88796b.c} (100%)
 create mode 100644 tools/testing/selftests/bpf/verifier/subreg.c
