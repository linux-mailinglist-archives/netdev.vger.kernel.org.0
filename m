Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C8511613B
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 10:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfLHJUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 04:20:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725860AbfLHJUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 04:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575796841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gS0OjyPW9rQzMNlZF5QFlZm/SX6xtTdxqzEl1pscpMA=;
        b=e/Q0wu2RhceQl0CqK6OtmiXq+ELYoN9ZqInzeOIWNj38Oy0WYfx6hKhQxb2oXBsrVQD5v+
        QIqacqD7gAr6EC7Cc1NpOeVVGIq85tV8iOoK9UKCLVl3d2/3eeW4AZr/CJ2enpQfB/5H0F
        EWxKJnWxA5bxWQJo2H+jPPWadEj9RXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-bDzlBOfnNXuTX75D-PmzBQ-1; Sun, 08 Dec 2019 04:20:38 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07AF8183B713;
        Sun,  8 Dec 2019 09:20:37 +0000 (UTC)
Received: from localhost (ovpn-112-43.rdu2.redhat.com [10.10.112.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E87C60476;
        Sun,  8 Dec 2019 09:20:33 +0000 (UTC)
Date:   Sun, 08 Dec 2019 01:20:32 -0800 (PST)
Message-Id: <20191208.012032.1258816267132319518.davem@redhat.com>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@redhat.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: bDzlBOfnNXuTX75D-PmzBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) More jumbo frame fixes in r8169, from Heiner Kallweit.

2) Fix bpf build in minimal configuration, from Alexei Starovoitov.

3) Use after free in slcan driver, from Jouni Hogander.

4) Flower classifier port ranges don't work properly in the HW
   offload case, from Yoshiki Komachi.

5) Use after free in hns3_nic_maybe_stop_tx(), from Yunsheng Lin.

6) Out of bounds access in mqprio_dump(), from Vladyslav Tarasiuk.

7) Fix flow dissection in dsa TX path, from Alexander Lobakin.

8) Stale syncookie timestampe fixes from Guillaume Nault.

Please pull, thanks a lot!

The following changes since commit 596cf45cbf6e4fa7bcb0df33e373a7d062b644b5:

  Merge branch 'akpm' (patches from Andrew) (2019-12-01 20:36:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 0fc75219fe9a3c90631453e9870e4f6d956f0ebc:

  r8169: fix rtl_hw_jumbo_disable for RTL8168evl (2019-12-07 14:23:06 -0800)

----------------------------------------------------------------
Aaron Conole (2):
      openvswitch: support asymmetric conntrack
      act_ct: support asymmetric conntrack

Aditya Pakki (1):
      pppoe: remove redundant BUG_ON() check in pppoe_pernet

Alexander Lobakin (1):
      net: dsa: fix flow dissection on Tx path

Alexandru Ardelean (1):
      NFC: NCI: use new `delay` structure for SPI transfer delays

Alexei Starovoitov (3):
      bpf: Fix static checker warning
      libbpf: Fix sym->st_value print on 32-bit arches
      bpf: Fix build in minimal configurations

Andrii Nakryiko (2):
      libbpf: Fix Makefile' libbpf symbol mismatch diagnostic
      libbpf: Fix global variable relocation

Appana Durga Kedareswara rao (1):
      MAINTAINERS: add fragment for xilinx CAN driver

Arnaldo Carvalho de Melo (1):
      libbpf: Fix up generation of bpf_helper_defs.h

Aurelien Jarno (1):
      libbpf: Fix readelf output parsing on powerpc with recent binutils

Aya Levin (2):
      net/mlx5e: Fix translation of link mode into speed
      net/mlx5e: ethtool, Fix analysis of speed setting

Bruno Carneiro da Cunha (1):
      lpc_eth: kernel BUG on remove

Chuhong Yuan (1):
      phy: mdio-thunder: add missed pci_release_regions in remove

Cong Wang (1):
      gre: refetch erspan header from skb->data after pskb_may_pull()

Dan Carpenter (1):
      net: fix a leak in register_netdevice()

Daniel Borkmann (1):
      bpf: Avoid setting bpf insns pages read-only when prog is jited

Danit Goldberg (1):
      net/core: Populate VF index in struct ifla_vf_guid

David S. Miller (9):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'linux-can-fixes-for-5.5-20191203' of git://git.kernel.org/.../mkl/linux-can
      Merge branch 'net-convert-ipv6_stub-to-ip6_dst_lookup_flow'
      Merge branch 's390-fixes'
      Merge branch 'hns3-fixes'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'net-tc-indirect-block-relay'
      Merge tag 'mlx5-fixes-2019-12-05' of git://git.kernel.org/.../saeed/linux
      Merge branch 'tcp-fix-handling-of-stale-syncookies-timestamps'

Dust Li (1):
      net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues

Eran Ben Elisha (2):
      net/mlx5e: Fix TXQ indices to be sequential
      net/mlx5e: Fix SFF 8472 eeprom length

Eric Biggers (1):
      ppp: fix out-of-bounds access in bpf_prog_create()

Eric Dumazet (5):
      tcp: refactor tcp_retransmit_timer()
      net: avoid an indirect call in ____sys_recvmsg()
      tcp: md5: fix potential overestimation of TCP option space
      inet: protect against too small mtu values.
      net_sched: validate TCA_KIND attribute in tc_chain_tmplt_add()

Grygorii Strashko (3):
      net: ethernet: ti: cpsw_switchdev: fix unmet direct dependencies detected for NET_SWITCHDEV
      net: ethernet: ti: cpsw: fix extra rx interrupt
      net: phy: dp83867: fix hfs boot in rgmii mode

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Heiner Kallweit (2):
      r8169: add missing RX enabling for WoL on RTL8125
      r8169: fix rtl_hw_jumbo_disable for RTL8168evl

Huy Nguyen (1):
      net/mlx5e: Query global pause state before setting prio2buffer

Jesper Dangaard Brouer (1):
      samples/bpf: Fix broken xdp_rxq_info due to map order assumptions

Jian Shen (1):
      net: hns3: fix VF ID issue for setting VF VLAN

Johan Hovold (1):
      can: ucan: fix non-atomic allocation in completion handler

John Hurley (2):
      net: core: rename indirect block ingress cb function
      net: sched: allow indirect blocks to bind to clsact in TC

Jonathan Lemon (1):
      xdp: obtain the mem_id mutex before trying to remove an entry.

Jongsung Kim (1):
      net: stmmac: reset Tx desc base address before restarting Tx

Jouni Hogander (2):
      can: slcan: Fix use-after-free Read in slcan_open
      net-sysfs: Call dev_hold always in netdev_queue_add_kobject

Julian Wiedmann (3):
      s390/qeth: guard against runt packets
      s390/qeth: ensure linear access to packet headers
      s390/qeth: fix dangling IO buffers after halt/clear

Martin Varghese (2):
      Fixed updating of ethertype in function skb_mpls_pop
      net: Fixed updating of ethertype in skb_mpls_push()

Mian Yousaf Kaukab (1):
      net: thunderx: start phy before starting autonegotiation

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Parav Pandit (1):
      net/mlx5e: E-switch, Fix Ingress ACL groups in switchdev mode for prio tag

Roi Dayan (2):
      net/mlx5e: Fix freeing flow with kfree() and not kvfree()
      net/mlx5e: Fix free peer_flow when refcount is 0

Russell King (2):
      net: sfp: fix unbind
      net: sfp: fix hwmon

Sabrina Dubroca (2):
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Shannon Nelson (1):
      ionic: keep users rss hash across lif reset

Srinivas Neeli (1):
      can: xilinx_can: Fix usage of skb memory

Sriram Dash (1):
      MAINTAINERS: add myself as maintainer of MCAN MMIO device driver

Stanislav Fomichev (5):
      bpf: Support pre-2.25-binutils objcopy for vmlinux BTF
      bpf: Force .BTF section start to zero when dumping from vmlinux
      selftests/bpf: Don't hard-code root cgroup id
      selftests/bpf: Bring back c++ include/link test
      selftests/bpf: De-flake test_tcpbpf

Stefano Garzarella (1):
      vhost/vsock: accept only packets with the right dst_cid

Taehee Yoo (2):
      hsr: fix a NULL pointer dereference in hsr_dev_xmit()
      tipc: fix ordering of tipc module init and exit routine

Valentin Vidic (1):
      net/tls: Fix return values to avoid ENOTSUPP

Venkatesh Yadav Abbarapu (1):
      can: xilinx_can: skip error message on deferred probe

Victorien Molle (1):
      sch_cake: Add missing NLA policy entry TCA_CAKE_SPLIT_GSO

Vladimir Oltean (1):
      net: mscc: ocelot: unregister the PTP clock on deinit

Vladyslav Tarasiuk (1):
      mqprio: Fix out-of-bounds access in mqprio_dump

Yangbo Lu (1):
      enetc: disable EEE autoneg by default

Yonghong Song (2):
      bpf: Fix a bug when getting subprog 0 jited image in check_attach_btf_id
      selftests/bpf: Add a fexit/bpf2bpf test with target bpf prog no callees

Yoshiki Komachi (1):
      cls_flower: Fix the behavior using port ranges with hw-offload

Yunsheng Lin (2):
      net: hns3: fix for TX queue not restarted problem
      net: hns3: fix a use after free problem in hns3_nic_maybe_stop_tx()

 MAINTAINERS                                         |  17 +++
 drivers/infiniband/core/addr.c                      |   7 +-
 drivers/infiniband/sw/rxe/rxe_net.c                 |   8 +-
 drivers/net/can/slcan.c                             |   1 +
 drivers/net/can/usb/ucan.c                          |   2 +-
 drivers/net/can/xilinx_can.c                        |  28 ++--
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c   |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c        |   5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c     |  50 +++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  18 +--
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c    |  27 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c    |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  31 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h   |   9 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  | 122 +++++++++++-----
 drivers/net/ethernet/mscc/ocelot.c                  |  14 +-
 drivers/net/ethernet/nxp/lpc_eth.c                  |   2 -
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  16 ++-
 drivers/net/ethernet/realtek/r8169_main.c           |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |   2 +
 drivers/net/ethernet/ti/Kconfig                     |   2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                 |   2 +-
 drivers/net/geneve.c                                |   4 +-
 drivers/net/phy/dp83867.c                           | 119 +++++++++-------
 drivers/net/phy/mdio-thunder.c                      |   1 +
 drivers/net/phy/sfp.c                               |  17 ++-
 drivers/net/ppp/ppp_generic.c                       |   5 +-
 drivers/net/ppp/pppoe.c                             |   2 -
 drivers/net/vxlan.c                                 |   8 +-
 drivers/s390/net/qeth_core.h                        |   4 +
 drivers/s390/net/qeth_core_main.c                   | 158 +++++++++++++--------
 drivers/s390/net/qeth_core_mpc.h                    |  14 --
 drivers/s390/net/qeth_ethtool.c                     |   1 +
 drivers/s390/net/qeth_l2_main.c                     |  12 +-
 drivers/s390/net/qeth_l3_main.c                     |  13 +-
 drivers/vhost/vsock.c                               |   4 +-
 include/linux/filter.h                              |   8 +-
 include/linux/netdevice.h                           |   5 +
 include/linux/skbuff.h                              |   5 +-
 include/linux/time.h                                |  13 ++
 include/net/flow_dissector.h                        |   1 +
 include/net/flow_offload.h                          |  15 +-
 include/net/ip.h                                    |   5 +
 include/net/ipv6.h                                  |   2 +-
 include/net/ipv6_stubs.h                            |   6 +-
 include/net/tcp.h                                   |  27 ++--
 kernel/bpf/btf.c                                    |   5 +-
 kernel/bpf/verifier.c                               |   5 +-
 net/bridge/br_device.c                              |   6 +
 net/core/dev.c                                      |   9 +-
 net/core/flow_dissector.c                           |  42 ++++--
 net/core/flow_offload.c                             |  45 +++---
 net/core/lwt_bpf.c                                  |   4 +-
 net/core/net-sysfs.c                                |   7 +-
 net/core/rtnetlink.c                                |   4 +-
 net/core/skbuff.c                                   |  10 +-
 net/core/xdp.c                                      |   8 +-
 net/dccp/ipv6.c                                     |   6 +-
 net/hsr/hsr_device.c                                |   9 +-
 net/ipv4/devinet.c                                  |   5 -
 net/ipv4/gre_demux.c                                |   2 +-
 net/ipv4/ip_output.c                                |  13 +-
 net/ipv4/tcp_output.c                               |   5 +-
 net/ipv4/tcp_timer.c                                |  10 +-
 net/ipv6/addrconf_core.c                            |  11 +-
 net/ipv6/af_inet6.c                                 |   4 +-
 net/ipv6/datagram.c                                 |   2 +-
 net/ipv6/inet6_connection_sock.c                    |   4 +-
 net/ipv6/ip6_output.c                               |   8 +-
 net/ipv6/raw.c                                      |   2 +-
 net/ipv6/syncookies.c                               |   2 +-
 net/ipv6/tcp_ipv6.c                                 |   4 +-
 net/l2tp/l2tp_ip6.c                                 |   2 +-
 net/mpls/af_mpls.c                                  |   7 +-
 net/netfilter/nf_tables_offload.c                   |   6 +-
 net/nfc/nci/spi.c                                   |   6 +-
 net/openvswitch/actions.c                           |   6 +-
 net/openvswitch/conntrack.c                         |  11 ++
 net/sched/act_ct.c                                  |  13 +-
 net/sched/act_mpls.c                                |   7 +-
 net/sched/cls_api.c                                 |  60 +++++---
 net/sched/cls_flower.c                              | 118 ++++++++-------
 net/sched/sch_cake.c                                |   1 +
 net/sched/sch_mq.c                                  |   1 +
 net/sched/sch_mqprio.c                              |   3 +-
 net/sctp/ipv6.c                                     |   4 +-
 net/socket.c                                        |   7 +-
 net/tipc/core.c                                     |  29 ++--
 net/tipc/udp_media.c                                |   9 +-
 net/tls/tls_device.c                                |   8 +-
 net/tls/tls_main.c                                  |   4 +-
 net/tls/tls_sw.c                                    |   8 +-
 samples/bpf/xdp_rxq_info_user.c                     |   6 +-
 scripts/link-vmlinux.sh                             |   8 +-
 tools/lib/bpf/.gitignore                            |   1 -
 tools/lib/bpf/Makefile                              |  15 +-
 tools/lib/bpf/libbpf.c                              |  45 +++---
 tools/perf/MANIFEST                                 |   1 +
 tools/testing/selftests/bpf/.gitignore              |   1 +
 tools/testing/selftests/bpf/Makefile                |   6 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c        |  70 ++++++---
 tools/testing/selftests/bpf/progs/fentry_test.c     |  12 +-
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c   |   6 +-
 .../selftests/bpf/progs/fexit_bpf2bpf_simple.c      |  26 ++++
 tools/testing/selftests/bpf/progs/fexit_test.c      |  12 +-
 tools/testing/selftests/bpf/progs/test_mmap.c       |   4 +-
 .../selftests/bpf/progs/test_pkt_md_access.c        |   4 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c  |   1 +
 .../selftests/bpf/test_cpp.cpp}                     |   0
 .../testing/selftests/bpf/test_skb_cgroup_id_user.c |   2 +-
 tools/testing/selftests/bpf/test_tcpbpf.h           |   1 +
 tools/testing/selftests/bpf/test_tcpbpf_user.c      |  25 +++-
 tools/testing/selftests/net/tls.c                   |   8 +-
 119 files changed, 1024 insertions(+), 627 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
 rename tools/{lib/bpf/test_libbpf.c => testing/selftests/bpf/test_cpp.cpp} (100%)

