Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD69A8F4FE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfHOTqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:20 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:39650
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726865AbfHOTqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:46:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuC/MwpGWvf9XTz5+ZRgcGw61A+1yhmARghXjV/jnq8h8XRzBWSojbpvSDiK6aubPYvtsZi9WRAJvWfqcLPW+YvaQemdmNgGJMEV7MHxxM4AnnYqv3Hr1epen/sHmpofSI9htYmq0bxF8IGVAcMx8k7q8SVnSv2SmCGXW0twcoi2m0GiBNSP2UwFEEAQqscg0cdE5L+A/3GmupCaHLDxgkeQwt5J3Img3qppSxJHLBJmDjx8U/NQO1JVBh7TidNG8Z2kdY+msYjP8wCqgSn+L7C86ILNJoECzu4Onv+8HgWDPlBQSWjTI4oPpUe+Kz6gEgfgYamcmMeaGF/GFqMhJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSInisJzEw6CGaQlDuVZOZAFZYbE7YQFc7WUN7+/t8Q=;
 b=YTmaE9u2Vh81e3C52xSQltVAgmF1TxdkiCj08FhI43lyXNG3ajXcdKGxQwtXbHVJ821rw5Kls7Ayd2R0BOvYTXRtrXUl5D7pLsWF+xG1RQjNv0gjiEDTZVlLK6Yfivhhc0fn+6/k/c9IMcE7ne+xvUTqboWLia59nLx94aSgqSa13BS3ltLGFNY58/z8uh9h4tS7oMgBKo3O0EWlrGcdp5OQqHfpd7F+6y6VNqL73tl9LKZbyPM82dx7jMj7AB6NYia51GkAmLsYBKzKXq2Xk5n+3TdtyPYEZZZERHXAxFCGAWNkMJbRivY/t+5WKb0nuxqRBQrT6JfA0l65fhVp4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSInisJzEw6CGaQlDuVZOZAFZYbE7YQFc7WUN7+/t8Q=;
 b=XeqKLkhCi6Z+tU8xeGjWBIPZjTRU5S0V/IHTtbRHpqv5n5Zljwc6ZOMIHMFtVRmbholKzTqwkLGsGn8Fbt/PhapLK6Q3F3B92M0ivE10L/gX9hh4bGasZZ+OqyIApnli34A12Wq4Af6j/QZKh+R2ea4oR+T7MgfiTT9nloVzji8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 15 Aug 2019 19:46:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:46:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 0/5] Mellanox, Updates for mlx5-next branch
 2019-08-15
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, Updates for mlx5-next branch
 2019-08-15
Thread-Index: AQHVU6IUZREU+lqw60OtGrhrmpkosQ==
Date:   Thu, 15 Aug 2019 19:46:06 +0000
Message-ID: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 588057e9-48ad-42cd-e6c5-08d721b9364f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB27597FE484E7EA8FC79EF154BEAC0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(53754006)(199004)(189003)(5660300002)(25786009)(7736002)(110136005)(14454004)(66476007)(66556008)(64756008)(66446008)(2906002)(305945005)(54906003)(6486002)(66946007)(14444005)(256004)(6636002)(1076003)(498600001)(52116002)(99286004)(3846002)(2616005)(102836004)(6512007)(6116002)(6436002)(15650500001)(6506007)(386003)(4326008)(36756003)(186003)(26005)(8676002)(81156014)(81166006)(71200400001)(86362001)(66066001)(50226002)(53936002)(450100002)(8936002)(476003)(71190400001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8GTdJseT9G7MXp7uSlX0k52h0116pJlqof2sCKVGc0OxqwxYIrf5lr4nkUvvlSYD5iZDiBNcasy5Ox8ue7oNsoQ8V+MaNinga/SuO6HlIFzqoW9+vO3O0iEYPE1kE9HQ4uX7VCBJGW9K8Ga99n6jusVpRA7YJ0JL/Y8NIunmx8fK7zDjaHT9X0ss7lkLkIFtQ3wtuLMjSuOOWXhaZy2ooEs7YeWsdX0opnsfd5FziHDrMM4a6n9j3ez5Z9A9kY9ozkhT4Ga/htwSD0rKHLYM8EOYyZUrLGeYg7M3yPoDhrw44pxSLap5DoRxOsCWKzhrbWzvYpWQteKDQW+wHqyuCy4w+vj9zVwqgLhsK4dH43RqYZUS2kQ4hju7c6fLuHoxbKVk4YzJLxrxJU10p5suapxJysOxG3F70NUXTKm2+aU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588057e9-48ad-42cd-e6c5-08d721b9364f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:46:06.3145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LRcFJd3jekseZB4sVNkmmE5U6eLqmmMb828vFe/BiaM27mRsZrOrPax5ShKibjuCzkssiHchP0sUElmyB0QcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series includes misc updates for mlx5-next shared branch.

mlx5 HW spec and bits updates:
1) Aya exposes IP-in-IP capability in mlx5_core.
2) Maxim exposes lag tx port affinity capabilities.
3) Moshe adds VNIC_ENV internal rq counter bits.

Misc updates:
4) Saeed, two compiler warnings cleanups

In case of no objection this series will be applied to mlx5-next branch
and sent later as pull request to both rdma-next and net-next branches.

Thanks,
Saeed.

---

Aya Levin (1):
  net/mlx5: Expose IP-in-IP capability bit

Maxim Mikityanskiy (1):
  net/mlx5: Add lag_tx_port_affinity capability bit

Moshe Shemesh (1):
  net/mlx5: Add support for VNIC_ENV internal rq counter

Saeed Mahameed (2):
  net/mlx5: Add missing include file to lib/crypto.c
  net/mlx5: Improve functions documentation

 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 22 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 18 +++++++++++----
 3 files changed, 28 insertions(+), 13 deletions(-)

--=20
2.21.0

