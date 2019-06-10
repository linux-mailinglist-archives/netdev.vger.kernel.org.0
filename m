Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B929D3BFF7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390776AbfFJXiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:17 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:50500
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390625AbfFJXiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dldddHTRHbXE+Bvb/O3/z3WYc97C3qpcbmtBEpPr6DA=;
 b=ICvG7hcfbtGtDmE2NPyM03sM+DFs91BSe0KRqiDe7eaaJhpO/64pAzWuiUWPe9e3ArtB4SiMy86ELYRngOuMiMB7u4ph/G/Nz1Bk7u60Uuu00ZOcGQKV0TbeEHg/ijHfLHPTe/cYu46l0zp8Jnw7IUsac7s+DWeZe/PWfMrvoiA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:11 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 00/16] Mellanox, mlx5 next updates 10-06-2019
Thread-Topic: [PATCH mlx5-next 00/16] Mellanox, mlx5 next updates 10-06-2019
Thread-Index: AQHVH+WQKUAaOLo+ckSVksYLubbYdw==
Date:   Mon, 10 Jun 2019 23:38:11 +0000
Message-ID: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e244ff07-843d-4e0a-8f58-08d6edfcb2b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB2166414F263759F8670D1F31BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(136003)(366004)(53754006)(199004)(189003)(26005)(71190400001)(386003)(7736002)(6506007)(73956011)(66556008)(102836004)(86362001)(66476007)(66946007)(71200400001)(305945005)(5660300002)(64756008)(66446008)(316002)(68736007)(66066001)(1076003)(6636002)(110136005)(3846002)(54906003)(6116002)(36756003)(186003)(15650500001)(2616005)(81166006)(256004)(85306007)(450100002)(14454004)(50226002)(53936002)(6512007)(52116002)(25786009)(8936002)(8676002)(14444005)(476003)(99286004)(6486002)(4326008)(81156014)(478600001)(2906002)(6436002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8hQA/K7MY0b4SqvOko4F+J2Gwf2rnhDR9FxkCAiFYioLr+e9I/hq9X/tnS0LWAM3zgkPmvG9t9Lvat401IhSxyBGQXsn/P2XCA+ey9sZwFdxRhj7p1PuJ8NMwyNCNrwvYldf0iKDH0GEYnP0aVSDJ+mhz/nO/9VdFUS4t2gNalvCRPdCCQpCDIJ40s8fdKeaZCPPc/APTgGsGdhjJPJP0zzVqI/wtU3XguUHpmHu/QKdI8byz9njRIcxGPAzpXMxjFr1reV3q60Zt7TW7GbnIa4IWjjykbiodyMiz/FEMBUrBYr3MhAJYw88f7zs047z35bL12wWaEmB+onEZxbCqmakJT8TKccf0Z6n5PS6ili02igwl0C7IoRVLbVxhwjAF/PvTNIdoNBF791WlhspPLrPAI7r7t3EkWPuOLKRhfs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e244ff07-843d-4e0a-8f58-08d6edfcb2b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:11.3367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsLA0KDQpUaGlzIHNlcmllcyBpcyBhaW1lZCBtbHg1LW5leHQgYnJhbmNoLCBpdCBpbmNs
dWRlcyBhIGNvdXBsZSBvZiBsb3cgbGV2ZWwNCnVwZGF0ZXMgZm9yIG1seDVfY29yZSBkcml2ZXIs
IG5lZWRlZCBmb3IgYm90aCByZG1hIGFuZCBuZXQtbmV4dCB0cmVlcy4NCg0KMSkgQm9kb25nIHJl
ZmFjdG9ycyBxdWVyeSBlc3cgZnVuY3Rpb25zIHNvIGhlIGNvdWxkIHVzZSBpdCB0byBzdXBwb3J0
DQpxdWVyeWluZyBtYXggVkZzIGZyb20gZGV2aWNlLg0KDQoyKSBWdSwgaGFuZGxlcyBWRiByZXBy
ZXNlbnRvcnMgY3JlYXRpb24gZnJvbSBWRiBjcmVhdGlvbiBoYW5kbGVyDQpjb250ZXh0Lg0KDQoz
KSBEYW5pZWwsIGluY3JlYXNlZCB0aGUgZncgaW5pdGlhbGl6YXRpb24gd2FpdCB0aW1lb3V0IGZv
ciBsYXJnZSBzcmlvdg0KY29uZmlndXJhdGlvbi4NCg0KNCkgWXV2YWwsIHJlZmFjdG9ycyBJUlEg
dmVjdG9ycyBtYW5hZ2VtZW50IGFuZCBzZXBhcmF0ZXMgdGhlbSBmcm9tIEVRcywNCnNvIElSUXMg
Y2FuIGJlIHNoYXJlZCBiZXR3ZWVuIGRpZmZlcmVudCBFUXMgdG8gc2F2ZSBzeXN0ZW0gcmVzb3Vy
Y2VzLA0KZXNwZWNpYWxseSBvbiBWTXMgYW5kIFZGIGZ1bmN0aW9ucy4NCg0KNSkgQXJpZWwsIGV4
cGxvaXRzIFl1dmFsJ3Mgd29yayBhbmQgdXNlcyBvbmx5IG9uZSBJUlEgZm9yIHRoZSA0IGFzeW5j
DQpFUXMgd2UgaGF2ZSBwZXIgZnVuY3Rpb24gKFNvIHdlIGNhbiBzYXZlIDMgSVJRIHZlY3RvcnMg
cGVyIGZ1bmN0aW9uKS4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCi0tLQ0KDQpBcmllbCBMZXZrb3Zp
Y2ggKDEpOg0KICBuZXQvbWx4NTogVXNlIGEgc2luZ2xlIElSUSBmb3IgYWxsIGFzeW5jIEVRcw0K
DQpCb2RvbmcgV2FuZyAoMik6DQogIG5ldC9tbHg1OiBFLVN3aXRjaCwgUmV0dXJuIHJhdyBvdXRw
dXQgZm9yIHF1ZXJ5IGVzdyBmdW5jdGlvbnMNCiAgbmV0L21seDU6IFN1cHBvcnQgcXVlcnlpbmcg
bWF4IFZGcyBmcm9tIGRldmljZQ0KDQpEYW5pZWwgSnVyZ2VucyAoMSk6DQogIG5ldC9tbHg1OiBJ
bmNyZWFzZSB3YWl0IHRpbWUgZm9yIGZ3IGluaXRpYWxpemF0aW9uDQoNClZ1IFBoYW0gKDEpOg0K
ICBuZXQvbWx4NTogRS1Td2l0Y2gsIEhhbmRsZSByZXByZXNlbnRvcnMgY3JlYXRpb24gaW4gaGFu
ZGxlciBjb250ZXh0DQoNCll1dmFsIEF2bmVyeSAoMTEpOg0KICBuZXQvbWx4NTogSW50cm9kdWNl
IEVRIHBvbGxpbmcgYnVkZ2V0DQogIG5ldC9tbHg1OiBDaGFuZ2UgaW50ZXJydXB0IGhhbmRsZXIg
dG8gY2FsbCBjaGFpbiBub3RpZmllcg0KICBuZXQvbWx4NTogU2VwYXJhdGUgSVJRIHJlcXVlc3Qv
ZnJlZSBmcm9tIEVRIGxpZmUgY3ljbGUNCiAgbmV0L21seDU6IFNlcGFyYXRlIElSUSBkYXRhIGZy
b20gRVEgdGFibGUgZGF0YQ0KICBuZXQvbWx4NTogTW92ZSBJUlEgcm1hcCBjcmVhdGlvbiB0byBJ
UlEgYWxsb2NhdGlvbiBwaGFzZQ0KICBuZXQvbWx4NTogTW92ZSBJUlEgYWZmaW5pdHkgc2V0IHRv
IElSUSBhbGxvY2F0aW9uIHBoYXNlDQogIG5ldC9tbHg1OiBTZXBhcmF0ZSBJUlEgdGFibGUgY3Jl
YXRpb24gZnJvbSBFUSB0YWJsZSBjcmVhdGlvbg0KICBuZXQvbWx4NTogR2VuZXJhbGl6ZSBJUlEg
aW50ZXJmYWNlIHRvIHdvcmsgd2l0aCBpcnFfdGFibGUNCiAgbmV0L21seDU6IE1vdmUgYWxsIElS
USBsb2dpYyB0byBwY2lfaXJxLmMNCiAgbmV0L21seDU6IFJlbmFtZSBtbHg1X2lycV9pbmZvIHRv
IG1seDVfaXJxDQogIG5ldC9tbHg1OiBBZGQgRVEgZW5hYmxlL2Rpc2FibGUgQVBJDQoNCiBkcml2
ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmggICAgICAgICAgfCAgIDEgKw0KIGRyaXZl
cnMvaW5maW5pYmFuZC9ody9tbHg1L29kcC5jICAgICAgICAgICAgICB8ICAyMSArLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlICB8ICAgMiArLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jICB8IDQzOSArKysrKysrLS0t
LS0tLS0tLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMg
fCAgMzMgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmgg
fCAgIDcgKy0NCiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyAgICAg
fCAgOTQgKystLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9lcS5o
ICB8ICAgOSArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYyAg
ICB8ICA1NiArKy0NCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5o
ICAgfCAgMTMgKw0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3BjaV9pcnEu
YyB8IDMzNCArKysrKysrKysrKysrDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvc3Jpb3YuYyAgIHwgIDIyICsNCiBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmggICAgICAg
ICAgICAgICAgICAgfCAgMTAgKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvZXEuaCAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMjMgKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaCAgICAg
ICAgICAgICAgICAgfCAgIDIgKy0NCiAxNSBmaWxlcyBjaGFuZ2VkLCA2NzMgaW5zZXJ0aW9ucygr
KSwgMzkzIGRlbGV0aW9ucygtKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvcGNpX2lycS5jDQoNCi0tIA0KMi4yMS4wDQoNCg==
