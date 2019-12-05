Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6AEB11487B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbfLEVMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:12 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729489AbfLEVMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6KhgxBgfzbCaJFhQj3sXskVIW6h09dU+6sSRuJL90r74RnlhocXPzRGnCJoCu4TDkcwkKo620Ef+V2N/4Pc14nGoc1ghmKwnFNX0HwxM5NSBhtvAIHfRdd+kV8yXnEe5WWxjbzc7GraDm8J6QSiSkTGPpFtGaYZrTGKw7kz7TZN0uHZACnZlO7nVr/K5g0CS1e654aA/NbZvHRW6Xp46JMQc1W2Ohe8ZQk9zrfG4J6xGp/7pCHXAKcCC7p6S4IstXPZ12GS0uNwwcpZKaq/bIXKpJOlRKkcX0JBVg99WkPj5Tp1FkbhZNkT8mQb4niB84ypY+dmF30Y7rkTm0cvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHD2ywZuLAqb7o3cjxPVfLZHPX34TYzCIuT9DGx4TcI=;
 b=gPloctt2VawJzqaTYMiuztG2HGx++KR7aQ4dF/+816fBAvqa4xnd+8DI5MDJ+Cm7Umu8px4MbeMspCvm4iOzHLPGSsO0gJ8pfvx2q9bU7intJxQD7Ek0xc61dMPNILqPx6SrLJbnDjs8myZAU9qrW4XJDniqIMt8ZSiD5MItV3/XGi/vIv2R78nt81QbSS0+fR6V1PlcLqcNW4SM5IRTSbjv9bkDI+oVIwbf1T8u5Zb6XUXrbaaCVQy9QJEo10KvTxjE3+rWhtWWPH1HD9AqekvYvyMhngv8EmsR8eIcWZKlm6blUxu1nPbqmd0SkqZhByJrAt3G8L0Rlk7zfcSGvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHD2ywZuLAqb7o3cjxPVfLZHPX34TYzCIuT9DGx4TcI=;
 b=BdJ94dpHtIM+1LqXjHqiLZwyqYpC1HDAmtCkQZDVAQhtmaGnmeF+vwZUV5ug00IqCFZwZqZPa1pNOpVhR4T3RAGGDY8uSvwQISgOYsUGAnImhIPpyEyL/ZCOJspdmmrttHFORaJ/BT5K3OyHVoUXiPEGJQcsFYkrxVuG6nXK9rs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/8] Mellanox, mlx5 fixes 2019-12-05
Thread-Topic: [pull request][net 0/8] Mellanox, mlx5 fixes 2019-12-05
Thread-Index: AQHVq7CkHiSDGT5BYE+eapgH6kxJDg==
Date:   Thu, 5 Dec 2019 21:12:04 +0000
Message-ID: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2433d48-dc2c-4c1a-b062-08d779c7c72a
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB33268A8EA3E570621718B097BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(26005)(186003)(5660300002)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QKQ+Ge8xbcaoEyZ1XZUYojargdmLSBXj+sq9YDZR6Z3He2rpuNyCt58OwcYy6JGQe1nMw/6bOcuzlt5m4ddNDCGuA0D0cM7Dg+NfXC0uAtk60xUJsb4Vd+l5WyKnFm/rPAd6ATf7MhuuVJxQj1SFXEKi3wmkzMDuZ/SSJL9Pt481MQUX7UWGLsWNUff4Uzho3g0mstYFyUd+BY6IAE4GBGPpcVAjKM/eW7WVcZyb1WdGy+wvJch8K80b11sh3FHIN7fg+xbdhDeRcJGoeyWTtG7omgwtjHOx+pDarst1eaMmHNbCyblexSJAUkCvcjTRMoZ8YfO3aZnBChirTOPU5usDtVY3Yedg+NgL+duyjB/FtKCwB/MHNhEl8DGXzNW39sneYc++IZV4vnOqRdvFqyskzVozS84j7VF/axbMEOsOyfEdycPcWzbhzRoy0wTI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2433d48-dc2c-4c1a-b062-08d779c7c72a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:04.5599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d0/c9+J+Ti/K6qDUseijyD8aDGvHsbF7kTA6cmSi7cKe0EuTNXK2MY1GiagY3ooMVo5LyqxPNmGWbgCUmlzARg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.19:
 ('net/mlx5e: Query global pause state before setting prio2buffer')

For -stable v5.3
 ('net/mlx5e: Fix SFF 8472 eeprom length')
 ('net/mlx5e: Fix translation of link mode into speed')
 ('net/mlx5e: Fix freeing flow with kfree() and not kvfree()')
 ('net/mlx5e: ethtool, Fix analysis of speed setting')
 ('net/mlx5e: Fix TXQ indices to be sequential')

Thanks,
Saeed.

---
The following changes since commit a350d2e7adbb57181d33e3aa6f0565632747feaa=
:

  net: thunderx: start phy before starting autonegotiation (2019-12-05 12:1=
0:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-12-05

for you to fetch changes up to b7826076d7ae5928fdd2972a6c3e180148fb74c1:

  net/mlx5e: E-switch, Fix Ingress ACL groups in switchdev mode for prio ta=
g (2019-12-05 13:02:13 -0800)

----------------------------------------------------------------
mlx5-fixes-2019-12-05

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5e: Fix translation of link mode into speed
      net/mlx5e: ethtool, Fix analysis of speed setting

Eran Ben Elisha (2):
      net/mlx5e: Fix TXQ indices to be sequential
      net/mlx5e: Fix SFF 8472 eeprom length

Huy Nguyen (1):
      net/mlx5e: Query global pause state before setting prio2buffer

Parav Pandit (1):
      net/mlx5e: E-switch, Fix Ingress ACL groups in switchdev mode for pri=
o tag

Roi Dayan (2):
      net/mlx5e: Fix freeing flow with kfree() and not kvfree()
      net/mlx5e: Fix free peer_flow when refcount is 0

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   1 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  27 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  15 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  31 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   9 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 122 ++++++++++++++---=
----
 10 files changed, 143 insertions(+), 75 deletions(-)
