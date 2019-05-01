Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B6D10ED0
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEAVzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:55:05 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:32576
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfEAVzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ea/6+K1V1yeIx4IRj533LuJ+Y8J93yU+IIytw+LXcCg=;
 b=b73PfW6n7da09yfkncgpB/SdgQwOuer0q2bLGqIrTklXgEgLjhRsV/1jijfREss0D4Pm7yjdlONX5p0JqHT0I9TjFLVXhLVpwxrN9xxOusSKcz/jUk3EB1B7TBcxlzV6zJmDqorthbXqFuAGNLGQYwAMU4w045WSxBTG6g5Mcjo=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5868.eurprd05.prod.outlook.com (20.179.8.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 1 May 2019 21:54:56 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:54:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 06/15] ethtool: Add SFF-8436 and SFF-8636 max EEPROM
 length definitions
Thread-Topic: [net-next V2 06/15] ethtool: Add SFF-8436 and SFF-8636 max
 EEPROM length definitions
Thread-Index: AQHVAGiD8QHG08tSqUihn1vTk8itwQ==
Date:   Wed, 1 May 2019 21:54:56 +0000
Message-ID: <20190501215433.24047-7-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ede636a7-42ae-496c-b6e3-08d6ce7fa61d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5868;
x-ms-traffictypediagnostic: DB8PR05MB5868:
x-microsoft-antispam-prvs: <DB8PR05MB586850C5038765FD0A90BC01BE3B0@DB8PR05MB5868.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(5660300002)(256004)(86362001)(6512007)(14444005)(66066001)(71190400001)(71200400001)(316002)(478600001)(446003)(11346002)(476003)(2616005)(186003)(1076003)(6486002)(26005)(486006)(6436002)(2906002)(102836004)(52116002)(6506007)(36756003)(6916009)(4326008)(76176011)(50226002)(107886003)(66446008)(68736007)(7736002)(66946007)(66476007)(66556008)(64756008)(53936002)(54906003)(305945005)(8676002)(81156014)(3846002)(81166006)(386003)(25786009)(73956011)(8936002)(99286004)(6116002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5868;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0iBBKW179mPgpKLJnueLC3DDBdtzs14Eoqb89vqhfMKpl6nBtYTaapzkLqHq99IbxFNXbGxrz1IpbakXYEAR238MFBVOgRo4eLNhYJzh4uqsp+tB+OHfao770+FQl58UlFsDUfAxA3FzS667qobzGLDkatgGdYG6RZhJG3xT4cd5lcbtDVE3zLelUc7O0rGO9OqIng6heGKHbzEDY74TbToKplrQdfSFwGrkT0ERXwa0HNCY6v2AfjhuC+ecqVddJfHDX/Je4jRAPRzqVVfio3vVRtPsGyE/ghnAsvoWUrh/2ITzxFFjFT+NnGssp/F94y+D6msK9K4XPs0gpQve4zuVtRAaxDAbt9oDX7ACBhCaBUv8ktoGXZFiumHdDmIobw9QYuHzpUedx3lsBz2hKRnM4ATmN3kLZvmngKWN6KM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede636a7-42ae-496c-b6e3-08d6ce7fa61d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:54:56.7260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5868
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJleiBBbGZhc2kgPGVyZXphQG1lbGxhbm94LmNvbT4NCg0KQWRkZWQgbWF4IEVFUFJP
TSBsZW5ndGggZGVmaW5lcyBmb3IgZXRodG9vbCB1c2FnZToNCiAjZGVmaW5lIEVUSF9NT0RVTEVf
U0ZGXzg2MzZfTUFYX0xFTiAgICAgNjQwDQogI2RlZmluZSBFVEhfTU9EVUxFX1NGRl84NDM2X01B
WF9MRU4gICAgIDY0MA0KDQpUaGVzZSBkZWZpbml0aW9ucyBhcmUgdXNlZCB0byBkZXRlcm1pbmUg
dGhlIEVFUFJPTQ0KZGF0YSBsZW5ndGggd2hlbiByZWFkaW5nIGhpZ2ggZWVwcm9tIHBhZ2VzLg0K
DQpGb3IgZXhhbXBsZSwgU0ZGLTg2MzYgRUVQUk9NIGRhdGEgZnJvbSBwYWdlIDAzaA0KbmVlZHMg
dG8gYmUgc3RvcmVkIGF0IGRhdGFbNTEyXSAtIGRhdGFbNjM5XS4NCg0KU2lnbmVkLW9mZi1ieTog
RXJleiBBbGZhc2kgPGVyZXphQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1h
aGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogaW5jbHVkZS91YXBpL2xpbnV4L2V0
aHRvb2wuaCB8IDMgKysrDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRvb2wuaCBiL2luY2x1ZGUvdWFwaS9saW51
eC9ldGh0b29sLmgNCmluZGV4IDgxOGFkMzY4YjU4Ni4uMzUzNGNlMTU3YWU5IDEwMDY0NA0KLS0t
IGEvaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRvb2wuaA0KKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4
L2V0aHRvb2wuaA0KQEAgLTE3MTIsNiArMTcxMiw5IEBAIHN0YXRpYyBpbmxpbmUgaW50IGV0aHRv
b2xfdmFsaWRhdGVfZHVwbGV4KF9fdTggZHVwbGV4KQ0KICNkZWZpbmUgRVRIX01PRFVMRV9TRkZf
ODQzNgkJMHg0DQogI2RlZmluZSBFVEhfTU9EVUxFX1NGRl84NDM2X0xFTgkJMjU2DQogDQorI2Rl
ZmluZSBFVEhfTU9EVUxFX1NGRl84NjM2X01BWF9MRU4gICAgIDY0MA0KKyNkZWZpbmUgRVRIX01P
RFVMRV9TRkZfODQzNl9NQVhfTEVOICAgICA2NDANCisNCiAvKiBSZXNldCBmbGFncyAqLw0KIC8q
IFRoZSByZXNldCgpIG9wZXJhdGlvbiBtdXN0IGNsZWFyIHRoZSBmbGFncyBmb3IgdGhlIGNvbXBv
bmVudHMgd2hpY2gNCiAgKiB3ZXJlIGFjdHVhbGx5IHJlc2V0LiAgT24gc3VjY2Vzc2Z1bCByZXR1
cm4sIHRoZSBmbGFncyBpbmRpY2F0ZSB0aGUNCi0tIA0KMi4yMC4xDQoNCg==
