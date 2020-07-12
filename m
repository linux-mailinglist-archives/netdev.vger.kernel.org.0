Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2199C21CC1B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgGLXQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mPe-5W; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net-next 13/20] net: openvswitch: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:09 +0200
Message-Id: <20200712231516.1139335-14-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/openvswitch/flow_netlink.c | 6 +++---
 net/openvswitch/vport.c        | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 79252d4887ff..9d3e50c4d29f 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -1763,11 +1763,11 @@ static void mask_set_nlattr(struct nlattr *attr, u8 val)
  * does not include any don't care bit.
  * @net: Used to determine per-namespace field support.
  * @match: receives the extracted flow match information.
- * @key: Netlink attribute holding nested %OVS_KEY_ATTR_* Netlink attribute
+ * @nla_key: Netlink attribute holding nested %OVS_KEY_ATTR_* Netlink attribute
  * sequence. The fields should of the packet that triggered the creation
  * of this flow.
- * @mask: Optional. Netlink attribute holding nested %OVS_KEY_ATTR_* Netlink
- * attribute specifies the mask field of the wildcarded flow.
+ * @nla_mask: Optional. Netlink attribute holding nested %OVS_KEY_ATTR_*
+ * Netlink attribute specifies the mask field of the wildcarded flow.
  * @log: Boolean to allow kernel error logging.  Normally true, but when
  * probing for feature compatibility this should be passed in as false to
  * suppress unnecessary error logging.
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 47febb4504f0..0d44c5c013fa 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -87,6 +87,7 @@ EXPORT_SYMBOL_GPL(ovs_vport_ops_unregister);
 /**
  *	ovs_vport_locate - find a port that has already been created
  *
+ * @net: network namespace
  * @name: name of port to find
  *
  * Must be called with ovs or RCU read lock.
@@ -418,7 +419,7 @@ u32 ovs_vport_find_upcall_portid(const struct vport *vport, struct sk_buff *skb)
  *
  * @vport: vport that received the packet
  * @skb: skb that was received
- * @tun_key: tunnel (if any) that carried packet
+ * @tun_info: tunnel (if any) that carried packet
  *
  * Must be called with rcu_read_lock.  The packet cannot be shared and
  * skb->data should point to the Ethernet header.
-- 
2.27.0.rc2

