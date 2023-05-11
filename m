Return-Path: <netdev+bounces-1731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B146FF011
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 258961C20F1D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACA8637;
	Thu, 11 May 2023 10:44:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADF528F1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:44:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC42D52
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683801838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MHaGSheX03bFaaahcKs7iJDPO3dUtTLJ/9oLvjckzjY=;
	b=CDSaOQ0L9iV+wEP/8H/+BPNFU9IdGdJWfnS2iNvS/TsCt1rNxqsFx4p3Vjc3scmK372VtO
	8vMRW7v1INxM9mLvnDvXRweruIYnrt8XuEPbwbxdle6p+oj48NiTGi0QJTXSts6jnkLnlI
	fw7r8mDx7FQcfQtlmXns2FTnEJAXtkY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-Yt57wi35P-ier9djhmMlZw-1; Thu, 11 May 2023 06:43:53 -0400
X-MC-Unique: Yt57wi35P-ier9djhmMlZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D31A2280BC5E;
	Thu, 11 May 2023 10:43:52 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.9])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0617C15BA0;
	Thu, 11 May 2023 10:43:51 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.4-rc2
Date: Thu, 11 May 2023 12:43:42 +0200
Message-Id: <20230511104342.18276-1-pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Linus!

The following changes since commit ed23734c23d2fc1e6a1ff80f8c2b82faeed0ed0c:

  Merge tag 'net-6.4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-05-05 19:12:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc2

for you to fetch changes up to cceac9267887753f3c9594f1f7b92237cb0f64fb:

  Merge tag 'nf-23-05-10' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2023-05-10 19:08:58 -0700)

----------------------------------------------------------------
Networking fixes for 6.4-rc2, including fixes from netfilter

Current release - regressions:

  - mtk_eth_soc: fix NULL pointer dereference

Previous releases - regressions:

  - core:
    - skb_partial_csum_set() fix against transport header magic value
    - fix load-tearing on sk->sk_stamp in sock_recv_cmsgs().
    - annotate sk->sk_err write from do_recvmmsg()
    - add vlan_get_protocol_and_depth() helper

  - netlink: annotate accesses to nlk->cb_running

  - netfilter: always release netdev hooks from notifier

Previous releases - always broken:

  - core: deal with most data-races in sk_wait_event()

  - netfilter: fix possible bug_on with enable_hooks=1

  - eth: bonding: fix send_peer_notif overflow

  - eth: xpcs: fix incorrect number of interfaces

  - eth: ipvlan: fix out-of-bounds caused by unclear skb->cb

  - eth: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Boris Sukholitko (4):
      selftests: nft_flowtable.sh: use /proc for pid checking
      selftests: nft_flowtable.sh: no need for ps -x option
      selftests: nft_flowtable.sh: wait for specific nc pids
      selftests: nft_flowtable.sh: monitor result file sizes

Christophe JAILLET (1):
      net: mdio: mvusb: Fix an error handling path in mvusb_mdio_probe()

Colin Foster (1):
      net: mscc: ocelot: fix stat counter register values

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix NULL pointer dereference

David S. Miller (1):
      Merge branch 'bonding-overflow'

Eric Dumazet (7):
      net: skb_partial_csum_set() fix against transport header magic value
      netlink: annotate accesses to nlk->cb_running
      net: annotate sk->sk_err write from do_recvmmsg()
      net: deal with most data-races in sk_wait_event()
      net: add vlan_get_protocol_and_depth() helper
      tcp: add annotations around sk->sk_shutdown accesses
      net: datagram: fix data-races in datagram_poll()

Florian Fainelli (1):
      net: phy: bcm7xx: Correct read from expansion register

Florian Westphal (3):
      netfilter: nf_tables: always release netdev hooks from notifier
      netfilter: conntrack: fix possible bug_on with enable_hooks=1
      selftests: nft_flowtable.sh: check ingress/egress chain too

Hangbin Liu (4):
      bonding: fix send_peer_notif overflow
      Documentation: bonding: fix the doc of peer_notif_delay
      selftests: forwarding: lib: add netns support for tc rule handle stats get
      kselftest: bonding: add num_grat_arp test

Jakub Kicinski (2):
      Merge branch 'af_unix-fix-two-data-races-reported-by-kcsan'
      Merge tag 'nf-23-05-10' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Kuniyuki Iwashima (3):
      net: Fix load-tearing on sk->sk_stamp in sock_recv_cmsgs().
      af_unix: Fix a data race of sk->sk_receive_queue->qlen.
      af_unix: Fix data races around sk->sk_shutdown.

Marek Vasut (1):
      net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register

Randy Dunlap (1):
      docs: networking: fix x25-iface.rst heading & index order

Roy Novich (1):
      linux/dim: Do nothing if no time delta between samples

Russell King (Oracle) (1):
      net: pcs: xpcs: fix incorrect number of interfaces

Ziwei Xiao (1):
      gve: Remove the code of clearing PBA bit

t.feng (1):
      ipvlan:Fix out-of-bounds caused by unclear skb->cb

 Documentation/networking/bonding.rst               |   9 +-
 Documentation/networking/index.rst                 |   2 +-
 Documentation/networking/x25-iface.rst             |   3 +-
 drivers/net/bonding/bond_netlink.c                 |   7 +-
 drivers/net/bonding/bond_options.c                 |   8 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  13 --
 drivers/net/ethernet/mediatek/mtk_wed.c            |   2 +-
 drivers/net/ethernet/mscc/vsc7514_regs.c           |  18 +--
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   5 +
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +
 drivers/net/mdio/mdio-mvusb.c                      |  11 +-
 drivers/net/pcs/pcs-xpcs.c                         |   2 +-
 drivers/net/phy/bcm-phy-lib.h                      |   5 +
 drivers/net/phy/bcm7xxx.c                          |   2 +-
 drivers/net/tap.c                                  |   4 +-
 include/linux/dim.h                                |   3 +-
 include/linux/if_vlan.h                            |  17 +++
 include/net/bonding.h                              |   2 +-
 include/net/sock.h                                 |   2 +-
 lib/dim/dim.c                                      |   5 +-
 lib/dim/net_dim.c                                  |   3 +-
 lib/dim/rdma_dim.c                                 |   3 +-
 net/bridge/br_forward.c                            |   2 +-
 net/core/datagram.c                                |  15 ++-
 net/core/dev.c                                     |   2 +-
 net/core/skbuff.c                                  |   4 +-
 net/core/stream.c                                  |  12 +-
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/tcp.c                                     |  14 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   4 +-
 net/llc/af_llc.c                                   |   8 +-
 net/netfilter/core.c                               |   6 +-
 net/netfilter/nf_conntrack_standalone.c            |   3 +-
 net/netfilter/nft_chain_filter.c                   |   9 +-
 net/netlink/af_netlink.c                           |   8 +-
 net/packet/af_packet.c                             |   6 +-
 net/smc/smc_close.c                                |   4 +-
 net/smc/smc_rx.c                                   |   4 +-
 net/smc/smc_tx.c                                   |   4 +-
 net/socket.c                                       |   2 +-
 net/tipc/socket.c                                  |   4 +-
 net/tls/tls_main.c                                 |   3 +-
 net/unix/af_unix.c                                 |  22 ++--
 .../selftests/drivers/net/bonding/bond_options.sh  |  50 +++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh          |   2 +
 tools/testing/selftests/net/forwarding/lib.sh      |   3 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 145 ++++++++++++++++++++-
 49 files changed, 361 insertions(+), 112 deletions(-)


