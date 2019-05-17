Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36E21F03
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfEQUTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:19:46 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbfEQUTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHI5Y6+8RzsJY+mddIz06jNM3RV2PKYPEEWQ+qa33Xo=;
 b=cHR8f5dnzm43NChy9wP+xFV2JuwCGeVFESmJ3/1aAjT2u3seB94P7qfSHD3Cftu+geZnAkDIDS6Yful1l803M2k+TpZWhXuaczVmr0CwEF7uIMLMUADticc2f3ljtGb6jPnjDbt/rG0szdK4ORDEMzL6u9Wos1LMUL3cU6GaGq4=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:29 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/11] Mellanox, mlx5 fixes 2019-05-17
Thread-Topic: [pull request][net 00/11] Mellanox, mlx5 fixes 2019-05-17
Thread-Index: AQHVDO3UIGJOaLducESn9jxMoQ0ffQ==
Date:   Fri, 17 May 2019 20:19:29 +0000
Message-ID: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72b99755-8d7a-452b-6d28-08d6db04f68e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB61383BA57EF540B651FDD826BE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(305945005)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ONGC4vfZXmqoTdc5blw4SmP+hjylKCBOVW1tWtrhnkgvf+7mHlD3Z4z5OV7+4lQmLHS3TNdUzQrWCWasCvU/CurncG0v12D+rmSJKpob8V43BmQ9yYLW5oRW91dOhL3FE4fiE4VMsVDcVbC7Ctfy8AIZ7leGqFnlo8Ml5KepT1jczuPGLlS+FR+Jn7IeRi+e8pkXQU6ElyIQguxvm9CFww9gkRZl6A2DLUs3x1B66wvP4pujEMsoVKSIU9bji+3xwyyxX+IyJzFgLu3DVbhoynUjxUaTg927ySFPuGG92RvU/bcvbyh0y8lV3qvca16Ed2CMmKMm3DqGEbVKL+uZL2W3BTLpvKRYvjtOlf1xGyHNGsS6rLq340N/c1YDk3y1R18h178DjxzTAiRNYQ2FUS2m511g3cMSilar7ARsYT4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b99755-8d7a-452b-6d28-08d6db04f68e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:29.3568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwNCg0KVGhpcyBzZXJpZXMgaW50cm9kdWNlcyBzb21lIGZpeGVzIHRvIG1seDUgZHJp
dmVyLg0KRm9yIG1vcmUgaW5mb3JtYXRpb24gcGxlYXNlIHNlZSB0YWcgbG9nIGJlbG93Lg0KDQpQ
bGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQoNCkZv
ciAtc3RhYmxlIHY0LjE5DQogIG5ldC9tbHg1ZTogRml4IGV0aHRvb2wgcnhmaCBjb21tYW5kcyB3
aGVuIENPTkZJR19NTFg1X0VOX1JYTkZDIGlzIGRpc2FibGVkDQogIG5ldC9tbHg1OiBJbXBseSBN
TFhGVyBpbiBtbHg1X2NvcmUNCg0KRm9yIC1zdGFibGUgdjUuMA0KICBuZXQvbWx4NWU6IEFkZCBt
aXNzaW5nIGV0aHRvb2wgZHJpdmVyIGluZm8gZm9yIHJlcHJlc2VudG9ycw0KICBuZXQvbWx4NWU6
IEFkZGl0aW9uYWwgY2hlY2sgZm9yIGZsb3cgZGVzdGluYXRpb24gY29tcGFyaXNvbg0KDQpGb3Ig
LXN0YWJsZSB2NS4xDQogIG5ldC9tbHg1OiBGaXggcGVlciBwZiBkaXNhYmxlIGhjYSBjb21tYW5k
DQoNClRoYW5rcywNClNhZWVkLg0KDQotLS0NClRoZSBmb2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBj
b21taXQgNTU5MzUzMGU1Njk0MzE4MmViYjZkODFlY2E4YTNiZTZkYjZkYmJhNDoNCg0KICBSZXZl
cnQgInRpcGM6IGZpeCBtb2Rwcm9iZSB0aXBjIGZhaWxlZCBhZnRlciBzd2l0Y2ggb3JkZXIgb2Yg
ZGV2aWNlIHJlZ2lzdHJhdGlvbiIgKDIwMTktMDUtMTcgMTI6MTU6MDUgLTA3MDApDQoNCmFyZSBh
dmFpbGFibGUgaW4gdGhlIEdpdCByZXBvc2l0b3J5IGF0Og0KDQogIGdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zYWVlZC9saW51eC5naXQgdGFncy9tbHg1LWZp
eGVzLTIwMTktMDUtMTcNCg0KZm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVwIHRvIGU3NzM5YTYw
NzEyYTA0MTUxNmY3NGM4OTE3YTBiM2U1ZjFlNGYwMWU6DQoNCiAgbmV0L21seDVlOiBGaXggcG9z
c2libGUgbW9kaWZ5IGhlYWRlciBhY3Rpb25zIG1lbW9yeSBsZWFrICgyMDE5LTA1LTE3IDEzOjE2
OjQ5IC0wNzAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQptbHg1LWZpeGVzLTIwMTktMDUtMTcNCg0KLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
Qm9kb25nIFdhbmcgKDEpOg0KICAgICAgbmV0L21seDU6IEZpeCBwZWVyIHBmIGRpc2FibGUgaGNh
IGNvbW1hbmQNCg0KRG15dHJvIExpbmtpbiAoMik6DQogICAgICBuZXQvbWx4NWU6IEFkZCBtaXNz
aW5nIGV0aHRvb2wgZHJpdmVyIGluZm8gZm9yIHJlcHJlc2VudG9ycw0KICAgICAgbmV0L21seDVl
OiBBZGRpdGlvbmFsIGNoZWNrIGZvciBmbG93IGRlc3RpbmF0aW9uIGNvbXBhcmlzb24NCg0KRWxp
IEJyaXRzdGVpbiAoMyk6DQogICAgICBuZXQvbWx4NWU6IEZpeCBudW1iZXIgb2YgdnBvcnRzIGZv
ciBpbmdyZXNzIEFDTCBjb25maWd1cmF0aW9uDQogICAgICBuZXQvbWx4NWU6IEZpeCBubyByZXdy
aXRlIGZpZWxkcyB3aXRoIHRoZSBzYW1lIG1hdGNoDQogICAgICBuZXQvbWx4NWU6IEZpeCBwb3Nz
aWJsZSBtb2RpZnkgaGVhZGVyIGFjdGlvbnMgbWVtb3J5IGxlYWsNCg0KUGFyYXYgUGFuZGl0ICgx
KToNCiAgICAgIG5ldC9tbHg1OiBFLVN3aXRjaCwgQ29ycmVjdCB0eXBlIHRvIHUxNiBmb3IgdnBv
cnRfbnVtIGFuZCBpbnQgZm9yIHZwb3J0X2luZGV4DQoNClNhZWVkIE1haGFtZWVkICgyKToNCiAg
ICAgIG5ldC9tbHg1OiBJbXBseSBNTFhGVyBpbiBtbHg1X2NvcmUNCiAgICAgIG5ldC9tbHg1ZTog
Rml4IGV0aHRvb2wgcnhmaCBjb21tYW5kcyB3aGVuIENPTkZJR19NTFg1X0VOX1JYTkZDIGlzIGRp
c2FibGVkDQoNClRhcmlxIFRvdWthbiAoMSk6DQogICAgICBuZXQvbWx4NWU6IEZpeCB3cm9uZyB4
bWl0X21vcmUgYXBwbGljYXRpb24NCg0KVmFsZW50aW5lIEZhdGlldiAoMSk6DQogICAgICBuZXQv
bWx4NTogQWRkIG1lYW5pbmdmdWwgcmV0dXJuIGNvZGVzIHRvIHN0YXR1c190b19lcnIgZnVuY3Rp
b24NCg0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jICAgICAgICAgICAgICAg
IHwgMTMgKysrKysrLS0tLS0NCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuaCAg
ICAgICAgICAgICAgICB8IDEyICsrKysrLS0tLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvS2NvbmZpZyAgICB8ICAxICsNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvY21kLmMgICAgICB8IDIyICsrKysrKysrKysrKysrKysrLQ0KIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lY3BmLmMgICAgIHwgIDIgKy0N
CiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9ldGh0b29sLmMgICB8IDE4
ICsrKysrKysrKysrKysrLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9yZXAuYyAgIHwgMTkgKysrKysrKysrKysrKystDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMgICAgfCAyNyArKysrKysrKysrKysrKysrLS0tLS0t
DQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3R4LmMgICAgfCAg
OSArKysrLS0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoLmMgIHwgMjAgKysrKysrKystLS0tLS0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lc3dpdGNoLmggIHwgMjIgKysrKysrKysrLS0tLS0tLS0tDQogLi4uL2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgfCAyMCArKysrKysr
Ky0tLS0tLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2Nv
cmUuYyAgfCAgMiArKw0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2lwb2li
L2lwb2liLmMgIHwgIDIgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9p
cG9pYi9pcG9pYi5oICB8ICAzICsrLQ0KIGluY2x1ZGUvbGludXgvbWx4NS9lc3dpdGNoLmggICAg
ICAgICAgICAgICAgICAgICAgIHwgIDYgKystLS0NCiAxNiBmaWxlcyBjaGFuZ2VkLCAxMzYgaW5z
ZXJ0aW9ucygrKSwgNjIgZGVsZXRpb25zKC0pDQo=
