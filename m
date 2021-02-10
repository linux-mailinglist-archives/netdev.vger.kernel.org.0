Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7731684A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhBJNuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:50:03 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15459 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBJNt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:49:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e45d0003>; Wed, 10 Feb 2021 05:49:17 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:49:17 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 13:49:15 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v3 1/5] update UAPI header copies
Date:   Wed, 10 Feb 2021 15:48:36 +0200
Message-ID: <20210210134840.2187696-2-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210134840.2187696-1-danieller@nvidia.com>
References: <20210210134840.2187696-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612964958; bh=3dpW9XEF/ErmQSbOgUxqP2CbeCf8m425iZ/8wLPok+s=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lTU8fv0LtDARdlZ1UwdAivlfrfWVI7dAG35h/zdAoOntgtGFQGIroFYHGpocqpkXp
         cbIE20LBjiOqXqDJd3y+B7wM35wMU/8FR+J7nFZfMfKxEEWVxionMltgoVQvLka7Ay
         iordRjh1Sk0E7IdfI3J/+xWVVzVcizsfpNkyYCYbD7pH7rRcB+mvzFluCrzlCtXAT7
         Zs8VQwu3RFtviWNLp2X3oaFywEIrKQHIgefTiLvsMx5WQqxsd8MKcZgnZAvd4Oj+FF
         PH9tikrmttydW0/7bdzL2Ip27qrawq7d5jBEOFcF0+tDcsoGc9pG95oAKNCLw5mE/e
         iKmKhzelW+nFQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 012ce4dd3102.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---
 uapi/linux/ethtool.h         |  2 +-
 uapi/linux/ethtool_netlink.h |  1 +
 uapi/linux/if_link.h         | 10 ++++++++--
 uapi/linux/netlink.h         |  2 +-
 uapi/linux/rtnetlink.h       | 20 +++++++++++++++-----
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 052689b..a951137 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_ETHTOOL_H
 #define _LINUX_ETHTOOL_H
=20
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
=20
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index c022883..0cd6906 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
=20
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 307e5c2..c96880c 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -75,8 +75,9 @@ struct rtnl_link_stats {
  *
  * @rx_dropped: Number of packets received but not processed,
  *   e.g. due to lack of resources or unsupported protocol.
- *   For hardware interfaces this counter should not include packets
- *   dropped by the device which are counted separately in
+ *   For hardware interfaces this counter may include packets discarded
+ *   due to L2 address filtering but should not include packets dropped
+ *   by the device due to buffer exhaustion which are counted separately i=
n
  *   @rx_missed_errors (since procfs folds those two counters together).
  *
  * @tx_dropped: Number of packets dropped on their way to transmission,
@@ -522,6 +523,8 @@ enum {
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
 	IFLA_BRPORT_MRP_IN_OPEN,
+	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
+	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
@@ -586,6 +589,8 @@ enum {
 	IFLA_MACVLAN_MACADDR,
 	IFLA_MACVLAN_MACADDR_DATA,
 	IFLA_MACVLAN_MACADDR_COUNT,
+	IFLA_MACVLAN_BC_QUEUE_LEN,
+	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
 	__IFLA_MACVLAN_MAX,
 };
=20
@@ -804,6 +809,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index dfef006..5024c54 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -2,7 +2,7 @@
 #ifndef __LINUX_NETLINK_H
 #define __LINUX_NETLINK_H
=20
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
=20
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index 5ad84e6..c66fd24 100644
--- a/uapi/linux/rtnetlink.h
+++ b/uapi/linux/rtnetlink.h
@@ -396,11 +396,13 @@ struct rtnexthop {
 #define RTNH_F_DEAD		1	/* Nexthop is dead (used by multipath)	*/
 #define RTNH_F_PERVASIVE	2	/* Do recursive gateway lookup	*/
 #define RTNH_F_ONLINK		4	/* Gateway is forced on link	*/
-#define RTNH_F_OFFLOAD		8	/* offloaded route */
+#define RTNH_F_OFFLOAD		8	/* Nexthop is offloaded */
 #define RTNH_F_LINKDOWN		16	/* carrier-down on nexthop */
 #define RTNH_F_UNRESOLVED	32	/* The entry is unresolved (ipmr) */
+#define RTNH_F_TRAP		64	/* Nexthop is trapping packets */
=20
-#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | RTNH_F_OFFLOAD)
+#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
+				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
=20
 /* Macros to handle hexthops */
=20
@@ -764,12 +766,18 @@ enum {
 #define TA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcamsg))
 /* tcamsg flags stored in attribute TCA_ROOT_FLAGS
  *
- * TCA_FLAG_LARGE_DUMP_ON user->kernel to request for larger than TCA_ACT_=
MAX_PRIO
- * actions in a dump. All dump responses will contain the number of action=
s
- * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
+ * TCA_ACT_FLAG_LARGE_DUMP_ON user->kernel to request for larger than
+ * TCA_ACT_MAX_PRIO actions in a dump. All dump responses will contain the
+ * number of actions being dumped stored in for user app's consumption in
+ * TCA_ROOT_COUNT
+ *
+ * TCA_ACT_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that=
 only
+ * includes essential action info (kind, index, etc.)
  *
  */
 #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
+#define TCA_ACT_FLAG_LARGE_DUMP_ON	TCA_FLAG_LARGE_DUMP_ON
+#define TCA_ACT_FLAG_TERSE_DUMP		(1 << 1)
=20
 /* New extended info filters for IFLA_EXT_MASK */
 #define RTEXT_FILTER_VF		(1 << 0)
@@ -777,6 +785,8 @@ enum {
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
 #define RTEXT_FILTER_MRP	(1 << 4)
+#define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
+#define RTEXT_FILTER_CFM_STATUS	(1 << 6)
=20
 /* End of information exported to user level */
=20
--=20
2.26.2

