Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D51FBBC3
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfKMWle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:34 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfKMWle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtysSVg7CteMkQreh/8hLX6s0idjXdgpibY+yR2pE03lZhASO9xw3gMTkxyEzUNLo606PuMQZZIc9RKp20PK6C4iE9DGOB2FGDeKiH0ptCtlk4NrCRXDashO94r+helwYDJBCA351/e+f9ewiIQAhP0lcUM0TOyu+tOB44hnMoA57zKxhAeuFjM4QR/UctoLrjv15Ft11UqK0xqCeTDwTwARacx07fshtfN2w7qhTQKbSa6m4l24HPWlGiJgVaLEyoFSaBmiGxoPeA4vDXvXlWZGpacnOzxsfMeO2P/iG3VfNFPgZoscEpV4s0xdYah8rZLQ5zC3NLGrPrIb6XTCcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJMzFBjHiYZrkuboOBT7FOBJ7fdRSK/IeXoUoWHtMv0=;
 b=eIAUUjkO0ebpYwsQIBufyR74UmQmfd31NDDM/A9sS+AFkhnptkjTsWod00ogk8lc3uH7WZxJPdWXzZxsVvceqXAxOHbRZR0cGCMhr2z/RW+lWVBWCeh2kGAp1uXLHHhvUYG+YwY7TryaMe3G+oBm3ltMfA5FlZUWWWs+N19U+xnvXiVO6Yl+W+p3RNRf5WLbdAxHHhWk6lC4OKn72R+L1275/78gTDvpQ7uQ5JN0N8Nwa5l6ajBiMr8/EwyXDYnESiSNInB8474ICBQhedVOWLfURRekGWPQ9N/c0NoCFPDQraNSRBqhvojFj4zeAxtwZ71VmiwZe7QGLCnHK6mOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJMzFBjHiYZrkuboOBT7FOBJ7fdRSK/IeXoUoWHtMv0=;
 b=VAuz4pXMuVA9DSYhPuGzezgqZ1CSlwDhkNDqRU5tzQGDRiRNN88nIDddSLynmdElSyRTWoLtgBVF0k61ySAe0IeLqSroWCPxLCwy2K/GxUPbiXwvz/vxL0IJG9cqbLVP6gUqytFU66yaWavkX/hs0GAvBtRI5VeTX53/veeQL7M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 0/7] Mellanox, mlx5 updates 2019-11-12
Thread-Topic: [pull request][net-next V2 0/7] Mellanox, mlx5 updates
 2019-11-12
Thread-Index: AQHVmnN9A5+uMpQOwkazhQGnYMbaNg==
Date:   Wed, 13 Nov 2019 22:41:29 +0000
Message-ID: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6d4ae58-db91-4b41-478b-08d7688aa00d
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB513594A6D8F5190F27BC3D9DBE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(15650500001)(50226002)(5660300002)(1076003)(4001150100001)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(7736002)(6506007)(14454004)(305945005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(71200400001)(71190400001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mALZI9b8t35zcdPBF1SXtM2YqJ0QpT50WR+SECOIhznbphaYLykz5FqtzoIg/OJ59YF68aLrvJPbTFfPJCRjnR8YI4J1ChJJyGDLzDwcf2FjdArh9JxGDhlDFzezygqD4g5HI1wIvDVbC0tVGucm/GX/6we8heSFFkpqFfT1uOA7gjTn0wp/n8pHYAt3NDmuoyMVPEJB0LUTj2UxQI+sWQReFbNmahxqY7MAb7auh6LlaENWg+9AKFRHRdnGG3lQTw/Ticm1lKSLo4zopBxgGSEbgoCA//1OrXSs2f36faewFB0NIndQmmzJJH2WLKHDDnLqfj3LgM0fTbivTGAuzWnhH9su+XimACBWddKD1GCVsoLy8AsyUx54ED8qDuMYwz/T/uMnddDXqtsAmlUnngbGugVu6ChlalL/92EXwBLCiYjzHlLzFx6TAgYsQN70
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d4ae58-db91-4b41-478b-08d7688aa00d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:29.7794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IzD3PZk5idc822tjm3DEWiZ0pKCEVO+guWk3EfCtAuMBhTcwuLBbqkLcpajKWcocnZk2t46FsyylJV2A/8ReOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 driver,
For more information please see tag log below.

Highlights:
1) Devlink reload support
2) TC Flowtable offloads=20

Please pull and let me know if there is any problem.
Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

v1->v2:
- dropped the 2 patches dealing with sriov vlan trunks, as it was nacked.
- merged the flowtables offloads low level infrastructure into mlx5-next
  and updated the mlx5-next merge commit.
- added mlx5 TC flowtables offload support patch on top of this series.

Thanks,
Saeed.

---
The following changes since commit c94ef13b04e2382c8fcb876705ea505bff9fb714=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-11-13 14:24:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-11-12

for you to fetch changes up to 84179981317fb4fb3e9df5acd42ea33cf6037793:

  net/mlx5: TC: Offload flow table rules (2019-11-13 14:25:04 -0800)

----------------------------------------------------------------
mlx5-updates-2019-11-12

1) Merge mlx5-next for devlink reload and flowtable offloads dependencies
2) Devlink reload support
3) TC Flowtable offloads
4) Misc cleanup

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Fix matcher builders select check

Eli Cohen (2):
      net/mlx5: Remove redundant NULL initializations
      net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/=
6

Michael Guralnik (2):
      net/mlx5e: Set netdev name space on creation
      net/mlx5: Add devlink reload

Parav Pandit (1):
      net/mlx5: Read num_vfs before disabling SR-IOV

Paul Blakey (1):
      net/mlx5: TC: Offload flow table rules

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 20 +++++++++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 26 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 47 ++++++++++++++++++=
++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 28 ++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 +++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    | 11 ++---
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  2 +-
 11 files changed, 128 insertions(+), 23 deletions(-)
