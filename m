Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083A33A6756
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhFNND4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:56 -0400
Received: from mail-eopbgr80123.outbound.protection.outlook.com ([40.107.8.123]:50677
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233494AbhFNNDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax+9oGCVqIUdFV4QCA9yCoIkU1hlytqb7Fq1+Y7gKCFgu7yueDP8QSPTnYorAsQSHgSgg7zknjV39mJ7kiBXQeOPkPGimNIGH1MlmkDidCUhocyUHeFfG/00pbaOY08poDw8fZ8sqM+nYynnvXpJoSxjxBCBeS28aw0Ya9NhVcF7LOvUUy2q1OpnfzrgMslhWDrKqcByNNDI5P3yUF+Ho7kQEXAiUtBUi2RlxG4nejF6mZ9Wu8PsOdZ4DpfJmhTyGEFwM7mg86Fi0mDo03khbvQLGIHicRF0Rfj5gFZ76omc2zsX6Ikw1+riwQm2YWTplD2ypuUQv71NHBjf/tB1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qke/290SZ770AUQk2fJvnQPrvJ71m9oxWidNiF0Yx8=;
 b=iZMzfQx2CSrHx6qqWxmjrovGfloWWAeb8lzDDfJFx4VVqREkAtIyh68wIuXMeEIgO16KiDash3K+fp41PN2+EtczqE+gvoLIfqn2DNDbVIdNC87pOSNodx1fdX3Rxkqjl+m4Qlo+N1OYNuU/KSYkf3A+hVaF15lZUT+9Lsub1EzeO1GKpNw/zICBVnFCf+o1e4xsBiG1GQZtCYI5y1zhE/TrUfc6hKPLynpoVmXKrQlmKuQoM6V3YIYnRQUi+NzrOdJe3o+UFH3HrdbPKxPOD1ZbAaX2sRM2a6/uUirTWuDu4VUBoJdcaS+aAH5nqMIoZ0XZI+uJTNEUcNTrRthpnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qke/290SZ770AUQk2fJvnQPrvJ71m9oxWidNiF0Yx8=;
 b=frJKOJG6csBgPG0mOWwfoJvpO9dQOEveu2zs70Ldr4/2PjZOUAb0iHPQdeEil9teTb3ud0oXCdVHhd4rg2hc4ZPGjt+RkNf2AsH7mEu4u2iALBhX7qkRUMZRhWxZCMYAa7oWAC35pMHJTQDfdwkrjX8dko3KgiBRz87r4CiYlsw=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1026.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:264::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 13:01:44 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:44 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org, linux-doc@vger.kernel.org
Subject: [PATCH net-next v2 7/7] documentation: networking: devlink: add prestera switched driver Documentation
Date:   Mon, 14 Jun 2021 16:01:18 +0300
Message-Id: <20210614130118.20395-8-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fd980f2-17c5-41ed-a4d6-08d92f348f5b
X-MS-TrafficTypeDiagnostic: AM9P190MB1026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB10266CBBC99E09B60C7B9C5BE4319@AM9P190MB1026.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUNcnnQ0R8Ay/MvyoeRCsqgkFDZPs8s7SWBmWcC2lu2ix1oEpjOhT1jDCn1aONdQdhBwRj4N6PxMRr/FrwisGNf3eahugBv5qPcNOb6HWPVxXpjDnKMLuHbyK6KCDAlyPB5Nyynp29DDMcbCC6TTqFwzvC56HCncKhkzuENFedKFYOz5JmvvbOu+6OgfKbN80PKRJLYI46DspIPalx8NuHxGua5I7eAkDKzholwbtHPmvTxI/JJMhYAW0B4Mj9d8WOGMc4xvAdD9FsvoTe8JGpfdcaCHpL0ELMqMdWnUbnQN56CZuL/0+aqscju91gzk7gHGv1adCaCGt0IjGecqAHDCtFi6TAodg0JOn63sKg07m9QFBI3ATkhvgTfdHoO/st1F/9l2sLYaw0F3EiN1vu04pXbuTEqKTpNELmyXz6Abn1UBSGmXOM5f+zb3FzdKFz+ajR/DKg1hHGn11NWdCHH1ih7AHhuoGBwrBsZtiPMJVVxkA2RDTlC/+a8+eXk1EZv6G/L2dWNEFCRsxSa3tmkktUuNCzm80meyYjQ/pyFM/rQFgbbl51/pKYPITccxlBlXKXWv5x5jyMUrU45LKEQGj2BF2xl0RBvLfCKFp4zUJitopyixUCs1xthlhB8AVelXHbUyuzsfgbd8SOLqTKbAgH6VnGqfiSQ7ZMUMhfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(39830400003)(366004)(396003)(346002)(6506007)(66556008)(186003)(44832011)(4326008)(66476007)(8676002)(36756003)(8936002)(6666004)(1076003)(16526019)(2906002)(316002)(6916009)(66574015)(7416002)(956004)(38100700002)(66946007)(6512007)(38350700002)(52116002)(478600001)(6486002)(2616005)(5660300002)(83380400001)(26005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cyct/NSHscZYag6JTRzz+kRkynd4x/vppHHsbDPHZ4PNHnFcNg9j3DX7Klv5?=
 =?us-ascii?Q?T86OE6bsORrFr0jEuTlXsH+CaUUvqsaTn9iO4J7YB0qTfuv2xdq2iF7UARr9?=
 =?us-ascii?Q?p0lxicv8kNXcAe+mQZOqwZi4t277x7rGGAaa+Of1ef16c/ICCjz9TTzQOe+U?=
 =?us-ascii?Q?+hM5lgrottdbmxuc4hkTgQAa97FJbFw89WSvUjHuYukCrYYuR6KQ3fI2+cmR?=
 =?us-ascii?Q?6aJg12IPvOPv5yfJUsW5GZIWqZNkvA/8s5j1wD6an3F0Y/5pF8ELdSrRelLp?=
 =?us-ascii?Q?Votc6NQlAtMH1i8Z9ElPOuAhMX6mVTd/7HSs7emd1Ef9RfkV6U1yBRfhVP+q?=
 =?us-ascii?Q?5mj9YBEGjTvtLXWyhcR6gfdweWYgSoQCRqQUtHAV56dQ/vlM/iQwLd6fFU52?=
 =?us-ascii?Q?5mApLSrbSTqBDEz3K9kxJHpZc6ZwW2OHJsoBr7aIfo1HQqqHAFvyhmgtV/Px?=
 =?us-ascii?Q?3g3ytSs9MYPPFbsN/Uqh4BboMLTVqd06tQuy5aDfWTiw6DeVd1Chj2MOnTGg?=
 =?us-ascii?Q?37DEY+Rm/RTRordoJSMPXXmcqzq6pM0HZbZdOAIEuPwT8o8ee5IiUYSZKMJZ?=
 =?us-ascii?Q?9X/J8BPs1wUegJmLb7TCjJHB7Q0WhF3XgLJxX4X0B5PwletqqpEralupuKVQ?=
 =?us-ascii?Q?KOzexlAVb51dBjDei2rgRODrIMZA0nIv+HlBDQDY3CNleJh9bwyZGTtQ+/i6?=
 =?us-ascii?Q?lfvjLnjJgZP5wEu4cVQX957EKNc0MEljqdjow9DYO2tGaeMNO9sZ8+hRVhL4?=
 =?us-ascii?Q?QbZ6Kgu1WfJ3ojYMGfEOvCbptMWHeP5QH3diZqYQ+fYXH4EJYVt8YkgU5OMb?=
 =?us-ascii?Q?3HQ2oT+ykoAc9NrNiDn4wD8i3972eYq79ohPBxONBunRnDKqOcmR2/VAhQbT?=
 =?us-ascii?Q?2eGxqMWiztJThc02iajSHNmDVzOWobZDiZ9TScxd6NKc5xg7GyFpWu7m39jw?=
 =?us-ascii?Q?yVcOJS5bXXiG7l6QaDP0kR4DR92+UT2cM8G++Gjl6lRoZIxAXmuJVAle885I?=
 =?us-ascii?Q?Us2yxBa8qw4WV8f2Z88IkjzQCjrOuIbESX8wkcXxP2Vndk5YgVAVEQvL+gk8?=
 =?us-ascii?Q?9+P/SWD5/AFrEPLFklbyT3GAA6EsPovyzsBAiVlq59YkELpFPZBsqfnpr6l3?=
 =?us-ascii?Q?6nTziMqyfxW/gtDzC3fMr8PzaKuq/gawA6ugjY3LFrOlHVJfY1p/zS8KXlzU?=
 =?us-ascii?Q?dZc4D6DtjL9DaoDZ13JEBfyxQyor0l922Ff4czqpKxkXxlkfV77XrRIb4TDD?=
 =?us-ascii?Q?BWDN9UG7qvKpILk59KAN0zX5qhHumY/hV+xuo/XmaV+ZL5dBlnGilaeVygkf?=
 =?us-ascii?Q?O0xOBQivvqglBLRWxlJglPO2?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd980f2-17c5-41ed-a4d6-08d92f348f5b
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:44.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlczpvJ3BVvWvnJ0jkxD57KB1eFW7kUycrheMbHLrhg1xTXwhtq5BIhXM/rfdhxhPrUlhvZ2Q0e89KVWsLVM6GegSP0wOnG2nB8jcnQFGko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the devlink feature prestera switchdev driver supports:
add description for the support of the driver-specific devlink traps
(include both traps with action TRAP and action DROP);

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 Documentation/networking/devlink/prestera.rst | 141 ++++++++++++++++++
 1 file changed, 141 insertions(+)
 create mode 100644 Documentation/networking/devlink/prestera.rst

diff --git a/Documentation/networking/devlink/prestera.rst b/Documentation/networking/devlink/prestera.rst
new file mode 100644
index 000000000000..e8b52ffd4707
--- /dev/null
+++ b/Documentation/networking/devlink/prestera.rst
@@ -0,0 +1,141 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+prestera devlink support
+=====================
+
+This document describes the devlink features implemented by the ``prestera``
+device driver.
+
+Driver-specific Traps
+=====================
+
+.. list-table:: List of Driver-specific Traps Registered by ``prestera``
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+.. list-table:: List of Driver-specific Traps Registered by ``prestera``
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``arp_bc``
+     - ``trap``
+     - Traps ARP broadcast packets (both requests/responses)
+   * - ``is_is``
+     - ``trap``
+     - Traps IS-IS packets
+   * - ``ospf``
+     - ``trap``
+     - Traps OSPF packets
+   * - ``ip_bc_mac``
+     - ``trap``
+     - Traps IPv4 packets with broadcast DA Mac address
+   * - ``stp``
+     - ``trap``
+     - Traps STP BPDU
+   * - ``lacp``
+     - ``trap``
+     - Traps LACP packets
+   * - ``lldp``
+     - ``trap``
+     - Traps LLDP packets
+   * - ``router_mc``
+     - ``trap``
+     - Traps multicast packets
+   * - ``vrrp``
+     - ``trap``
+     - Traps VRRP packets
+   * - ``dhcp``
+     - ``trap``
+     - Traps DHCP packets
+   * - ``mtu_error``
+     - ``trap``
+     - Traps (exception) packets that exceeded port's MTU
+   * - ``mac_to_me``
+     - ``trap``
+     -  Traps packets with switch-port's DA Mac address
+   * - ``ttl_error``
+     - ``trap``
+     - Traps (exception) IPv4 packets whose TTL exceeded
+   * - ``ipv4_options``
+     - ``trap``
+     - Traps (exception) packets due to the malformed IPV4 header options
+   * - ``ip_default_route``
+     - ``trap``
+     - Traps packets that have no specific IP interface (IP to me) and no forwarding prefix
+   * - ``local_route``
+     - ``trap``
+     - Traps packets that have been send to one of switch IP interfaces addresses
+   * - ``ipv4_icmp_redirect``
+     - ``trap``
+     - Traps (exception) IPV4 ICMP redirect packets
+   * - ``arp_response``
+     - ``trap``
+     - Traps ARP replies packets that have switch-port's DA Mac address
+   * - ``acl_code_0``
+     - ``trap``
+     - Traps packets that have ACL priority set to 0 (tc pref 0)
+   * - ``acl_code_1``
+     - ``trap``
+     - Traps packets that have ACL priority set to 1 (tc pref 1)
+   * - ``acl_code_2``
+     - ``trap``
+     - Traps packets that have ACL priority set to 2 (tc pref 2)
+   * - ``acl_code_3``
+     - ``trap``
+     - Traps packets that have ACL priority set to 3 (tc pref 3)
+   * - ``acl_code_4``
+     - ``trap``
+     - Traps packets that have ACL priority set to 4 (tc pref 4)
+   * - ``acl_code_5``
+     - ``trap``
+     - Traps packets that have ACL priority set to 5 (tc pref 5)
+   * - ``acl_code_6``
+     - ``trap``
+     - Traps packets that have ACL priority set to 6 (tc pref 6)
+   * - ``acl_code_7``
+     - ``trap``
+     - Traps packets that have ACL priority set to 7 (tc pref 7)
+   * - ``ipv4_bgp``
+     - ``trap``
+     - Traps IPv4 BGP packets
+   * - ``ssh``
+     - ``trap``
+     - Traps SSH packets
+   * - ``telnet``
+     - ``trap``
+     - Traps Telnet packets
+   * - ``icmp``
+     - ``trap``
+     - Traps ICMP packets
+   * - ``rxdma_drop``
+     - ``drop``
+     - Drops packets (RxDMA) due to the lack of ingress buffers etc.
+   * - ``port_no_vlan``
+     - ``drop``
+     - Drops packets due to faulty-configured network or due to internal bug (config issue).
+   * - ``local_port``
+     - ``drop``
+     - Drops packets whose decision (FDB entry) is to bridge packet back to the incoming port/trunk.
+   * - ``invalid_sa``
+     - ``drop``
+     - Drops packets with multicast source MAC address.
+   * - ``illegal_ip_addr``
+     - ``drop``
+     - Drops packets with illegal SIP/DIP multicast/unicast addresses.
+   * - ``illegal_ipv4_hdr``
+     - ``drop``
+     - Drops packets with illegal IPV4 header.
+   * - ``ip_uc_dip_da_mismatch``
+     - ``drop``
+     - Drops packets with destination MAC being unicast, but destination IP address being multicast.
+   * - ``ip_sip_is_zero``
+     - ``drop``
+     - Drops packets with zero (0) IPV4 source address.
+   * - ``met_red``
+     - ``drop``
+     - Drops non-conforming packets (dropped by Ingress policer, metering drop), e.g. packet rate exceeded configured bandwith.
-- 
2.17.1

