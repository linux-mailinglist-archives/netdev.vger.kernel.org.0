Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52138280C6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfEWPPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:15:55 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:34944
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730710AbfEWPPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 11:15:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21QR590SMM/KqRl82vM9w7ERSj0v4eANbqAg+QIWMM0=;
 b=ZzcVdmGRM9ahOEhRXAScBy8+GHc0D4/v0cLf2sBDm8Z/1/DpXHmJyhb+RYwGVkR8W7UzlaluT+E4V1SSSH2VjpxHxRFVwlj5iiL6fmIYyMiDrQwS80V6FmNx64bRbYFRyvBnXV7EPqe4nUIpl2TVrnUYCcrpVMMb71CUT2Udlrw=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB4968.eurprd05.prod.outlook.com (20.177.36.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 23 May 2019 15:15:48 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09%3]) with mapi id 15.20.1922.016; Thu, 23 May 2019
 15:15:48 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>, Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Bug or mis configuration for mlx5e lag and multipath
Thread-Topic: Bug or mis configuration for mlx5e lag and multipath
Thread-Index: AQHVDq7V3EhKEOTvIkS9QlDIJnxOfKZ412uA
Date:   Thu, 23 May 2019 15:15:48 +0000
Message-ID: <8bbeec48-6bbc-260c-91e3-4b58290055b2@mellanox.com>
References: <678285cb-0821-405a-57ae-0d72e96f9ef7@ucloud.cn>
In-Reply-To: <678285cb-0821-405a-57ae-0d72e96f9ef7@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
x-clientproxiedby: AM0PR05CA0032.eurprd05.prod.outlook.com
 (2603:10a6:208:55::45) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a63ca35a-09b3-4fde-539b-08d6df9188d1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4968;
x-ms-traffictypediagnostic: AM6PR05MB4968:
x-microsoft-antispam-prvs: <AM6PR05MB49687164AC77511E6D9350C6B5010@AM6PR05MB4968.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(136003)(396003)(346002)(189003)(199004)(68736007)(66446008)(5660300002)(52116002)(64126003)(66556008)(486006)(66476007)(186003)(6246003)(53546011)(99286004)(71200400001)(6116002)(26005)(53936002)(65956001)(64756008)(71190400001)(65806001)(386003)(6506007)(76176011)(3846002)(6636002)(66066001)(81166006)(478600001)(6512007)(81156014)(305945005)(6486002)(31686004)(102836004)(65826007)(86362001)(316002)(7736002)(2906002)(14444005)(256004)(229853002)(8936002)(58126008)(25786009)(36756003)(31696002)(2616005)(476003)(66946007)(446003)(8676002)(6436002)(110136005)(4326008)(14454004)(11346002)(73956011)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4968;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7RAEOTcwMfQpmxyX/a4iUnK112wfHU2DEdh0y1LMa/p6h2kJOhnZ6A0BsCksxS4aYDM9V6f6aP0iZgBqLwjcAU3l9dVwj85a08dZG52CJ+sXN14shGcUnAn4xrLpv9kwvppKIxDbne/qogBOMKgLKP/uXAbMbe/Py3wb/xnPobygIn8+EU+G7wiZQ9Li6zzsBfzeEPKORFsg1TxuOqFwTsUCTEd8G1YhvdnQMZqmRIF16b7j3o8ppgrqopoQcMWsancQIiRDrwE2LWNMQycMF0tRc3rcL477Kh9mEeO9icfOY1XuefPGMPJ7vQoHJxkzdBbwjps4EisXxnRR3LpCncN0i1Ab1FPWywNdjcC03q35NR9FtRSe8idoRZ2UzmtO7dC6eg2to7ADPfqX0D7leVJn2tviLE3V+aP1WoobQp8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB06F8F9AE2C2D4A90225A6069E772D1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a63ca35a-09b3-4fde-539b-08d6df9188d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 15:15:48.0464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roid@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwLzA1LzIwMTkgMDQ6NTMsIHdlbnh1IHdyb3RlOg0KPiBIaSBSb2kgJiBTYWVlZCwN
Cj4gDQo+IEkganVzdCB0ZXN0IHRoZSBtbHg1ZSBsYWcgYW5kIG11dGlwYXRoIGZlYXR1cmUuIFRo
ZXJlIGFyZSBzb21lIHN1aXR1YXRpb24gdGhlIG91dGdvaW5nIGNhbid0IGJlIG9mZmxvYWRlZC4N
Cj4gDQo+IG92cyBjb25maWd1cmVhdGlvbiBhcyBmb2xsb3dpbmcuDQo+IA0KPiAjIG92cy12c2N0
bCBzaG93DQo+IGRmZDcxZGZiLTZlMjItNDIzZS1iMDg4LWQyMDIyMTAzYWY2Yg0KPiDCoMKgwqAg
QnJpZGdlICJicjAiDQo+IMKgwqDCoMKgwqDCoMKgIFBvcnQgIm1seF9wZjB2ZjAiDQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgSW50ZXJmYWNlICJtbHhfcGYwdmYwIg0KPiDCoMKgwqDCoMKgwqDC
oCBQb3J0IGdyZQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEludGVyZmFjZSBncmUNCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHR5cGU6IGdyZQ0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgb3B0aW9uczoge2tleT0iMTAwMCIsIGxvY2FsX2lwPSIxNzIuMTY4LjE1
Mi43NSIsIHJlbW90ZV9pcD0iMTcyLjE2OC4xNTIuMjQxIn0NCj4gwqDCoMKgwqDCoMKgwqAgUG9y
dCAiYnIwIg0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEludGVyZmFjZSAiYnIwIg0KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHlwZTogaW50ZXJuYWwNCj4gDQo+IHNldCB0aGUg
bWx4NWUgZHJpdmVyOg0KPiANCj4gDQo+IG1vZHByb2JlIG1seDVfY29yZQ0KPiBlY2hvIDAgPiAv
c3lzL2NsYXNzL25ldC9ldGgyL2RldmljZS9zcmlvdl9udW12ZnMNCj4gZWNobyAwID4gL3N5cy9j
bGFzcy9uZXQvZXRoMy9kZXZpY2Uvc3Jpb3ZfbnVtdmZzDQo+IGVjaG8gMiA+IC9zeXMvY2xhc3Mv
bmV0L2V0aDIvZGV2aWNlL3NyaW92X251bXZmcw0KPiBlY2hvIDIgPiAvc3lzL2NsYXNzL25ldC9l
dGgzL2RldmljZS9zcmlvdl9udW12ZnMNCj4gbHNwY2kgLW5uIHwgZ3JlcCBNZWxsYW5veA0KPiBl
Y2hvIDAwMDA6ODE6MDAuMiA+IC9zeXMvYnVzL3BjaS9kcml2ZXJzL21seDVfY29yZS91bmJpbmQN
Cj4gZWNobyAwMDAwOjgxOjAwLjMgPiAvc3lzL2J1cy9wY2kvZHJpdmVycy9tbHg1X2NvcmUvdW5i
aW5kDQo+IGVjaG8gMDAwMDo4MTowMy42ID4gL3N5cy9idXMvcGNpL2RyaXZlcnMvbWx4NV9jb3Jl
L3VuYmluZA0KPiBlY2hvIDAwMDA6ODE6MDMuNyA+IC9zeXMvYnVzL3BjaS9kcml2ZXJzL21seDVf
Y29yZS91bmJpbmQNCj4gDQo+IGRldmxpbmsgZGV2IGVzd2l0Y2ggc2V0IHBjaS8wMDAwOjgxOjAw
LjDCoCBtb2RlIHN3aXRjaGRldiBlbmNhcCBlbmFibGUNCj4gZGV2bGluayBkZXYgZXN3aXRjaCBz
ZXQgcGNpLzAwMDA6ODE6MDAuMcKgIG1vZGUgc3dpdGNoZGV2IGVuY2FwIGVuYWJsZQ0KPiANCj4g
bW9kcHJvYmUgYm9uZGluZyBtb2RlPTgwMi4zYWQgbWlpbW9uPTEwMCBsYWNwX3JhdGU9MQ0KPiBp
cCBsIGRlbCBkZXYgYm9uZDANCj4gaWZjb25maWcgbWx4X3AwIGRvd24NCj4gaWZjb25maWcgbWx4
X3AxIGRvd24NCj4gaXAgbCBhZGQgZGV2IGJvbmQwIHR5cGUgYm9uZCBtb2RlIDgwMi4zYWQNCj4g
aWZjb25maWcgYm9uZDAgMTcyLjE2OC4xNTIuNzUvMjQgdXANCj4gZWNobyAxID4gL3N5cy9jbGFz
cy9uZXQvYm9uZDAvYm9uZGluZy94bWl0X2hhc2hfcG9saWN5DQo+IGlwIGwgc2V0IGRldiBtbHhf
cDAgbWFzdGVyIGJvbmQwDQo+IGlwIGwgc2V0IGRldiBtbHhfcDEgbWFzdGVyIGJvbmQwDQo+IGlm
Y29uZmlnIG1seF9wMCB1cA0KPiBpZmNvbmZpZyBtbHhfcDEgdXANCj4gDQo+IHN5c3RlbWN0bCBz
dGFydCBvcGVudnN3aXRjaA0KPiBvdnMtdnNjdGwgc2V0IE9wZW5fdlN3aXRjaCAuIG90aGVyX2Nv
bmZpZzpody1vZmZsb2FkPXRydWUNCj4gc3lzdGVtY3RsIHJlc3RhcnQgb3BlbnZzd2l0Y2gNCj4g
DQo+IA0KPiBtbHhfcGYwdmYwIGlzIGFzc2lnbmVkIHRvIHZtLiBUaGUgdGMgcnVsZSBzaG93IGlu
X2h3DQo+IA0KPiAjIHRjIGZpbHRlciBscyBkZXYgbWx4X3BmMHZmMCBpbmdyZXNzDQo+IGZpbHRl
ciBwcm90b2NvbCBpcCBwcmVmIDIgZmxvd2VyDQo+IGZpbHRlciBwcm90b2NvbCBpcCBwcmVmIDIg
Zmxvd2VyIGhhbmRsZSAweDENCj4gwqAgZHN0X21hYyA4ZTpjMDpiZDpiZjo3MjpjMw0KPiDCoCBz
cmNfbWFjIDUyOjU0OjAwOjAwOjEyOjc1DQo+IMKgIGV0aF90eXBlIGlwdjQNCj4gwqAgaXBfdG9z
IDAvMw0KPiDCoCBpcF9mbGFncyBub2ZyYWcNCj4gwqAgaW5faHcNCj4gwqDCoMKgIGFjdGlvbiBv
cmRlciAxOiB0dW5uZWxfa2V5IHNldA0KPiDCoMKgwqAgc3JjX2lwIDE3Mi4xNjguMTUyLjc1DQo+
IMKgwqDCoCBkc3RfaXAgMTcyLjE2OC4xNTIuMjQxDQo+IMKgwqDCoCBrZXlfaWQgMTAwMCBwaXBl
DQo+IMKgwqDCoCBpbmRleCAyIHJlZiAxIGJpbmQgMQ0KPiDCoA0KPiDCoMKgwqAgYWN0aW9uIG9y
ZGVyIDI6IG1pcnJlZCAoRWdyZXNzIFJlZGlyZWN0IHRvIGRldmljZSBncmVfc3lzKSBzdG9sZW4N
Cj4gwqDCoMKgwqAgaW5kZXggMiByZWYgMSBiaW5kIDENCj4gDQo+IEluIHRoZSB2bTrCoCB0aGUg
bWx4NWUgZHJpdmVyIGVuYWJsZSB4cHMgZGVmYXVsdCAoYnkgdGhlIHdheSBJIHRoaW5rIGl0IGlz
IGJldHRlciBub3QgZW5hYmxlIHhwcyBpbiBkZWZhdWx0IGtlcm5lbCBjYW4gc2VsZWN0IHF1ZXVl
IGJ5IGVhY2ggZmxvdykswqAgaW4gdGhlIGxhZyBtb2RlIGRpZmZlcmVudCB2ZiBxdWV1ZSBhc3Nv
Y2lhdGUgd2l0aCBodyBQRi4NCj4gDQo+IHdpdGggY29tbWFuZCB0YXNrc2V0IC1jIDIgcGluZyAx
MC4wLjAuMjQxDQo+IA0KPiB0aGUgcGFja2V0IGNhbiBiZSBvZmZsb2FkZWQgLCB0aGUgb3V0Z29p
bmcgcGYgaXMgbWx4X3AwDQo+IA0KPiBidXQgd2l0aCBjb21tYW5kIHRhc2tzZXQgLWMgMSBwaW5n
IDEwLjAuMC4yNDENCj4gDQo+IHRoZSBwYWNrZXQgY2FuJ3QgYmUgb2ZmbG9hZGVkLCBJIGNhbiBj
YXB0dXJlIHRoZSBwYWNrZXQgb24gdGhlIG1seF9wZjB2ZjAsIHRoZSBvdXRnb2luZyBwZiBpcyBt
bHhfcDEuIEFsdGhyb3VnaCB0aGUgdGMgZmxvd2VyIHJ1bGUgc2hvdyBpbl9odw0KPiANCj4gDQo+
IEkgY2hlY2sgd2l0aCB0aGUgZHJpdmVywqAgYm90aCBtbHhfcGYwdmYwIGFuZCBwZWVyKG1seF9w
MSkgaW5zdGFsbCB0aGUgdGMgcnVsZSBzdWNjZXNzDQo+IA0KPiBJIHRoaW5rIGl0J3MgYSBwcm9i
bGVtIG9mIGxhZyBtb2RlLiBPciBJIG1pc3Mgc29tZSBjb25maWd1cmVhdGlvbj8NCj4gDQo+IA0K
PiBCUg0KPiANCj4gd2VueHUNCj4gDQo+IA0KPiANCj4gDQo+IA0KDQpIaSwNCg0Kd2UgbmVlZCB0
byB2ZXJpZnkgdGhlIGRyaXZlciBkZXRlY3RlZCB0byBiZSBpbiBsYWcgbW9kZSBhbmQNCmR1cGxp
Y2F0ZWQgdGhlIG9mZmxvYWQgcnVsZSB0byBib3RoIGVzd2l0Y2hlcy4NCmRvIHlvdSBzZWUgbGFn
IG1hcCBtZXNzYWdlcyBpbiBkbWVzZz8NCnNvbWV0aGluZyBsaWtlICJsYWcgbWFwIHBvcnQgMTox
IHBvcnQgMjoyIg0KdGhpcyBpcyB0byBtYWtlIHN1cmUgdGhlIGRyaXZlciBhY3R1YWxseSBpbiBs
YWcgbW9kZS4NCmluIHRoaXMgbW9kZSBhIHJ1bGUgYWRkZWQgdG8gbWx4X3BmMHZmMCB3aWxsIGJl
IGFkZGVkIHRvIGVzdyBvZiBwZjAgYW5kIGVzdyBvZiBwZjEuDQp0aGVuIHdoZW4gdSBzZW5kIGEg
cGFja2V0IGl0IGNvdWxkIGJlIGhhbmRsZWQgaW4gZXN3MCBvciBlc3cxDQppZiB0aGUgcnVsZSBp
cyBub3QgaW4gZXN3MSB0aGVuIGl0IHdvbnQgYmUgb2ZmbG9hZGVkIHdoZW4gdXNpbmcgcGYxLg0K
DQp0aGFua3MsDQpSb2kNCg==
