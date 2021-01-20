Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4515E2FD7FA
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391808AbhATSMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391925AbhATSKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 13:10:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F83B233FC;
        Wed, 20 Jan 2021 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611166154;
        bh=ajbgiswJ3h2+Nlvm3e43oiSyttRBtXdBI9yK03Uznoo=;
        h=From:To:Cc:Subject:Date:From;
        b=HE9n96BkuOqUMmWEfUwAvVd8G6kgny5WBJmn8Z3WZ3WNVCpycyeIGuuFq7Mid2diK
         GKBMiKzgcDXZRDq6DwnJDXS04FXank8/pcWVZBo3SxDQL5c5JkfJaTAnJn/c3gwLHj
         mf/q8zQivzxxs+YiDEl3/jienvYx22+uHPdaPwWd63BBiCeM9bmdQLG1k9YijYG3k+
         S1pkzPRLLxvIfEw5A+7taQm5Z2kxL5sB/N35ECRrJRYcTtY98alYZ1e18tkX4fv2Um
         uhxwWMmVZgOTnYIUmhmq0PL1dqTsZ/2F3gGZ479pHQP0kM4neg6xBK+LzeiuEe9cd6
         D8Ye2ejjoClNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc5
Date:   Wed, 20 Jan 2021 10:09:13 -0800
Message-Id: <20210120180913.514293-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 146620506274bd24d52fb1c589110a30eed8240b:

  Merge tag 'linux-kselftest-fixes-5.11-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest (2021-01-14 13:54:09 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc5

for you to fetch changes up to 535d31593f5951f2cd344df7cb618ca48f67393f:

  Merge tag 'linux-can-fixes-for-5.11-20210120' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can (2021-01-20 09:16:01 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc5, including fixes from bpf, wireless,
and can trees.

Current release - regressions:

 - nfc: nci: fix the wrong NCI_CORE_INIT parameters

Current release - new code bugs:

 - bpf: allow empty module BTFs

Previous releases - regressions:

 - bpf: fix signed_{sub,add32}_overflows type handling

 - tcp: do not mess with cloned skbs in tcp_add_backlog()

 - bpf: prevent double bpf_prog_put call from bpf_tracing_prog_attach

 - bpf: don't leak memory in bpf getsockopt when optlen == 0

 - tcp: fix potential use-after-free due to double kfree()

 - mac80211: fix encryption issues with WEP

 - devlink: use right genl user_ptr when handling port param get/set

 - ipv6: set multicast flag on the multicast route

 - tcp: fix TCP_USER_TIMEOUT with zero window

Previous releases - always broken:

 - bpf: local storage helpers should check nullness of owner ptr passed

 - mac80211: fix incorrect strlen of .write in debugfs

 - cls_flower: call nla_ok() before nla_next()

 - skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alban Bedel (1):
      net: mscc: ocelot: Fix multicast to the CPU port

Alexander Lobakin (1):
      skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Andrii Nakryiko (2):
      bpf: Allow empty module BTFs
      libbpf: Allow loading empty BTFs

Björn Töpel (1):
      MAINTAINERS: Update my email address

Bongsu Jeon (1):
      net: nfc: nci: fix the wrong NCI_CORE_INIT parameters

Cong Wang (1):
      cls_flower: call nla_ok() before nla_next()

Dan Carpenter (1):
      net: dsa: b53: fix an off by one in checking "vlan->vid"

Daniel Borkmann (1):
      bpf: Fix signed_{sub,add32}_overflows type handling

Enke Chen (1):
      tcp: fix TCP_USER_TIMEOUT with zero window

Eric Dumazet (4):
      net_sched: reject silly cell_log in qdisc_get_rtab()
      net_sched: gen_estimator: support large ewma log
      net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
      tcp: do not mess with cloned skbs in tcp_add_backlog()

Felix Fietkau (3):
      mac80211: fix fast-rx encryption check
      mac80211: fix encryption key selection for 802.3 xmit
      mac80211: do not drop tx nulldata packets on encrypted links

Geert Uytterhoeven (3):
      mdio-bitbang: Export mdiobb_{read,write}()
      sh_eth: Make PHY access aware of Runtime PM to fix reboot crash
      sh_eth: Fix power down vs. is_opened flag ordering

Gilad Reti (2):
      bpf: Support PTR_TO_MEM{,_OR_NULL} register spilling
      selftests/bpf: Add verifier test for PTR_TO_MEM spill

Grant Grundler (1):
      net: usb: cdc_ncm: don't spew notifications

Guillaume Nault (2):
      udp: mask TOS bits in udp_v4_early_demux()
      netfilter: rpfilter: mask ecn bits before fib lookup

Hangbin Liu (1):
      selftests: net: fib_tests: remove duplicate log test

Ilan Peer (1):
      cfg80211: Save the regulatory domain with a lock

Jakub Kicinski (7):
      Merge https://git.kernel.org/.../bpf/bpf
      Merge tag 'mac80211-for-net-2021-01-18.2' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'ipv6-fixes-for-the-multicast-routes'
      Merge branch 'sh_eth-fix-reboot-crash'
      Merge branch 'ipv4-ensure-ecn-bits-don-t-influence-source-address-validation'
      Merge https://git.kernel.org/.../bpf/bpf
      Merge tag 'linux-can-fixes-for-5.11-20210120' of git://git.kernel.org/.../mkl/linux-can

Jiri Olsa (1):
      bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach

Johannes Berg (1):
      cfg80211/mac80211: fix kernel-doc for SAR APIs

KP Singh (3):
      bpf: Local storage helpers should check nullness of owner ptr passed
      bpf: Fix typo in bpf_inode_storage.c
      bpf: Update local storage test to check handling of null ptrs

Kuniyuki Iwashima (1):
      tcp: Fix potential use-after-free due to double kfree()

Lorenzo Bianconi (1):
      mac80211: check if atf has been disabled in __ieee80211_schedule_txq

Matteo Croce (2):
      ipv6: create multicast route with RTPROT_KERNEL
      ipv6: set multicast flag on the multicast route

Mauro Carvalho Chehab (1):
      cfg80211: fix a kerneldoc markup

Maxim Mikityanskiy (1):
      xsk: Clear pool even for inactive queues

Mircea Cirjaliu (1):
      bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback

Oleksandr Mazur (1):
      net: core: devlink: use right genl user_ptr when handling port param get/set

Pan Bian (1):
      net: systemport: free dev before on error path

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext

Shayne Chen (1):
      mac80211: fix incorrect strlen of .write in debugfs

Song Liu (1):
      bpf: Reject too big ctx_size_in for raw_tp test run

Stanislav Fomichev (1):
      bpf: Don't leak memory in bpf getsockopt when optlen == 0

Tariq Toukan (1):
      net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled

Vincent Mailhol (3):
      can: dev: can_restart: fix use after free bug
      can: vxcan: vxcan_xmit: fix use after free bug
      can: peak_usb: fix use after free bugs

Vladimir Oltean (1):
      net: mscc: ocelot: allow offloading of bridge on top of LAG

Yingjie Wang (1):
      octeontx2-af: Fix missing check bugs in rvu_cgx.c

Yuchung Cheng (1):
      tcp: fix TCP socket rehash stats mis-accounting

 .mailmap                                           |  2 +
 Documentation/networking/tls-offload.rst           |  3 +
 MAINTAINERS                                        |  4 +-
 drivers/net/can/dev.c                              |  4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  8 +-
 drivers/net/can/vxcan.c                            |  6 +-
 drivers/net/dsa/b53/b53_common.c                   |  2 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |  4 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |  6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  6 ++
 drivers/net/ethernet/mscc/ocelot.c                 | 23 ++++--
 drivers/net/ethernet/mscc/ocelot_net.c             |  4 +-
 drivers/net/ethernet/renesas/sh_eth.c              | 30 ++++++-
 drivers/net/mdio/mdio-bitbang.c                    |  6 +-
 drivers/net/usb/cdc_ncm.c                          | 12 ++-
 include/linux/mdio-bitbang.h                       |  3 +
 include/linux/usb/usbnet.h                         |  2 +
 include/net/cfg80211.h                             |  5 +-
 include/net/inet_connection_sock.h                 |  3 +
 include/net/mac80211.h                             |  1 +
 include/net/sock.h                                 | 17 ++--
 kernel/bpf/bpf_inode_storage.c                     |  9 +-
 kernel/bpf/bpf_task_storage.c                      |  5 +-
 kernel/bpf/btf.c                                   |  2 +-
 kernel/bpf/cgroup.c                                |  5 +-
 kernel/bpf/helpers.c                               |  2 +-
 kernel/bpf/syscall.c                               |  6 +-
 kernel/bpf/verifier.c                              |  8 +-
 net/bpf/test_run.c                                 |  3 +-
 net/core/dev.c                                     |  5 ++
 net/core/devlink.c                                 |  4 +-
 net/core/gen_estimator.c                           | 11 ++-
 net/core/skbuff.c                                  |  6 +-
 net/ipv4/inet_connection_sock.c                    |  1 +
 net/ipv4/netfilter/ipt_rpfilter.c                  |  2 +-
 net/ipv4/tcp.c                                     |  1 +
 net/ipv4/tcp_input.c                               |  6 +-
 net/ipv4/tcp_ipv4.c                                | 29 +++----
 net/ipv4/tcp_output.c                              |  1 +
 net/ipv4/tcp_timer.c                               | 36 ++++----
 net/ipv4/udp.c                                     |  3 +-
 net/ipv6/addrconf.c                                |  3 +-
 net/mac80211/debugfs.c                             | 44 +++++-----
 net/mac80211/rx.c                                  |  2 +
 net/mac80211/tx.c                                  | 31 +++----
 net/nfc/nci/core.c                                 |  2 +-
 net/sched/cls_flower.c                             | 22 +++--
 net/sched/cls_tcindex.c                            |  8 +-
 net/sched/sch_api.c                                |  3 +-
 net/wireless/reg.c                                 | 11 ++-
 net/xdp/xsk.c                                      |  4 +-
 tools/lib/bpf/btf.c                                |  5 --
 .../selftests/bpf/prog_tests/test_local_storage.c  | 96 ++++++----------------
 tools/testing/selftests/bpf/progs/local_storage.c  | 62 ++++++++------
 tools/testing/selftests/bpf/test_verifier.c        | 12 ++-
 tools/testing/selftests/bpf/verifier/spill_fill.c  | 30 +++++++
 tools/testing/selftests/net/fib_tests.sh           |  1 -
 57 files changed, 380 insertions(+), 252 deletions(-)
