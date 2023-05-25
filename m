Return-Path: <netdev+bounces-5298-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B307710A67
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BA95281516
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68474E57B;
	Thu, 25 May 2023 10:57:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A2BD303
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:57:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EEDC5
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685012234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k1Wg3zjxYdmVwTYUPZNoN64KyEZCyHfEIqxRXKnBqiw=;
	b=AhT9vjxjVOfeAuRW4W7J+D1Mi7c5dFFdrht+0vst3mMla+WPv2hZjuUbbIZQPh+SSsAx02
	RKCz2ISAIfPmA+MDZV3Wp//covkN2y7X50PCnMhQNQGMM7uTNAMaxO8Bxxn+XomySZ/O0j
	WTR9sFNXJhSeSDEuj8iFGBNXtIGNr6o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-D9T7BEW8OOWD1-jFygnbWw-1; Thu, 25 May 2023 06:57:11 -0400
X-MC-Unique: D9T7BEW8OOWD1-jFygnbWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D9502A5957F;
	Thu, 25 May 2023 10:57:11 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.113])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0C002166B2B;
	Thu, 25 May 2023 10:57:09 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.4-rc4
Date: Thu, 25 May 2023 12:56:31 +0200
Message-Id: <20230525105631.211284-1-pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Linus!

The following changes since commit 1f594fe7c90746982569bd4f3489e809104a9176:

  Merge tag 'net-6.4-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-05-18 08:52:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc4

for you to fetch changes up to ad42a35bdfc6d3c0fc4cb4027d7b2757ce665665:

  udplite: Fix NULL pointer dereference in __sk_mem_raise_allocated(). (2023-05-25 10:51:58 +0200)

----------------------------------------------------------------
Networking fixes for 6.4-rc4, including fixes from bluetooth and bpf

Current release - regressions:

  - net: fix skb leak in __skb_tstamp_tx()

  - eth: mtk_eth_soc: fix QoS on DSA MAC on non MTK_NETSYS_V2 SoCs

Current release - new code bugs:

  - handshake:
    - fix sock->file allocation
    - fix handshake_dup() ref counting

  - bluetooth:
    - fix potential double free caused by hci_conn_unlink
    - fix UAF in hci_conn_hash_flush

Previous releases - regressions:

  - core: fix stack overflow when LRO is disabled for virtual interfaces

  - tls: fix strparser rx issues

  - bpf:
    - fix many sockmap/TCP related issues
    - fix a memory leak in the LRU and LRU_PERCPU hash maps
    - init the offload table earlier

  - eth: mlx5e:
    - do as little as possible in napi poll when budget is 0
    - fix using eswitch mapping in nic mode
    - fix deadlock in tc route query code

Previous releases - always broken:

  - udplite: fix NULL pointer dereference in __sk_mem_raise_allocated()

  - raw: fix output xfrm lookup wrt protocol

  - smc: reset connection when trying to use SMCRv2 fails

  - phy: mscc: enable VSC8501/2 RGMII RX clock

  - eth: octeontx2-pf: fix TSOv6 offload

  - eth: cdc_ncm: deal with too low values of dwNtbOutMaxSize

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alejandro Lucero (1):
      sfc: fix devlink info error handling

Andrii Nakryiko (1):
      samples/bpf: Drop unnecessary fallthrough

Anton Protopopov (1):
      bpf: fix a memory leak in the LRU and LRU_PERCPU hash maps

Arınç ÜNAL (1):
      net: ethernet: mtk_eth_soc: fix QoS on DSA MAC on non MTK_NETSYS_V2 SoCs

Christophe JAILLET (2):
      forcedeth: Fix an error handling path in nv_probe()
      3c589_cs: Fix an error handling path in tc589_probe()

Chuck Lever (8):
      net/handshake: Squelch allocation warning during Kunit test
      net/handshake: Fix sock->file allocation
      net/handshake: Remove unneeded check from handshake_dup()
      net/handshake: Fix handshake_dup() ref counting
      net/handshake: Fix uninitialized local variable
      net/handshake: handshake_genl_notify() shouldn't ignore @flags
      net/handshake: Unpin sock->file if a handshake is cancelled
      net/handshake: Enable the SNI extension to work properly

David Epping (4):
      net: phy: mscc: add VSC8502 to MODULE_DEVICE_TABLE
      net: phy: mscc: add support for VSC8501
      net: phy: mscc: remove unnecessary phydev locking
      net: phy: mscc: enable VSC8501/2 RGMII RX clock

David S. Miller (2):
      Merge branch 'tls-fixes'
      Merge tag 'mlx5-fixes-2023-05-22' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Erez Shitrit (1):
      net/mlx5: DR, Fix crc32 calculation to work on big-endian (BE) CPUs

Gavrilov Ilia (1):
      ipv6: Fix out-of-bounds access in ipv6_find_tlv()

Horatiu Vultur (1):
      lan966x: Fix unloading/loading of the driver

Jakub Kicinski (14):
      bpf: netdev: init the offload table earlier
      tls: rx: device: fix checking decryption status
      tls: rx: strp: set the skb->len of detached / CoW'ed skbs
      tls: rx: strp: force mixed decrypted records into copy mode
      tls: rx: strp: fix determining record length in copy mode
      tls: rx: strp: factor out copying skb data
      tls: rx: strp: preserve decryption status of skbs when needed
      tls: rx: strp: don't use GFP_KERNEL in softirq context
      net/mlx5e: do as little as possible in napi poll when budget is 0
      Merge tag 'for-net-2023-05-19' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      docs: netdev: document the existence of the mail bot
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'bug-fixes-for-net-handshake'
      Merge branch 'net-phy-mscc-support-vsc8501'

Jeremy Sowden (1):
      selftests/bpf: Fix pkg-config call building sign-file

John Fastabend (14):
      bpf, sockmap: Pass skb ownership through read_skb
      bpf, sockmap: Convert schedule_work into delayed_work
      bpf, sockmap: Reschedule is now done through backlog
      bpf, sockmap: Improved check for empty queue
      bpf, sockmap: Handle fin correctly
      bpf, sockmap: TCP data stall on recv before accept
      bpf, sockmap: Wake up polling after data copy
      bpf, sockmap: Incorrectly handling copied_seq
      bpf, sockmap: Pull socket helpers out of listen test for general use
      bpf, sockmap: Build helper to create connected socket pair
      bpf, sockmap: Test shutdown() correctly exits epoll and recv()=0
      bpf, sockmap: Test FIONREAD returns correct bytes in rx buffer
      bpf, sockmap: Test FIONREAD returns correct bytes in rx buffer with drops
      bpf, sockmap: Test progs verifier error with latest clang

Kuniyuki Iwashima (1):
      udplite: Fix NULL pointer dereference in __sk_mem_raise_allocated().

Neeraj Sanjay Kale (1):
      Bluetooth: btnxpuart: Fix compiler warnings

Nicolas Dichtel (1):
      ipv{4,6}/raw: fix output xfrm lookup wrt protocol

Paul Blakey (1):
      net/mlx5e: TC, Fix using eswitch mapping in nic mode

Po-Hsu Lin (1):
      selftests: fib_tests: mute cleanup error message

Pratyush Yadav (1):
      net: fix skb leak in __skb_tstamp_tx()

Rahul Rameshbabu (1):
      net/mlx5e: Fix SQ wake logic in ptp napi_poll context

Roi Dayan (1):
      net/mlx5: Fix error message when failing to allocate device memory

Ruihan Li (4):
      Bluetooth: Fix potential double free caused by hci_conn_unlink
      Bluetooth: Refcnt drop must be placed last in hci_conn_unlink
      Bluetooth: Fix UAF in hci_conn_hash_flush again
      Bluetooth: Unlink CISes when LE disconnects in hci_conn_del

Sebastian Andrzej Siewior (1):
      r8169: Use a raw_spinlock_t for the register locks.

Shay Drory (8):
      net/mlx5: Collect command failures data only for known commands
      net/mlx5: Handle pairing of E-switch via uplink un/load APIs
      net/mlx5: E-switch, Devcom, sync devcom events and devcom comp register
      net/mlx5: Devcom, fix error flow in mlx5_devcom_register_device
      net/mlx5: Devcom, serialize devcom registration
      net/mlx5: Free irqs only on shutdown callback
      net/mlx5: Fix irq affinity management
      net/mlx5: Fix indexing of mlx5_irq

Shenwei Wang (1):
      net: fec: add dma_wmb to ensure correct descriptor values

Sunil Goutham (1):
      octeontx2-pf: Fix TSOv6 offload

Taehee Yoo (1):
      net: fix stack overflow when LRO is disabled for virtual interfaces

Tudor Ambarus (1):
      net: cdc_ncm: Deal with too low values of dwNtbOutMaxSize

Vlad Buslov (2):
      net/mlx5e: Use correct encap attribute during invalidation
      net/mlx5e: Fix deadlock in tc route query code

Vladimir Oltean (1):
      MAINTAINERS: add myself as maintainer for enetc

Wen Gu (1):
      net/smc: Reset connection when trying to use SMCRv2 fails.

Will Deacon (1):
      bpf: Fix mask generation for 32-bit narrow loads of 64-bit fields

Xin Long (1):
      sctp: fix an issue that plpmtu can never go to complete state

Yevgeny Kliteynik (1):
      net/mlx5: DR, Check force-loopback RC QP capability independently from RoCE

Yunsheng Lin (1):
      page_pool: fix inconsistency for page_pool_ring_[un]lock()

 Documentation/netlink/specs/handshake.yaml         |   4 +
 Documentation/networking/tls-handshake.rst         |   5 +
 Documentation/process/maintainer-netdev.rst        |  33 +-
 MAINTAINERS                                        |   1 +
 drivers/bluetooth/btnxpuart.c                      |   6 +-
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/ethernet/3com/3c589_cs.c               |  11 +-
 drivers/net/ethernet/freescale/fec_main.c          |  17 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   2 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  57 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   5 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  16 +-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |  70 +++-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  40 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   3 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  10 +
 drivers/net/ethernet/nvidia/forcedeth.c            |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  44 +--
 drivers/net/ethernet/sfc/efx_devlink.c             |  95 +++--
 drivers/net/phy/mscc/mscc.h                        |   2 +
 drivers/net/phy/mscc/mscc_main.c                   |  82 +++--
 drivers/net/team/team.c                            |   7 +-
 drivers/net/usb/cdc_ncm.c                          |  24 +-
 include/linux/if_team.h                            |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 include/linux/skbuff.h                             |  10 +
 include/linux/skmsg.h                              |   3 +-
 include/net/bluetooth/hci_core.h                   |   2 +-
 include/net/bonding.h                              |   1 +
 include/net/handshake.h                            |   1 +
 include/net/ip.h                                   |   2 +
 include/net/page_pool.h                            |  18 -
 include/net/tcp.h                                  |  10 +
 include/net/tls.h                                  |   1 +
 include/uapi/linux/handshake.h                     |   1 +
 include/uapi/linux/in.h                            |   1 +
 kernel/bpf/hashtab.c                               |   6 +-
 kernel/bpf/offload.c                               |   2 +-
 kernel/bpf/verifier.c                              |   2 +-
 net/bluetooth/hci_conn.c                           |  77 ++--
 net/core/page_pool.c                               |  28 +-
 net/core/skbuff.c                                  |   4 +-
 net/core/skmsg.c                                   |  81 ++---
 net/core/sock_map.c                                |   3 +-
 net/handshake/handshake-test.c                     |  44 ++-
 net/handshake/handshake.h                          |   1 +
 net/handshake/netlink.c                            |  12 +-
 net/handshake/request.c                            |   4 +
 net/handshake/tlshd.c                              |   8 +
 net/ipv4/ip_sockglue.c                             |  12 +-
 net/ipv4/raw.c                                     |   5 +-
 net/ipv4/tcp.c                                     |  11 +-
 net/ipv4/tcp_bpf.c                                 |  79 ++++-
 net/ipv4/udp.c                                     |   7 +-
 net/ipv4/udplite.c                                 |   2 +
 net/ipv6/exthdrs_core.c                            |   2 +
 net/ipv6/raw.c                                     |   3 +-
 net/ipv6/udplite.c                                 |   2 +
 net/sctp/transport.c                               |  11 +-
 net/smc/af_smc.c                                   |   9 +-
 net/smc/smc_core.c                                 |   1 +
 net/tls/tls.h                                      |   5 +
 net/tls/tls_device.c                               |  22 +-
 net/tls/tls_strp.c                                 | 185 ++++++++--
 net/tls/tls_sw.c                                   |   4 +
 net/unix/af_unix.c                                 |   7 +-
 net/vmw_vsock/virtio_transport_common.c            |   5 +-
 samples/bpf/hbm.c                                  |   1 -
 tools/testing/selftests/bpf/Makefile               |   2 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       | 131 +++++++
 .../selftests/bpf/prog_tests/sockmap_helpers.h     | 390 +++++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 370 +------------------
 .../selftests/bpf/progs/test_sockmap_drop_prog.c   |  32 ++
 .../selftests/bpf/progs/test_sockmap_kern.h        |  12 +-
 .../selftests/bpf/progs/test_sockmap_pass_prog.c   |  32 ++
 tools/testing/selftests/net/fib_tests.sh           |   2 +-
 88 files changed, 1488 insertions(+), 792 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c


