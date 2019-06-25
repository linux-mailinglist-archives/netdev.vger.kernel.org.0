Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508A75562F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbfFYRrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:47:55 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:15870
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbfFYRry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKDrVFgUU5PbxzwVTw3OD0RZcZV9T7qgQbZHn7vIhV0=;
 b=jxn4tieFUXFEBLS2znHHOaG9V8IhHKxpV/wKx4yVAs0rCl1U/wpffuN9POW2EvPN5Ovvp13SXoEJQZPdKv273cllQqRBxTiyvXq+yQPIXQrfTu9HRFYEEwf0lRt+tq5Th49/BzxIxpGu+8VIIgfM7GbZHkAlyotrRZhg4qjYOvE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:47:48 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:47:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH V2 mlx5-next 00/13] Mellanox, mlx5 vport metadata matching
Thread-Topic: [PATCH V2 mlx5-next 00/13] Mellanox, mlx5 vport metadata
 matching
Thread-Index: AQHVK34a1Kbi2wF+mkOypz3S1XQRsQ==
Date:   Tue, 25 Jun 2019 17:47:48 +0000
Message-ID: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5af2db9a-7d05-4cc2-7b43-08d6f9953c66
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB221698997FA5B747AB1BFDEABEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(14444005)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(450100002)(4326008)(486006)(7736002)(8676002)(66556008)(64756008)(66946007)(73956011)(99286004)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J9Ks5uNtU6DjTOZ/RdOHAKrOnZQ1BTU5D0P3tBbgXFlQNFBV7EQBaXUcWTNkG4V7BlhY7sQeb29UeHuMkiTPgfr2OAHm9wC2P1UKZZthgRXnHh7kUX2kHSayd5AsjjyfZEqS+60c56iaIZNu7cq2TMUZOrEQ+W5jLrSHNCtELVjEVumm0lfNwRVBYvXzq8lJiduPwBBqCawzj0S0h3unh2h1J6Hx/hZCXk8uvtmLzPTLTTFb/kHX/xHik0k08bWPWd/lKSqSda+op3xco3LsbDkYX/f5jbnGS8FJjQzEkiVMLNulpEKPar7ZazKXtQIWdHURMt43mTPGUKrclGxJIbtkytYk263RtqpynhSkJ19KbBtatAoU4ua/niX1ljtZLgmLSTzllEB/u/IFPOXoPBkYeFo9ihHa5XYgup//8Xg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79E22F8C25CF8C42B436A0606522F85A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af2db9a-7d05-4cc2-7b43-08d6f9953c66
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:47:48.2890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBzZXJpZXMgaW5jbHVkZXMgbWx4NSB1cGRhdGVzIGZvciBib3RoIHJkbWEgYW5kIG5ldC1u
ZXh0IHRyZWVzLg0KSW4gY2FzZSBvZiBubyBvYmplY3Rpb24gaXQgd2lsbCBiZSBhcHBsaWVkIHRv
IG1seDUtbmV4dCBicmFuY2ggYW5kIGxhdGVyDQpvbiB3aWxsIGJlIHNlbnQgYXMgcHVsbCByZXF1
ZXN0IHRvIHJkbWEgYW5kIG5ldC1uZXh0Lg0KDQpGcm9tIEppYW5ibywgVnBvcnQgbWV0YSBkYXRh
IG1hdGNoaW5nOg0KDQpIYXJkd2FyZSBzdGVlcmluZyBoYXMgbm8gbm90aW9uIG9mIHZwb3J0IG51
bWJlciwgYW5kIHZwb3J0IGlzIGFuDQphYnN0cmFjdCBjb25jZXB0LCBzbyBmaXJtd2FyZSBuZWVk
IHRvIHRyYW5zbGF0ZSB0aGUgc291cmNlIHZwb3J0DQptYXRjaGluZyB0byBtYXRjaCBvbiB0aGUg
VkhDQSBJRCAoVmlydHVhbCBIQ0EgSUQpLg0KDQpJbiBkdWFsLXBvcnQgUm9DRSwgdGhlIGR1YWwt
cG9ydCBWSENBIGlzIGFibGUgdG8gc2VuZCBhbHNvIG9uIHRoZQ0Kc2Vjb25kIHBvcnQgb24gYmVo
YWxmIG9mIHRoZSBhZmZpbGlhdGVkIHZwb3J0LCBzbyBub3cgd2UgY2Fu4oCZdCBhc3N1bWUNCmFu
eW1vcmUgdGhhdCB2cG9ydCBpcyByZXByZXNlbnRlZCBieSBzaW5nbGUgVkhDQSBvbmx5Lg0KDQpU
byByZXNvbHZlIHRoaXMgaXNzdWUsIHdlIHVzZSBtZXRhZGF0YSByZWdpc3RlciBhcyBzb3VyY2Ug
cG9ydA0KaW5kaWNhdG9yIGluc3RlYWQuDQoNCldoZW4gYSBwYWNrZXQgZW50ZXJzIHRoZSBlc3dp
dGNoLCBlc3dpdGNoIGluZ3Jlc3MgdHJhZmZpYyBwYXNzZXMgdGhlDQppbmdyZXNzIEFDTCBmbG93
IHRhYmxlcywgd2hlcmUgd2UgdGFnIHRoZSBwYWNrZXRzICh2aWEgdGhlIG1ldGFkYXRhDQp2YWx1
ZSwgaW4gdGhpcyBjYXNlIFJFR19DIGF0IGluZGV4IDApIHdpdGggYSB1bmlxdWUgdmFsdWUgd2hp
Y2ggd2lsbA0KYWN0IGFzIGFuIGFsaWFzIG9mIHRoZSB2cG9ydC4gSW4gb3JkZXIgdG8gZ3VhcmFu
dGVlIHVuaXF1ZW5lc3MsIHdlIHVzZQ0KdGhlIGVzd2l0Y2ggb3duZXIgdmhjYSBpZCBhbmQgdGhl
IHZwb3J0IG51bWJlciBhcyB0aGF0IHZhbHVlLg0KDQpVc3VhbGx5LCB0aGUgdnBvcnRzIGFyZSBu
dW1iZXJlZCBpbiBlYWNoIGVzd2l0Y2ggYXMgZm9sbG93ZWQ6DQogICAgLSBQaHlzaWNhbCBGdW5j
dGlvbiAoUEYpIHZwb3J0LCB0aGUgbnVtYmVyIGlzIDAuDQogICAgLSBWaXJ0dWFsIEZ1bmN0aW9u
IChWRikgdnBvcnQsIHN0YXJ0aW5nIGZyb20gMS4NCiAgICAtIFVwbGluayB2cG9ydCwgdGhlIHJl
c2VydmVkIHZwb3J0IG51bWJlciBmb3IgaXQgaXMgMHhGRkZGLg0KDQpXaXRoIHRoZSBtZXRhZGF0
YSBpbiBlYWNoIHBhY2tldCwgd2UgY2FuIHRoZW4gZG8gbWF0Y2hpbmcgb24gaXQsIGluDQpib3Ro
IGZhc3QgcGF0aCBhbmQgc2xvdyBwYXRoLg0KDQpGb3Igc2xvdyBwYXRoLCB0aGVyZSBpcyBhIHJl
cHJlc2VudG9yIGZvciBlYWNoIHZwb3J0LiBQYWNrZXQgdGhhdA0KbWlzc2VzIGFsbCBvZmZsb2Fk
ZWQgcnVsZXMgaW4gRkRCLCB3aWxsIGJlIGZvcndhcmRlZCB0byB0aGUgZXN3aXRjaA0KbWFuYWdl
ciB2cG9ydC4gSW4gaXRzIE5JQyBSWCwgaXQgdGhlbiB3aWxsIGJlIHN0ZWVyZWQgdG8gdGhlIHJp
Z2h0DQpyZXByZXNlbnRvci4gVGhlIHJ1bGVzLCB3aGljaCBkZWNpZGUgdGhlIGRlc3RpbmF0aW9u
IHJlcHJlc2VudG9yLA0KcHJldmlvdXNseSB3ZXJlIG1hdGNoaW5nIG9uIHNvdXJjZSBwb3J0LCB3
aWxsIG5vdyBtYXRjaCBtZXRhZGF0YQ0KaW5zdGVhZC4NCg0KVjI6DQotIFJlbW92ZSBlc3dpdGNo
IGNsZWFudXAgcGF0Y2hlcyBmcm9tIGJvZG9uZywgd2lsbCBzdWJtaXQgbGF0ZXIuDQotIFJlbW92
ZSBJQiBzcGVjaWZpZWQgQVBJcyAobWx4NV9pYl9lc3dpdGNoXyopIGFkZGVkIGluIFYxLg0KLSBB
ZGQgbWx4NV9lc3dpdGNoX2lzX3ZmX3Zwb3J0KCkgdG8gY2hlY2sgaWYgdGhlIHZwb3J0IGlzIFZG
IHZwb3J0Lg0KLSBPdGhlciBzbWFsbCBjaGFuZ2VzLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KLS0t
DQoNCkppYW5ibyBMaXUgKDEyKToNCiAgbmV0L21seDU6IEludHJvZHVjZSB2cG9ydCBtZXRhZGF0
YSBtYXRjaGluZyBiaXRzIGFuZCBlbnVtIGNvbnN0YW50cw0KICBuZXQvbWx4NTogR2V0IHZwb3J0
IEFDTCBuYW1lc3BhY2UgYnkgdnBvcnQgaW5kZXgNCiAgbmV0L21seDU6IFN1cHBvcnQgYWxsb2Nh
dGluZyBtb2RpZnkgaGVhZGVyIGNvbnRleHQgZnJvbSBpbmdyZXNzIEFDTA0KICBuZXQvbWx4NTog
QWRkIGZsb3cgY29udGV4dCBmb3IgZmxvdyB0YWcNCiAgbmV0L21seDU6IEUtU3dpdGNoLCBUYWcg
cGFja2V0IHdpdGggdnBvcnQgbnVtYmVyIGluIFZGIHZwb3J0cyBhbmQNCiAgICB1cGxpbmsgaW5n
cmVzcyBBQ0xzDQogIG5ldC9tbHg1ZTogU3BlY2lmeWluZyBrbm93biBvcmlnaW4gb2YgcGFja2V0
cyBtYXRjaGluZyB0aGUgZmxvdw0KICBuZXQvbWx4NTogRS1Td2l0Y2gsIEFkZCBtYXRjaCBvbiB2
cG9ydCBtZXRhZGF0YSBmb3IgcnVsZSBpbiBmYXN0IHBhdGgNCiAgbmV0L21seDU6IEUtU3dpdGNo
LCBBZGQgcXVlcnkgYW5kIG1vZGlmeSBlc3cgdnBvcnQgY29udGV4dCBmdW5jdGlvbnMNCiAgbmV0
L21seDU6IEUtU3dpdGNoLCBQYXNzIG1ldGFkYXRhIGZyb20gRkRCIHRvIGVzd2l0Y2ggbWFuYWdl
cg0KICBuZXQvbWx4NTogRS1Td2l0Y2gsIEFkZCBtYXRjaCBvbiB2cG9ydCBtZXRhZGF0YSBmb3Ig
cnVsZSBpbiBzbG93IHBhdGgNCiAgUkRNQS9tbHg1OiBBZGQgdnBvcnQgbWV0YWRhdGEgbWF0Y2hp
bmcgZm9yIElCIHJlcHJlc2VudG9ycw0KICBuZXQvbWx4NTogRS1Td2l0Y2gsIEVuYWJsZSB2cG9y
dCBtZXRhZGF0YSBtYXRjaGluZyBpZiBmaXJtd2FyZQ0KICAgIHN1cHBvcnRzIGl0DQoNClBhcmF2
IFBhbmRpdCAoMSk6DQogIG5ldC9tbHg1OiBJbnRyb2R1Y2UgYSBoZWxwZXIgQVBJIHRvIGNoZWNr
IFZGIHZwb3J0DQoNCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9mbG93LmMgICAgICAgICAg
ICAgfCAgMTMgKy0NCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMgICAgICAgICAg
ICAgfCAgNzUgKystDQogZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9pYi5oICAgICAg
ICAgIHwgICAxICsNCiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZnNfdHJhY2Vwb2ludC5o
ICAgfCAgIDQgKy0NCiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2VuX2ZzX2V0aHRvb2wuYyAgICAg
ICAgfCAgIDIgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5j
ICAgfCAgIDcgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNo
LmMgfCAgMzAgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNo
LmggfCAgMTYgKw0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jICAg
ICB8IDUwMCArKysrKysrKysrKysrKy0tLS0NCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2ZwZ2EvaXBzZWMuYyAgfCAgIDggKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9mc19jbWQuYyAgfCAgMTAgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9mc19jb3JlLmMgfCAgMzQgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9mc19jb3JlLmggfCAgIDEgKw0KIGluY2x1ZGUvbGludXgvbWx4NS9lc3dpdGNoLmgg
ICAgICAgICAgICAgICAgICB8ICAxNyArDQogaW5jbHVkZS9saW51eC9tbHg1L2ZzLmggICAgICAg
ICAgICAgICAgICAgICAgIHwgIDE2ICstDQogaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgg
ICAgICAgICAgICAgICAgIHwgIDU2ICstDQogMTYgZmlsZXMgY2hhbmdlZCwgNjIyIGluc2VydGlv
bnMoKyksIDE2OCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjIxLjANCg0K
