Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE57484A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 09:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbfGYHix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 03:38:53 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:16406
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388159AbfGYHix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 03:38:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgFVPiiBZlXNiVgdRW7/EpgFMdAmOSUhYrI/rsoCw/i34/k802pfDxWnPcS6qQFYoq40StwJhdBDZxetx4nwuJq6cu5JjZHT2hrJBKBUrrdjKVu+ihwAXCq+gv28onUd4wtM+ULE4VVN3enqtj+YyyYOjo9WxDciKmkPiIEBhY8lSIWHSSQbFs60lqfvNypWlSBFrRNX6SfInelDgXf4CxCNRKeYGjxy/KuRX5fEu2WJAX8OthrxtpYSahKUz/j6424yk374/V5QmRRGwdVvG0KtnhgWFVJa8C3zug6TycGZUVcMpWApKWYrV8TpPdfHu/DRJUNuCH3JYbEcHRIgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QM4pNNBfFvkp/k2hOvDKWY/XQHK7h/ATs0QUPFWHHU=;
 b=DM6GWCJMXSN9988xdvobiZvptIun2hajK4RcrYu8FWx36zqMKM6SHxaWAxdveXMdLj/Vx2K+QgKwotZ75D9VbZT8xKGLKg7FOpPEeeQ9JQv0S390ixbvK3XtZlYyUiPsdvp7f07uOkKzn5VpWnvNkM0Ex70jJOqxPbdxlRPCQcLo2Y1pHGNjr3Jf9qHqMgMZq0yoH2cTzXmH7BMA+a35LYtmjJ1khxkRywzfdKfLjQscanrwKMSk5kDSuZuJR4vyNUnlYXGrODzjHA0bcsdIA6dEUDLlcQJkUPLvk+cokax2hD/osnXYKdF8fm/uW8ZIpGiT2VPyc5sXFO/fSQSgMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QM4pNNBfFvkp/k2hOvDKWY/XQHK7h/ATs0QUPFWHHU=;
 b=pwejajOyLCUzrlh+dDcR48OkbPXtdre7nHSvX9tFfsR5PTyNv0KQnF0rUviXwHcRUBjI53iAXjXy8x2+T7Xw41itV4hh8pqBzpvkV7IwCq1q1eUGOZTOyooDJWoA3fFXYXuk/y6i/A7bIaBpE3yDGlFqsHCuMB2oDiixpkG4mHA=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4506.eurprd04.prod.outlook.com (52.135.141.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Thu, 25 Jul 2019 07:38:48 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 07:38:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Topic: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Index: AQHVOIgqonFULiHPO0eSKFSJ3ULGeqbbAsWQ
Date:   Thu, 25 Jul 2019 07:38:48 +0000
Message-ID: <DB7PR04MB461831872271A98E741FF68AE6C10@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a4a8a47-929f-4c08-6a2f-08d710d321ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4506;
x-ms-traffictypediagnostic: DB7PR04MB4506:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DB7PR04MB450664E1215EB8E7334D8890E6C10@DB7PR04MB4506.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(199004)(189003)(13464003)(7736002)(25786009)(2501003)(8936002)(316002)(6116002)(966005)(11346002)(446003)(3846002)(99286004)(76176011)(102836004)(6506007)(110136005)(66066001)(476003)(14454004)(53546011)(478600001)(2906002)(486006)(33656002)(68736007)(7696005)(229853002)(8676002)(81166006)(26005)(86362001)(53936002)(14444005)(55016002)(6436002)(76116006)(66946007)(5660300002)(256004)(6246003)(64756008)(186003)(66476007)(71200400001)(66556008)(6306002)(71190400001)(9686003)(74316002)(54906003)(305945005)(81156014)(4326008)(66446008)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4506;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OvsXXvnwHfU9jm6lFNGK9jU9niEE9ut/KPJoCkIrU8q2HZBVVqwfDYqF45Ah63jcJQ7nvqDrd1h3kokGUG1+B1gTxEciCZBQBg/qz2F1bcf11ziJQOJs+5XigZ0EsFhQmCbEppNda+7GEiPkaFVn4B79PGvlB2NfF2FOL9nCbmiAmGFtPgch+mItARtoQzuz9JWGSskgQJ0a2XHyEIIRw1eCc41CbYgM5DD8Y426dbpwbPQK804J03Gqalgf22eIxBF0rpGdb8UsjtENZflqtgXFSOSoWSLFwdeymwvAYAdBQnt3DoQlEHIfLwaU8nGnTX20FPaHrPOeng5vYNTMnBIIDv54hhVLX5cvXX9B2lwmDS2OCrnuv8yTMe2GabAuDlY6uj2UsrMTbExP2dLwnMhVKSt8BWnOreHojoxAeKg=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4a8a47-929f-4c08-6a2f-08d710d321ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 07:38:48.8410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4506
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQpLaW5kbHkgcGluZ2luZy4uLg0KDQpBZnRlciB5b3UgZ2l0IHB1bGwgcmVx
dWVzdCBmb3IgbGludXgtY2FuLW5leHQtZm9yLTUuNC0yMDE5MDcyNCwgc29tZSBwYXRjaGVzIGFy
ZSBtaXNzaW5nIGZyb20gbGludXgtY2FuLW5leHQvdGVzdGluZy4NCmNhbjogZmxleGNhbjogZmxl
eGNhbl9tYWlsYm94X3JlYWQoKSBtYWtlIHVzZSBvZiBmbGV4Y2FuX3dyaXRlNjQoKSB0byBtYXJr
IHRoZSBtYWlsYm94IGFzIHJlYWQNCmNhbjogZmxleGNhbjogZmxleGNhbl9pcnEoKTogYWRkIHN1
cHBvcnQgZm9yIFRYIG1haWxib3ggaW4gaWZsYWcxDQpjYW46IGZsZXhjYW46IGZsZXhjYW5fcmVh
ZF9yZWdfaWZsYWdfcngoKTogb3B0aW1pemUgcmVhZGluZw0KY2FuOiBmbGV4Y2FuOiBpbnRyb2R1
Y2Ugc3RydWN0IGZsZXhjYW5fcHJpdjo6dHhfbWFzayBhbmQgbWFrZSB1c2Ugb2YgaXQNCmNhbjog
ZmxleGNhbjogY29udmVydCBzdHJ1Y3QgZmxleGNhbl9wcml2OjpyeF9tYXNrezEsMn0gdG8gcnhf
bWFzaw0KY2FuOiBmbGV4Y2FuOiByZW1vdmUgVFggbWFpbGJveCBiaXQgZnJvbSBzdHJ1Y3QgZmxl
eGNhbl9wcml2OjpyeF9tYXNrezEsMn0NCmNhbjogZmxleGNhbjogcmVuYW1lIHN0cnVjdCBmbGV4
Y2FuX3ByaXY6OnJlZ19pbWFza3sxLDJ9X2RlZmF1bHQgdG8gcnhfbWFza3sxLDJ9DQpjYW46IGZs
ZXhjYW46IGZsZXhjYW5faXJxKCk6IHJlbmFtZSB2YXJpYWJsZSByZWdfaWZsYWcgLT4gcmVnX2lm
bGFnX3J4DQpjYW46IGZsZXhjYW46IHJlbmFtZSBtYWNybyBGTEVYQ0FOX0lGTEFHX01CKCkgLT4g
RkxFWENBTl9JRkxBRzJfTUIoKQ0KDQpZb3UgY2FuIHJlZmVyIHRvIGJlbG93IGxpbmsgZm9yIHRo
ZSByZWFzb24gb2YgYWRkaW5nIGFib3ZlIHBhdGNoZXM6DQpodHRwczovL3d3dy5zcGluaWNzLm5l
dC9saXN0cy9saW51eC1jYW4vbXNnMDA3NzcuaHRtbA0KaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQv
bGlzdHMvbGludXgtY2FuL21zZzAxMTUwLmh0bWwNCg0KQXJlIHlvdSBwcmVwYXJlZCB0byBhZGQg
YmFjayB0aGVzZSBwYXRjaGVzIGFzIHRoZXkgYXJlIG5lY2Vzc2FyeSBmb3IgRmxleGNhbiBDQU4g
RkQ/IEFuZCB0aGlzIEZsZXhjYW4gQ0FOIEZEIHBhdGNoIHNldCBpcyBiYXNlZCBvbiB0aGVzZSBw
YXRjaGVzLg0KDQpUaGFua3MgYSBsb3QhDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZw0KPiBT
ZW50OiAyMDE5xOo31MIxMsjVIDE2OjAzDQo+IFRvOiBta2xAcGVuZ3V0cm9uaXguZGU7IGxpbnV4
LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHdnQGdyYW5kZWdnZXIuY29tOyBkbC1saW51eC1p
bXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIDAvOF0g
Y2FuOiBmbGV4Y2FuOiBhZGQgQ0FOIEZEIHN1cHBvcnQgZm9yIE5YUCBGbGV4Y2FuDQo+IA0KPiBI
aSBNYXJjLA0KPiANCj4gVGhpcyBwYXRjaCBzZXQgaW50ZW5kcyB0byBhZGQgc3VwcG9ydCBmb3Ig
TlhQIEZsZXhjYW4gQ0FOIEZELCBpdCBoYXMgYmVlbg0KPiB2YWxpZGF0ZWQgb24gdGhyZWUgTlhQ
IHBsYXRmb3JtKGkuTVg4UU0vUVhQLCBTMzJWMjM0LCBMWDIxNjBBUjEpLg0KPiBBZnRlciBkaXNj
dXNzZWQgd2l0aCBhbm90aGVyIHR3byBGZXhjYW4gb3duZXIsIHdlIHNvcnRlZCBvdXQgdGhpcyB2
ZXJzaW9uLg0KPiANCj4gSSBob3BlIHlvdSBjYW4gcGljayB1cCB0aGUgcGF0Y2ggc2V0IGFzIGl0
IGNhbiBmdWxseSBtZWV0IHJlcXVpcmVtZW50IG9mIGFib3ZlDQo+IHRocmVlIHBsYXRmb3JtLiBB
bmQgYWZ0ZXIgdGhhdCwgd2UgY2FuIHN0YXJ0IHRvIGRvIHVwc3RyZWFtIGFib3V0IENBTiBGRC4N
Cj4gDQo+IFRoYW5rcyBhIGxvdCENCj4gDQo+IEJScywNCj4gSm9ha2ltIFpoYW5nDQo+IA0KPiBK
b2FraW0gWmhhbmcgKDgpOg0KPiAgIGNhbjogZmxleGNhbjogYWxsb2NhdGUgc2tiIGluIGZsZXhj
YW5fbWFpbGJveF9yZWFkDQo+ICAgY2FuOiBmbGV4Y2FuOiB1c2Ugc3RydWN0IGNhbmZkX2ZyYW1l
IGZvciBDQU4gY2xhc3NpYyBmcmFtZQ0KPiAgIGNhbjogZmxleGNhbjogYWRkIENBTiBGRCBtb2Rl
IHN1cHBvcnQNCj4gICBjYW46IGZsZXhjYW46IGFkZCBDQU5GRCBCUlMgc3VwcG9ydA0KPiAgIGNh
bjogZmxleGNhbjogYWRkIElTTyBDQU4gRkQgZmVhdHVyZSBzdXBwb3J0DQo+ICAgY2FuOiBmbGV4
Y2FuOiBhZGQgVHJhbnNjZWl2ZXIgRGVsYXkgQ29tcGVuc2F0aW9uIHN1b3Bwb3J0DQo+ICAgY2Fu
OiBmbGV4Y2FuOiBhZGQgaW14OHFtIHN1cHBvcnQNCj4gICBjYW46IGZsZXhjYW46IGFkZCBseDIx
NjBhcjEgc3VwcG9ydA0KPiANCj4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgICAgICB8IDM0
MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9y
eC1vZmZsb2FkLmMgICB8ICAzMyArLS0tDQo+ICBpbmNsdWRlL2xpbnV4L2Nhbi9yeC1vZmZsb2Fk
LmggfCAgIDUgKy0NCj4gIDMgZmlsZXMgY2hhbmdlZCwgMzA1IGluc2VydGlvbnMoKyksIDczIGRl
bGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi4xNy4xDQoNCg==
