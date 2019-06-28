Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8595A77C
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfF1XTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:19:05 -0400
Received: from mail-eopbgr50055.outbound.protection.outlook.com ([40.107.5.55]:38726
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfF1XTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:19:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=C/iefrYTxnpL/Ja0gnW4TnInQW08bE5Gk4lT+Z6P67UKH28HoveJ4G0plg2Xq8WBrTfsEGuAU4ecGLzVwoXSY1yKXhscHIzJR34mtWQznt8EavSwrpo5kDqry1KukMJvfg/TZa+umntztBJKgrfmHCKzInJK/yoLPda4SdLWMLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUb3pScgEu1p/Mrcms7FbKZHP7Htexg38xs+AJ6GWjQ=;
 b=oiDjzrGLgBJ2apKmRtY3zsgT05J8P1air/3w+viDWuFF89xP5haW2bm8LEDmlmLng15dXZyMhnbWPrSbT7cPMrQMaN0pqBR0OSazPTcUHXC7b6JD4wB2iXV7pTprZ3RAHH22wWNfH2jM112OSW41UcUedTGW2cHbVDair9lQQT8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUb3pScgEu1p/Mrcms7FbKZHP7Htexg38xs+AJ6GWjQ=;
 b=bQWOfab0CEH4EzymFGIgI5MBCWB5xxy8oNnsKnCFS/fqablwZjXDintsny+jiPQKYvZx0Y9KUAho0JvKJuu2iAKOs9t3HRieKPbQg1hq5EJ7PYPmuIhv10rlh5iAnbLd9zB8k7lBCwjLtYYC5FVn19kZ2HdDmWF0XelA4/0DsPk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:18 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/10] Mellanox, mlx5e updates 2019-06-28
Thread-Topic: [pull request][net-next 00/10] Mellanox, mlx5e updates
 2019-06-28
Thread-Index: AQHVLgfFeDbzIwOuiU+N0YKsRbZo2Q==
Date:   Fri, 28 Jun 2019 23:18:18 +0000
Message-ID: <20190628231759.16374-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c799a27-1db2-4a33-bd6d-08d6fc1ee77c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2198C947F2AF2FB1D1AAA773BEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(53936002)(66946007)(66556008)(15650500001)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(6306002)(73956011)(305945005)(66066001)(99286004)(4326008)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(966005)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n+XzyTJZhAZhqgzYvnQhnFYwuCLjI+pgff0KYecc+1WTt+1uNXfz5oEyJIwZ8Vd0oonXNx4uzvSsSB96P7dOskx/PrLxOanVJxPHlm2bo9lSQkOV87wTuXPQhaCiMTDdTfrU/EZwFaLqSqyENFxvT+xTmHR28SFp0dC1cE6LTpHFGY1voWK+vzEKRoJLyfnqFNPfpkvR5ea6HU5oNzsN18gq5Y9Z1PYol9/FdaYUCuUNWaYvx2E1CZf/3OmLkBuoI9sDxMnI4oZXdC9gAmhCJVvkXZIeZrm8KAqcTPM6xtA6VGNMApbdaYurE1uON0X4zFDVsqvPUC8RU7s8gofkdHG9VHt8MrnCKuGSrfE90Lhtj2e4GZ6WERJ92Uh/RXjhNmo78f6lXy61J5OC7f9EafElPAfRMRzDQRhbgHLzpPU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c799a27-1db2-4a33-bd6d-08d6fc1ee77c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:18.5376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwNCg0KVGhpcyBzZXJpZXMgYWRkcyBtaXNjIHVwZGF0ZXMgdG8gbWx4NWUgZHJpdmVy
Lg0KRm9yIG1vcmUgaW5mb3JtYXRpb24gcGxlYXNlIHNlZSB0YWcgbG9nIGJlbG93Lg0KDQpQbGVh
c2UgcHVsbCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQoNClBsZWFz
ZSBub3RlIHRoYXQgdGhlIHNlcmllcyBzdGFydHMgd2l0aCBhIG1lcmdlIG9mIG1seDUtbmV4dCBi
cmFuY2gsDQp0byByZXNvbHZlIGFuZCBhdm9pZCBkZXBlbmRlbmN5IHdpdGggcmRtYSB0cmVlLg0K
VGhpcyBwdWxsIHByb3ZpZGVzIHRoZSByZXNvbHV0aW9uIG9mIHRoZSBjb25mbGljdCByZXBvcnRl
ZCBieSBTdGVwaGVuOg0KaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMTkvNi8yNy8xMDE2DQoNClRo
YW5rcywNClNhZWVkLg0KDQotLS0NClRoZSBmb2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQg
NGY1ZDFiZWFkYzEwYjYyZTE0MTMzODU3MGI5YzMyZDg1NzgxNGJiMDoNCg0KICBNZXJnZSBicmFu
Y2ggJ21seDUtbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L21lbGxhbm94L2xpbnV4ICgyMDE5LTA2LTI4IDE2OjAzOjU0IC0wNzAwKQ0KDQphcmUg
YXZhaWxhYmxlIGluIHRoZSBHaXQgcmVwb3NpdG9yeSBhdDoNCg0KICBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc2FlZWQvbGludXguZ2l0IHRhZ3MvbWx4NWUt
dXBkYXRlcy0yMDE5LTA2LTI4DQoNCmZvciB5b3UgdG8gZmV0Y2ggY2hhbmdlcyB1cCB0byBmNmRj
MTI2NGYxYzAxOTc2YTg0MjM5ZDEwMzgzNTk2MDRlZTQyMDAxOg0KDQogIG5ldC9tbHg1ZTogRGlz
YWxsb3cgdGMgcmVkaXJlY3Qgb2ZmbG9hZCBjYXNlcyB3ZSBkb24ndCBzdXBwb3J0ICgyMDE5LTA2
LTI4IDE2OjA0OjAwIC0wNzAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQptbHg1ZS11cGRhdGVzLTIwMTktMDYtMjgN
Cg0KVGhpcyBzZXJpZXMgYWRkcyBzb21lIG1pc2MgdXBkYXRlcyBmb3IgbWx4NWUgZHJpdmVyDQoN
CjEpIEFsbG93IGFkZGluZyB0aGUgc2FtZSBtYWMgbW9yZSB0aGFuIG9uY2UgaW4gTVBGUyB0YWJs
ZQ0KMikgTW92ZSB0byBIVyBjaGVja3N1bW1pbmcgYWR2ZXJ0aXNpbmcNCjMpIFJlcG9ydCBuZXRk
ZXZpY2UgTVBMUyBmZWF0dXJlcw0KNCkgQ29ycmVjdCBwaHlzaWNhbCBwb3J0IG5hbWUgb2YgdGhl
IFBGIHJlcHJlc2VudG9yDQo1KSBSZWR1Y2Ugc3RhY2sgdXNhZ2UgaW4gbWx4NV9lc3dpdGNoX3Rl
cm10YmxfY3JlYXRlDQo2KSBSZWZyZXNoIFRJUiBpbXByb3ZlbWVudCBmb3IgcmVwcmVzZW50b3Jz
DQo3KSBFeHBvc2Ugc2FtZSBwaHlzaWNhbCBzd2l0Y2hfaWQgZm9yIGFsbCByZXByZXNlbnRvcnMN
Cg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KQXJpZWwgTGV2a292aWNoICgyKToNCiAgICAgIG5ldC9tbHg1ZTogTW92ZSB0
byBIVyBjaGVja3N1bW1pbmcgYWR2ZXJ0aXNpbmcNCiAgICAgIG5ldC9tbHg1ZTogUmVwb3J0IG5l
dGRldmljZSBNUExTIGZlYXR1cmVzDQoNCkFybmQgQmVyZ21hbm4gKDEpOg0KICAgICAgbmV0L21s
eDVlOiByZWR1Y2Ugc3RhY2sgdXNhZ2UgaW4gbWx4NV9lc3dpdGNoX3Rlcm10YmxfY3JlYXRlDQoN
CkdhdmkgVGVpdHogKDMpOg0KICAgICAgbmV0L21seDU6IE1QRlMsIENsZWFudXAgYWRkIE1BQyBm
bG93DQogICAgICBuZXQvbWx4NTogTVBGUywgQWxsb3cgYWRkaW5nIHRoZSBzYW1lIE1BQyBtb3Jl
IHRoYW4gb25jZQ0KICAgICAgbmV0L21seDVlOiBEb24ndCByZWZyZXNoIFRJUnMgd2hlbiB1cGRh
dGluZyByZXByZXNlbnRvciBTUXMNCg0KUGFyYXYgUGFuZGl0ICgyKToNCiAgICAgIG5ldC9tbHg1
ZTogQ29ycmVjdCBwaHlzX3BvcnRfbmFtZSBmb3IgUEYgcG9ydA0KICAgICAgbmV0L21seDVlOiBT
ZXQgZHJ2aW5mbyBpbiBnZW5lcmljIG1hbm5lcg0KDQpQYXVsIEJsYWtleSAoMik6DQogICAgICBu
ZXQvbWx4NWU6IEV4cG9zZSBzYW1lIHBoeXNpY2FsIHN3aXRjaF9pZCBmb3IgYWxsIHJlcHJlc2Vu
dG9ycw0KICAgICAgbmV0L21seDVlOiBEaXNhbGxvdyB0YyByZWRpcmVjdCBvZmZsb2FkIGNhc2Vz
IHdlIGRvbid0IHN1cHBvcnQNCg0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi5oICAgICAgIHwgIDIgKysNCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi90Y190dW4uYyAgICB8ICA0ICsrLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX2V0aHRvb2wuYyAgIHwgIDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jICB8IDIxICsrKysrKysrLS0tLQ0KIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyAgIHwgMzggKysrKysrKysr
Ky0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl90Yy5jICAgIHwgMjIgKysrKysrKysrKy0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl90Yy5oICAgIHwgIDMgKysNCiAuLi4vbWVsbGFub3gvbWx4NS9jb3Jl
L2Vzd2l0Y2hfb2ZmbG9hZHNfdGVybXRibC5jICB8ICAyICstDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYyAgfCAyMCArKysrKystLS0tLS0NCiAuLi4v
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9pcG9pYi9pcG9pYi5jICB8ICAzICstDQog
Li4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9pcG9pYi9pcG9pYl92bGFuLmMgfCAgMyAr
LQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvbXBmcy5jIHwg
MzMgKysrKysrKysrKysrLS0tLS0tLQ0KIGluY2x1ZGUvbGludXgvbWx4NS9mcy5oICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCiAxMyBmaWxlcyBjaGFuZ2VkLCA5NyBpbnNlcnRp
b25zKCspLCA1OCBkZWxldGlvbnMoLSkNCg==
