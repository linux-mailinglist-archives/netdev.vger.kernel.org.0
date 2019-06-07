Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABABA39805
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbfFGVro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:47:44 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731225AbfFGVro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nL4CpUZwsPZpxz19KQ8a0R0tIqSzzSWqvsXlxkLjYR8=;
 b=r00YCAb4Mx/7h0aEZWkwHOxCKYhZ+uGgPWWDpSfKXZOZtBjh+KrvxzChIAv1cz+xc2wwMTtFg6kNdaSBLRVY1AusX3Scq5D2D9eHjf9cfPcO4ANnph5tUAwxmwY3tk0Wvgi3ZJZ92Sg9YuDUvN40mqkeVqqaIYH9zCSkQ1miMvI=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:35 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-06-07
Thread-Topic: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-06-07
Thread-Index: AQHVHXqeZU0Jwu8SiEqo703dnaDoQA==
Date:   Fri, 7 Jun 2019 21:47:35 +0000
Message-ID: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e00996de-7a41-4cfd-dada-08d6eb91c0a7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB6139AB55E3FAA17AFA5F8561BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(14444005)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(6486002)(68736007)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o/F8SCVrLu5v8vMeHxN1FiOhJKotCe4yt6z9PwcYQ0znVeCJ2T1srP+2j3wNUN+Mwm7J/QkFFxU2fY5ZsLIZpFYVClYJDyyRNvfjNI7K5uyQS8BiZaJbAwNjt1VhVAbSKLI8JRv1d+rcPhnO1T08kLkFNeXOA9OgocdX0Di1Mf4BN5c/+ZbqtdSQdZpLXLdh+e5zmVPXBJFP92aDyA+JF2tMCEkq+8JvYdOfaDCxl6Yne1RN824+d2DHMBzlpwt9+F+I2ZPjD2O1Bg4BP6YRxMDpgUaCuNj0QXolifm6u39z+gT8JYw2thneYkhjzzkymbmOiI5tbv4kwUEabAEgGmaXqjfzl6vGBFDn1kYdCAnlZRER6MYgl0kJT1aeSpjvmxxy7c1AjNw4YxsQWzAUVinCmCVoptU7U4xHHG2k4ag=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e00996de-7a41-4cfd-dada-08d6eb91c0a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:35.6763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwNCg0KVGhpcyBzZXJpZXMgaW50cm9kdWNlcyBzb21lIGZpeGVzIHRvIG1seDUgZHJp
dmVyLg0KDQpQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IHByb2Js
ZW0uDQoNCkZvciAtc3RhYmxlIHY0LjE3DQogICgnbmV0L21seDU6IEF2b2lkIHJlbG9hZGluZyBh
bHJlYWR5IHJlbW92ZWQgZGV2aWNlcycpDQoNCkZvciAtc3RhYmxlIHY1LjANCiAgKCduZXQvbWx4
NWU6IEF2b2lkIGRldGFjaGluZyBub24tZXhpc3RpbmcgbmV0ZGV2IHVuZGVyIHN3aXRjaGRldiBt
b2RlJykNCg0KRm9yIC1zdGFibGUgdjUuMQ0KICAoJ25ldC9tbHg1ZTogRml4IHNvdXJjZSBwb3J0
IG1hdGNoaW5nIGluIGZkYiBwZWVyIGZsb3cgcnVsZScpDQogICgnbmV0L21seDVlOiBTdXBwb3J0
IHRhZ2dlZCB0dW5uZWwgb3ZlciBib25kJykNCiAgKCduZXQvbWx4NWU6IEFkZCBuZG9fc2V0X2Zl
YXR1cmUgZm9yIHVwbGluayByZXByZXNlbnRvcicpDQogICgnbmV0L21seDU6IFVwZGF0ZSBwY2kg
ZXJyb3IgaGFuZGxlciBlbnRyaWVzIGFuZCBjb21tYW5kIHRyYW5zbGF0aW9uJykNCg0KVGhhbmtz
LA0KU2FlZWQuDQoNCi0tLQ0KVGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdCBmMmM3
Yzc2YzVkMGE0NDMwNTNlOTRhZGI5ZjA5MThmYTJmYjg1YzNhOg0KDQogIExpbnV4IDUuMi1yYzMg
KDIwMTktMDYtMDIgMTM6NTU6MzMgLTA3MDApDQoNCmFyZSBhdmFpbGFibGUgaW4gdGhlIEdpdCBy
ZXBvc2l0b3J5IGF0Og0KDQogIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9zYWVlZC9saW51eC5naXQgdGFncy9tbHg1LWZpeGVzLTIwMTktMDYtMDcNCg0KZm9y
IHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVwIHRvIDQ1ZTdkNGMwYzE3MjdkMzYyMDEyYTYyZWI1NzI1
NGVhNzFhMmQ1OTE6DQoNCiAgbmV0L21seDVlOiBTdXBwb3J0IHRhZ2dlZCB0dW5uZWwgb3ZlciBi
b25kICgyMDE5LTA2LTA3IDE0OjQwOjM3IC0wNzAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQptbHg1LWZpeGVzLTIw
MTktMDYtMDcNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KQWxhYSBIbGVpaGVsICgyKToNCiAgICAgIG5ldC9tbHg1OiBB
dm9pZCByZWxvYWRpbmcgYWxyZWFkeSByZW1vdmVkIGRldmljZXMNCiAgICAgIG5ldC9tbHg1ZTog
QXZvaWQgZGV0YWNoaW5nIG5vbi1leGlzdGluZyBuZXRkZXYgdW5kZXIgc3dpdGNoZGV2IG1vZGUN
Cg0KQ2hyaXMgTWkgKDEpOg0KICAgICAgbmV0L21seDVlOiBBZGQgbmRvX3NldF9mZWF0dXJlIGZv
ciB1cGxpbmsgcmVwcmVzZW50b3INCg0KRWR3YXJkIFNyb3VqaSAoMSk6DQogICAgICBuZXQvbWx4
NTogVXBkYXRlIHBjaSBlcnJvciBoYW5kbGVyIGVudHJpZXMgYW5kIGNvbW1hbmQgdHJhbnNsYXRp
b24NCg0KRWxpIEJyaXRzdGVpbiAoMSk6DQogICAgICBuZXQvbWx4NWU6IFN1cHBvcnQgdGFnZ2Vk
IHR1bm5lbCBvdmVyIGJvbmQNCg0KUmFlZCBTYWxlbSAoMSk6DQogICAgICBuZXQvbWx4NWU6IEZp
eCBzb3VyY2UgcG9ydCBtYXRjaGluZyBpbiBmZGIgcGVlciBmbG93IHJ1bGUNCg0KU2hheSBBZ3Jv
c2tpbiAoMSk6DQogICAgICBuZXQvbWx4NWU6IFJlcGxhY2UgcmVjaXByb2NhbF9zY2FsZSBpbiBU
WCBzZWxlY3QgcXVldWUgZnVuY3Rpb24NCg0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9jbWQuYyAgICAgIHwgIDggKysrKysrKw0KIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9kZXYuYyAgICAgIHwgMjUgKysrKysrKysrKysrKysrKysrKyst
LQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oICAgICAgIHwg
IDIgKysNCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y190dW4uYyAg
ICB8IDExICsrKysrLS0tLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fbWFpbi5jICB8ICA5ICsrKysrKy0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX3JlcC5jICAgfCAxMCArKysrKy0tLS0NCiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYyAgICB8ICAzIC0tLQ0KIGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jICAgIHwgMTIgKysrKystLS0tLS0N
CiA4IGZpbGVzIGNoYW5nZWQsIDU4IGluc2VydGlvbnMoKyksIDIyIGRlbGV0aW9ucygtKQ0K
