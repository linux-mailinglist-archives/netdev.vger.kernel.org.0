Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF61141EE2
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgASPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:39:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgASPjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:39:44 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9422514F0E473;
        Sun, 19 Jan 2020 07:39:42 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:39:41 +0100 (CET)
Message-Id: <20200119.163941.2280554179674027217.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:39:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix non-blocking connect() in x25, from Martin Schiller.

2) Fix spurious decryption errors in kTLS, from Jakub Kicinski.

3) Netfilter use-after-free in mtype_destroy(), from Cong Wang.

4) Limit size of TSO packets properly in lan78xx driver, from Eric
   Dumazet.

5) r8152 probe needs an endpoint sanity check, from Johan Hovold.

6) Prevent looping in tcp_bpf_unhash() during sockmap/tls free,
   from John Fastabend.

7) hns3 needs short frames padded on transmit, from Yunsheng Lin.

8) Fix netfilter ICMP header corruption, from Eyal Birger.

9) Fix soft lockup when low on memory in hns3, from Yonglong Liu.

10) Fix NTUPLE firmware command failures in bnxt_en, from Michael
    Chan.

11) Fix memory leak in act_ctinfo, from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit e69ec487b2c7c82ef99b4b15122f58a2a99289a3:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid (2020-01-09 10:51:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to b2383ad987a61bdd3a0a4ec3f343fbf0e3d9067b:

  cxgb4: reject overlapped queues in TC-MQPRIO offload (2020-01-19 16:12:53 +0100)

----------------------------------------------------------------
Adam Ludkiewicz (1):
      i40e: Set PHY Access flag on X722

Alexander Lobakin (2):
      net: dsa: tag_gswip: fix typo in tagger name
      net: dsa: tag_qca: fix doubled Tx statistics

Arnd Bergmann (1):
      wireless: wext: avoid gcc -O3 warning

Brett Creeley (1):
      i40e: Fix virtchnl_queue_select bitmap validation

Cambda Zhu (1):
      ixgbe: Fix calculation of queue with VFs and flow director on interface flap

Colin Ian King (1):
      net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Cong Wang (2):
      netfilter: fix a use-after-free in mtype_destroy()
      net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()

Dan Carpenter (1):
      netfilter: nf_tables: fix memory leak in nf_tables_parse_netdev_hooks()

Dan Murphy (2):
      net: phy: DP83TC811: Fix typo in Kconfig
      net: phy: DP83822: Update Kconfig with DP83825I support

Daniel Borkmann (2):
      bpf: Fix incorrect verifier simulation of ARSH under ALU32
      Merge branch 'bpf-sockmap-tls-fixes'

David Ahern (1):
      ipv4: Detect rollover in specific fib table dump

David S. Miller (10):
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'stmmac-filtering-fixes'
      Merge branch 'DP83822-and-DP83TC811-Fixes'
      Merge tag 'mac80211-for-net-2020-01-15' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'mlxsw-Various-fixes'
      Merge tag 'batadv-net-for-davem-20200114' of git://git.open-mesh.org/linux-merge
      Merge branch 'stmmac-Fix-selftests-in-Synopsys-AXS101-board'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'bnxt_en-fixes'

Eric Dumazet (4):
      net: usb: lan78xx: limit size of local TSO packets
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
      net/sched: act_ife: initalize ife->metalist earlier
      net: sched: act_ctinfo: fix memory leak

Eyal Birger (1):
      netfilter: nat: fix ICMP header corruption on ICMP errors

Felix Fietkau (3):
      cfg80211: fix memory leak in nl80211_probe_mesh_link
      cfg80211: fix memory leak in cfg80211_cqm_rssi_update
      cfg80211: fix page refcount issue in A-MSDU decap

Florian Fainelli (2):
      net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec
      net: systemport: Fixed queue mapping in internal ring map

Florian Westphal (5):
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
      netfilter: nft_tunnel: fix null-attribute check
      netfilter: nft_tunnel: ERSPAN_VERSION must not be null
      netfilter: nf_tables: remove WARN and add NLA_STRING upper limits
      netfilter: nf_tables: fix flowtable list del corruption

Ganapathi Bhat (1):
      wireless: fix enabling channel 12 for custom regulatory domain

Ido Schimmel (4):
      devlink: Wait longer before warning about unset port type
      mlxsw: spectrum: Do not enforce same firmware version for multiple ASICs
      mlxsw: spectrum: Do not modify cloned SKBs during xmit
      mlxsw: switchx2: Do not modify cloned SKBs during xmit

Jacob Keller (2):
      devlink: correct misspelling of snapshot
      doc: fix typo of snapshot in documentation

Jakub Kicinski (3):
      net/tls: avoid spurious decryption error with HW resync
      net/tls: fix async operation
      MAINTAINERS: update my email address

Jeff Kirsher (1):
      e1000e: Revert "e1000e: Make watchdog use delayed work"

Johan Hovold (2):
      NFC: pn533: fix bulk-message timeout
      r8152: add missing endpoint sanity check

Johannes Berg (1):
      cfg80211: check for set_wiphy_params

John Fastabend (8):
      bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop
      bpf: Sockmap, ensure sock lock held during tear down
      bpf: Sockmap/tls, push write_space updates through ulp updates
      bpf: Sockmap, skmsg helper overestimates push, pull, and pop bounds
      bpf: Sockmap/tls, msg_push_data may leave end mark in place
      bpf: Sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
      bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining
      bpf: Sockmap/tls, fix pop data with SK_DROP return code

Jose Abreu (5):
      net: stmmac: selftests: Update status when disabling RSS
      net: stmmac: tc: Do not setup flower filtering if RSS is enabled
      net: stmmac: selftests: Make it work in Synopsys AXS101 boards
      net: stmmac: selftests: Mark as fail when received VLAN ID != expected
      net: stmmac: selftests: Guard VLAN Perfect test against non supported HW

Jouni Malinen (1):
      mac80211: Fix TKIP replay protection immediately after key setup

Kristian Evensen (1):
      qmi_wwan: Add support for Quectel RM500Q

Kunihiko Hayashi (1):
      net: ethernet: ave: Avoid lockdep warning

Lingpeng Chen (1):
      bpf/sockmap: Read psock ingress_msg before sk_receive_queue

Lorenz Bauer (1):
      net: bpf: Don't leak time wait and request sockets

Lorenzo Bianconi (1):
      net: mvneta: fix dma sync size in mvneta_run_xdp

Madhuparna Bhowmik (1):
      net: wan: lapbether.c: Use built-in RCU list checking

Manfred Rudigier (1):
      igb: Fix SGMII SFP module discovery for 100FX/LX.

Markus Theil (2):
      mac80211: mesh: restrict airtime metric to peered established plinks
      cfg80211: fix deadlocks in autodisconnect work

Martin KaFai Lau (1):
      bpftool: Fix printing incorrect pointer in btf_dump_ptr

Martin Schiller (1):
      net/x25: fix nonblocking connect

Michael Chan (3):
      bnxt_en: Fix NTUPLE firmware command failures.
      bnxt_en: Fix ipv6 RFS filter matching logic.
      bnxt_en: Do not treat DSN (Digital Serial Number) read failure as fatal.

Michael Grzeschik (1):
      net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset

Milind Parab (1):
      net: macb: fix for fixed-link mode

Mohammed Gamal (1):
      hv_netvsc: Fix memory leak when removing rndis device

Orr Mazor (1):
      cfg80211: Fix radar event during another phy CAC

Pablo Neira Ayuso (1):
      netfilter: nf_tables: store transaction list locally while requesting module

Pengcheng Yang (1):
      tcp: fix marked lost packets not being retransmitted

Petr Machata (3):
      selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation
      mlxsw: spectrum: Wipe xstats.backlog of down ports
      mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list

Rahul Lakkireddy (2):
      cxgb4: fix Tx multi channel port rate limit
      cxgb4: reject overlapped queues in TC-MQPRIO offload

Sergei Shtylyov (1):
      sh_eth: check sh_eth_cpu_data::dual_port when dumping registers

Stefan Assmann (1):
      iavf: remove current MAC address filter on VF reset

Sunil Muthuswamy (1):
      hv_sock: Remove the accept port restriction

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Vladimir Oltean (1):
      net: dsa: sja1105: Don't error out on disabled ports with no phy-mode

Vladis Dronov (1):
      ptp: free ptp device pin descriptors properly

Yonglong Liu (1):
      net: hns: fix soft lockup when there is not enough memory

Yunsheng Lin (1):
      net: hns3: pad the short frame before sending to the hardware

 .mailmap                                                  |  1 +
 Documentation/admin-guide/devices.txt                     |  2 +-
 Documentation/media/v4l-drivers/meye.rst                  |  2 +-
 MAINTAINERS                                               | 10 +++++-----
 drivers/net/dsa/bcm_sf2.c                                 |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c                    |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                |  7 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 | 29 ++++++++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                 |  4 +---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c             |  3 +++
 drivers/net/ethernet/cadence/macb_main.c                  | 30 +++++++++++++++++-------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c           | 14 +++++++++++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c    | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c      | 28 +++++++++++++++++++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/sched.c                | 16 ++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/sched.h                |  2 ++
 drivers/net/ethernet/hisilicon/hns/hns_enet.c             |  4 +---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           |  6 ++++++
 drivers/net/ethernet/intel/e1000e/e1000.h                 |  5 ++---
 drivers/net/ethernet/intel/e1000e/netdev.c                | 54 +++++++++++++++++++++++++-----------------------------
 drivers/net/ethernet/intel/i40e/i40e_adminq.c             |  5 +++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c        | 22 ++++++++++++++++++----
 drivers/net/ethernet/intel/iavf/iavf.h                    |  2 ++
 drivers/net/ethernet/intel/iavf/iavf_main.c               | 17 +++++++++++++----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c           |  3 +++
 drivers/net/ethernet/intel/igb/e1000_82575.c              |  8 ++------
 drivers/net/ethernet/intel/igb/igb_ethtool.c              |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c             | 37 +++++++++++++++++++++++++++----------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c         |  5 -----
 drivers/net/ethernet/marvell/mvneta.c                     | 19 ++++++++++---------
 drivers/net/ethernet/mellanox/mlx4/crdump.c               |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            | 54 +++++++++++++++++++++++++++++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c      | 30 +++++++++++++++++++++++-------
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c            | 17 ++++++-----------
 drivers/net/ethernet/renesas/sh_eth.c                     | 38 +++++++++++++++++++++-----------------
 drivers/net/ethernet/socionext/sni_ave.c                  | 20 +++++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c    | 52 ++++++++++++++++++++++++++++++++++++----------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c           |  4 ++++
 drivers/net/hyperv/rndis_filter.c                         |  2 --
 drivers/net/macvlan.c                                     |  5 +++--
 drivers/net/netdevsim/dev.c                               |  2 +-
 drivers/net/phy/Kconfig                                   |  8 ++++----
 drivers/net/phy/dp83867.c                                 |  8 +++++++-
 drivers/net/usb/lan78xx.c                                 |  1 +
 drivers/net/usb/qmi_wwan.c                                |  1 +
 drivers/net/usb/r8152.c                                   |  3 +++
 drivers/net/wan/fsl_ucc_hdlc.c                            |  2 +-
 drivers/net/wan/lapbether.c                               |  2 +-
 drivers/nfc/pn533/usb.c                                   |  2 +-
 drivers/ptp/ptp_clock.c                                   |  4 ++--
 include/linux/skmsg.h                                     | 13 +++++++++----
 include/linux/tnum.h                                      |  2 +-
 include/net/cfg80211.h                                    |  5 +++++
 include/net/devlink.h                                     |  2 +-
 include/net/tcp.h                                         |  6 ++++--
 kernel/bpf/tnum.c                                         |  9 +++++++--
 kernel/bpf/verifier.c                                     | 13 ++++++++++---
 net/batman-adv/distributed-arp-table.c                    |  4 +++-
 net/core/dev.c                                            | 12 ------------
 net/core/devlink.c                                        |  8 ++++----
 net/core/filter.c                                         | 20 ++++++++++----------
 net/core/skmsg.c                                          |  2 ++
 net/core/sock_map.c                                       |  7 ++++++-
 net/dsa/tag_gswip.c                                       |  2 +-
 net/dsa/tag_qca.c                                         |  3 ---
 net/ipv4/fib_trie.c                                       |  6 ++++++
 net/ipv4/netfilter/arp_tables.c                           | 19 ++++++++++---------
 net/ipv4/tcp_bpf.c                                        | 17 +++++++----------
 net/ipv4/tcp_input.c                                      |  7 ++++---
 net/ipv4/tcp_ulp.c                                        |  6 ++++--
 net/mac80211/cfg.c                                        | 23 +++++++++++++++++++++++
 net/mac80211/mesh_hwmp.c                                  |  3 +++
 net/mac80211/tkip.c                                       | 18 +++++++++++++++---
 net/netfilter/ipset/ip_set_bitmap_gen.h                   |  2 +-
 net/netfilter/nf_nat_proto.c                              | 13 +++++++++++++
 net/netfilter/nf_tables_api.c                             | 39 ++++++++++++++++++++++++++-------------
 net/netfilter/nft_tunnel.c                                |  5 ++++-
 net/sched/act_ctinfo.c                                    | 11 +++++++++++
 net/sched/act_ife.c                                       |  7 +++----
 net/tls/tls_main.c                                        | 10 +++++++---
 net/tls/tls_sw.c                                          | 41 ++++++++++++++++++++++++++++++++---------
 net/vmw_vsock/hyperv_transport.c                          | 65 ++++++-----------------------------------------------------------
 net/wireless/nl80211.c                                    |  3 +++
 net/wireless/rdev-ops.h                                   | 14 ++++++++++++++
 net/wireless/reg.c                                        | 36 ++++++++++++++++++++++++++++++++----
 net/wireless/sme.c                                        |  6 +++---
 net/wireless/trace.h                                      |  5 +++++
 net/wireless/util.c                                       |  2 +-
 net/wireless/wext-core.c                                  |  3 ++-
 net/x25/af_x25.c                                          |  6 +++++-
 tools/bpf/bpftool/btf_dumper.c                            |  2 +-
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh |  8 ++++++--
 92 files changed, 773 insertions(+), 377 deletions(-)
