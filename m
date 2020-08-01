Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0E23546E
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 23:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgHAVgg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 Aug 2020 17:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHAVgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 17:36:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83B5C06174A;
        Sat,  1 Aug 2020 14:36:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C896C126B8331;
        Sat,  1 Aug 2020 14:19:48 -0700 (PDT)
Date:   Sat, 01 Aug 2020 14:36:31 -0700 (PDT)
Message-Id: <20200801.143631.1794965770015082550.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Aug 2020 14:19:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Encap offset calculation is incorrect in esp6, from Sabrina Dubroca.

2) Better parameter validation in pfkey_dump(), from Mark Salyzyn.

3) Fix several clang issues on powerpc in selftests, from Tanner Love.

4) cmsghdr_from_user_compat_to_kern() uses the wrong length, from
   Al Viro.

5) Out of bounds access in mlx5e driver, from Raed Salem.

6) Fix transfer buffer memleak in lan78xx, from Johan Havold.

7) RCU fixups in rhashtable, from Herbert Xu.

8) Fix ipv6 nexthop refcnt leak, from Xiyu Yang.

9) vxlan FDB dump must be done under RCU, from Ido Schimmel.

10) Fix use after free in mlxsw, from Ido Schimmel.

11) Fix map leak in HASH_OF_MAPS bpf code, from Andrii Nakryiko.

12) Fix bug in mac80211 Tx ack status reporting, from Vasanthakumar
    Thiagarajan.

13) Fix memory leaks in IPV6_ADDRFORM code, from Cong Wang.

14) Fix bpf program reference count leaks in mlx5 during
    mlx5e_alloc_rq(), from Xin Xiong.

Please pull, thanks a lot!

The following changes since commit 04300d66f0a06d572d9f2ad6768c38cabde22179:

  Merge tag 'riscv-for-linus-5.8-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux into master (2020-07-25 14:42:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to fda2ec62cf1aa7cbee52289dc8059cd3662795da:

  vxlan: fix memleak of fdb (2020-08-01 11:49:18 -0700)

----------------------------------------------------------------
Aaron Ma (1):
      e1000e: continue to init PHY even when failed to disable ULP

Al Viro (1):
      fix a braino in cmsghdr_from_user_compat_to_kern()

Alaa Hleihel (1):
      net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev

Amit Cohen (1):
      selftests: ethtool: Fix test when only two speeds are supported

Andrii Nakryiko (2):
      bpf: Fix map leak in HASH_OF_MAPS map
      selftests/bpf: Extend map-in-map selftest to detect memory leaks

Aya Levin (1):
      net/mlx5e: Fix error path of device attach

Christoph Hellwig (1):
      net/bpfilter: Initialize pos in __bpfilter_process_sockopt

Cong Wang (1):
      ipv6: fix memory leaks on IPV6_ADDRFORM path

David Howells (1):
      rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

David S. Miller (12):
      Merge branch 'selftests-net-Fix-clang-warnings-on-powerpc'
      Merge branch 'hns3-fixes'
      Merge branch 'net-lan78xx-fix-NULL-deref-and-memory-leak'
      Merge tag 'mlx5-fixes-2020-07-28' of git://git.kernel.org/.../saeed/linux
      Merge branch 'rhashtable-Fix-unprotected-RCU-dereference-in-__rht_ptr'
      Merge branch 'Fix-bugs-in-Octeontx2-netdev-driver'
      Merge branch 'mlxsw-fixes'
      Merge tag 'mac80211-for-davem-2020-07-30' of git://git.kernel.org/.../jberg/mac80211
      Merge branch '1GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge tag 'mlx5-fixes-2020-07-30' of git://git.kernel.org/.../saeed/linux
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge git://git.kernel.org/.../bpf/bpf

Eran Ben Elisha (3):
      net/mlx5: Fix a bug of using ptp channel index as pin index
      net/mlx5: Verify Hardware supports requested ptp function on a given pin
      net/mlx5: Query PPS pin operational status before registering it

Felix Fietkau (1):
      mac80211: remove STA txq pending airtime underflow warning

Francesco Ruggeri (1):
      igb: reinit_locked() should be called with rtnl_lock

Guillaume Nault (1):
      bareudp: forbid mixing IP and MPLS in multiproto mode

Guojia Liao (2):
      net: hns3: fix aRFS FD rules leftover after add a user FD rule
      net: hns3: fix for VLAN config when reset failed

Hangbin Liu (1):
      selftests/bpf: fix netdevsim trap_flow_action_cookie read

Herbert Xu (2):
      rhashtable: Fix unprotected RCU dereference in __rht_ptr
      rhashtable: Restore RCU marking on rhash_lock_head

Ido Schimmel (7):
      vxlan: Ensure FDB dump is performed under RCU
      ipv4: Silence suspicious RCU usage warning
      mlxsw: spectrum_router: Allow programming link-local host routes
      mlxsw: spectrum: Use different trap group for externally routed packets
      mlxsw: core: Increase scope of RCU read-side critical section
      mlxsw: core: Free EMAD transactions using kfree_rcu()
      mlxsw: spectrum_router: Fix use-after-free in router init / de-init

Jakub Kicinski (2):
      mlx4: disable device on shutdown
      devlink: ignore -EOPNOTSUPP errors on dumpit

Jean-Philippe Brucker (1):
      selftests/bpf: Fix cgroup sockopt verifier test

Jian Shen (1):
      net: hns3: add reset check for VF updating port based VLAN

Jianbo Liu (3):
      net/mlx5e: CT: Support restore ipv6 tunnel
      net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring
      net/mlx5e: E-Switch, Specify flow_source for rule with no in_port

Johan Hovold (3):
      net: lan78xx: add missing endpoint sanity check
      net: lan78xx: fix transfer-buffer memory leak
      net: lan78xx: replace bogus endpoint lookup

Joyce Ooi (1):
      MAINTAINERS: Replace Thor Thayer as Altera Triple Speed Ethernet maintainer

Julian Squires (1):
      cfg80211: check vendor command doit pointer before use

Landen Chao (1):
      net: ethernet: mtk_eth_soc: fix MTU warnings

Lu Wei (1):
      net: nixge: fix potential memory leak in nixge_probe()

Maor Dickman (1):
      net/mlx5e: Fix missing cleanup of ethtool steering during rep rx cleanup

Maor Gottlieb (1):
      net/mlx5: Fix forward to next namespace

Mark Salyzyn (1):
      af_key: pfkey_dump needs parameter validation

Martin Varghese (1):
      Documentation: bareudp: Corrected description of bareudp module.

Matthieu Baerts (1):
      mptcp: fix joined subflows with unblocking sk

Parav Pandit (2):
      net/mlx5: E-switch, Destroy TSAR when fail to enable the mode
      net/mlx5: E-switch, Destroy TSAR after reload interface

Peilin Ye (2):
      bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()
      rds: Prevent kernel-infoleak in rds_notify_queue_get()

Raed Salem (1):
      net/mlx5e: Fix slab-out-of-bounds in mlx5e_rep_is_lag_netdev

Rajkumar Manoharan (1):
      mac80211: fix warning in 6 GHz IE addition in mesh mode

Remi Pommarel (2):
      mac80211: mesh: Free ie data when leaving mesh
      mac80211: mesh: Free pending skb when destroying a mpath

René van Dorst (1):
      net: ethernet: mtk_eth_soc: Always call mtk_gmac0_rgmii_adjust() for mt7623

Ron Diskin (1):
      net/mlx5e: Modify uplink state on interface up/down

Rustam Kovhaev (1):
      usb: hso: check for return value in hso_serial_common_create()

Sabrina Dubroca (7):
      xfrm: esp6: fix encapsulation header offset computation
      espintcp: support non-blocking sends
      espintcp: recv() should return 0 when the peer socket is closed
      xfrm: policy: fix IPv6-only espintcp compilation
      xfrm: esp6: fix the location of the transport header with encapsulation
      espintcp: handle short messages instead of breaking the encap socket
      espintcp: count packets dropped in espintcp_rcv

Shannon Nelson (1):
      ionic: unlock queue mutex in error path

Steffen Klassert (2):
      Merge remote-tracking branch 'origin/testing'
      xfrm: Fix crash when the hold queue is used.

Subbaraya Sundeep (3):
      octeontx2-pf: Fix reset_task bugs
      octeontx2-pf: cancel reset_task work
      octeontx2-pf: Unregister netdev at driver remove

Taehee Yoo (1):
      vxlan: fix memleak of fdb

Tanner Love (4):
      selftests/net: rxtimestamp: fix clang issues for target arch PowerPC
      selftests/net: psock_fanout: fix clang issues for target arch PowerPC
      selftests/net: so_txtime: fix clang issues for target arch PowerPC
      selftests/net: tcp_mmap: fix clang warning for target arch PowerPC

Thomas Falcon (1):
      ibmvnic: Fix IRQ mapping disposal in error path

Vasanthakumar Thiagarajan (1):
      mac80211: Fix bug in Tx ack status reporting in 802.3 xmit path

Wang Hai (1):
      net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()

Xin Long (1):
      xfrm: policy: match with both mark and mask on user interfaces

Xin Xiong (2):
      atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent
      net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq

Xiyu Yang (1):
      ipv6: Fix nexthop refcnt leak when creating ipv6 route info

Yonglong Liu (1):
      net: hns3: fix a TX timeout issue

Yunsheng Lin (1):
      net: hns3: fix desc filling bug when skb is expanded or lineared

laurent brando (1):
      net: mscc: ocelot: fix hardware timestamp dequeue logic

liujian (1):
      net/sched: The error lable position is corrected in ct_init_module

 Documentation/networking/bareudp.rst                       |   5 ++--
 Documentation/networking/devlink/devlink-trap.rst          |   4 +++
 MAINTAINERS                                                |   2 +-
 drivers/atm/atmtcp.c                                       |  10 ++++++--
 drivers/net/bareudp.c                                      |  29 ++++++++++++++++-----
 drivers/net/ethernet/cortina/gemini.c                      |   5 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c            |  18 +++++--------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  35 +++++++++++++------------
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  38 ++++++++++++++++++---------
 drivers/net/ethernet/ibm/ibmvnic.c                         |   2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                |   4 +--
 drivers/net/ethernet/intel/igb/igb_main.c                  |   9 +++++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c       |   3 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c       |   2 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                |  21 +++++++++++----
 drivers/net/ethernet/mellanox/mlx4/main.c                  |   2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c      |   7 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c        |  30 +++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |   2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    |   2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |   2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          |  31 +++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c           |   3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |  27 ++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          |   2 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  19 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |  28 ++++----------------
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c        |  78 ++++++++++++++++++++++++++++++++++++++++++++++----------
 drivers/net/ethernet/mellanox/mlxsw/core.c                 |   8 +++---
 drivers/net/ethernet/mellanox/mlxsw/reg.h                  |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      |  59 +++++++++++++++++++-----------------------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c        |  14 +++++++---
 drivers/net/ethernet/mscc/ocelot.c                         |  10 ++++----
 drivers/net/ethernet/ni/nixge.c                            |   8 +++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c            |   4 ++-
 drivers/net/usb/hso.c                                      |   5 +++-
 drivers/net/usb/lan78xx.c                                  | 113 +++++++++++++++++++++++----------------------------------------------------------
 drivers/net/vxlan.c                                        |  16 +++++++++---
 include/linux/mlx5/mlx5_ifc.h                              |   1 +
 include/linux/rhashtable.h                                 |  69 +++++++++++++++++++++++--------------------------
 include/net/addrconf.h                                     |   1 +
 include/net/devlink.h                                      |   3 +++
 include/net/xfrm.h                                         |  15 ++++++-----
 kernel/bpf/btf.c                                           |   5 ++++
 kernel/bpf/hashtab.c                                       |  12 ++++++---
 lib/rhashtable.c                                           |  35 ++++++++++++-------------
 net/bpfilter/bpfilter_kern.c                               |   2 +-
 net/compat.c                                               |   2 +-
 net/core/devlink.c                                         |  25 +++++++++++++-----
 net/ipv4/fib_trie.c                                        |   2 +-
 net/ipv6/anycast.c                                         |  17 +++++++++----
 net/ipv6/esp6.c                                            |  13 +++++++---
 net/ipv6/ipv6_sockglue.c                                   |   1 +
 net/ipv6/route.c                                           |   8 +++---
 net/key/af_key.c                                           |  11 ++++++--
 net/mac80211/cfg.c                                         |   1 +
 net/mac80211/mesh.c                                        |  13 ++++++++++
 net/mac80211/mesh_pathtbl.c                                |   1 +
 net/mac80211/sta_info.c                                    |   4 +--
 net/mac80211/tx.c                                          |   7 ++---
 net/mac80211/util.c                                        |   4 +++
 net/mptcp/protocol.c                                       |   2 +-
 net/rds/recv.c                                             |   3 ++-
 net/rxrpc/call_object.c                                    |  27 ++++++++++++++------
 net/rxrpc/conn_object.c                                    |   8 +++---
 net/rxrpc/recvmsg.c                                        |   2 +-
 net/rxrpc/sendmsg.c                                        |   3 +++
 net/sched/act_ct.c                                         |   4 +--
 net/wireless/nl80211.c                                     |   6 ++---
 net/xfrm/espintcp.c                                        |  62 ++++++++++++++++++++++++++++++++++-----------
 net/xfrm/xfrm_policy.c                                     |  43 +++++++++++++------------------
 net/xfrm/xfrm_user.c                                       |  18 ++++++++-----
 tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c    | 124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 tools/testing/selftests/bpf/test_offload.py                |   3 +++
 tools/testing/selftests/bpf/verifier/event_output.c        |   1 +
 tools/testing/selftests/net/forwarding/ethtool.sh          |   2 --
 tools/testing/selftests/net/psock_fanout.c                 |   3 ++-
 tools/testing/selftests/net/rxtimestamp.c                  |   3 +--
 tools/testing/selftests/net/so_txtime.c                    |   2 +-
 tools/testing/selftests/net/tcp_mmap.c                     |   6 ++---
 81 files changed, 782 insertions(+), 451 deletions(-)
