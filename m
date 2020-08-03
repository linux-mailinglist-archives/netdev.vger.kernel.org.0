Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E80823AE55
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgHCUmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:42:54 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:21862
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgHCUmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:42:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCXqPx0QP7CSh1W/nPozOi/YEkt8TiS/WTCExquqTPBflXHA3PMk3kbI7vAGK9OP1K/RFpY78lW8TVivXINbQ/aDSRXUPacKgVwB79wkcVmKguFxEmSf3p/axA7u3wzckKMFpV1VPfYIvT0rXfj6aGh62adaIu4J2Gk9dtpnrgiuuWYK3RK22OBxHkareg9k4FXbRNlK9OILwg5VVXL+97BtPUDNVsn6PpP+Om2OXjoF6efFSs51WlUUm/CPWSbECzP9STLlw+gx4y/XP3o2tK3QjL0AX7O3YeOKRqBpO7dd0BVMutc4sVj/9CoXLiGTpJqylXT9wXMP2prucgUlCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD79GlbSVD8EzVbGs/w/rZwpTURcqfsNyalgo5XR3PE=;
 b=P4w3gPwMKl1wI4S7zztO/rsqIl7wHS40ZVXtOSHY1+cuapPzG0q4ELM/3NAe6/hrzSxojWdFRg9oNhP4IeY13nqWc/im9cMAYij8VPg2IeW5GVz35CjmtHX5at012FNFc9Ingcm51UEVxs7g0pwYxbqPiZ869fp0LU+aMWIudFUb+RheSZou3sj1TVdiR2zHJxQjCm2YGVtv246Ed4Sl+g9DG1AyaYY27zsILEMYPXsb7R076J8V1/wF1cla6hyWEoYPM6oMyqTmKaThzR5TZefloEGX4sgigOREp4sl+XqivdbvHr3lu5QKj0Oe+Xi17PnaRzpC5Cy5ku0MWH7Vlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD79GlbSVD8EzVbGs/w/rZwpTURcqfsNyalgo5XR3PE=;
 b=PlMWrq7YvkaVYQoOQqJOcr9wVXKJVSBCAveCvI35hogCcl3inADPcPv0Fpokt2E45zIB4D4zi29XLwVaNyxfoxrjc4mbDhm18Wy/K9LKHbYgbeHbx24x6CShnLe+/pYPylTE4M6X50lE77/SxP8329gjF7gh6m8qF/RmABi/ZP0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VE1PR05MB7311.eurprd05.prod.outlook.com (2603:10a6:800:1a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 20:42:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:42:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/5] Mellanox, mlx5 updates 2020-08-03
Date:   Mon,  3 Aug 2020 13:41:46 -0700
Message-Id: <20200803204151.120802-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 20:42:48 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8eec03d3-3ef0-4580-6448-08d837edc940
X-MS-TrafficTypeDiagnostic: VE1PR05MB7311:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB731170CAFBE6ABEA0A012424BE4D0@VE1PR05MB7311.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nG+hsMPZALGCdlYUoTWKy+5xBmIXGIpZU8vFj4L3P6fVuDp/nOg6JcCAaLtWGJvjFl1u7weZ9ee9liuReGf3SjNfOXcbyk6lG5vr7hGXMhvEj66Qx0WVrKv4tjkMrSvVao3WN2RPs8XxdKz6qWFYh8jyjks23pQJo4M1wxrViCYpZZMOYkOgHabkRtIzNlq86yvxNv+Ehc5gaxjNMtp4xGmRVyiF+e6cegy2m1i6QPvRxRDC1u8I0asFR8KI49Jnuk/6IvfZ0uIGXkbaikdqYPhTS0XNxj6ZxFKRA7WpQiFz3i0r07609aiPxiHV6IiT8p7+3tvmXFcmBgI4OuoyoKKU/KgEOHoJY2yt7bd+pP5JdpttblG/fSRgq0M8NvoS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(956004)(1076003)(478600001)(110136005)(8936002)(5660300002)(2906002)(2616005)(86362001)(316002)(15650500001)(16526019)(66946007)(66476007)(66556008)(6486002)(36756003)(6506007)(26005)(8676002)(107886003)(83380400001)(52116002)(6512007)(4326008)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5Q4tvdRh8U7v3hQ/4BX9hVRdYp0TsUyiyTg7ORK96TEnIKw09WfAJGrlK1wQt0zd48nqRTyDLJf8TIZYuL92vbYwThLGyD1345pLG1Dxn1loL56V3cATDA68a0eaXrILNcDKwfTmpaTtr6CoY1R3v16OE/O/oe14i1PGSScsYWaPyK6pPSrxpPi/dl5Mzos7DJFYup7dv6VVbIYAUddFwRWgvQxWkmQ+W327Opgb+qyuIxfcBCSEDcmoMTWEOQ730PrujWxo2psn1rRYUij6/yk8DHqf3OqWQbLv9sNfB3woVQgEQlaDNvRriNFaW4y32p6ZnQJGcv+6XeBWi/qe8LL6xExzJaar3j8Jxxu/6zupOS32tJwaj6FUgAyJQL66CdDupdVnRsnjUd8D6LjtFEAIc3cfNMUFwbpm64ucaQq6gGzQW7NnAXklfPsP/vXesnqZAwS1EvcvQRQasHpZtVnbP2ZWHpBxAAXO3Bf4ZvHtrb2nnWKG+uGyYDgWoDZRnmLDNpT1cD8Pj2g06nUsGffNu+gIw6Z1YGlGe7pCE/+A9R1EtYGhu4FpUznTCiKKXZVdllU4tEqXTB/jdbMZUxmCCJC/ltgqVyBeylForoKxzfsYURrWkx7mUFYXuPsgfbotLYDEyEc8+tFiGnwQPQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eec03d3-3ef0-4580-6448-08d837edc940
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 20:42:49.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJGmLqC/svHE9aVN9fy6uHvUZTx3iKCmz5siVXZoHOs5WlGZ68UW53mZmXlZZjiLR2xb60eF1JuP9M39IjE5wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This patchset adds misc updates to mlx5.

Please note there is one non-mlx5 patch from Jakub that adds support
for static vxlan port configuration in udp tunnel infrastructure.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit bd0b33b24897ba9ddad221e8ac5b6f0e38a2e004:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-08-02 01:02:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-08-03

for you to fetch changes up to 6c4e9bcfb48933d533ff975e152757991556294a:

  net/mlx5: Delete extra dump stack that gives nothing (2020-08-03 10:13:58 -0700)

----------------------------------------------------------------
mlx5-updates-2020-08-03

This patchset introduces some updates to mlx5 driver.

1) Jakub converts mlx5 to use the new udp tunnel infrastructure.
   Starting with a hack to allow drivers to request a static configuration
   of the default vxlan port, and then a patch that converts mlx5.

2) Parav implements change_carrier ndo for VF eswitch representors,
   to speedup link state control of representors netdevices.

3) Alex Vesker, makes a simple update to software steering to fix an issue
   with push vlan action sequence

4) Leon removes a redundant dump stack on error flow.

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Change push vlan action sequence

Jakub Kicinski (2):
      udp_tunnel: add the ability to hard-code IANA VXLAN
      net/mlx5: convert to new udp_tunnel infrastructure

Leon Romanovsky (1):
      net/mlx5: Delete extra dump stack that gives nothing

Parav Pandit (1):
      net/mlx5e: Enable users to change VF/PF representors carrier state

 Documentation/networking/ethtool-netlink.rst       |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 121 +++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  29 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   9 +-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |  64 +++--------
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |   5 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  42 +++----
 include/net/udp_tunnel.h                           |   5 +
 net/ethtool/tunnels.c                              |  69 ++++++++++--
 net/ipv4/udp_tunnel_nic.c                          |   7 ++
 11 files changed, 188 insertions(+), 171 deletions(-)
