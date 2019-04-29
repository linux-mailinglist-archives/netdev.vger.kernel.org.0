Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88692E9E0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfD2SOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:14:43 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:31557
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728748AbfD2SOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8I0y69iqpBWeUWPTy9T43K5RlPaQ6Kg19/CRHFpzqDE=;
 b=Yu51EEFrBatmArM7F13d/7ceGwrYZxV3rm+j8SeMJvoxsXIYdc2tn5wMTKEhUlPR0Ip4NiN8pgS/pB4hbd3fhwhwWVHhXEojbidJg3mOwst21b+X8CYF3s1B3wOSwl8ViAYls2sHjWfCCmPkdbTnZpCl3/alelGSBCs84HgwOow=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6619.eurprd05.prod.outlook.com (20.179.12.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Mon, 29 Apr 2019 18:13:59 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:13:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH V2 mlx5-next 00/11] Mellanox, mlx5-next updates 2019-04-25
Thread-Topic: [PATCH V2 mlx5-next 00/11] Mellanox, mlx5-next updates
 2019-04-25
Thread-Index: AQHU/rdQCT5HmbSN5kGRKvPoPpHHQg==
Date:   Mon, 29 Apr 2019 18:13:58 +0000
Message-ID: <20190429181326.6262-1-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: cd259b43-470b-43c1-8a11-08d6ccce7313
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6619;
x-ms-traffictypediagnostic: DB8PR05MB6619:
x-microsoft-antispam-prvs: <DB8PR05MB6619911B3958C942F13F4447BE390@DB8PR05MB6619.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(136003)(376002)(396003)(189003)(199004)(6636002)(316002)(66066001)(386003)(6506007)(7736002)(68736007)(36756003)(305945005)(54906003)(110136005)(6512007)(102836004)(186003)(26005)(99286004)(14454004)(52116002)(478600001)(8936002)(85306007)(81156014)(8676002)(81166006)(1076003)(2906002)(5660300002)(86362001)(6116002)(71200400001)(71190400001)(66946007)(450100002)(73956011)(4326008)(6436002)(97736004)(66556008)(66446008)(66476007)(64756008)(486006)(476003)(2616005)(25786009)(53936002)(6486002)(3846002)(50226002)(15650500001)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6619;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wf8OGOZIJ1cnmde3ULWtwMqRf/N9EBcjs7FOI2F413WnLfIk1ca2RdJqe4YnQKJA8BlMSJBWRZ3bcgxla1rNyYSaUSufk1tjrtLI6SZQdg9ax5/Kt5Q9AVdqPRiNryaVDmT2jEQ4L9GAsAHYi68VEsSJQBEFOERVQUN+/xDWG9d28Mflrsx88oaBC42Tnv4M5YOzVpu0uMFV4nZFM43Y/VNoyGFZNLDe9CI6+wa0oI+kLYI2iOf6ueUHCasiAemriS1ppfMDkn+dEHQrqERwQbd6+uYNIg1pS/HYlF3dOkqjCFnGFrgZVTffORthdt/DXDB2M9aBKQDe2uI3H3t78keE4GdDygmKJG5sQiR8ABRypCUxHzZPf+zjRC99FOcE+QY7XEwKW4S0h9R9jI7r3MlCSfm5uVDNtvWH7SjCsMA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd259b43-470b-43c1-8a11-08d6ccce7313
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:13:59.0316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIHByb3ZpZGVzIG1pc2MgbG93IGxldmVsIHVwZGF0ZXMgdG8gbWx4
NSBjb3JlIGRyaXZlciwgdG8gYmUNCnNoYXJlZCBiZXR3ZWVuIHJkbWEgYW5kIG5ldC1uZXh0IHRy
ZWVzLg0KDQoxKSBGcm9tIEF5YTogRW5hYmxlIGdlbmVyYWwgZXZlbnRzIG9uIGFsbCBwaHlzaWNh
bCBsaW5rIHR5cGVzIGFuZCANCnJlc3RyaWN0IGdlbmVyYWwgZXZlbnQgaGFuZGxpbmcgb2Ygc3Vi
dHlwZSBERUxBWV9EUk9QX1RJTUVPVVQgaW4gbWx4NSByZG1hDQpkcml2ZXIgdG8gZXRoZXJuZXQg
bGlua3Mgb25seSBhcyBpdCB3YXMgaW50ZW5kZWQuDQoNCjIpIEZyb20gRWxpOiBJbnRyb2R1Y2Ug
bG93IGxldmVsIGJpdHMgZm9yIHByaW8gdGFnIG1vZGUNCg0KMykgRnJvbSBNYW9yOiBMb3cgbGV2
ZWwgc3RlZXJpbmcgdXBkYXRlcyB0byBzdXBwb3J0IFJETUEgUlggZmxvdw0Kc3RlZXJpbmcgYW5k
IGVuYWJsZXMgUm9DRSBsb29wYmFjayB0cmFmZmljIHdoZW4gc3dpdGNoZGV2IGlzIGVuYWJsZWQu
DQoNCjQpIEZyb20gVnUgYW5kIFBhcmF2OiBUd28gc21hbGwgbWx4NSBjb3JlIGNsZWFudXBzDQoN
CjUpIEZyb20gWWV2Z2VueSBhZGQgSFcgZGVmaW5pdGlvbnMgb2YgZ2VuZXZlIG9mZmxvYWRzDQoN
CkluIGNhc2Ugb2Ygbm8gb2JqZWN0aW9ucyB0aGlzIHNlcmllcyB3aWxsIGJlIGFwcGxpZWQgdG8g
bWx4NS1uZXh0DQpicmFuY2guDQoNCnYyOg0KLSAgQWRkcmVzcyBjb21tZW50cyBmcm9tIExlb24u
DQotICBTdGF0aWMgY2hlY2tlciBmaXhlcy4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCi0tLQ0KDQpB
eWEgTGV2aW4gKDIpOg0KICBJQi9tbHg1OiBSZXN0cmljdCAnREVMQVlfRFJPUF9USU1FT1VUJyBz
dWJ0eXBlIHRvIEV0aGVybmV0IGludGVyZmFjZXMNCiAgbmV0L21seDU6IEVuYWJsZSBnZW5lcmFs
IGV2ZW50cyBvbiBhbGwgaW50ZXJmYWNlcw0KDQpFbGkgQnJpdHN0ZWluICgxKToNCiAgbmV0L21s
eDU6IEUtU3dpdGNoOiBJbnRyb2R1Y2UgcHJpbyB0YWcgbW9kZQ0KDQpNYW9yIEdvdHRsaWViICg0
KToNCiAgbmV0L21seDU6IFBhc3MgZmxvdyBzdGVlcmluZyBvYmplY3RzIHRvIGZzX2NtZA0KICBu
ZXQvbWx4NTogQWRkIHN1cHBvcnQgaW4gUkRNQSBSWCBzdGVlcmluZw0KICBuZXQvbWx4NTogQWRk
IG5ldyBtaXNzIGZsb3cgdGFibGUgYWN0aW9uDQogIG5ldC9tbHg1OiBFc3dpdGNoLCBlbmFibGUg
Um9DRSBsb29wYmFjayB0cmFmZmljDQoNClBhcmF2IFBhbmRpdCAoMSk6DQogIG5ldC9tbHg1OiBH
ZXQgcmlkIG9mIHN0b3JpbmcgY29weSBvZiBkZXZpY2UgbmFtZQ0KDQpWdSBQaGFtICgxKToNCiAg
bmV0L21seDU6IFNlcGFyYXRlIGFuZCBnZW5lcmFsaXplIGRtYSBkZXZpY2UgZnJvbSBwY2kgZGV2
aWNlDQoNCllldmdlbnkgS2xpdGV5bmlrICgyKToNCiAgbmV0L21seDU6IEdlbmV2ZSwgQWRkIGJh
c2ljIEdlbmV2ZSBlbmNhcC9kZWNhcCBmbG93IHRhYmxlIGNhcGFiaWxpdGllcw0KICBuZXQvbWx4
NTogR2VuZXZlLCBBZGQgZmxvdyB0YWJsZSBjYXBhYmlsaXRpZXMgZm9yIEdlbmV2ZSBkZWNhcCB3
aXRoDQogICAgVExWIG9wdGlvbnMNCg0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21haW4u
YyAgICAgICAgICAgICB8ICAxNiArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL01ha2VmaWxlICB8ICAgMiArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2FsbG9jLmMgICB8ICAxOSArLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9jbWQuYyB8ICAgOSArLQ0KIC4uLi9tbHg1L2NvcmUvZGlhZy9md190cmFjZXJfdHJh
Y2Vwb2ludC5oICAgICB8ICAgNSArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX21haW4uYyB8ICAxNCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX3JlcC5jICB8ICAgMiArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX3RjLmMgICB8ICAgNSArLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lcS5jICB8ICAgMyArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2Vzd2l0Y2guaCB8ICAgOCArLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9v
ZmZsb2Fkcy5jICAgICB8ICAgNCArDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9m
cGdhL2lwc2VjLmMgIHwgIDg2ICsrKysrLS0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2ZzX2NtZC5jICB8IDExMyArKysrKystLS0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5oICB8ICAzMyArKy0tDQogLi4uL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5jIHwgIDczICsrKystLS0NCiAuLi4vbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmggfCAgIDUgKy0NCiAuLi4vbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYyAgfCAgIDIgKy0NCiAuLi4vbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgICAgfCAgMTUgKy0NCiAuLi4vZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oICAgfCAgNjUgKysrKy0tLQ0KIC4uLi9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvcGFnZWFsbG9jLmMgICB8ICAyMCArLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3JkbWEuYyAgICB8IDE4MiArKysrKysrKysr
KysrKysrKysNCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9yZG1hLmggICAg
fCAgMjAgKysNCiBpbmNsdWRlL2xpbnV4L21seDUvZGV2aWNlLmggICAgICAgICAgICAgICAgICAg
fCAgMTAgKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmggICAgICAgICAgICAgICAgICAg
fCAgMTAgKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvZnMuaCAgICAgICAgICAgICAgICAgICAgICAg
fCAgIDEgKw0KIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAgICAgICAgICB8
ICA4MiArKysrKystLQ0KIDI2IGZpbGVzIGNoYW5nZWQsIDU2NiBpbnNlcnRpb25zKCspLCAyMzgg
ZGVsZXRpb25zKC0pDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9yZG1hLmMNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3JkbWEuaA0KDQotLSANCjIuMjAuMQ0KDQo=
