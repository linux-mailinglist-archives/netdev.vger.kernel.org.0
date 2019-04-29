Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35D0E9D4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfD2SOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:14:21 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:53125
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728928AbfD2SOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLemOQbnPtEp0c/LDsG37k6xwp/fNrKod6oAshJFAcQ=;
 b=smkURcjk0lPLbjFCNkgMw0iHOqIxqmQEdQZyPXSpxj9zfmQA9oYgwo0k7X44pRWOuj2+U/Suf6z5N0MaPj+73QQFr1q9aLvRrJREzewnLwPJ7PfTz/WOX/SIrhqeVIOVWpGNMJwlCwSUx4kLOvF6FhgxxJb5/6S0XTankyyHtgI=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6026.eurprd05.prod.outlook.com (20.179.10.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.16; Mon, 29 Apr 2019 18:14:07 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:14:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>
Subject: [PATCH V2 mlx5-next 04/11] IB/mlx5: Restrict 'DELAY_DROP_TIMEOUT'
 subtype to Ethernet interfaces
Thread-Topic: [PATCH V2 mlx5-next 04/11] IB/mlx5: Restrict
 'DELAY_DROP_TIMEOUT' subtype to Ethernet interfaces
Thread-Index: AQHU/rdVnyxuKODFIE2b5TzVVJvyJg==
Date:   Mon, 29 Apr 2019 18:14:07 +0000
Message-ID: <20190429181326.6262-5-saeedm@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:a03:40::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98ad102f-2e36-4e8b-5e0c-08d6ccce77f3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6026;
x-ms-traffictypediagnostic: DB8PR05MB6026:
x-microsoft-antispam-prvs: <DB8PR05MB60260ED6FA6A819731DFC09DBE390@DB8PR05MB6026.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(189003)(199004)(25786009)(3846002)(66476007)(64756008)(66446008)(66556008)(107886003)(305945005)(76176011)(256004)(14444005)(52116002)(450100002)(4326008)(66066001)(386003)(6506007)(6116002)(14454004)(478600001)(73956011)(6512007)(66946007)(53936002)(8936002)(36756003)(11346002)(2616005)(2906002)(71190400001)(71200400001)(5660300002)(110136005)(186003)(316002)(26005)(486006)(6636002)(54906003)(446003)(6436002)(68736007)(99286004)(7736002)(50226002)(85306007)(102836004)(81166006)(81156014)(8676002)(86362001)(6486002)(97736004)(1076003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6026;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W92R2JgnK29KtHZfknO2XnR/hAZThQpr4/z+tJWWa2nSg1Tr7oXIygAstm9LpfLjA5tniodf70X+ZHdxD3GxtaBhEBJpPK8yw1bMjhUqmzrg6AJmb31UzWZxUZmiGgyeprZ0TLLv5tytwkyJ/ccPTsyKbsIXp7jKhvDuwC9WaNT8KiroJCpVEd6Hmzwdrp/Lod5LyNFMWJR8cEmHqvWO4Nr0ugkzgV3Zuu1HGnnEn5/IuCZmksgqmLvKLiTApc/RRYIGSzUzIIKMktO6sPaN2cppWFX735EQzEeC8jKUlR8T5zjsKKK1dx/rSLUgD5dewwkSz+GHN4hJCr/bd7/fIxGw4QPoOiXJq2Qvyx0ZfM9r53gALwjvKKhkeBTN3w+Lgr9fKmQRZNKUirxQoAujEYM4QBYj/336tYKw813uU0k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ad102f-2e36-4e8b-5e0c-08d6ccce77f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:14:07.1824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXlhIExldmluIDxheWFsQG1lbGxhbm94LmNvbT4NCg0KU3VidHlwZSAnREVMQVlfRFJP
UF9USU1FT1VUJyAodW5kZXIgJ0dFTkVSQUwnIGV2ZW50KSBpcyByZXN0cmljdGVkIHRvDQpFdGhl
cm5ldCBpbnRlcmZhY2VzLiBUaGlzIHBhdGNoIGRvZXNuJ3QgY2hhbmdlIGZ1bmN0aW9uYWxpdHkg
b3IgYnJlYWtzDQpjdXJyZW50IGZsb3cuIEluIHRoZSBkb3duc3RyZWFtIHBhdGNoLCBub24gRXRo
ZXJuZXQgKGxpa2UgSUIpIGludGVyZmFjZXMNCndpbGwgcmVjZWl2ZSAnR0VORVJBTCcgZXZlbnQu
DQoNCkZpeGVzOiA1ZDNjNTM3ZjkwNzAgKCJuZXQvbWx4NTogSGFuZGxlIGV2ZW50IG9mIHBvd2Vy
IGRldGVjdGlvbiBpbiB0aGUgUENJRSBzbG90IikNClNpZ25lZC1vZmYtYnk6IEF5YSBMZXZpbiA8
YXlhbEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21haW4uYyB8
IDYgKysrKystDQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jIGIvZHJp
dmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jDQppbmRleCA0NGQwMGNjNWZmZTIuLmZhZTZh
NmExZmJlYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21haW4uYw0K
KysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jDQpAQCAtNDM0Nyw5ICs0MzQ3
LDEzIEBAIHN0YXRpYyB2b2lkIGRlbGF5X2Ryb3BfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQogc3RhdGljIHZvaWQgaGFuZGxlX2dlbmVyYWxfZXZlbnQoc3RydWN0IG1seDVfaWJf
ZGV2ICppYmRldiwgc3RydWN0IG1seDVfZXFlICplcWUsDQogCQkJCSBzdHJ1Y3QgaWJfZXZlbnQg
KmliZXYpDQogew0KKwl1OCBwb3J0ID0gKGVxZS0+ZGF0YS5wb3J0LnBvcnQgPj4gNCkgJiAweGY7
DQorDQogCXN3aXRjaCAoZXFlLT5zdWJfdHlwZSkgew0KIAljYXNlIE1MWDVfR0VORVJBTF9TVUJU
WVBFX0RFTEFZX0RST1BfVElNRU9VVDoNCi0JCXNjaGVkdWxlX3dvcmsoJmliZGV2LT5kZWxheV9k
cm9wLmRlbGF5X2Ryb3Bfd29yayk7DQorCQlpZiAobWx4NV9pYl9wb3J0X2xpbmtfbGF5ZXIoJmli
ZGV2LT5pYl9kZXYsIHBvcnQpID09DQorCQkJCQkgICAgSUJfTElOS19MQVlFUl9FVEhFUk5FVCkN
CisJCQlzY2hlZHVsZV93b3JrKCZpYmRldi0+ZGVsYXlfZHJvcC5kZWxheV9kcm9wX3dvcmspOw0K
IAkJYnJlYWs7DQogCWRlZmF1bHQ6IC8qIGRvIG5vdGhpbmcgKi8NCiAJCXJldHVybjsNCi0tIA0K
Mi4yMC4xDQoNCg==
