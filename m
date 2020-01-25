Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD19214936A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgAYFLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:05 -0500
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:22390
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgAYFLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlYgOciOh6/TzalRDyUij5sqW3KlP9aIURL5M4Y/I/WdrPgS1SFVoUt4ygtAWw64Ih0+rzLbf5UnUtCsi/gt+DdLsrCYyiY70N7XgDjX4DJYg86MyMbo4eiMBIM69BbpWOemUY1YvjauxxQ7F0Z1/7GgFEgS887NLexUx6ks2ihZeJs9YIqrnVyVu/rzXhtdKFlbMPojQD37WszCZAcdzBqMweyswGHAdZasi+xEC0js00yoej0tg7s5L+R8YOAQDHYt8GHDC5L+jEHfehIefSnSU658O4mvxJJ13g2SLPrpGlyQNmrbLKlZf6LQxQgaLRMHxtjsdusEOLMTiVCJWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZaqTkWzUY5rQFTo/84QFrOlrssUc3ksgpNB1s79Fn0=;
 b=PRyPGZhYnje4Od/jII3q0YRESqN/AY8QRThG6zFSaKjxa2yVHZp6w09HXVpQ7vHGXop7XS23SC1GBhF0QCzCB4Rb0M/j08kK5p5kUkLHBw7c4LzE4rDtr/QaD3+fUdtDfkLHcBirXUdZtXZz5sqI9MDTsUmf+NDGM3FPqI/aXbSWBVrLR9FDvrauJG8D5O9qAPfDfQSFS0pio0pW7rOlBaEr+kYL5aacYN9p9LFJwBPdbzvpVkPPdfdORZcfjhhankeIiDZQ/QiQcc9j/Uu3K2kBOPnc1iVhC4IkjZKuRlgYaaOjLSPlszET/lKCfOhDT8dfXXT8no2fAb4fgn4dmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZaqTkWzUY5rQFTo/84QFrOlrssUc3ksgpNB1s79Fn0=;
 b=YnKSKcGo7bk1B6GL2st39KoqEdaZVz/f7+wA2pBVRUIEEVndf7jfAXm2AH1Ykl/R6B2UDct0PrD879RPdk55W1paYxqUuWzRgpjPkP9X6p+UG0WnJReDnQWyYBdAJM0mShqUP+k+VbH3vFvJpXVkiIdFN/oI0FfinMkv0bxVpPY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:10:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:10:59 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:10:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 00/14] Mellanox, mlx5 updates 2020-01-24
Thread-Topic: [pull request][net-next V2 00/14] Mellanox, mlx5 updates
 2020-01-24
Thread-Index: AQHV0z3TVnwn9d/Ptk+/GCv7MQ9qAQ==
Date:   Sat, 25 Jan 2020 05:10:56 +0000
Message-ID: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57605cc7-084c-46f9-6ea1-08d7a154f55e
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03947A7A80707D6C33AAD0A8BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(189003)(199004)(36756003)(66476007)(66946007)(2906002)(107886003)(4326008)(86362001)(52116002)(6512007)(66556008)(15650500001)(26005)(6506007)(8676002)(81166006)(66446008)(64756008)(81156014)(316002)(8936002)(71200400001)(1076003)(478600001)(54906003)(5660300002)(6486002)(16526019)(6916009)(956004)(186003)(2616005)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hX588/Okkg0X+Fkt/CroQeHWUZWkpSULwWTDMLXc86fBsjh9skeftlock482XbWILkBRHhj7xYs4WkgsDMDKmumgvDrZo5Ffomd00NXZtV0kRxMUTPV5gIGSb5YtnJXHJvgewxmFPZleXSspWpD1oerLXcTG7bRH49v4DU8xhWiJ0fCDgQUqqMQyZN9i/gVOWep2saxMtnntQ5Z4oZQwgjveM6RnQh7ZmmcyakdCSyCmVech+HxBvDgus3Med0bQqQL7TRJE27yBGH0J1FXsLehmaQtwetXTr2uP/VGqSckK9LquXaMZVPEiRTOyMygV0fU3lvHGulQMijeOS7vR6SOWI6LPdJDDNc/VYRx5MfPtoZzsuit2pOwJ6gDOXZIGFQ7Omp16l/BNtfMzTv1xQvNoVO7TBGQxVel1gQFih8UwvS2MYizNVPEDREn2j2jHhax8LJ3YG7HFC49e4BcQRTBoClu9D9v1FoCJDkEnWN2Db8rfJXmmvAeSnYLNmmpzRBk+RFZUglGVcCLRnAI5Vzqgl887uwuu9QNLxKUSr6Y=
x-ms-exchange-antispam-messagedata: xZLbWza3cX6I63koLi4xIB0F56aQ+DPeDvPzcMYSezwLjhP2EoJ1Q9iMmMlRBCJWY69tyZhtgojHH2WnOQakqK1bwdejuZP40awkPXLzymWwCvQer8xUvxU6LdFaNl/5ED9xvnG35NYUDaCRz9/IXw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57605cc7-084c-46f9-6ea1-08d7a154f55e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:10:58.9140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MpnzrEtr74tHUGqay0jNX4kuj8pf+7VvRdO7W8agTiSVOAH2Rj6X57bbCwXjhggfeScO6naSwMRE4Z4WwSyoiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds some updates to mlx5 driver
1) Devlink health dump support for both rx and tx health reporters.
2) FEC modes supports.
3) misc small patches.

V1 -> V2:
 - Remove "\n" from snprintf, happened due to rebase with a conflicting
   feature, Thanks Joe for spotting this.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Note about non-mlx5 change:
For the FEC link modes support, Aya added the define for
low latency Reed Solomon FEC as LLRS, in: include/uapi/linux/ethtool.h

Thanks,
Saeed.

The following changes since commit 62a2b103785a30f0354ca9b5af9da81641a6ec47=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2020-01-24 21:04:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-01-24

for you to fetch changes up to f8db58cf4e15bda512c834c075c8ebbd35e0f79e:

  net/mlx5: Fix lowest FDB pool size (2020-01-24 21:05:06 -0800)

----------------------------------------------------------------
mlx5-updates-2020-01-24

This series adds two moderate updates and some misc small patches to
mlx5 driver.

1) From Aya, Add the missing devlink health dump callbacks support for
both rx and tx health reporters.

First patch of the series is extending devlink API to set binary fmsg
data.

All others patches in the series are adding the mlx5 devlink health
callbacks support and the needed FW commands.

2) Also from Aya, Support for FEC modes based on 50G per lane links.
Part of this series, Aya adds one missing link mode define "FEC_LLRS"
to include/uapi/linux/ethtool.h.

3) Erez handles the reformat capability in SW steerig

4) From Joe, Use proper logging and tracing line terminations

5) Paul, Fix lowest FDB pool size, which got lost due to code re-placement
in net-next.

----------------------------------------------------------------
Aya Levin (11):
      devlink: Force enclosing array on binary fmsg data
      net/mlx5: Add support for resource dump
      net/mlx5e: Gather reporters APIs together
      net/mlx5e: Support dump callback in TX reporter
      net/mlx5e: Support dump callback in RX reporter
      net/mlx5e: Set FEC to auto when configured mode is not supported
      net/mlx5e: Enforce setting of a single FEC mode
      net/mlx5e: Advertise globaly supported FEC modes
      net/mlxe5: Separate between FEC and current speed
      ethtool: Add support for low latency RS FEC
      net/mlx5e: Add support for FEC modes based on 50G per lane links

Erez Shitrit (1):
      net/mlx5: DR, Handle reformat capability over sw-steering tables

Joe Perches (1):
      mlx5: Use proper logging and tracing line terminations

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    | 286 +++++++++++++++++=
++++
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.h    |  58 +++++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 107 +++++++-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 253 ++++++++++-------=
-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   8 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 266 ++++++++++++++++-=
--
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 181 ++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  71 ++---
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   9 +-
 drivers/net/phy/phy-core.c                         |   2 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/net/devlink.h                              |   5 +
 include/uapi/linux/ethtool.h                       |   4 +-
 net/core/devlink.c                                 |  94 ++++++-
 net/ethtool/common.c                               |   1 +
 net/ethtool/linkmodes.c                            |   1 +
 20 files changed, 1144 insertions(+), 227 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
