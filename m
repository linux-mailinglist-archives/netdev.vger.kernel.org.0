Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2926B1010D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfD3UkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:40:08 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:37375
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfD3UkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q18NcZcLWOdm+JylPb3WNrYZLRS8wkpyMqubbSviN34=;
 b=CZzl6P8ELBVInGz7X1OA59suUvzUL73Yw4VhHF+qxzMVRQUtHbc9pcss2crcWMW3hNDsyHevrkL7wZ9LytseYigzSq4e2/F3HW/ZQLuTMpStrdtTPed+aCTSqtbZm3DVicwtnbmfNssA4/lE/Yg03XfZKPzxaWM2QcrzK1DMcpY=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:39:56 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:39:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/15] ethtool: Add SFF-8436 and SFF-8636 max EEPROM length
 definitions
Thread-Topic: [net-next 06/15] ethtool: Add SFF-8436 and SFF-8636 max EEPROM
 length definitions
Thread-Index: AQHU/5Tf+clxYLmbT0qQic7oa4E1Gw==
Date:   Tue, 30 Apr 2019 20:39:56 +0000
Message-ID: <20190430203926.19284-7-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00aee606-a226-44c9-7147-08d6cdac014c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB6542824BADB10469873FC0DFBE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(14444005)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: borlgXGFW1iow0FLy5YyV9rTtP8cllsyqxZs21NgFXMPOx7M6NdIAMmN375bfOmeN49bnW+/LuG+ZZzzEq1gGE2DovY7X0q+NvhdrOrJp8m7kLA8SUmBMBEmT7M3qnQq3lnoDuvmoHG7Dyqq9xijtVwGZ3rpSlaUpO1e4fxxGkJvO1vkDhTyn9ZgbIgbyXAkV/Q4awxxi3YBus1n/AypSDVYvrHKZYRB+dUqvdQGHL17NmOkMM+Im747xS5Te6ptz/sKJxLnrTqQJUi5US0KMS0GfMtoFwKpPsq7db/W4LdH461BC1SdyVWIuf0DgSdffFdqbIanUQrj5LVyhLtZGUcytY+0sIWJZ+qDvwInMasVXLNioxpi4lCcia1Hr9Tvh6FxO+8Ap0MBHd2KQWhsQK/wAtusXa+4AwuPJJhqXMM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00aee606-a226-44c9-7147-08d6cdac014c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:39:56.5274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJleiBBbGZhc2kgPGVyZXphQG1lbGxhbm94LmNvbT4NCg0KQWRkZWQgbWF4IEVFUFJP
TSBsZW5ndGggZGVmaW5lcyBmb3IgZXRodG9vbCB1c2FnZToNCiAjZGVmaW5lIEVUSF9NT0RVTEVf
U0ZGXzg2MzZfTUFYX0xFTiAgICAgNjQwDQogI2RlZmluZSBFVEhfTU9EVUxFX1NGRl84NDM2X01B
WF9MRU4gICAgIDY0MA0KDQpUaGVzZSBkZWZpbml0aW9ucyBhcmUgZXhpc3RzIGluIGV0aHRvb2wg
YW5kIHVzZWQgdG8NCmRldGVybWluZSB0aGUgRUVQUk9NIGRhdGEgbGVuZ3RoIHdoZW4gcmVhZGlu
ZyBoaWdoDQpwYWdlcyBhcyB3ZWxsLg0KDQpGb3IgZXhhbXBsZSwgU0ZGLTg2MzYgRUVQUk9NIGRh
dGEgZnJvbSBwYWdlIDAzaA0KbmVlZHMgdG8gYmUgc3RvcmVkIGF0IGRhdGFbNTEyXSAtIGRhdGFb
NjM5XS4NCg0KU2lnbmVkLW9mZi1ieTogRXJleiBBbGZhc2kgPGVyZXphQG1lbGxhbm94LmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0t
DQogaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRvb2wuaCB8IDMgKysrDQogMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRv
b2wuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9ldGh0b29sLmgNCmluZGV4IDgxOGFkMzY4YjU4Ni4u
MzUzNGNlMTU3YWU5IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRvb2wuaA0K
KysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRvb2wuaA0KQEAgLTE3MTIsNiArMTcxMiw5IEBA
IHN0YXRpYyBpbmxpbmUgaW50IGV0aHRvb2xfdmFsaWRhdGVfZHVwbGV4KF9fdTggZHVwbGV4KQ0K
ICNkZWZpbmUgRVRIX01PRFVMRV9TRkZfODQzNgkJMHg0DQogI2RlZmluZSBFVEhfTU9EVUxFX1NG
Rl84NDM2X0xFTgkJMjU2DQogDQorI2RlZmluZSBFVEhfTU9EVUxFX1NGRl84NjM2X01BWF9MRU4g
ICAgIDY0MA0KKyNkZWZpbmUgRVRIX01PRFVMRV9TRkZfODQzNl9NQVhfTEVOICAgICA2NDANCisN
CiAvKiBSZXNldCBmbGFncyAqLw0KIC8qIFRoZSByZXNldCgpIG9wZXJhdGlvbiBtdXN0IGNsZWFy
IHRoZSBmbGFncyBmb3IgdGhlIGNvbXBvbmVudHMgd2hpY2gNCiAgKiB3ZXJlIGFjdHVhbGx5IHJl
c2V0LiAgT24gc3VjY2Vzc2Z1bCByZXR1cm4sIHRoZSBmbGFncyBpbmRpY2F0ZSB0aGUNCi0tIA0K
Mi4yMC4xDQoNCg==
