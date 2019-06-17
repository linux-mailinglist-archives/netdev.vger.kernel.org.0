Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D448E42
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfFQTXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:14 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:14178
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbfFQTXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQ36l3lKiQq5mTEWX4lV+4VrGI+/rI88/DwIEquGe2M=;
 b=qZhmTyYZcJ5ttvgaAvWYxdVsIY2MDGF43VXlyqDRPTc/SAToVEnz5X29SW7dJ+8ssMBxHyfGmkgyuOxZb/Lv4/iHlg8BammrHaAxT6RFSTkWeng3jSrQBi6WTSDAZr006y17BdKhWOCrKk1IfhMB8PNw0DQB/mDxbRl12ojqlbY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 00/15] Mellanox, mlx5 vport metadata matching
Thread-Topic: [PATCH mlx5-next 00/15] Mellanox, mlx5 vport metadata matching
Thread-Index: AQHVJUIXrkdBiZpQ+0+K9J1dO3DVlQ==
Date:   Mon, 17 Jun 2019 19:23:06 +0000
Message-ID: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb991251-c3e6-4794-db98-08d6f359395d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB27890FFA382FDDCD5C8AC102BEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(14444005)(6636002)(66476007)(2616005)(476003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(102836004)(99286004)(53936002)(305945005)(52116002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qtaqUxiR/4SsTUkyVay8rxGZV0ODiPSrUc6/qSXFiGKsJ0MrlMw943tn0ZWIOCL65RnQu5P62eDyjYcoA109dXOhBtBQEoV0tGNLsdhxMCy3lvrfydMEL02PIbH0aLfLK5nor01M0ZJw2TkV2WFYGI+nouqTGz7hJgFOD61qxIIUdw7X7vahGwwnrmTSj/CFejNbkIMRPe99N/Yq/myeKQwiLd+nkB58W8emkdfPsijTo48LacXXJTkBnQaaN2ct+TN+ezfi/IlDNNY+ql9byYAlPJN+uvWBKuUgwgnSf3dHZeag2IOuwW1qTAqg9j8pfGsNdEcLSbKejVNSXjWXVk+ZKCS3KTguPvCqgStIG/7PqkhgF70qBzt8CiNy0/IKkQPdwL4O9KK6t7s2JL3/rIvfCVFLqXlKKoWbIVbqfuk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15F6521F6D4F984DB7CF00A717EFBA38@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb991251-c3e6-4794-db98-08d6f359395d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:06.7341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIA0KDQpUaGlzIHNlcmllcyBpbmNsdWRlcyBtbHg1IHVwZGF0ZXMgZm9yIGJvdGggcmRtYSBh
bmQgbmV0LW5leHQgdHJlZXMuDQpJbiBjYXNlIG9mIG5vIG9iamVjdGlvbiBpdCB3aWxsIGJlIGFw
cGxpZWQgdG8gbWx4NS1uZXh0IGJyYW5jaCBhbmQgbGF0ZXINCm9uIHdpbGwgYmUgc2VudCBhcyBw
dWxsIHJlcXVlc3QgdG8gcmRtYSBhbmQgbmV0LW5leHQuDQoNCjEpIEZyb20gQm9kb25nLCBFLVN3
aXRjaCB2cG9ydCBjbGVhbnVwcyBwYXRjaGVzLg0KDQoyKSBGcm9tIEppYW5ibywgVnBvcnQgbWV0
YSBkYXRhIG1hdGNoaW5nOg0KDQpIYXJkd2FyZSBzdGVlcmluZyBoYXMgbm8gbm90aW9uIG9mIHZw
b3J0IG51bWJlciwgYW5kIHZwb3J0IGlzIGFuDQphYnN0cmFjdCBjb25jZXB0LCBzbyBmaXJtd2Fy
ZSBuZWVkIHRvIHRyYW5zbGF0ZSB0aGUgc291cmNlIHZwb3J0DQptYXRjaGluZyB0byBtYXRjaCBv
biB0aGUgVkhDQSBJRCAoVmlydHVhbCBIQ0EgSUQpLg0KDQpJbiBkdWFsLXBvcnQgUm9DRSwgdGhl
IGR1YWwtcG9ydCBWSENBIGlzIGFibGUgdG8gc2VuZCBhbHNvIG9uIHRoZQ0Kc2Vjb25kIHBvcnQg
b24gYmVoYWxmIG9mIHRoZSBhZmZpbGlhdGVkIHZwb3J0LCBzbyBub3cgd2UgY2Fu4oCZdCBhc3N1
bWUNCmFueW1vcmUgdGhhdCB2cG9ydCBpcyByZXByZXNlbnRlZCBieSBzaW5nbGUgVkhDQSBvbmx5
Lg0KDQpUbyByZXNvbHZlIHRoaXMgaXNzdWUsIHdlIHVzZSBtZXRhZGF0YSByZWdpc3RlciBhcyBz
b3VyY2UgcG9ydA0KaW5kaWNhdG9yIGluc3RlYWQuDQoNCldoZW4gYSBwYWNrZXQgZW50ZXJzIHRo
ZSBlc3dpdGNoLCBlc3dpdGNoIGluZ3Jlc3MgdHJhZmZpYyBwYXNzZXMgdGhlDQppbmdyZXNzIEFD
TCBmbG93IHRhYmxlcywgd2hlcmUgd2UgdGFnIHRoZSBwYWNrZXRzICh2aWEgdGhlIG1ldGFkYXRh
DQp2YWx1ZSwgaW4gdGhpcyBjYXNlIFJFR19DIGF0IGluZGV4IDApIHdpdGggYSB1bmlxdWUgdmFs
dWUgd2hpY2ggd2lsbA0KYWN0IGFzIGFuIGFsaWFzIG9mIHRoZSB2cG9ydC4gSW4gb3JkZXIgdG8g
Z3VhcmFudGVlIHVuaXF1ZW5lc3MsIHdlIHVzZQ0KdGhlIGVzd2l0Y2ggb3duZXIgdmhjYSBpZCBh
bmQgdGhlIHZwb3J0IG51bWJlciBhcyB0aGF0IHZhbHVlLg0KDQpVc3VhbGx5LCB0aGUgdnBvcnRz
IGFyZSBudW1iZXJlZCBpbiBlYWNoIGVzd2l0Y2ggYXMgZm9sbG93ZWQ6DQogICAgLSBQaHlzaWNh
bCBGdW5jdGlvbiAoUEYpIHZwb3J0LCB0aGUgbnVtYmVyIGlzIDAuDQogICAgLSBWaXJ0dWFsIEZ1
bmN0aW9uIChWRikgdnBvcnQsIHN0YXJ0aW5nIGZyb20gMS4NCiAgICAtIFVwbGluayB2cG9ydCwg
dGhlIHJlc2VydmVkIHZwb3J0IG51bWJlciBmb3IgaXQgaXMgMHhGRkZGLg0KDQpXaXRoIHRoZSBt
ZXRhZGF0YSBpbiBlYWNoIHBhY2tldCwgd2UgY2FuIHRoZW4gZG8gbWF0Y2hpbmcgb24gaXQsIGlu
DQpib3RoIGZhc3QgcGF0aCBhbmQgc2xvdyBwYXRoLg0KDQpGb3Igc2xvdyBwYXRoLCB0aGVyZSBp
cyBhIHJlcHJlc2VudG9yIGZvciBlYWNoIHZwb3J0LiBQYWNrZXQgdGhhdA0KbWlzc2VzIGFsbCBv
ZmZsb2FkZWQgcnVsZXMgaW4gRkRCLCB3aWxsIGJlIGZvcndhcmRlZCB0byB0aGUgZXN3aXRjaA0K
bWFuYWdlciB2cG9ydC4gSW4gaXRzIE5JQyBSWCwgaXQgdGhlbiB3aWxsIGJlIHN0ZWVyZWQgdG8g
dGhlIHJpZ2h0DQpyZXByZXNlbnRvci4gVGhlIHJ1bGVzLCB3aGljaCBkZWNpZGUgdGhlIGRlc3Rp
bmF0aW9uIHJlcHJlc2VudG9yLA0KcHJldmlvdXNseSB3ZXJlIG1hdGNoaW5nIG9uIHNvdXJjZSBw
b3J0LCB3aWxsIG5vdyBtYXRjaCBtZXRhZGF0YQ0KaW5zdGVhZC4NCg0KLS0tDQoNCkJvZG9uZyBX
YW5nICgzKToNCiAgbmV0L21seDU6IEUtU3dpdGNoLCBVc2UgdnBvcnQgaW5kZXggd2hlbiBpbml0
IHJlcA0KICB7SUIsIG5ldH0vbWx4NTogRS1Td2l0Y2gsIFVzZSBpbmRleCBvZiByZXAgZm9yIHZw
b3J0IHRvIElCIHBvcnQNCiAgICBtYXBwaW5nDQogIFJETUEvbWx4NTogQ2xlYW51cCByZXAgd2hl
biBkb2luZyB1bmxvYWQNCg0KSmlhbmJvIExpdSAoMTIpOg0KICBuZXQvbWx4NTogSW50cm9kdWNl
IHZwb3J0IG1ldGFkYXRhIG1hdGNoaW5nIGJpdHMgYW5kIGVudW0gY29uc3RhbnRzDQogIG5ldC9t
bHg1OiBHZXQgdnBvcnQgQUNMIG5hbWVzcGFjZSBieSB2cG9ydCBpbmRleA0KICBuZXQvbWx4NTog
U3VwcG9ydCBhbGxvY2F0aW5nIG1vZGlmeSBoZWFkZXIgY29udGV4dCBmcm9tIGluZ3Jlc3MgQUNM
DQogIG5ldC9tbHg1OiBBZGQgZmxvdyBjb250ZXh0IGZvciBmbG93IHRhZw0KICBuZXQvbWx4NTog
RS1Td2l0Y2gsIFRhZyBwYWNrZXQgd2l0aCB2cG9ydCBudW1iZXIgaW4gVkYgdnBvcnRzIGFuZA0K
ICAgIHVwbGluayBpbmdyZXNzIEFDTHMNCiAgbmV0L21seDVlOiBTcGVjaWZ5aW5nIGtub3duIG9y
aWdpbiBvZiBwYWNrZXRzIG1hdGNoaW5nIHRoZSBmbG93DQogIG5ldC9tbHg1OiBFLVN3aXRjaCwg
QWRkIG1hdGNoIG9uIHZwb3J0IG1ldGFkYXRhIGZvciBydWxlIGluIGZhc3QgcGF0aA0KICBuZXQv
bWx4NTogRS1Td2l0Y2gsIEFkZCBxdWVyeSBhbmQgbW9kaWZ5IGVzdyB2cG9ydCBjb250ZXh0IGZ1
bmN0aW9ucw0KICBuZXQvbWx4NTogRS1Td2l0Y2gsIFBhc3MgbWV0YWRhdGEgZnJvbSBGREIgdG8g
ZXN3aXRjaCBtYW5hZ2VyDQogIG5ldC9tbHg1OiBFLVN3aXRjaCwgQWRkIG1hdGNoIG9uIHZwb3J0
IG1ldGFkYXRhIGZvciBydWxlIGluIHNsb3cgcGF0aA0KICBSRE1BL21seDU6IEFkZCB2cG9ydCBt
ZXRhZGF0YSBtYXRjaGluZyBmb3IgSUIgcmVwcmVzZW50b3JzDQogIG5ldC9tbHg1OiBFLVN3aXRj
aCwgRW5hYmxlIHZwb3J0IG1ldGFkYXRhIG1hdGNoaW5nIGlmIGZpcm13YXJlDQogICAgc3VwcG9y
dHMgaXQNCg0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2Zsb3cuYyAgICAgICAgICAgICB8
ICAxMyArLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jICAgICAgICAgICB8
ICAzMyArLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5oICAgICAgICAgICB8
ICAxNiArDQogZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jICAgICAgICAgICAgIHwg
IDc1ICsrLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21seDVfaWIuaCAgICAgICAgICB8
ICAgMiArLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9mc190cmFjZXBvaW50LmggICB8
ICAgNCArLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZnNfZXRodG9vbC5jICAgICAgICB8
ICAgMiArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMgICB8
ICAgNyArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyB8
ICAzMCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCB8
ICAxNCArDQogLi4uL21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgICAgIHwg
NDk0ICsrKysrKysrKysrKysrLS0tLQ0KIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZnBnYS9pcHNlYy5jICB8ICAgOCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2ZzX2NtZC5jICB8ICAxMCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2ZzX2NvcmUuYyB8ICAzNCArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2ZzX2NvcmUuaCB8ICAgMSArDQogaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2guaCAgICAg
ICAgICAgICAgICAgIHwgICA1ICsNCiBpbmNsdWRlL2xpbnV4L21seDUvZnMuaCAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMTYgKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaCAgICAg
ICAgICAgICAgICAgfCAgNTYgKy0NCiAxOCBmaWxlcyBjaGFuZ2VkLCA2MzkgaW5zZXJ0aW9ucygr
KSwgMTgxIGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMjEuMA0KDQo=
