Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB171E7CE9
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbfJ1Xe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:34:58 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:18405
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfJ1Xe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:34:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwGsXf22E3D+30mcSlp23PFYCwWczKfvtEw/sgCeYryj2thsEhVuQrayMkGs+/rwkSoJ9Vl1RTlWrT8f+Gx9l7MCppgsPiyvf7VsvxBAt+IRrfjB9TzJExByxA7Ebk3HUE20NA7vMsZHwLA2NQGYnZSNxNc0lPvElRGwyBJJgUMg3SUd4+ySw4glLJS+23FXik1T/HGGDDxvrSklxuVBYHQJtecAmDTuZ178tvaZ1C56hnfPWH9Ua/L7VxHBBVzHnOPTGFwTUM9XMpuxj2gnQ23awzm/EquW+Ql9GaeE+nhX484oG4ZLo4LwRmKeNI/JTw+wbyKahr9JbaHEXcjV3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1jiNJYfsp4BNHdJ7YificEwc5eBFLYPWUZKssw2miI=;
 b=NK1qAhYZ2KQpGy/H92jYobGjWJNsfLVZLOjKNp+HHZMNSJ0RUmgTbmTWAXkfhpkU9ME8AhtZwcWXTjuiuBfskBZEiVFuIGDsrrIfVQ6GAGLr1SJQGeCEWvAq4amdhYloAa2WHP3Na08kab3mBJ6OfamyzarZnrP7Xq6YY+8RAGQcGt+iBLbOxb7GJ13RLGAWSnUxmijEiNFFVgHD/wH8cRoQBN1auqI6soAvFlwVjWDsPdQSQWYUonr6IeUt7ZWJI35sSHg+ZM34TUveYLvdbputWpIFai0XRkA5VQW6dhMtAbGw1bLiecnOo37zHlcDaYLh434uYAXxbIL+vw77Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1jiNJYfsp4BNHdJ7YificEwc5eBFLYPWUZKssw2miI=;
 b=OIhkd1ToyV2caEGLlA0esyrRIfYJRU1KKJUPsxwtbWI15foQdFKl0Hb6Hl97uxthZjWxdcZLbAli+MSSRawCBf8MrN3+NGK8OPWE1M8P+uxBaIRpomli2jQ+UKGBbBdNo+66UqNLaMykPRpLv1IEpX2AyIPazpXiR5RaCnd1iCs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:34:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:34:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 00/18] Mellanox, mlx5-next updates 28-10-2019
Thread-Topic: [PATCH mlx5-next 00/18] Mellanox, mlx5-next updates 28-10-2019
Thread-Index: AQHVjehNWopMiBOYdUCwLPj6a+lSdg==
Date:   Mon, 28 Oct 2019 23:34:54 +0000
Message-ID: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a9e41737-35c7-4254-069b-08d75bff6fd7
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448B437C0B8B97BD3914CCCBE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(486006)(64756008)(6512007)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qL0N3TJ5b3k6hCKqaKfMJyqw1zxK561owOQ4sTatU8ULyI/01NO9JnhbX32magpVDJwBWn+rLJO2K7ZhT4wZBgIusoPjA9rtMtupHvXOQ+TMj21GljUamyNZOSBchqZFFtzPWwPdt9jv1LlMO/1qxfzElekFr6MBFWoSTf2OKZCaBKv5x/D/JCvaL23aDezN2dqTSnkXu72Q5+mgoynuKRnc82Zsol4YFWxLmZP2MRUIz0/jBFe2OX7AWyMogYHFxI/cmwI4MEMjJuPcujSrHX9gEHhnSOEO6Yi1SPVdZQxXqxvZnX9oe9/wgaiec8jiMwXqtkldkDehLmJ0G7PD31TYRNmj6kX72496gechWaI6AdsajctrZQfWSuP15KbLOzOEuo3sW5O5IumE+T8kvdaRkkHLFFTrL1uh07w4ZxcYmj8kgbnsNyLoi3hZb6bL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e41737-35c7-4254-069b-08d75bff6fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:34:54.9314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4qm9wuhhx+6E1bhyHgkv4YucDhVwSJ2wTFbInfZUPOeV7XUYwuzVwT7TNHTS3ZwyihvxAlPxi9d3DXbhnsu8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=20

This series refactors and tide up eswitch vport and ACL code to provide
better separation between eswitch legacy mode and switchdev mode=20
implementation in mlx5, for better future scalability and introduction of
new switchdev mode functionality which might rely on shared structures
with legacy mode, such as vport ACL tables.

Summary:

1. Do vport ACL configuration on per vport basis when enabling/disabling a =
vport.
This enables to have vports enabled/disabled outside of eswitch config for =
future.

2. Split the code for legacy vs offloads mode and make it clear

3. Tide up vport locking and workqueue usage

4. Fix metadata enablement for ECPF

5. Make explicit use of VF property to publish IB_DEVICE_VIRTUAL_FUNCTION

In case of no objection this series will be applied to mlx5-next branch
and sent later as pull request to both rdma-next and net-next branches.

Thanks,
Saeed.

---

Parav Pandit (14):
  net/mlx5: E-switch, Introduce and use vlan rule config helper
  net/mlx5: Introduce and use mlx5_esw_is_manager_vport()
  net/mlx5: Correct comment for legacy fields
  net/mlx5: Move metdata fields under offloads structure
  net/mlx5: Move legacy drop counter and rule under legacy structure
  net/mlx5: Tide up state_lock and vport enabled flag usage
  net/mlx5: E-switch, Prepare code to handle vport enable error
  net/mlx5: E-switch, Legacy introduce and use per vport acl tables APIs
  net/mlx5: Move ACL drop counters life cycle close to ACL lifecycle
  net/mlx5: E-switch, Offloads introduce and use per vport acl tables
    APIs
  net/mlx5: Restrict metadata disablement to offloads mode
  net/mlx5: Refactor ingress acl configuration
  net/mlx5: E-switch, Enable metadata on own vport
  IB/mlx5: Introduce and use mlx5_core_is_vf()

Qing Huang (1):
  net/mlx5: Fixed a typo in a comment in esw_del_uc_addr()

Vu Pham (3):
  net/mlx5: E-Switch, Rename egress config to generic name
  net/mlx5: E-Switch, Rename ingress acl config in offloads mode
  net/mlx5: E-switch, Offloads shift ACL programming during
    enable/disable vport

 drivers/infiniband/hw/mlx5/main.c             |   2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 573 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  66 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 259 ++++----
 include/linux/mlx5/driver.h                   |   5 +
 5 files changed, 537 insertions(+), 368 deletions(-)

--=20
2.21.0

