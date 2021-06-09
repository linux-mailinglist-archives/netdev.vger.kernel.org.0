Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A783A1910
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhFIPTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:19:04 -0400
Received: from mail-eopbgr80090.outbound.protection.outlook.com ([40.107.8.90]:23438
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239228AbhFIPSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIKmE0ghTetTUDgQCsUL0VhXgOmGR0FGF+iIO0De+kg7DG9kFAUjAiti8tlQ7OtDGCeIg41X+o0cpnQZ3gTGtu9tt0RzIIZ8ZBwmeuEoq9g+rt8b+bXvoMZI/hc/XDIrw0RJl1UpdI3dLE61rNKTjgTCMJWxMg6TmxjiNov2uKTP20vhJpKyNIjsBTd6r3lDD5BOkA+VXCxxAvIlEGqoByunQ/0u6Nq5e88hp8AeWzH19nAT9GplGy83eHcvHhWlQ5JUh20eOOe1poJwldEY0VU7Rx9NQLUf/G8H6/wva00VWdJU/qK+jS7fQxq5RrHInmYXwa+VP6gXJwZbL5fL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEB4xA52d2+ZwzXblV37zF8N4CPjkyGKhYIScADcpqs=;
 b=PQKRoFPQMTlVlzMmJW/WZmv2i5jUJmaxZX0xo3d2DWaBeDynBJo88RbyJ0Rg2x2y/3FMZAP3oBockTHTqVmNyCFb+cxG87xF/ioHOyjyKgigIzvt/UY4pmCPecwvYfzdPoig7AF9ktoevY8V4Jw/h44sRxPQDLq07vQyM+Qer/qxx8ITW73oWLFLdUvT6pCIOmpTUqXlNFsVl4iwcYYDl927jrgouYTwsL3bKwAAkVjYIffP8YuvbbFa2txdRuQU/iLfKKhIcGjlHoi2QLOtA4gqIcHZCKeOysdp+jowQKDH35eF+Z+ZPjjpnWmZDrfV6jxI03CVOWtz3ORXP621KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEB4xA52d2+ZwzXblV37zF8N4CPjkyGKhYIScADcpqs=;
 b=p5HLMYMptwG1iR4w79QsYaMTjDjlXO7NJ415rFYAQTCP1PVRxxUDl1eVOiRQNz4SjVwm5YVoKWjDyymCyhaI+I0D5Qya/VLGohihMlNyn8TAftzcAA9F2ezEn6iVkH35lwpyDWP2GfBSq/ZslPytm0wiUiKPnjxM1wvG0RbL0hE=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:54 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:54 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next 11/11] documentation: networking: devlink: add prestera switched driver Documentation
Date:   Wed,  9 Jun 2021 18:16:01 +0300
Message-Id: <20210609151602.29004-12-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c04fb28-6ac5-4224-7bf2-08d92b599d24
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB142773F1BFDC5DEE6C0DC424E4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHdTlv4LkyiLr4UkE9FkYfsLPcX7zPHJgwT+PEsXj38rX4LIv0PZ/+S2KNjV1ptpIhzrIyAxNsU0iyRLpZtJ/TsdWBLmnK6R7t24HEmVmgt6KvAeMi2PaGCpbOpyXDRKk9razgS0+uFZDJvpkivk+f4LB6VEcF11eed1SL0PJGdpLrG3kxuX05tQ7SH4+vY2ogK5CUJTN7RSk0Srnnbx1cjy2SpMvWOxTj+jlvciBV7Sfw4jDv27iEyuDX3EEedoOGzCBjJt7F8fnoUexqCwoWHUxYDsmfX6LP3XCsw7bNjUm5XAWfWrQvXfXx9Pm8kzdfggDn/aV9X5uVjqUd3wPbFL2SiPfTSRaguSdNOflElgW/zwulq9maIazdqZvDHv98LB4loVlfcH78Km2s4eVdd2/doAwapb7MD7ZLOriIE/+JioLZkUSewdsMphf6UrfCUa/HYbYnYG/3qhmr8BOuuScqvDRNd+l1hT+1yNMeKKwTqtxR+sQNS7Q7Ja8V8ErzUHSZO/UTGFPCpfOZlrT+xRoJX6rNI07AKq7PfpIfVxYB8/+45vdYgIQmoFHSw4IqiX5YbXo2KpIPW78vhyozMmy6vKDLcn2yB04XEMjYYdNJwscjPljuI2vs5eVwbubj0z0QDB1zDnYTE5Ou6nH7ikLu0n0HjAyJtaJ6OsPaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(6916009)(66574015)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4UpGOH3kumlVdbH/zl6hsKtyP3oRStD3zruO/dd+xJM8HOsRetRQsHitveIY?=
 =?us-ascii?Q?Wi2bsw0BbywdaEKrQgu/UeTlmBtNBtK7MMncYMubVhyWuLuz/ob5CHbvEahe?=
 =?us-ascii?Q?NsQXocSR3iVjAMDa/D2LZ94jLuVAgfeOq0IOe3m7rIB2EbhxUFzAWw1J+IG4?=
 =?us-ascii?Q?E2H0gNkNugT8+lqieyHd9xwy8XGxYlRK2nwMY0LjNX8kp24k0PZFAZUyq9gF?=
 =?us-ascii?Q?6uexiLKF+JJT7sC1E9pkS3UpCP6ioZvimpYm5CZxVxEAhSBLpEHYgrxx+DjU?=
 =?us-ascii?Q?Z70v39Dt7Qmq/Cgq9G+2qB6id+tE5Wigo/s89WO4yqeCCSJyRw/ISrwvBkOb?=
 =?us-ascii?Q?meE3oIJUdwPX0OqiLVIBrqKV0jD1s4fgbV2JzUWd/vgbHJf0UlAWxr/wUMhl?=
 =?us-ascii?Q?X9+UpE5P/PgU3wGBdmiVD376HygWvIDasOaO+KZ10KJ7EZXObPuo9np5yolX?=
 =?us-ascii?Q?L1WyvL1OCZa2XsInbEa/+2z32hNm5qC6t/D5geTF6suQP1O8shpqYiLW+QD2?=
 =?us-ascii?Q?A1PhelbHMt0OPS5I9hN86iPcRWhMnggSTkwBH76cs5+dDgoXOvn4mh1vAoKf?=
 =?us-ascii?Q?rgRM+k7inQcycQ5Wl9u2jt9LEGDJwI0hXZtXdiRYpX0PmBKO/0X11Im6AT5s?=
 =?us-ascii?Q?lKglSQ9lF4Q/pQ2a3jgBsYNN2L9qvmyeIeiyLGlG1NW0PB0MA3Td6Lk1uCYh?=
 =?us-ascii?Q?SuFY72U0IB/JM8pNmCmaa3nwy5YsTCTwOkCFhJ5WPyeyQO03TzNTh1u0UZ5y?=
 =?us-ascii?Q?wQm/SD8ZA8gqgLRrpQsUQ4/6mc0l3y6F9excXCuQ46DClyuPQ6qsNva0MjQv?=
 =?us-ascii?Q?t/fshNIZ44XMIWGqOZSqiKuM36kWhcNX217CLydKivQGx7eennQbppimWkYV?=
 =?us-ascii?Q?0otmKOoGzSdsLrzdDXhpu0wyy4COKLJr6p+nvcpsecZZIS0BHwH5cnw75ZZP?=
 =?us-ascii?Q?n1WTZ8/3j2/OoPnGtyxMoHCi/sAgkp67BY/bzjwI0nzRte1ZGW3KFSQpxiVo?=
 =?us-ascii?Q?Dh+npKb+AyvPa/warmZAeuXfnVQ+qW/2zg94JavNT52yBb65aWq8AOTlYadA?=
 =?us-ascii?Q?rcfWyrAckdZLkVwk2MGe6g+W4S42B1iXGHfbcjVumt/mRJ/knA2uKMUd6EV8?=
 =?us-ascii?Q?svI6sAL/i0kAOXY55ZO8CNKjV81hS+5gj1PRYzLMxhHM2fPlV5oK6JUvVdCd?=
 =?us-ascii?Q?BmnEX+2Rgzt6J/W5MuAP6J5j11sjFoK3uErHe7JxKF83TCgL8jw+eFufCiQe?=
 =?us-ascii?Q?a2D3L+I8dfOnhszhV2ORt3UB7OoNQQP5fLWWwpbKwY4znidBW0Kwl05XbDWR?=
 =?us-ascii?Q?Kyg+jnzh2u9kVq1axWMvBulP?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c04fb28-6ac5-4224-7bf2-08d92b599d24
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:53.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6owVsztwFTXqj01dbK47EQyoDs3SaFTgG4XtA1VEg5yeeJJnKAkTNkIZQVMRXHTBT158DBQJWsruK//JLoE9CCla1iAdT/pNgBDmGAQ5B+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the devlink feature prestera switchdev driver supports:
add description for the support for the per-port devlink Parameters
(used form storm control);
add description for the support of the driver-specific devlink traps
(include both traps with action TRAP and action DROP);

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 Documentation/networking/devlink/prestera.rst | 167 ++++++++++++++++++
 1 file changed, 167 insertions(+)
 create mode 100644 Documentation/networking/devlink/prestera.rst

diff --git a/Documentation/networking/devlink/prestera.rst b/Documentation/networking/devlink/prestera.rst
new file mode 100644
index 000000000000..b73d70319344
--- /dev/null
+++ b/Documentation/networking/devlink/prestera.rst
@@ -0,0 +1,167 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+prestera devlink support
+=====================
+
+This document describes the devlink features implemented by the ``prestera``
+device driver.
+
+Parameters (per-port)
+=====================
+
+.. list-table:: Driver-specific parameters (per-port) implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``bc_kbyte_per_sec_rate``
+     - u32
+     - runtime
+    - Sets the maximum ingress traffic rate, at which port can
+      receive broadcast traffic.
+   * - ``unk_uc_kbyte_per_sec_rate``
+     - u32
+     - runtime
+    - Sets the maximum ingress traffic rate, at which port can
+      receive unknown unicast traffic.
+   * - ``unreg_mc_kbyte_per_sec_rate``
+     - u32
+     - runtime
+    - Sets the maximum ingress traffic rate, at which port can
+      receive unregistered multicast traffic.
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

