Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7DD21CC04
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgGLXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgGLXP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mP8-FM; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 00/20] net simple kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:14:56 +0200
Message-Id: <20200712231516.1139335-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of simple kerneldoc fixes. They are all low
hanging fruit, were not real understanding of the code was needed.

Andrew Lunn (20):
  net: 9p: kerneldoc fixes
  net: can: kerneldoc fixes
  net: core: kerneldoc fixes
  net: dccp: kerneldoc fixes
  net: decnet: kerneldoc fixes
  net: ipv4: kerneldoc fixes
  net: ipv6: kerneldoc fixes
  net: llc: kerneldoc fixes
  net: mac80211: kerneldoc fixes
  net: netfilter: kerneldoc fixes
  net: netlabel: kerneldoc fixes
  net: nfc: kerneldoc fixes
  net: openvswitch: kerneldoc fixes
  net: rxrpc: kerneldoc fixes
  net: sched: kerneldoc fixes
  net: socket: Move kerneldoc next to function it documents
  net: switchdev: kerneldoc fixes
  net: tipc: kerneldoc fixes
  net: wireless: kerneldoc fixes
  net: x25: kerneldoc fixes

 net/9p/client.c                     |  2 +-
 net/9p/trans_rdma.c                 |  7 ++++---
 net/can/af_can.c                    |  2 ++
 net/core/dev.c                      |  1 +
 net/dccp/ccids/lib/packet_history.c |  2 ++
 net/dccp/feat.c                     |  6 ++++++
 net/dccp/input.c                    |  1 +
 net/dccp/ipv4.c                     |  2 ++
 net/dccp/options.c                  |  4 ++++
 net/dccp/timer.c                    |  2 ++
 net/decnet/dn_route.c               |  2 ++
 net/ipv4/cipso_ipv4.c               |  6 ++++--
 net/ipv4/ipmr.c                     |  3 +++
 net/ipv4/tcp_input.c                |  1 -
 net/ipv4/tcp_output.c               |  2 ++
 net/ipv4/tcp_timer.c                |  2 +-
 net/ipv4/udp.c                      |  6 +++---
 net/ipv6/exthdrs.c                  |  1 -
 net/ipv6/ip6_output.c               |  6 ++++--
 net/ipv6/ip6_tunnel.c               | 10 ++++++----
 net/ipv6/udp.c                      |  3 +++
 net/llc/af_llc.c                    |  1 -
 net/llc/llc_conn.c                  |  7 ++++---
 net/llc/llc_input.c                 |  1 +
 net/llc/llc_pdu.c                   |  2 +-
 net/llc/llc_sap.c                   |  3 +++
 net/mac80211/mesh_pathtbl.c         |  4 +---
 net/netfilter/nf_conntrack_core.c   |  2 +-
 net/netfilter/nf_tables_api.c       |  8 ++++----
 net/netfilter/nft_set_pipapo.c      |  8 ++++----
 net/netlabel/netlabel_domainhash.c  |  2 +-
 net/nfc/core.c                      |  3 +--
 net/nfc/nci/core.c                  |  4 ++--
 net/openvswitch/flow_netlink.c      |  6 +++---
 net/openvswitch/vport.c             |  3 ++-
 net/rxrpc/af_rxrpc.c                |  2 +-
 net/sched/em_canid.c                |  1 +
 net/sched/ematch.c                  |  3 +--
 net/socket.c                        | 17 ++++++++---------
 net/switchdev/switchdev.c           |  3 +--
 net/tipc/bearer.c                   |  2 +-
 net/tipc/discover.c                 |  5 ++---
 net/tipc/link.c                     |  6 +++---
 net/tipc/msg.c                      |  2 +-
 net/tipc/node.c                     |  4 ++--
 net/tipc/socket.c                   |  8 +++-----
 net/tipc/udp_media.c                |  2 +-
 net/wireless/reg.c                  |  4 +++-
 net/wireless/wext-compat.c          |  1 -
 net/x25/x25_link.c                  |  2 +-
 net/x25/x25_route.c                 |  2 +-
 51 files changed, 111 insertions(+), 78 deletions(-)

-- 
2.27.0.rc2

