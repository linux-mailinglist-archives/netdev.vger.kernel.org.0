Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431382D6BF0
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLJXac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:30:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35772 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729708AbgLJXaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:30:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 12DBB4D2ED6EB
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:29:44 -0800 (PST)
Date:   Thu, 10 Dec 2020 15:29:42 -0800 (PST)
Message-Id: <20201210.152942.937409047655902940.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: Fw: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_Dec_10_15_29_42_2020_567)--"
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 15:29:44 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----Next_Part(Thu_Dec_10_15_29_42_2020_567)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Typod this lists addr first two times, third times the cgarm I suppose.

----Next_Part(Thu_Dec_10_15_29_42_2020_567)--
Content-Type: Message/Rfc822
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Date: Thu, 10 Dec 2020 15:06:12 -0800 (PST)
Message-Id: <20201210.150612.456170079356664075.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: kuba@kernel.org, nedev@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable


1) IPsec compaat fixes, from Dmitrey Safonov.

2) Fix memory leak in xfrm_user_policy().  Fix from Yu Kuai.

3)  Fix polling in xsk sockets by using sk_poll_wait() instead of
   datagram_poll() which keys off of sk_wmem_alloc and  such which xsk =
sockets
   do not update.  From Xuan Zhuo.

4) Missing init of rekey_data in cfgh80211, from Sara Sharon.

5) Fix destroy of timer before init, from Davide Caratti.

6) Missing CRYPTO_CRC32 selects in ethernet driver Kconfigs, from Arnd =
Bergmann.

7) Missing error return in rtm_to_fib_config() switch case, from Zhang =
Changzhong.

8) Fix some src/dest address handling in vrf and add a testcase.  From
   Stephen Suryaputra.

9) Fix multicast handling in Seville switches driven by mscc-ocelot dri=
ver.  From
   Vladimir Oltean.

10) Fix proto value passed to skb delivery demux in udp, from Xin Long.=


11) HW pkt counters not reported correctly in enetc driver, from Claudi=
u Manoil.

12) Fix deadlock in bridge, from Joseph Huang.

13) Missing of_node_pur() in dpaa2 driver, fromn Christophe JAILLET.

14) Fix pid fetching in bpftool when there are a lot of results, from A=
ndrii Nakryiko.

15) Fix long timeouts in nft_dynset, from Pablo Neira Ayuso.

16) Various stymmac fixes, from Fugang Duan.

17) Fix null deref in tipc, from Cengiz Can.

18) When mss is biog, coose more resonable rcvq_space in tcp, fromn Eri=
c Dumazet.

19) Revert a geneve change that likely isnt necessary, from Jakub Kicin=
ski.

20) Avoid premature rx buffer reuse in various Intel driversm from Bj=F6=
rn T=F6pel.

21) retain EcT bits during TIS reflection in tcp, from Wei Wang.

22) Fix Tso deferral wrt. cwnd limiting in tcp, from Neal Cardwell.

23) MPLS_OPT_LSE_LABEL attribute is 342 ot 8 bits, from Guillaume
    Nault

24) Fix propagation of 32-bit signed bounds in bpf verifier and add tes=
t cases, from
    Alexei Starovoitov.

Please pull, thanks a lot!

The following changes since commit bbe2ba04c5a92a49db8a42c850a5a2f6481e=
47eb:

  Merge tag 'net-5.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel=
/git/netdev/net (2020-12-03 13:10:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git =


for you to fetch changes up to d9838b1d39283c1200c13f9076474c7624b8ec34=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2020-12-=
10 14:29:30 -0800)

----------------------------------------------------------------
Alex Elder (1):
      net: ipa: pass the correct size when freeing DMA memory

Alexei Starovoitov (1):
      bpf: Fix propagation of 32-bit signed bounds from 64-bit bounds.

Andrii Nakryiko (3):
      libbpf: Fix ring_buffer__poll() to return number of consumed samp=
les
      selftests/bpf: Drain ringbuf samples at the end of test
      tools/bpftool: Fix PID fetching with a lot of results

Arnd Bergmann (2):
      ethernet: select CONFIG_CRC32 as needed
      ch_ktls: fix build warning for ipv4-only config

Bj=F6rn T=F6pel (4):
      xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in xdp_return_buff()=

      i40e: avoid premature Rx buffer reuse
      ixgbe: avoid premature Rx buffer reuse
      ice: avoid premature Rx buffer reuse

Borwankar, Antara (1):
      mac80211: set SDATA_STATE_RUNNING for monitor interfaces

Brett Mastbergen (1):
      netfilter: nft_ct: Remove confirmation check for NFT_CT_ID

Cengiz Can (1):
      net: tipc: prevent possible null deref of link

Chris Mi (1):
      net: flow_offload: Fix memory leak for indirect flow block

Christophe JAILLET (1):
      dpaa2-mac: Add a missing of_node_put after of_device_is_available=


Claudiu Manoil (1):
      enetc: Fix reporting of h/w packet counters

Cong Wang (1):
      lwt_bpf: Replace preempt_disable() with migrate_disable()

Daniel Borkmann (1):
      Merge branch 'bpf-xdp-offload-fixes'

David S. Miller (5):
      Merge branch 'stmmac-fixes'
      Merge branch 'mlx4_en-fixes'
      Merge branch '1GbE' of git://git.kernel.org/.../tnguy/net-queue
      Merge git://git.kernel.org/.../pablo/nf
      Merge git://git.kernel.org/.../bpf/bpf

Davide Caratti (1):
      net/sched: fq_pie: initialize timer earlier in fq_pie_init()

Dmitry Safonov (3):
      xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
      xfrm/compat: memset(0) 64-bit padding at right place
      xfrm/compat: Don't allocate memory with __GFP_ZERO

Dongdong Wang (1):
      lwt: Disable BH too in run_lwt_bpf()

Eric Dumazet (2):
      mac80211: mesh: fix mesh_pathtbl_init() error path
      tcp: select sane initial rcvq_space.space for big MSS

Fugang Duan (5):
      net: stmmac: increase the timeout for dma reset
      net: stmmac: start phylink instance before stmmac_hw_setup()
      net: stmmac: free tx skb buffer in stmmac_resume()
      net: stmmac: delete the eee_ctrl_timer after napi disabled
      net: stmmac: overwrite the dma_cap.addr64 according to HW design

Guillaume Nault (1):
      net: sched: Fix dump of MPLS_OPT_LSE_LABEL attribute in cls_flowe=
r

Huazhong Tan (1):
      net: hns3: remove a misused pragma packed

Jakub Kicinski (3):
      Merge tag 'mac80211-for-net-2020-12-04' of git://git.kernel.org/.=
../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Revert "geneve: pull IP header before ECN decapsulation"

Jarod Wilson (1):
      bonding: fix feature flag setting at init time

Jean-Philippe Brucker (3):
      selftests/bpf: Add test for signed 32-bit bound check bug
      selftests/bpf: Fix array access with signed variable test
      selftests/bpf: Fix "dubious pointer arithmetic" test

Jianguo Wu (1):
      mptcp: print new line in mptcp_seq_show() if mptcp isn't in use

Joseph Huang (1):
      bridge: Fix a deadlock when enabling multicast snooping

KP Singh (1):
      bpf, doc: Update KP's email in MAINTAINERS

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel m=
ux

Michal Kubecek (1):
      ethtool: fix stack overflow in ethnl_parse_bitset()

Mickey Rachamim (1):
      MAINTAINERS: Add entry for Marvell Prestera Ethernet Switch drive=
r

Moshe Shemesh (2):
      net/mlx4_en: Avoid scheduling restart task if it is already runni=
ng
      net/mlx4_en: Handle TX error CQE

Neal Cardwell (1):
      tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Oliver Hartkopp (1):
      can: isotp: isotp_setsockopt(): block setsockopt on bound sockets=


Pablo Neira Ayuso (2):
      netfilter: nft_dynset: fix timeouts later than 23 days
      netfilter: nftables: comment indirect serialization of commit_mut=
ex with rtnl_mutex

Paolo Abeni (1):
      selftests: fix poll error in udpgro.sh

Sara Sharon (1):
      cfg80211: initialize rekey_data

Steffen Klassert (1):
      Merge branch 'xfrm/compat: syzbot-found fixes'

Stephen Suryaputra (1):
      vrf: packets with lladdr src needs dst at input with orig_iif whe=
n needs strict

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Switch synchronization to RCU

Sven Auhagen (6):
      igb: XDP xmit back fix error code
      igb: take VLAN double header into account
      igb: XDP extack message on error
      igb: skb add metasize for xdp
      igb: use xdp_do_flush
      igb: avoid transmit queue timeout in xdp path

Toke H=F8iland-J=F8rgensen (7):
      xdp: Remove the xdp_attachment_flags_ok() callback
      selftests/bpf/test_offload.py: Remove check for program load flag=
s match
      netdevsim: Add debugfs toggle to reject BPF programs in verifier
      selftests/bpf/test_offload.py: Only check verifier log on verific=
ation fails
      selftests/bpf/test_offload.py: Fix expected case of extack messag=
es
      selftests/bpf/test_offload.py: Reset ethtool features after faile=
d setting
      selftests/bpf/test_offload.py: Filter bpftool internal map when c=
ounting maps

Vitaly Lifshits (1):
      e1000e: fix S0ix flow to allow S0i3.2 subset entry

Vladimir Oltean (1):
      net: mscc: ocelot: fix dropping of unknown IPv4 multicast on Sevi=
lle

Wang Hai (1):
      openvswitch: fix error return code in validate_and_copy_dec_ttl()=


Wei Wang (1):
      tcp: Retain ECT bits for tos reflection

Wen Gong (1):
      mac80211: fix return value of ieee80211_chandef_he_6ghz_oper

Xin Long (1):
      udp: fix the proto value passed to ip_protocol_deliver_rcu for th=
e segments

Xuan Zhuo (2):
      xsk: Replace datagram_poll by sock_poll_wait
      xsk: Change the tx writeable condition

Yu Kuai (1):
      net: xfrm: fix memory leak in xfrm_user_policy()

Zhang Changzhong (5):
      xsk: Return error code if force_zc is set
      ipv4: fix error return code in rtm_to_fib_config()
      net: bridge: vlan: fix error return code in __vlan_add()
      net: marvell: prestera: Fix error return code in prestera_port_cr=
eate()
      net: ll_temac: Fix potential NULL dereference in temac_probe()

Zhang Qilong (1):
      can: softing: softing_netdev_open(): fix error handling

 MAINTAINERS                                                    | 11 ++=
+++++--
 drivers/net/bonding/bond_options.c                             | 22 ++=
++++++++++------
 drivers/net/can/softing/softing_main.c                         |  9 ++=
++++--
 drivers/net/dsa/ocelot/felix.c                                 |  7 --=
----
 drivers/net/dsa/ocelot/felix_vsc9959.c                         |  1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c                       |  1 +
 drivers/net/ethernet/agere/Kconfig                             |  1 +
 drivers/net/ethernet/cadence/Kconfig                           |  1 +
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  6 +-=
---
 drivers/net/ethernet/faraday/Kconfig                           |  1 +
 drivers/net/ethernet/freescale/Kconfig                         |  1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c               |  1 +
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c           | 10 ++=
+++---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h                | 10 ++=
+++---
 drivers/net/ethernet/freescale/fman/Kconfig                    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h     |  4 --=
--
 drivers/net/ethernet/intel/e1000e/netdev.c                     |  8 ++=
+----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                    | 27 ++=
++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.c                      | 31 ++=
+++++++++++++++--------
 drivers/net/ethernet/intel/igb/igb.h                           |  5 ++=
++
 drivers/net/ethernet/intel/igb/igb_main.c                      | 37 ++=
+++++++++++++++++++---------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  | 24 ++=
+++++++++++------
 drivers/net/ethernet/marvell/prestera/prestera_main.c          |  4 ++=
+-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                 | 21 ++=
+++++++++------
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                     | 40 ++=
++++++++++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                   | 12 ++=
+++++++-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig                |  1 +
 drivers/net/ethernet/microchip/Kconfig                         |  1 +
 drivers/net/ethernet/mscc/ocelot.c                             |  9 ++=
++----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c                     |  1 +
 drivers/net/ethernet/netronome/Kconfig                         |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c            |  6 --=
---
 drivers/net/ethernet/nxp/Kconfig                               |  1 +
 drivers/net/ethernet/rocker/Kconfig                            |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c                |  9 +-=
------
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c            |  6 ++=
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c               |  2 +-=

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              | 51 ++=
++++++++++++++++++++++++++++++---------
 drivers/net/ethernet/ti/cpsw_priv.c                            |  3 --=
-
 drivers/net/ethernet/xilinx/ll_temac_main.c                    |  9 ++=
+-----
 drivers/net/geneve.c                                           | 20 ++=
++------------
 drivers/net/ipa/gsi_trans.c                                    |  7 ++=
+++-
 drivers/net/netdevsim/bpf.c                                    | 15 ++=
++++++----
 drivers/net/netdevsim/netdevsim.h                              |  1 +
 drivers/net/vrf.c                                              | 10 ++=
++++--
 include/linux/netfilter/x_tables.h                             |  5 ++=
+-
 include/linux/stmmac.h                                         |  1 +
 include/net/bonding.h                                          |  2 --=

 include/net/netfilter/nf_tables.h                              |  4 ++=
++
 include/net/xdp.h                                              |  2 --=

 include/soc/mscc/ocelot.h                                      |  3 ++=
+
 kernel/bpf/verifier.c                                          | 10 ++=
++----
 net/bridge/br_device.c                                         |  6 ++=
+++
 net/bridge/br_multicast.c                                      | 34 ++=
+++++++++++++++++--------
 net/bridge/br_private.h                                        | 10 ++=
++++++
 net/bridge/br_vlan.c                                           |  4 ++=
+-
 net/can/isotp.c                                                |  3 ++=
+
 net/core/dev.c                                                 | 22 ++=
++++++++++++++--
 net/core/flow_offload.c                                        |  4 +-=
--
 net/core/lwt_bpf.c                                             | 12 ++=
+++-----
 net/core/xdp.c                                                 | 29 ++=
++++++---------------
 net/ethtool/bitset.c                                           |  2 ++=

 net/ipv4/fib_frontend.c                                        |  2 +-=

 net/ipv4/netfilter/arp_tables.c                                | 14 ++=
++++------
 net/ipv4/netfilter/ip_tables.c                                 | 14 ++=
++++------
 net/ipv4/tcp_input.c                                           |  3 ++=
-
 net/ipv4/tcp_ipv4.c                                            |  7 ++=
++--
 net/ipv4/tcp_output.c                                          |  9 ++=
+++---
 net/ipv4/udp.c                                                 |  2 +-=

 net/ipv6/netfilter/ip6_tables.c                                | 14 ++=
++++------
 net/ipv6/tcp_ipv6.c                                            |  7 ++=
++--
 net/mac80211/iface.c                                           |  2 ++=

 net/mac80211/mesh_pathtbl.c                                    |  4 +-=
--
 net/mac80211/util.c                                            |  2 +-=

 net/mptcp/mib.c                                                |  1 +
 net/netfilter/nf_tables_api.c                                  |  8 ++=
+++--
 net/netfilter/nft_ct.c                                         |  2 --=

 net/netfilter/nft_dynset.c                                     |  8 ++=
++---
 net/netfilter/x_tables.c                                       | 49 ++=
++++++++++---------------------------
 net/openvswitch/flow_netlink.c                                 |  2 +-=

 net/sched/cls_flower.c                                         |  4 ++=
--
 net/sched/sch_fq_pie.c                                         |  2 +-=

 net/tipc/node.c                                                |  6 ++=
+--
 net/wireless/nl80211.c                                         |  2 +-=

 net/xdp/xsk.c                                                  | 20 ++=
++++++++++----
 net/xdp/xsk_buff_pool.c                                        |  1 +
 net/xdp/xsk_queue.h                                            |  6 ++=
+++
 net/xfrm/xfrm_compat.c                                         |  5 ++=
--
 net/xfrm/xfrm_state.c                                          |  4 ++=
+-
 tools/bpf/bpftool/pids.c                                       |  4 ++=
--
 tools/lib/bpf/ringbuf.c                                        |  2 +-=

 tools/testing/selftests/bpf/prog_tests/align.c                 |  8 ++=
+----
 tools/testing/selftests/bpf/prog_tests/ringbuf.c               |  8 ++=
++++-
 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c         |  2 +-=

 tools/testing/selftests/bpf/test_offload.py                    | 53 ++=
+++++++++++++++++++++-------------------
 tools/testing/selftests/bpf/verifier/array_access.c            |  2 +-=

 tools/testing/selftests/bpf/verifier/bounds.c                  | 41 ++=
+++++++++++++++++++++++++++++++
 tools/testing/selftests/net/fcnal-test.sh                      | 95 ++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++
 tools/testing/selftests/net/udpgso_bench_rx.c                  |  3 ++=
+
 99 files changed, 694 insertions(+), 327 deletions(-)

----Next_Part(Thu_Dec_10_15_29_42_2020_567)----
