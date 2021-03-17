Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9341C33F75C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhCQRpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:45:33 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:14215
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232500AbhCQRpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:45:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ex4Wxtyp+OcXUbwt7PqpGNUJQ24g6a2BzTM1j2rwcTIuiP8Nlq1tljOmyyA/QMUPfHZql6ab0vPSx/90cUhJwQxRU7OFqjqmZZWwBWliBObeuXnTEWKq1E9mjo8AeKVxg8u3Me3Chj73ndsXPiRglPDlt0VXvWMku7WdllY0V6rP+MEItDa0FwXW3LGeH6nSvZevaLq1qSnWuVR1wjShUTa/YhpYcFr4ek5mMR6hjnax8/GvZ4RDwVoVTUK14cF/D5IRO2rqAzq/fGGe8LSSn9UAyD7Zbc5Iz6GjZrTPdC2BxczdLVPnz3mzUCY8z9Ql3P6lKlnpw2P/omXDvBlIWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFzEBTYQsE7S502RvNd6GosGpUrBxYesqbsoSjIS6rc=;
 b=AfViGk5tedZqg1SyROABdTeUJkvxQVhz0Sd0339PPcG3dmE9bBivxJr+bvn/Ovz9ZaW7vTgI6/E7Kf5soZjyNqFgDKMo7a80rgfECQoUyxn/yr9AFXW9udfUvw74pcqwJkDgOsROM9460AoOL1JSxh1YxwNpI9hox+EEjcCP1HdAQd+a8eAP0xLW5Mesjh7KmzSBf4lCj3woN4aIyr8RKoh8VR2n4zKIJ6DEBk4NTfQ9Oq/kRGsKPcFH4tkprL8NAKDnt3gyhgk/7jh9DY1pIk1BSBMg2f+HpsSZAG1FEM922gyJRqMjeW1jSb91NeURYGlcelps+ZBOunDu4RuP/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFzEBTYQsE7S502RvNd6GosGpUrBxYesqbsoSjIS6rc=;
 b=bS4F/CU3kW4vc/5gLWWO0KiIWcEV1cUpFBy31KaPybWro2egTMlOg40csYRMK1iN2slXcyjDskcZg68/rE60V4eqA3n238us3cdBSdLJncD3wcfPCwRlQezMqlPd87OAQTJpnt151INQhLX+VT6JrVox2RQM+suLg+Z1Qt3wS9s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 17:45:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:45:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 4/5] Documentation: networking: dsa: demote subsections to simple emphasized words
Date:   Wed, 17 Mar 2021 19:44:57 +0200
Message-Id: <20210317174458.2349642-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
References: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.16.165]
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.16.165) by AM0PR06CA0106.eurprd06.prod.outlook.com (2603:10a6:208:fa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 17:45:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9798461-4bdc-41a5-97bf-08d8e96c6c74
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7119639973E9B07D5B2A2983E06A9@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYFom8QJn7ezFC9YHNibkeErStY0BO4wiOfo+mpRyNIsgTRKmBOFua+T2jvtPtbeF+o+DN/eaq40pq9xxSNOX24juME5AVdDlc3XT70xNOUiCsoUyOiOKMWNQ9bvUnQQeeH8uSbFHT7SPqFKBu86n+iMgr2Emk64jm/x5rN4uKTYxhXUPyCHLfv/q8Yny4xjm7eiweahKSzLB5+fG8ku+xV+LDpwxdMRiy01Ekh3SI5LdR72+06M9wB6aepscu+e9wz0BCsZwk9eikwoD/jeN8hTYPYlj8/dKIK7BYyylXsBN2GJ6+fK/n/7Cp6RMTyhM2i6STBZUfKLEirG9c89YOLLlerWvxCP6w4Wad2R5iu2updeBAVjiIK0mxudcnEnQggugfpVjX6xcRIIDKQwRUm7AdfWX5jWWrpZoQnisxwpuV4hR3jSUx+UPx+SY98m56+RjqGGJ4Bhci+xbXT3u+ni2mztdoU/FDR5eZdGsFQjZrzkxhy0T+Su5ZMLt9qlY0GCh2n2mJ+RU0on4MoSwx3MtknlJGv2YMkm11iXqBK1YFtOSSz4AaJuz6GnthqYCpmeX6qHy9NEAD4pDwDVniT4oA2x8UWLLoX88HKU3zSlt/G07yWqFSOcgEhJQtuO1hfLAMhHkcUZpmckGV8+D5jffCTSbzBHnbCnalQFn4lFJC6sRVXgOXEyid7HqrTE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(86362001)(110136005)(83380400001)(69590400012)(6506007)(36756003)(52116002)(6666004)(1076003)(186003)(16526019)(54906003)(66946007)(66556008)(2906002)(26005)(5660300002)(6512007)(2616005)(966005)(8676002)(956004)(4326008)(316002)(44832011)(66476007)(6486002)(478600001)(8936002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dqCFKVsKiokRvx2767Vnl0QFZVEEPlpqVIMz/Hy0pT2ErUGELvsnsllUdCgb?=
 =?us-ascii?Q?VOYB3JRyi1IzIAUWoiz3yKQHyTSSOIdUQClX4+FHebJYE3EBr1xEq8JPcEZ/?=
 =?us-ascii?Q?kQzcLK3DYKTw1qfv38uyy0IS6ew9+EWngl3dtPoC4K/2Y5FW72tjxqeTuV6i?=
 =?us-ascii?Q?9eMWxelRxeK1W6lZY0sjiCcULngZ9coJ9fsMKUdItiU+E/ajrKF17OPKDJqX?=
 =?us-ascii?Q?xub1Y+hEQZlf8GrUHD0azvJVaor+h1CXyBPRUafNJMW5Pwa8nVWj455ydHsS?=
 =?us-ascii?Q?Tkcsly62jyxv4TklhQ4hk4IML5b79S6sfeNUZLKXcUAFGsNqJ2JKfdbuRCE7?=
 =?us-ascii?Q?+LtWXDnYe+Xj/yuPYIxTZStY4DQK9ZPWbKlPs0wUVPxuIpv+SaU/h0eScwIo?=
 =?us-ascii?Q?jj7i3cecl1aIUuJfsKt0bJ4aFqVTpZsKG9F5yeCh+LuXPRe0PXmIUaIrrVLc?=
 =?us-ascii?Q?kNMyh5yx18XupRHNJZVxlNGwyuOy4GF3lSHa81mGkACO/w6B1hoYZ/fUHiN6?=
 =?us-ascii?Q?485l5iHspkCxQRlfDk4sR7fc/u+vRV1rHlPib3IjfumQcHyAp+zfSUBKK7+e?=
 =?us-ascii?Q?PlgdbJ+Lk4RwHguujQOYjzAs9vRResA7Uap5fTIB6Gw74pvvy34syPFjIIuk?=
 =?us-ascii?Q?Utikwun6k/S4GpJ0I+5gEQ+16iLAGccrobgGMJesYzFH169vFYLYMjuZTJw5?=
 =?us-ascii?Q?tpkc9fk9fg5n7SiNzbxN+0NQUe5+YQWe1/9G+EkWhaL3XDy4jzMUPlJIhkka?=
 =?us-ascii?Q?sM+cg9qKivmeZOVxMc+/5ao3Iz6keYJgjwNY7wW9lhv1zEcSp3pgB9A3fXW8?=
 =?us-ascii?Q?lVpGo0xn3FULGqKvo+Qw/YqZUcZ3am+wJMvmL+2KsFF85Mq/QE9iyVBTs/M6?=
 =?us-ascii?Q?JObuZ6NmZceiuZeDGKVKm+g312GiDryqw2HD9YFSYvwUib3gx3B0OCuvdAX4?=
 =?us-ascii?Q?Yv9QCg2Li9uXB5+nZFoF/QBy0eKH6Bc4E1W4VH/JXuNY5dTQkTx9DYcnqqSO?=
 =?us-ascii?Q?xO+o7s94d1jFa9R1+jcERghGL7R8UKT5ozA2QJ5jG+qVbPbgmEsljGbBTGpO?=
 =?us-ascii?Q?YA5/m/p0vnj8+g+jQO/njkbAAynJxZ4COyP1fQ5cDauOmLChDL63kfkJCt41?=
 =?us-ascii?Q?0PzJXiva1/YvT30rN000LBYsYGIIIuz+OBUAcVqkBiTauGX7b0vLiGWjXjyt?=
 =?us-ascii?Q?lRfJMDUoxicDTGGrBGgzI+j7FQksS/boRSxR2OqyBFxJxqeEZBOsM+5vxmZL?=
 =?us-ascii?Q?oYtGsBnEi6OHyPUQeO4GKHzTZNDuARPY/Xqq14D2J7nm91MfoNof1BACyLXO?=
 =?us-ascii?Q?FGwofEMd23QObD+VwLJNjxNI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9798461-4bdc-41a5-97bf-08d8e96c6c74
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 17:45:16.0154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YHR1DeaFwlJfGfgWp2LwYgIacbQUbAcmaLhKtUpxyra1/H5jeot+QzjynV75tJHWJB/g74oVfLmBd0PVr7FQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"make htmldocs" complains:
configuration.rst:165: WARNING: duplicate label networking/dsa/configuration:single port, other instance in (...)
configuration.rst:212: WARNING: duplicate label networking/dsa/configuration:bridge, other instance in (...)
configuration.rst:252: WARNING: duplicate label networking/dsa/configuration:gateway, other instance in (...)

And for good reason, because the "single port", "bridge" and "gateway"
use cases are replicated twice, once for normal taggers and twice for
DSA_TAG_PROTO_NONE. So when trying to reference these sections via a
hyperlink such as:

https://www.kernel.org/doc/html/latest/networking/dsa/configuration.html#single-port

it will always reference the first occurrence, and never the second one.

This change makes the "single port", "bridge" and "gateway"
configuration examples consistent with the formatting used in the
"Configuration showcases" subsection.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../networking/dsa/configuration.rst          | 295 +++++++++---------
 1 file changed, 142 insertions(+), 153 deletions(-)

diff --git a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
index 11bd5e6108c0..d20b908bd861 100644
--- a/Documentation/networking/dsa/configuration.rst
+++ b/Documentation/networking/dsa/configuration.rst
@@ -78,79 +78,73 @@ The tagging based configuration is desired and supported by the majority of
 DSA switches. These switches are capable to tag incoming and outgoing traffic
 without using a VLAN based configuration.
 
-single port
-~~~~~~~~~~~
-
-.. code-block:: sh
-
-  # configure each interface
-  ip addr add 192.0.2.1/30 dev lan1
-  ip addr add 192.0.2.5/30 dev lan2
-  ip addr add 192.0.2.9/30 dev lan3
-
-  # The master interface needs to be brought up before the slave ports.
-  ip link set eth0 up
+*single port*
+  .. code-block:: sh
 
-  # bring up the slave interfaces
-  ip link set lan1 up
-  ip link set lan2 up
-  ip link set lan3 up
+    # configure each interface
+    ip addr add 192.0.2.1/30 dev lan1
+    ip addr add 192.0.2.5/30 dev lan2
+    ip addr add 192.0.2.9/30 dev lan3
 
-bridge
-~~~~~~
+    # The master interface needs to be brought up before the slave ports.
+    ip link set eth0 up
 
-.. code-block:: sh
+    # bring up the slave interfaces
+    ip link set lan1 up
+    ip link set lan2 up
+    ip link set lan3 up
 
-  # The master interface needs to be brought up before the slave ports.
-  ip link set eth0 up
+*bridge*
+  .. code-block:: sh
 
-  # bring up the slave interfaces
-  ip link set lan1 up
-  ip link set lan2 up
-  ip link set lan3 up
+    # The master interface needs to be brought up before the slave ports.
+    ip link set eth0 up
 
-  # create bridge
-  ip link add name br0 type bridge
+    # bring up the slave interfaces
+    ip link set lan1 up
+    ip link set lan2 up
+    ip link set lan3 up
 
-  # add ports to bridge
-  ip link set dev lan1 master br0
-  ip link set dev lan2 master br0
-  ip link set dev lan3 master br0
+    # create bridge
+    ip link add name br0 type bridge
 
-  # configure the bridge
-  ip addr add 192.0.2.129/25 dev br0
+    # add ports to bridge
+    ip link set dev lan1 master br0
+    ip link set dev lan2 master br0
+    ip link set dev lan3 master br0
 
-  # bring up the bridge
-  ip link set dev br0 up
+    # configure the bridge
+    ip addr add 192.0.2.129/25 dev br0
 
-gateway
-~~~~~~~
+    # bring up the bridge
+    ip link set dev br0 up
 
-.. code-block:: sh
+*gateway*
+  .. code-block:: sh
 
-  # The master interface needs to be brought up before the slave ports.
-  ip link set eth0 up
+    # The master interface needs to be brought up before the slave ports.
+    ip link set eth0 up
 
-  # bring up the slave interfaces
-  ip link set wan up
-  ip link set lan1 up
-  ip link set lan2 up
+    # bring up the slave interfaces
+    ip link set wan up
+    ip link set lan1 up
+    ip link set lan2 up
 
-  # configure the upstream port
-  ip addr add 192.0.2.1/30 dev wan
+    # configure the upstream port
+    ip addr add 192.0.2.1/30 dev wan
 
-  # create bridge
-  ip link add name br0 type bridge
+    # create bridge
+    ip link add name br0 type bridge
 
-  # add ports to bridge
-  ip link set dev lan1 master br0
-  ip link set dev lan2 master br0
+    # add ports to bridge
+    ip link set dev lan1 master br0
+    ip link set dev lan2 master br0
 
-  # configure the bridge
-  ip addr add 192.0.2.129/25 dev br0
+    # configure the bridge
+    ip addr add 192.0.2.129/25 dev br0
 
-  # bring up the bridge
-  ip link set dev br0 up
+    # bring up the bridge
+    ip link set dev br0 up
 
 .. _dsa-vlan-configuration:
 
@@ -161,132 +155,127 @@ A minority of switches are not capable to use a taging protocol
 (DSA_TAG_PROTO_NONE). These switches can be configured by a VLAN based
 configuration.
 
-single port
-~~~~~~~~~~~
-The configuration can only be set up via VLAN tagging and bridge setup.
-
-.. code-block:: sh
-
-  # tag traffic on CPU port
-  ip link add link eth0 name eth0.1 type vlan id 1
-  ip link add link eth0 name eth0.2 type vlan id 2
-  ip link add link eth0 name eth0.3 type vlan id 3
+*single port*
+  The configuration can only be set up via VLAN tagging and bridge setup.
 
-  # The master interface needs to be brought up before the slave ports.
-  ip link set eth0 up
-  ip link set eth0.1 up
-  ip link set eth0.2 up
-  ip link set eth0.3 up
+  .. code-block:: sh
 
-  # bring up the slave interfaces
-  ip link set lan1 up
-  ip link set lan2 up
-  ip link set lan3 up
+    # tag traffic on CPU port
+    ip link add link eth0 name eth0.1 type vlan id 1
+    ip link add link eth0 name eth0.2 type vlan id 2
+    ip link add link eth0 name eth0.3 type vlan id 3
 
-  # create bridge
-  ip link add name br0 type bridge
+    # The master interface needs to be brought up before the slave ports.
+    ip link set eth0 up
+    ip link set eth0.1 up
+    ip link set eth0.2 up
+    ip link set eth0.3 up
 
-  # activate VLAN filtering
-  ip link set dev br0 type bridge vlan_filtering 1
+    # bring up the slave interfaces
+    ip link set lan1 up
+    ip link set lan2 up
+    ip link set lan3 up
 
-  # add ports to bridges
-  ip link set dev lan1 master br0
-  ip link set dev lan2 master br0
-  ip link set dev lan3 master br0
+    # create bridge
+    ip link add name br0 type bridge
 
-  # tag traffic on ports
-  bridge vlan add dev lan1 vid 1 pvid untagged
-  bridge vlan add dev lan2 vid 2 pvid untagged
-  bridge vlan add dev lan3 vid 3 pvid untagged
+    # activate VLAN filtering
+    ip link set dev br0 type bridge vlan_filtering 1
 
-  # configure the VLANs
-  ip addr add 192.0.2.1/30 dev eth0.1
-  ip addr add 192.0.2.5/30 dev eth0.2
-  ip addr add 192.0.2.9/30 dev eth0.3
+    # add ports to bridges
+    ip link set dev lan1 master br0
+    ip link set dev lan2 master br0
+    ip link set dev lan3 master br0
 
-  # bring up the bridge devices
-  ip link set br0 up
+    # tag traffic on ports
+    bridge vlan add dev lan1 vid 1 pvid untagged
+    bridge vlan add dev lan2 vid 2 pvid untagged
+    bridge vlan add dev lan3 vid 3 pvid untagged
 
+    # configure the VLANs
+    ip addr add 192.0.2.1/30 dev eth0.1
+    ip addr add 192.0.2.5/30 dev eth0.2
+    ip addr add 192.0.2.9/30 dev eth0.3
 
-bridge
-~~~~~~
+    # bring up the bridge devices
+    ip link set br0 up
 
-.. code-block:: sh
 
-  # tag traffic on CPU port
-  ip link add link eth0 name eth0.1 type vlan id 1
+*bridge*
+  .. code-block:: sh
 
-  # The master interface needs to be brought up before the slave ports.
-  ip link set eth0 up
-  ip link set eth0.1 up
+    # tag traffic on CPU port
+    ip link add link eth0 name eth0.1 type vlan id 1
 
-  # bring up the slave interfaces
-  ip link set lan1 up
-  ip link set lan2 up
-  ip link set lan3 up
+    # The master interface needs to be brought up before the slave ports.
+    ip link set eth0 up
+    ip link set eth0.1 up
 
-  # create bridge
-  ip link add name br0 type bridge
+    # bring up the slave interfaces
+    ip link set lan1 up
+    ip link set lan2 up
+    ip link set lan3 up
 
-  # activate VLAN filtering
-  ip link set dev br0 type bridge vlan_filtering 1
+    # create bridge
+    ip link add name br0 type bridge
 
-  # add ports to bridge
-  ip link set dev lan1 master br0
-  ip link set dev lan2 master br0
-  ip link set dev lan3 master br0
-  ip link set eth0.1 master br0
+    # activate VLAN filtering
+    ip link set dev br0 type bridge vlan_filtering 1
 
-  # tag traffic on ports
-  bridge vlan add dev lan1 vid 1 pvid untagged
-  bridge vlan add dev lan2 vid 1 pvid untagged
-  bridge vlan add dev lan3 vid 1 pvid untagged
+    # add ports to bridge
+    ip link set dev lan1 master br0
+    ip link set dev lan2 master br0
+    ip link set dev lan3 master br0
+    ip link set eth0.1 master br0
 
-  # configure the bridge
-  ip addr add 192.0.2.129/25 dev br0
+    # tag traffic on ports
+    bridge vlan add dev lan1 vid 1 pvid untagged
+    bridge vlan add dev lan2 vid 1 pvid untagged
+    bridge vlan add dev lan3 vid 1 pvid untagged
 
-  # bring up the bridge
-  ip link set dev br0 up
+    # configure the bridge
+    ip addr add 192.0.2.129/25 dev br0
 
-gateway
-~~~~~~~
+    # bring up the bridge
+    ip link set dev br0 up
 
-.. code-block:: sh
+*gateway*
+  .. code-block:: sh
 
-  # tag traffic on CPU port
-  ip link add link eth0 name eth0.1 type vlan id 1
-  ip link add link eth0 name eth0.2 type vlan id 2
+    # tag traffic on CPU port
+    ip link add link eth0 name eth0.1 type vlan id 1
+    ip link add link eth0 name eth0.2 type vlan id 2
 
-  # The master interface needs to be brought up before the slave ports.
-  ip link set eth0 up
-  ip link set eth0.1 up
-  ip link set eth0.2 up
+    # The master interface needs to be brought up before the slave ports.
+    ip link set eth0 up
+    ip link set eth0.1 up
+    ip link set eth0.2 up
 
-  # bring up the slave interfaces
-  ip link set wan up
-  ip link set lan1 up
-  ip link set lan2 up
+    # bring up the slave interfaces
+    ip link set wan up
+    ip link set lan1 up
+    ip link set lan2 up
 
-  # create bridge
-  ip link add name br0 type bridge
+    # create bridge
+    ip link add name br0 type bridge
 
-  # activate VLAN filtering
-  ip link set dev br0 type bridge vlan_filtering 1
+    # activate VLAN filtering
+    ip link set dev br0 type bridge vlan_filtering 1
 
-  # add ports to bridges
-  ip link set dev wan master br0
-  ip link set eth0.1 master br0
-  ip link set dev lan1 master br0
-  ip link set dev lan2 master br0
+    # add ports to bridges
+    ip link set dev wan master br0
+    ip link set eth0.1 master br0
+    ip link set dev lan1 master br0
+    ip link set dev lan2 master br0
 
-  # tag traffic on ports
-  bridge vlan add dev lan1 vid 1 pvid untagged
-  bridge vlan add dev lan2 vid 1 pvid untagged
-  bridge vlan add dev wan vid 2 pvid untagged
+    # tag traffic on ports
+    bridge vlan add dev lan1 vid 1 pvid untagged
+    bridge vlan add dev lan2 vid 1 pvid untagged
+    bridge vlan add dev wan vid 2 pvid untagged
 
-  # configure the VLANs
-  ip addr add 192.0.2.1/30 dev eth0.2
-  ip addr add 192.0.2.129/25 dev br0
+    # configure the VLANs
+    ip addr add 192.0.2.1/30 dev eth0.2
+    ip addr add 192.0.2.129/25 dev br0
 
-  # bring up the bridge devices
-  ip link set br0 up
+    # bring up the bridge devices
+    ip link set br0 up
-- 
2.25.1

