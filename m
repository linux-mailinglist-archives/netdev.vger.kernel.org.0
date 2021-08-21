Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A4E3F3CAD
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 01:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhHUXGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 19:06:23 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:31556
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230384AbhHUXGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 19:06:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGAbFNg6UtvJDYkK06ojq4WY5UbMndDkI9+F7zTIf+awMy2QM8sWopKnguW1nwFOnwdDYk/ECk4TITn+qC8DrrslxPzZqru8KJWHvXaKEFA6ESv5O3ee9iOjhV1LcOwZDCyCtqrNozTGYI0GdG3BBFzdoQr3bOwSqUor9iPnC70HNtmOzP4T3r4HTn4ZXytSHGWKtFNbGChb1g4B5Yb8E2fmJyzgdOXp3dxtZhjeb8PE/0nBchdWqpkKmCg5owNebkFimRu9O+N7iQFlIjYyCRnTmAojYlxCIBjIzL3qL89pLnlnCkmRp5U6+gRLMSkxtoYB8pk/rm2iltP89ILJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dE/dJYC3aPW9yZfe6HP1wK6+DaNaySK5ABiyfskTX0U=;
 b=AIVWx0eDcT+j8HDE/0cEswIygPCQNApiz4i2I1jYIPMWJBo3qFxpb5SY0vSZmgRlar4GRI4KoLTamKRMey47BldvHY3FxLrWY9EtX8krninoD3lFSZobY15WSd0EWyG4F7jEoDxcY6ubdQvIpMilzQ+AqGrAf/cf6PW7mpWLbKJ6ZMxWMnA0hJaynh1Otn+pY735oNR3VX49vHGXzO/Mq0ob6ZuRRqi8Kntjd6+AhNI96y1E4SqvWYoQe+RbFnXl0ZhY49ogplsWmbumdsPiUP1taLWfrq7TNE7y+LsjkFLJuPITmdFMOJYkvyKkd2RVVEVb10SfDYSnnr8Vwy656w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dE/dJYC3aPW9yZfe6HP1wK6+DaNaySK5ABiyfskTX0U=;
 b=q2oN6VgDMQ7oOSWfIq9IHLLDlVK0IUW45lF0SmkVcctk8kdy27m+zioxYo4/6Aiq85RtB9Yv1H5S/3l1uPs9XasIORtK9i6aDjnieuyfJpBrPJ0eY+RygDIRf9HVcroJpS9O1CicE6z8McJnHlA4Ncga37WarPt5cjz60YCTM+4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sat, 21 Aug
 2021 23:05:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 23:05:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] docs: net: dsa: sja1105: update list of limitations
Date:   Sun, 22 Aug 2021 02:04:39 +0300
Message-Id: <20210821230441.1371168-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
References: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0501CA0047.eurprd05.prod.outlook.com (2603:10a6:200:68::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 23:05:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ed6efa-a294-4e51-9393-08d964f830f2
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-Microsoft-Antispam-PRVS: <VI1PR04MB513344BF085DEBEEA9AD8FAAE0C29@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ew9X9iGrrzZ3z0vp/pOiLqtSmp0iEg0gALWxQU3wIXDoRNjgopqTNr8YI+Sjv74X3ZqlvnPsPezP/vxqHgZLnnRPqRV/UtHqsb2S7Bl/iTr3y/Gj7K5ewdGdptllsDterg7kpNMy5cnSkWrqcdmoSNnqJoRhLbaKgE8XbWgJI+kmVwSq25dGIMqXQ1eOMUxpM5/3FhVLP0iHtcztjLbnm+V9/ZrSc7FheiQjZHseLPz4Li8JUmMEoJn4teMBz6duHttgwfziav2vjZ/C+H48U4kjYDx/ygL4V2BDRkvFNSgqsO0oCNc10ITpdoDTtyTMAoA03V8vlGVBn4Sa7WhG1P+PdAs9CeREQGQoS8L+RgBCQ6bExbRXxGCE6+gUb59rPNqEWIWg9Lvh6di+wtipVqq3vu5FOxjJ0L2Vh3CcKOcfCIDNfjy+LpTXwJtXZzxdmqicb0VzRVqMN1qieSvRDGj16k6n3aTyfcUIE07O2uPEljImsGstf+Ogu/r9jO3HXdmGUBXxCEAC+Z+qjbAt/03+xqMM6p1btDHFSx2mszXQZhVVQ/RveMfGFqOhvotT5/dgsQUR/gD2yK5hkfaxFuRbPcp61Yp4ynYLvxQv5a4Z5acuferjti/J3MaFWj5smFTblgz9YjynzEXZdTVubKGAD32dSOUe5tyqDF30GzDX2wsJGpcfMOJ6z4C7zM8C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39850400004)(346002)(396003)(66556008)(66476007)(86362001)(66946007)(2616005)(956004)(44832011)(38100700002)(38350700002)(316002)(6486002)(1076003)(6512007)(478600001)(83380400001)(36756003)(6506007)(52116002)(6916009)(26005)(186003)(8676002)(30864003)(8936002)(2906002)(5660300002)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wfC1oryNrvlO34UZDEY8T7pMSMVm8Nid2Ktg8qGy8fd3eStrSvGq1xYHfomi?=
 =?us-ascii?Q?YzJKM7zF4tMyov1kUY/peUB2OJM+7/sZIzAo+d7aYhC1ibeTpij3bhBBXwuk?=
 =?us-ascii?Q?QW031m80+0lF7VjIGXBfCk/RwDIxcBg2RPHVfxarqXlrgx/nK2Hxtze56uVq?=
 =?us-ascii?Q?6ezMWdIjfuVWfD+KtJDHhe96H/bOpC+5PMbT8/HOcD5ucGSOOAYcj2CdFLTK?=
 =?us-ascii?Q?IGhqli+ybpVBj/qQqw1CvBxAf6QcrbSWZ2xxcFfRrF4HCOt9N0qWbWeLQY0g?=
 =?us-ascii?Q?Yaw+eXgcGWUajK/HwQI+CjSCZcnNZqeWESypCkvL30D74lfalj9K5bHyqmMs?=
 =?us-ascii?Q?++RZZ6m9OOazdr+076kC0jS3jnJhN5s9l4X1dQfD+NTK/tDosaQ684myOYgY?=
 =?us-ascii?Q?OEX0L6xmwkH8zYx6fy8efqBKiaaegCOUoUmQNTfrmbeS8G++B8UsK2u0EmsK?=
 =?us-ascii?Q?+5KL3eqeiNlo1G75QcNqNMBDdSN9b8yIu+GoJF6LC7jj8CLD0OOGnJsrxR5D?=
 =?us-ascii?Q?cXoL3UNUPLrJtKtu0O7t5H2tWqG+SlBBrPxJQR88jdVHyidmyOhBeIItTnSC?=
 =?us-ascii?Q?l3D9TICbcKyZ9rXOFy9muAd6HcWBusEx+DBZuOWzWB3HzdNp0T7iO7tj5yFl?=
 =?us-ascii?Q?PkMNKyb1Rj4iJnHWwUCcGJVjT13kBwbiQTbIZEBQJpyOOdHTyR5w+wPOSj4I?=
 =?us-ascii?Q?XS2B4z/vMcUqweHB3W+fAjQxCprpaM593hHKePQCK9i/O7wtq8OoSorP10A2?=
 =?us-ascii?Q?KKcyo/Iql8mDCaD1GniPsoYoV/IfBBkNR7xs5LLwiBrDXcQogvOSTQx6YAlg?=
 =?us-ascii?Q?pkM5uAyXnj6/sGWcso3s8Ds8tweZou8tPliIj7E9c1lEr5a2S2O0IWopHZ/v?=
 =?us-ascii?Q?XOxZFu0D18KyozZvfJN7cDdut12DjjriupsCG7ilY2STK37WXbVb02SKrCoW?=
 =?us-ascii?Q?GwJLytBjdpgCEtIaIncGed/vZx1GcNxrYRCNHnBJhciSagCbR0Y10QUBoS7K?=
 =?us-ascii?Q?crxJIToIiRT1RgjFtWNQoaoeBFcNxfNk2gY0o3gm1rVnD1vygOIPJHIPUVZl?=
 =?us-ascii?Q?nG8eE1uwx/iBxblRaZiSc1UCoPI+nLj6DHoYg6pcVds8QlK4uYLpRJcC3Qy6?=
 =?us-ascii?Q?eh8WlaSMlVl/SuTxQzv8T8wZOhZr9TSEQMhfRwZSx0TDY+TwNXXv0LfSHAPZ?=
 =?us-ascii?Q?g1+IzBFEdxWhVW9QQc49DmwWzq/tX4/N1nNUYqQ+P3sp9j1W9nQWqElFB94V?=
 =?us-ascii?Q?Q31qMAXHTGFBiJDcCoUhsc9xh4Rjga/R/jlouk499qctQPa8njOhI2zPojNl?=
 =?us-ascii?Q?4aIFFcCUoB2r2OVcp78rmwgG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ed6efa-a294-4e51-9393-08d964f830f2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 23:05:38.6556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGnnoSA0ZJZH3q6jGZXFJDORnVERst8wtZbTfO+59RHL9RuZfvhTyIp762dHojN+Rv4Gw13A4/4RwhWYHnmYfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the paragraphs that talk about the various modes of traffic
support, bridging with foreign interfaces, etc etc. There is nothing
that the user needs to know now, it should all work out of the box as
expected.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/sja1105.rst | 218 +----------------------
 1 file changed, 1 insertion(+), 217 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index da4057ba37f1..564caeebe2b2 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -65,199 +65,6 @@ If that changed setting can be transmitted to the switch through the dynamic
 reconfiguration interface, it is; otherwise the switch is reset and
 reprogrammed with the updated static configuration.
 
-Traffic support
-===============
-
-The switches do not have hardware support for DSA tags, except for "slow
-protocols" for switch control as STP and PTP. For these, the switches have two
-programmable filters for link-local destination MACs.
-These are used to trap BPDUs and PTP traffic to the master netdevice, and are
-further used to support STP and 1588 ordinary clock/boundary clock
-functionality. For frames trapped to the CPU, source port and switch ID
-information is encoded by the hardware into the frames.
-
-But by leveraging ``CONFIG_NET_DSA_TAG_8021Q`` (a software-defined DSA tagging
-format based on VLANs), general-purpose traffic termination through the network
-stack can be supported under certain circumstances.
-
-Depending on VLAN awareness state, the following operating modes are possible
-with the switch:
-
-- Mode 1 (VLAN-unaware): a port is in this mode when it is used as a standalone
-  net device, or when it is enslaved to a bridge with ``vlan_filtering=0``.
-- Mode 2 (fully VLAN-aware): a port is in this mode when it is enslaved to a
-  bridge with ``vlan_filtering=1``. Access to the entire VLAN range is given to
-  the user through ``bridge vlan`` commands, but general-purpose (anything
-  other than STP, PTP etc) traffic termination is not possible through the
-  switch net devices. The other packets can be still by user space processed
-  through the DSA master interface (similar to ``DSA_TAG_PROTO_NONE``).
-- Mode 3 (best-effort VLAN-aware): a port is in this mode when enslaved to a
-  bridge with ``vlan_filtering=1``, and the devlink property of its parent
-  switch named ``best_effort_vlan_filtering`` is set to ``true``. When
-  configured like this, the range of usable VIDs is reduced (0 to 1023 and 3072
-  to 4094), so is the number of usable VIDs (maximum of 7 non-pvid VLANs per
-  port*), and shared VLAN learning is performed (FDB lookup is done only by
-  DMAC, not also by VID).
-
-To summarize, in each mode, the following types of traffic are supported over
-the switch net devices:
-
-+-------------+-----------+--------------+------------+
-|             |   Mode 1  |    Mode 2    |   Mode 3   |
-+=============+===========+==============+============+
-|   Regular   |    Yes    | No           |     Yes    |
-|   traffic   |           | (use master) |            |
-+-------------+-----------+--------------+------------+
-| Management  |    Yes    |     Yes      |     Yes    |
-| traffic     |           |              |            |
-| (BPDU, PTP) |           |              |            |
-+-------------+-----------+--------------+------------+
-
-To configure the switch to operate in Mode 3, the following steps can be
-followed::
-
-  ip link add dev br0 type bridge
-  # swp2 operates in Mode 1 now
-  ip link set dev swp2 master br0
-  # swp2 temporarily moves to Mode 2
-  ip link set dev br0 type bridge vlan_filtering 1
-  [   61.204770] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
-  [   61.239944] sja1105 spi0.1: Disabled switch tagging
-  # swp3 now operates in Mode 3
-  devlink dev param set spi/spi0.1 name best_effort_vlan_filtering value true cmode runtime
-  [   64.682927] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
-  [   64.711925] sja1105 spi0.1: Enabled switch tagging
-  # Cannot use VLANs in range 1024-3071 while in Mode 3.
-  bridge vlan add dev swp2 vid 1025 untagged pvid
-  RTNETLINK answers: Operation not permitted
-  bridge vlan add dev swp2 vid 100
-  bridge vlan add dev swp2 vid 101 untagged
-  bridge vlan
-  port    vlan ids
-  swp5     1 PVID Egress Untagged
-
-  swp2     1 PVID Egress Untagged
-           100
-           101 Egress Untagged
-
-  swp3     1 PVID Egress Untagged
-
-  swp4     1 PVID Egress Untagged
-
-  br0      1 PVID Egress Untagged
-  bridge vlan add dev swp2 vid 102
-  bridge vlan add dev swp2 vid 103
-  bridge vlan add dev swp2 vid 104
-  bridge vlan add dev swp2 vid 105
-  bridge vlan add dev swp2 vid 106
-  bridge vlan add dev swp2 vid 107
-  # Cannot use mode than 7 VLANs per port while in Mode 3.
-  [ 3885.216832] sja1105 spi0.1: No more free subvlans
-
-\* "maximum of 7 non-pvid VLANs per port": Decoding VLAN-tagged packets on the
-CPU in mode 3 is possible through VLAN retagging of packets that go from the
-switch to the CPU. In cross-chip topologies, the port that goes to the CPU
-might also go to other switches. In that case, those other switches will see
-only a retagged packet (which only has meaning for the CPU). So if they are
-interested in this VLAN, they need to apply retagging in the reverse direction,
-to recover the original value from it. This consumes extra hardware resources
-for this switch. There is a maximum of 32 entries in the Retagging Table of
-each switch device.
-
-As an example, consider this cross-chip topology::
-
-  +-------------------------------------------------+
-  | Host SoC                                        |
-  |           +-------------------------+           |
-  |           | DSA master for embedded |           |
-  |           |   switch (non-sja1105)  |           |
-  |  +--------+-------------------------+--------+  |
-  |  |   embedded L2 switch                      |  |
-  |  |                                           |  |
-  |  |   +--------------+     +--------------+   |  |
-  |  |   |DSA master for|     |DSA master for|   |  |
-  |  |   |  SJA1105 1   |     |  SJA1105 2   |   |  |
-  +--+---+--------------+-----+--------------+---+--+
-
-  +-----------------------+ +-----------------------+
-  |   SJA1105 switch 1    | |   SJA1105 switch 2    |
-  +-----+-----+-----+-----+ +-----+-----+-----+-----+
-  |sw1p0|sw1p1|sw1p2|sw1p3| |sw2p0|sw2p1|sw2p2|sw2p3|
-  +-----+-----+-----+-----+ +-----+-----+-----+-----+
-
-To reach the CPU, SJA1105 switch 1 (spi/spi2.1) uses the same port as is uses
-to reach SJA1105 switch 2 (spi/spi2.2), which would be port 4 (not drawn).
-Similarly for SJA1105 switch 2.
-
-Also consider the following commands, that add VLAN 100 to every sja1105 user
-port::
-
-  devlink dev param set spi/spi2.1 name best_effort_vlan_filtering value true cmode runtime
-  devlink dev param set spi/spi2.2 name best_effort_vlan_filtering value true cmode runtime
-  ip link add dev br0 type bridge
-  for port in sw1p0 sw1p1 sw1p2 sw1p3 \
-              sw2p0 sw2p1 sw2p2 sw2p3; do
-      ip link set dev $port master br0
-  done
-  ip link set dev br0 type bridge vlan_filtering 1
-  for port in sw1p0 sw1p1 sw1p2 sw1p3 \
-              sw2p0 sw2p1 sw2p2; do
-      bridge vlan add dev $port vid 100
-  done
-  ip link add link br0 name br0.100 type vlan id 100 && ip link set dev br0.100 up
-  ip addr add 192.168.100.3/24 dev br0.100
-  bridge vlan add dev br0 vid 100 self
-
-  bridge vlan
-  port    vlan ids
-  sw1p0    1 PVID Egress Untagged
-           100
-
-  sw1p1    1 PVID Egress Untagged
-           100
-
-  sw1p2    1 PVID Egress Untagged
-           100
-
-  sw1p3    1 PVID Egress Untagged
-           100
-
-  sw2p0    1 PVID Egress Untagged
-           100
-
-  sw2p1    1 PVID Egress Untagged
-           100
-
-  sw2p2    1 PVID Egress Untagged
-           100
-
-  sw2p3    1 PVID Egress Untagged
-
-  br0      1 PVID Egress Untagged
-           100
-
-SJA1105 switch 1 consumes 1 retagging entry for each VLAN on each user port
-towards the CPU. It also consumes 1 retagging entry for each non-pvid VLAN that
-it is also interested in, which is configured on any port of any neighbor
-switch.
-
-In this case, SJA1105 switch 1 consumes a total of 11 retagging entries, as
-follows:
-
-- 8 retagging entries for VLANs 1 and 100 installed on its user ports
-  (``sw1p0`` - ``sw1p3``)
-- 3 retagging entries for VLAN 100 installed on the user ports of SJA1105
-  switch 2 (``sw2p0`` - ``sw2p2``), because it also has ports that are
-  interested in it. The VLAN 1 is a pvid on SJA1105 switch 2 and does not need
-  reverse retagging.
-
-SJA1105 switch 2 also consumes 11 retagging entries, but organized as follows:
-
-- 7 retagging entries for the bridge VLANs on its user ports (``sw2p0`` -
-  ``sw2p3``).
-- 4 retagging entries for VLAN 100 installed on the user ports of SJA1105
-  switch 1 (``sw1p0`` - ``sw1p3``).
-
 Switching features
 ==================
 
@@ -282,33 +89,10 @@ untagged), and therefore this mode is also supported.
 
 Segregating the switch ports in multiple bridges is supported (e.g. 2 + 2), but
 all bridges should have the same level of VLAN awareness (either both have
-``vlan_filtering`` 0, or both 1). Also an inevitable limitation of the fact
-that VLAN awareness is global at the switch level is that once a bridge with
-``vlan_filtering`` enslaves at least one switch port, the other un-bridged
-ports are no longer available for standalone traffic termination.
+``vlan_filtering`` 0, or both 1).
 
 Topology and loop detection through STP is supported.
 
-L2 FDB manipulation (add/delete/dump) is currently possible for the first
-generation devices. Aging time of FDB entries, as well as enabling fully static
-management (no address learning and no flooding of unknown traffic) is not yet
-configurable in the driver.
-
-A special comment about bridging with other netdevices (illustrated with an
-example):
-
-A board has eth0, eth1, swp0@eth1, swp1@eth1, swp2@eth1, swp3@eth1.
-The switch ports (swp0-3) are under br0.
-It is desired that eth0 is turned into another switched port that communicates
-with swp0-3.
-
-If br0 has vlan_filtering 0, then eth0 can simply be added to br0 with the
-intended results.
-If br0 has vlan_filtering 1, then a new br1 interface needs to be created that
-enslaves eth0 and eth1 (the DSA master of the switch ports). This is because in
-this mode, the switch ports beneath br0 are not capable of regular traffic, and
-are only used as a conduit for switchdev operations.
-
 Offloads
 ========
 
-- 
2.25.1

