Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6655025CEA7
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgIDAD3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Sep 2020 20:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgIDADZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:03:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99381C061244;
        Thu,  3 Sep 2020 17:03:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70AED1289AB64;
        Thu,  3 Sep 2020 16:46:38 -0700 (PDT)
Date:   Thu, 03 Sep 2020 17:03:19 -0700 (PDT)
Message-Id: <20200903.170319.1154686215820482016.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 16:46:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Use netif_rx_ni() when necessary in batman-adv stack, from Jussi
   Kivilinna.

2) Fix loss of RTT samples in rxrpc, from David Howells.

3) Memory leak in hns_nic_dev_probe(), from Dignhao Liu.

4) ravb module cannot be unloaded, fix from Yuusuke Ashizuka.

5) We disable BH for too lokng in sctp_get_port_local(), add a
   cond_resched() here as well, from Xin Long.

6) Fix memory leak in st95hf_in_send_cmd, from Dinghao Liu.

7) Out of bound access in bpf_raw_tp_link_fill_link_info(), from
   Yonghong Song.

8) Missing of_node_put() in mt7530 DSA driver, from Sumera
   Priyadarsini.

9) Fix crash in bnxt_fw_reset_task(), from Michael Chan.

10) Fix geneve tunnel checksumming bug in hns3, from Yi Li.

11) Memory leak in rxkad_verify_response, from Dinghao Liu.

12) In tipc, don't use smp_processor_id() in preemptible context.
    From Tuong Lien.

13) Fix signedness issue in mlx4 memory allocation, from Shung-Hsi Yu.

14) Missing clk_disable_prepare() in gemini driver, from Dan
    Carpenter.

15) Fix ABI mismatch between driver and firmware in nfp, from Louis
    Peens.

Please pull, thanks a lot!

The following changes since commit cb95712138ec5e480db5160b41172bbc6f6494cc:

  Merge tag 'powerpc-5.9-3' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2020-08-23 11:37:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to b61ac5bb420adce0c9b79c6b9e1c854af083e33f:

  Merge branch 'smc-fixes' (2020-09-03 16:52:33 -0700)

----------------------------------------------------------------
Amar Singhal (1):
      cfg80211: Adjust 6 GHz frequency to channel conversion

Cong Wang (1):
      net_sched: fix error path in red_init()

Dan Carpenter (1):
      net: gemini: Fix another missing clk_disable_unprepare() in probe

Dan Murphy (1):
      net: dp83867: Fix WoL SecureOn password

Daniel Gorsulowski (1):
      net: dp83869: Fix RGMII internal delay configuration

David Howells (7):
      rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()
      rxrpc: Fix loss of RTT samples due to interposed ACK
      rxrpc: Make rxrpc_kernel_get_srtt() indicate validity
      afs: Remove afs_vlserver->probe.have_result
      afs: Expose information from afs_vlserver through /proc for debugging
      afs: Don't use VL probe running state to make decisions outside probe code
      afs: Fix error handling in VL server rotation

David S. Miller (10):
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'MAINTAINERS-Remove-self-from-PHY-LIBRARY'
      Merge tag 'batadv-net-for-davem-20200824' of git://git.open-mesh.org/linux-merge
      Merge branch 'bnxt_en-Bug-fixes'
      Merge branch 'net-fix-netpoll-crash-with-bnxt'
      Merge tag 'rxrpc-fixes-20200820' of git://git.kernel.org/.../dhowells/linux-fs
      Merge tag 'mac80211-for-davem-2020-08-28' of git://git.kernel.org/.../jberg/mac80211
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'smc-fixes'

Denis Efremov (1):
      net: bcmgenet: fix mask check in bcmgenet_validate_flow()

Dinghao Liu (6):
      net: hns: Fix memleak in hns_nic_dev_probe
      net: systemport: Fix memleak in bcm_sysport_probe
      NFC: st95hf: Fix memleak in st95hf_in_send_cmd
      net: arc_emac: Fix memleak in arc_mdio_probe
      firestream: Fix memleak in fs_open
      rxrpc: Fix memory leak in rxkad_verify_response()

Edward Cree (1):
      sfc: fix boolreturn.cocci warning and rename function

Edwin Peer (2):
      bnxt_en: fix HWRM error when querying VF temperature
      bnxt_en: init RSS table for Minimal-Static VF reservation

Fabian Frederick (5):
      selftests: netfilter: fix header example
      selftests: netfilter: exit on invalid parameters
      selftests: netfilter: remove unused variable in make_file()
      selftests: netfilter: simplify command testing
      selftests: netfilter: add command usage

Felix Fietkau (4):
      mac80211: use rate provided via status->rate on ieee80211_tx_status_ext for AQL
      mac80211: factor out code to look up the average packet length duration for a rate
      mac80211: improve AQL aggregation estimation for low data rates
      mac80211: reduce packet loss event false positives

Florian Fainelli (6):
      MAINTAINERS: GENET: Add missing platform data file
      MAINTAINERS: B53: Add DT binding file
      MAINTAINERS: GENET: Add DT binding file
      MAINTAINERS: GENET: Add UniMAC MDIO controller files
      MAINTAINERS: Add entry for Broadcom Ethernet PHY drivers
      MAINTAINERS: Remove self from PHY LIBRARY

Florian Westphal (4):
      netfilter: conntrack: allow sctp hearbeat after connection re-use
      netfilter: nf_tables: fix destination register zeroing
      mptcp: free acked data before waiting for more memory
      netfilter: conntrack: do not auto-delete clash entries on reply

Grygorii Strashko (1):
      net: ethernet: ti: am65-cpsw: fix rmii 100Mbit link mode

Herbert Xu (1):
      net: Get rid of consume_skb when tracing is off

Himadri Pandya (1):
      net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Ido Schimmel (2):
      ipv4: Silence suspicious RCU usage warning
      ipv6: Fix sysctl max for fib_multipath_hash_policy

Jakub Kicinski (2):
      net: disable netpoll on fresh napis
      bnxt: don't enable NAPI until rings are ready

Jesper Dangaard Brouer (2):
      selftests/bpf: Fix test_progs-flavor run getting number of tests
      selftests/bpf: Fix massive output from test_maps

Johannes Berg (2):
      nl80211: fix NL80211_ATTR_HE_6GHZ_CAPABILITY usage
      cfg80211: regulatory: reject invalid hints

Jussi Kivilinna (1):
      batman-adv: bla: use netif_rx_ni when not in interrupt context

Kamil Lorenc (1):
      net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Karsten Graul (1):
      net/smc: fix toleration of fake add_link messages

Kurt Kanzenbach (1):
      dt-bindings: net: dsa: Fix typo

Landen Chao (1):
      net: dsa: mt7530: fix advertising unsupported 1000baseT_Half

Leesoo Ahn (1):
      pktgen: fix error message with wrong function name

Linus Lüssing (1):
      batman-adv: Fix own OGM check in aggregated OGMs

Louis Peens (1):
      nfp: flower: fix ABI mismatch between driver and firmware

Miaohe Lin (1):
      net: Fix some comments

Michael Chan (4):
      bnxt_en: Fix ethtool -S statitics with XDP or TCs enabled.
      bnxt_en: Fix possible crash in bnxt_fw_reset_task().
      bnxt_en: Setup default RSS map in all scenarios.
      tg3: Fix soft lockup when tg3_reset_task() fails.

Mingming Cao (1):
      ibmvnic fix NULL tx_pools and rx_tools issue at do_reset

Murali Karicheri (3):
      net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port
      net: ethernet: ti: cpsw_new: fix clean up of vlan mc entries for host port
      net: ethernet: ti: cpsw_new: fix error handling in cpsw_ndo_vlan_rx_kill_vid()

Nathan Chancellor (1):
      net: dsa: sja1105: Do not use address of compatible member in sja1105_check_device_id

Nicolas Dichtel (1):
      gtp: add GTPA_LINK info to msg sent to userspace

Pablo Neira Ayuso (3):
      netfilter: nf_tables: add NFTA_SET_USERDATA if not null
      netfilter: nf_tables: incorrect enum nft_list_attributes definition
      netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS

Paul Barker (1):
      doc: net: dsa: Fix typo in config code sample

Paul Moore (1):
      netlabel: fix problems with mapping removal

Pavan Chebbi (1):
      bnxt_en: Don't query FW when netif_running() is false.

Potnuri Bharat Teja (1):
      cxgb4: fix thermal zone device registration

Randy Dunlap (1):
      netfilter: delete repeated words

Shannon Nelson (1):
      ionic: fix txrx work accounting

Shay Bar (1):
      wireless: fix wrong 160/80+80 MHz setting

Shung-Hsi Yu (1):
      net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()

Shyam Sundar S K (1):
      amd-xgbe: Add support for new port mode

Stefano Brivio (2):
      netfilter: nft_set_rbtree: Handle outcomes of tree rotations in overlap detection
      netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match

Sumera Priyadarsini (2):
      net: ocelot: Add of_node_put() before return statement
      net: dsa: mt7530: Add of_node_put() before break and return statements

Sven Eckelmann (1):
      batman-adv: Avoid uninitialized chaddr when handling DHCP

Tetsuo Handa (1):
      tipc: fix shutdown() of connectionless socket

Tobias Klauser (2):
      ipv6: ndisc: adjust ndisc_ifinfo_sysctl_change prototype
      bpf, sysctl: Let bpf_stats_handler take a kernel pointer buffer

Tong Zhang (1):
      net: caif: fix error code handling

Tuong Lien (1):
      tipc: fix using smp_processor_id() in preemptible

Ursula Braun (3):
      net/smc: set rx_off for SMCR explicitly
      net/smc: reset sndbuf_desc if freed
      net/smc: fix sock refcounting in case of termination

Vasundhara Volam (2):
      bnxt_en: Check for zero dir entries in NVRAM.
      bnxt_en: Fix PCI AER error recovery flow

Vinicius Costa Gomes (1):
      taprio: Fix using wrong queues in gate mask

Xie He (4):
      drivers/net/wan/lapbether: Added needed_tailroom
      drivers/net/wan/lapbether: Set network_header before transmitting
      drivers/net/wan/hdlc_cisco: Add hard_header_len
      drivers/net/wan/hdlc: Change the default of hard_header_len to 0

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

Yi Li (1):
      net: hns3: Fix for geneve tx checksum bug

Yonghong Song (1):
      bpf: Fix a buffer out-of-bound access when filling raw_tp link_info

YueHaibing (1):
      net: cdc_ncm: Fix build error

Yunsheng Lin (1):
      vhost: fix typo in error message

Yuusuke Ashizuka (1):
      ravb: Fixed to be able to unload modules

zhudi (1):
      netlink: fix a data race in netlink_rcv_wake()

 Documentation/devicetree/bindings/net/dsa/dsa.txt       |   2 +-
 Documentation/networking/dsa/configuration.rst          |   2 +-
 MAINTAINERS                                             |  17 +++++++-
 drivers/atm/firestream.c                                |   1 +
 drivers/net/dsa/mt7530.c                                |   7 +++-
 drivers/net/dsa/ocelot/felix.c                          |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c                  |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c             |  13 ++++++
 drivers/net/ethernet/arc/emac_mdio.c                    |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c              |   6 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               |  90 +++++++++++++++++++++++++++--------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c       |  16 +++-----
 drivers/net/ethernet/broadcom/genet/bcmgenet.c          |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                     |  17 ++++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c      |   8 +++-
 drivers/net/ethernet/cortina/gemini.c                   |  34 ++++++++--------
 drivers/net/ethernet/hisilicon/hns/hns_enet.c           |   9 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |   6 ++-
 drivers/net/ethernet/ibm/ibmvnic.c                      |  15 ++++++-
 drivers/net/ethernet/mellanox/mlx4/mr.c                 |   2 +-
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c        |  13 ++----
 drivers/net/ethernet/renesas/ravb_main.c                | 110 +++++++++++++++++++++++++-------------------------
 drivers/net/ethernet/sfc/ef100_rx.c                     |   8 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                |   2 +
 drivers/net/ethernet/ti/cpsw.c                          |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                      |  29 ++++++++++----
 drivers/net/gtp.c                                       |   1 +
 drivers/net/phy/dp83867.c                               |   4 +-
 drivers/net/phy/dp83869.c                               |  12 +++---
 drivers/net/usb/Kconfig                                 |   1 +
 drivers/net/usb/asix_common.c                           |   2 +-
 drivers/net/usb/dm9601.c                                |   4 ++
 drivers/net/wan/hdlc.c                                  |   2 +-
 drivers/net/wan/hdlc_cisco.c                            |   1 +
 drivers/net/wan/lapbether.c                             |   3 ++
 drivers/nfc/st95hf/core.c                               |   2 +-
 drivers/vhost/vhost.c                                   |   2 +-
 fs/afs/fs_probe.c                                       |   4 +-
 fs/afs/internal.h                                       |  14 ++++---
 fs/afs/proc.c                                           |   5 +++
 fs/afs/vl_list.c                                        |   1 +
 fs/afs/vl_probe.c                                       |  82 +++++++++++++++++++++++--------------
 fs/afs/vl_rotate.c                                      |   7 +++-
 include/linux/netfilter/nf_conntrack_sctp.h             |   2 +
 include/linux/netfilter/nfnetlink.h                     |   3 +-
 include/linux/skbuff.h                                  |  13 +++++-
 include/net/af_rxrpc.h                                  |   2 +-
 include/net/ndisc.h                                     |   2 +-
 include/net/netfilter/nf_tables.h                       |   2 +
 include/trace/events/rxrpc.h                            |  27 ++++++++++---
 include/uapi/linux/in.h                                 |   2 +-
 include/uapi/linux/netfilter/nf_tables.h                |   2 +-
 kernel/bpf/syscall.c                                    |   2 +-
 kernel/sysctl.c                                         |   3 +-
 net/batman-adv/bat_v_ogm.c                              |  11 ++---
 net/batman-adv/bridge_loop_avoidance.c                  |   5 ++-
 net/batman-adv/gateway_client.c                         |   6 ++-
 net/caif/cfrfml.c                                       |   4 +-
 net/core/dev.c                                          |   3 +-
 net/core/netpoll.c                                      |   2 +-
 net/core/pktgen.c                                       |   2 +-
 net/core/skbuff.c                                       |   2 +
 net/core/sock.c                                         |   2 +-
 net/ipv4/fib_trie.c                                     |   3 +-
 net/ipv4/netfilter/nf_nat_pptp.c                        |   2 +-
 net/ipv4/raw.c                                          |   2 +-
 net/ipv6/sysctl_net_ipv6.c                              |   3 +-
 net/l3mdev/l3mdev.c                                     |   2 +-
 net/mac80211/airtime.c                                  | 202 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 net/mac80211/sta_info.h                                 |   5 ++-
 net/mac80211/status.c                                   |  43 ++++++++++----------
 net/mptcp/protocol.c                                    |   3 +-
 net/netfilter/nf_conntrack_pptp.c                       |   2 +-
 net/netfilter/nf_conntrack_proto_sctp.c                 |  39 ++++++++++++++++--
 net/netfilter/nf_conntrack_proto_tcp.c                  |   2 +-
 net/netfilter/nf_conntrack_proto_udp.c                  |  26 +++++-------
 net/netfilter/nf_tables_api.c                           |  64 ++++++++++++++---------------
 net/netfilter/nfnetlink.c                               |  11 +++--
 net/netfilter/nfnetlink_log.c                           |   3 +-
 net/netfilter/nfnetlink_queue.c                         |   2 +-
 net/netfilter/nft_flow_offload.c                        |   2 +-
 net/netfilter/nft_payload.c                             |   4 +-
 net/netfilter/nft_set_rbtree.c                          |  57 +++++++++++++++++++++-----
 net/netfilter/xt_recent.c                               |   2 +-
 net/netlabel/netlabel_domainhash.c                      |  59 +++++++++++++--------------
 net/netlink/af_netlink.c                                |   2 +-
 net/rxrpc/ar-internal.h                                 |  13 +++---
 net/rxrpc/call_object.c                                 |   1 +
 net/rxrpc/input.c                                       | 123 ++++++++++++++++++++++++++++++++------------------------
 net/rxrpc/output.c                                      |  82 +++++++++++++++++++++++++++----------
 net/rxrpc/peer_object.c                                 |  16 ++++++--
 net/rxrpc/rtt.c                                         |   3 +-
 net/rxrpc/rxkad.c                                       |   3 +-
 net/sched/sch_red.c                                     |  20 ++--------
 net/sched/sch_taprio.c                                  |  30 +++++++++++---
 net/sctp/socket.c                                       |  16 +++-----
 net/smc/smc_close.c                                     |  15 +++----
 net/smc/smc_core.c                                      |   3 ++
 net/smc/smc_llc.c                                       |  15 ++++++-
 net/socket.c                                            |   4 +-
 net/tipc/crypto.c                                       |  12 ++++--
 net/tipc/socket.c                                       |   9 +++--
 net/wireless/chan.c                                     |  15 +++++--
 net/wireless/nl80211.c                                  |   2 +-
 net/wireless/reg.c                                      |   3 ++
 net/wireless/util.c                                     |   8 ++--
 tools/testing/selftests/bpf/test_maps.c                 |   2 +
 tools/testing/selftests/bpf/test_progs.c                |   4 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh      |  67 +++++++++++++++++--------------
 110 files changed, 1068 insertions(+), 599 deletions(-)
