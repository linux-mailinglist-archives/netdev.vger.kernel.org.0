Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD82F96C7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfKLRNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:13:43 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbfKLRNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kphFsIl2A0BpKuQrLg/u97M6mylLKHQqihR87N+FpOu04wfS4eZd4XHtUlo30KM5bHjnNWG3C0I0uItk8rFJDn2STqs2rrAMne53YSHAR/ol12FLs7ywKrB8lXaxH9W2niQEDtO9ntFMlwoyfRgMrwqyb3msiHb0VbOL1xzKsP1DhSjHD8fbGllFDUUrWRTC6cA9AZXmZMfKjUDtEXobkv+RwZsg2m+SbQ8u/jttbb8lhedZLn7SYKzE+fBSuxt23F3jKBM1gnbUvCZOk2/kzsjcxdcvUc5eisOj7OJBOf17HupDR2ptNC9zcNxb9CcwBbOaKZsGr/xbqYFXAJVc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2WpavETDij+Y8cidgSvT048KedhLuSJabkPJGc4Dt0=;
 b=L5lUYjZomM9XqiMjHbtGz8dGgjy8MLvfYmmXBbmfnZyLSsIBX+o5gYb/OzgFnbd0yUE7ekSiOzHMrBTrm04WeCIjeeXrwB3COnQ8thwIz+VV9jPWHlSGKVPa1qGas4Ir7yfPYcjDnUZhqSpeeDjyZga40x1SnwO42NPKadiCpfsCsmKRj6N5SLSLfru1yTYe5bJ5UGjA2nuh27OHe+2zgMFk13+YdLRQon4KmkvsKk6uOsn+IoIa3GkD7eRidlI3Do79Q1uLoyCsRCTp1x0dpqRqaYFiAJOejfv9vVht8zLTGGaLu7Q74dj43Yo4QsMH240AP/2qstLs3j2Fe4+LJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2WpavETDij+Y8cidgSvT048KedhLuSJabkPJGc4Dt0=;
 b=mEkpnh2few9lTfAa76oU3jBGvkGDgree1QwsYMBNzTNuT03UOG4jAb3Rd9k03sgA+kQV6bzgwn8D8ylcGIsNQYp0sxahcuH+pEqotxbIM2eMkD5gSwvGWduoxeX7r1lOMd9lMoG7QlR3WKhtd+P5H5pt01qhHM8wXwBRhqKabPk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/8] Mellanox, mlx5 updates 2019-11-12
Thread-Topic: [pull request][net-next 0/8] Mellanox, mlx5 updates 2019-11-12
Thread-Index: AQHVmXyGD4z9cRTmyESsjuog30fFRA==
Date:   Tue, 12 Nov 2019 17:13:38 +0000
Message-ID: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ada86023-12bf-49e4-907c-08d76793a88e
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6078B225CAC0CFA36F8D8B4CBE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(71190400001)(3846002)(15650500001)(6506007)(386003)(52116002)(256004)(316002)(476003)(14444005)(2616005)(486006)(6116002)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(4001150100001)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SqCmqVpXq4V6RStlSKnWMSWlol4jFwBR52Y+LHyNiVURXybi8lViHxjUKqmNz9qPI5jdbUJ8Jr6aqPMPx1kgkv3dWkIc+uYQyCdEpszdJH2wdgnvBrw/tKMA1WdGgAeck8ir+QnEo4gPmgL/kx6OLiOCFDMKWuAk9WspdKFhIJsj4QGHYFngGcKBLdpPMaa5ljyTQWkgUiIwEPJwO6NMwh/IJZHl0J+1e6Ou5AFoZsYO2m9+EhhtaJxhx+WhOfKpqbSat1h71j1raS6faBBQaDjLw4vLCXi2EvZAgXSR4QuKIvCuc/KCViYHYdwzY0OHPp4ZSThdpEY33gvvP3o9YXbj9l34npAgJUuPNorveIEmrV5d3q8CHvS1HZ9jkiOLVcn7xexl7MrMBeUk1A/HJsKNFabO6HpYx6lVy0ZrhxCsIR/ub1icFtUcr9Jc6kuO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada86023-12bf-49e4-907c-08d76793a88e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:38.4112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ol5+CsqVoJpjRguhHwTvLPC9lqbkt4+WamK2VaJlXDNWBeUxDPR5nIDQKFnv5f2HbMcSPaWv6dFoS8oYq3nEXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 driver,
For more information please see tag log below.

Highlights:
1) Devlink reload support
2) SRIOV VF ACL vlan trunk via tc flower

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Thanks,
Saeed.

---
The following changes since commit 73bb3b4ca77d012518d235838eeb451df96d5bc0=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-11-12 08:59:12 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-11-12

for you to fetch changes up to 9beec84b9d9adda3daa93cb93e745a476c6bf565:

  net/mlx5: Add vf ACL access via tc flower (2019-11-12 08:59:20 -0800)

----------------------------------------------------------------
mlx5-updates-2019-11-12

1) Merge mlx5-next for devlink reload dependencies
2) Devlink reload support
3) SRIOV VF ACL vlan trunk via tc flower
4) Misc cleanup

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Fix matcher builders select check

Ariel Levkovich (2):
      net/mlx5: Add eswitch ACL vlan trunk api
      net/mlx5: Add vf ACL access via tc flower

Eli Cohen (2):
      net/mlx5: Remove redundant NULL initializations
      net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/=
6

Michael Guralnik (2):
      net/mlx5e: Set netdev name space on creation
      net/mlx5: Add devlink reload

Parav Pandit (1):
      net/mlx5: Read num_vfs before disabling SR-IOV

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  20 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 139 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 517 ++++++++++++++++-=
----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  30 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  11 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |   2 +-
 13 files changed, 609 insertions(+), 160 deletions(-)
