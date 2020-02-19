Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F374A163AC3
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgBSDG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:26 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:44883
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728202AbgBSDG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guRq/1HzFXzJf7VYVMTAm9H/+SLQua3gp/vz9y/aHls2A/9cronMGzJ2n8NL1nx9SzPDeTLh1H+EP2ukLA8hJUntfRKKQHpzmNCjHjlVSoSeg2tBarHfJ/M1dfSAgpa/cWfUqFH9Et0YTNPTlw4CxxNt3EENb9ASgTzbV2G5KNDFumCnpjuSE/u8/sM9JYN/vswqe5p1KpVlvtd8fO487WTIl5uTQhy4aof/eY0rHrskixhBvNzmiz1JMMLpcBgSL5Vpc6bLPcYICenmxFKLhgK39aNNIb8yfrOGt88vxVCan0QhbN5t/WoS1qWZFG0qK0kbp5sRIS3d31P8wjwQjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zdP+aAgCqhoe8zW0mMpqSFVEuOm/z1Mc/hCfsGoHDQ=;
 b=a9szu4n5qoscGKwT1sF9Atyfoqth/EIFoOAyt2R6lywy0yDOitJfc86f61kpxrmr+MXOqx6Bj0v/m2YqILVi7Ch3fi6CWq5hOPYAODhuc/PEsPczvbEYiPVgnbaRa7LYg5Ot+Mig034FKWaISb2YA8MJayLca4oI8BvZ4NYqgCP95C5t6iio0N1YOEVkdM0r8U1E2L+Hike0mMmLrZr75vRYfXbfPT5K4gjpccZjT6lK1KqHermqSelSYCpcpr405LkUy/dd2YBDf2kpSdtgtlW6ZdDNGEO8lvxIFnpxFFomnQHJIuLcNr536f34YaXWpk++gUynRHgMqDhNsbH4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zdP+aAgCqhoe8zW0mMpqSFVEuOm/z1Mc/hCfsGoHDQ=;
 b=QzMFlO5yPI5BJaW8Gx9kNHOE/ZORdPgMaM9+RAyWSpgRjSRyWZP710o8OEvWNXN80xEK+Y3dxRihfT5HHAdaEnWBJ6ypRLQgLZzw3u7ePuurdYhFbk75Ol9fvzugRM8c8dn/bGshV4SqIQc0BSYfNy1LmuyaXa/d/fmXmvLOo70=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:20 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/7] Mellanox, mlx5 fixes 2020-02-18
Thread-Topic: [pull request][net 0/7] Mellanox, mlx5 fixes 2020-02-18
Thread-Index: AQHV5tGPAcoAv9P9gk+bc81P3oFR3Q==
Date:   Wed, 19 Feb 2020 03:06:20 +0000
Message-ID: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 58065e15-71a8-462d-eaf6-08d7b4e8b1af
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB58538C59155E5DF59A1B0E6DBE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(6666004)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XakxHqdhIhvBULqblzLuyVPic87xtZKiYPsWtGbi87RqECVz44HBnnEbv4i0uZMYUx8Cr5RsREV/eWbK3AGeBm/Sl2kZb4ni/Ai1sTPW2RM7VwrYWSMvTASe26w8/oOjdlkUokzpJTe2tFMbguMujJiui3n8hfDsbxhE2X3CuaPe7y1OyLCIMKW5wtzBeRQVu/W+TyikLz4Z74udIKbKu5rDVs2SboCbY9ASFDSClTOVnmfxO7KShENnOV3XZov4atMqfxfpUOzQ7gJb9HFaavDZajm/0QfIEMO7+024E4cbKYcjh/Eh2qy4S1jQhzSIwNN+/aDua6Gae8MGpsZSb6L//K7oNsMWEXD8t/w7MxEmSv40+nzDL+HDmR53IPDUolryKHOLdK6ja63AeBvLNWdURPtK7oUowxYdRDKDRsnJN2lBku+oBpAA+uFYUqYtktGqvDRC2s93kASddct9ldENNqSsOg2ZamCpsiQlwBn5zttsdOX50kr6tg0nMGkafEGgJg8bIjJ7M/A+xfwbqGIDbRNgNA9B6nmHZwLiOC0=
x-ms-exchange-antispam-messagedata: sxqbYJrmpBbLVu9WIEk+jbnvROvElUTfHG+Ip9Hp2w3W7LFkuAPsgfEULxvZN0eEnBrthPmLh1i03AGYW2j8/HerPWjA9SJKobxgCFx7dZY/YQ6z7t3glnutasKawjeQHgMrELx076GLtVKwYcfHYg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58065e15-71a8-462d-eaf6-08d7b4e8b1af
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:20.5651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KYZ0KnUhfmgrLP0bZ2H8Clbz2GRbEoF+3Uux62x0vTOv7uDg0N2kFCZ2p6hm3IoaqQAdhkdsvKHMNhdy5KpCUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v5.3
 ('net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa')

For -stable v5.4
 ('net/mlx5: DR, Fix matching on vport gvmi')
 ('net/mlx5e: Fix crash in recovery flow without devlink reporter')

For -stable v5.5
 ('net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST to =
RDY')
 ('net/mlx5e: Don't clear the whole vf config when switching modes')

Thanks,
Saeed.

---
The following changes since commit 9facfdb5467382a21fc0bd4211ced26c06f28832=
:

  netlabel_domainhash.c: Use built-in RCU list checking (2020-02-18 12:44:2=
3 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2020-02-18

for you to fetch changes up to 13a7e459a41a56d788ab33d825c6205379bbb711:

  net/mlx5: DR, Handle reformat capability over sw-steering tables (2020-02=
-18 19:01:20 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-02-18

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST =
to RDY
      net/mlx5e: Fix crash in recovery flow without devlink reporter

Dmytro Linkin (1):
      net/mlx5e: Don't clear the whole vf config when switching modes

Erez Shitrit (1):
      net/mlx5: DR, Handle reformat capability over sw-steering tables

Hamdan Igbaria (1):
      net/mlx5: DR, Fix matching on vport gvmi

Huy Nguyen (1):
      net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  8 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 20 +++++------
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  4 +--
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  5 ++-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  9 +++--
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       | 39 +++++++++++++++++-=
----
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |  2 ++
 include/linux/mlx5/mlx5_ifc.h                      |  5 ++-
 11 files changed, 70 insertions(+), 29 deletions(-)
