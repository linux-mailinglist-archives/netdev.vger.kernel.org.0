Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33208E09B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfD2Kg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:36:29 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:31457
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727560AbfD2Kg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MSpJQcxYQgg4E4wCby5AbJVV/qGl5a8qdFBoCUx1HU=;
 b=AKdO6AikNxYQrqCB62m4DPpsyEOVhL0os5+UbGLmNXLWWo9H7fEaiOh2PiSlHYUlMU7GKfO82T+bWQ1uMQQVs3yRqsOJA4Gtafq8/9+eYWmQhn4Ji+XsFJrhKYdUwjpVQcmwoB50quuZbLENFOPQDZvAHd3GMieoU2wEfWke8Z0=
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com (52.134.92.158) by
 AM0PR04MB4066.eurprd04.prod.outlook.com (52.134.92.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 10:36:24 +0000
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::8cda:4e52:8e87:8f0e]) by AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::8cda:4e52:8e87:8f0e%2]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 10:36:24 +0000
From:   Aisheng Dong <aisheng.dong@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: change .tseg1_min value to 2 in bittiming
 const
Thread-Topic: [PATCH] can: flexcan: change .tseg1_min value to 2 in bittiming
 const
Thread-Index: AQHU/l/eGgL8EWD7kUani7YEBLcwp6ZS8GyQ
Date:   Mon, 29 Apr 2019 10:36:24 +0000
Message-ID: <AM0PR04MB42119D481BD7A6494E4F364F80390@AM0PR04MB4211.eurprd04.prod.outlook.com>
References: <20190429074551.25754-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190429074551.25754-1-qiangqing.zhang@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aisheng.dong@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c739a4ed-23b3-41c0-3efc-08d6cc8e86f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4066;
x-ms-traffictypediagnostic: AM0PR04MB4066:
x-microsoft-antispam-prvs: <AM0PR04MB4066E39C7B1ACC77CEA83DAA80390@AM0PR04MB4066.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(97736004)(9686003)(305945005)(52536014)(76116006)(66476007)(66556008)(64756008)(66446008)(73956011)(55016002)(66946007)(6436002)(25786009)(7696005)(86362001)(54906003)(110136005)(2201001)(99286004)(6506007)(102836004)(76176011)(4326008)(6246003)(316002)(33656002)(6116002)(3846002)(7736002)(68736007)(81156014)(8676002)(8936002)(53936002)(74316002)(81166006)(2501003)(478600001)(2906002)(229853002)(256004)(14444005)(5660300002)(44832011)(486006)(446003)(11346002)(476003)(14454004)(71200400001)(71190400001)(66066001)(26005)(186003)(142923001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4066;H:AM0PR04MB4211.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y431h52vz0Eki8+zi7uS3ZUs1vDkShui4fgJSWrPA2oLc2hXP/VfbZ4A12U0NZ+Jl9uOXhgHY2+uGrKzgI1gwKt0n0z8v7PiSDYYnCmemtvv9bIdlI4Czi5EpnAdmZzRqfJgQvp8BBOlNyAhit6nOW8HUJZyBnSFyjiQUSMU3EmBYABF29bIBF0dWnLX/Jg0Wx6XKWeuu2/h1O9Rm+IJVjOlTYVehz1vynxeOdvSsdDefdW3MzdgFeg6zltjoAv+32ye6OhrIietq1BousdYE7BkLHoyUzfNSHnJfOoHbP3TQaDkeu9BPpKAk/vB6jW62qXzb2gfaMrSWZsvDKs/KtGT99Z3RyWLAmS6+2XJhYPGWCTT9tZLCm3+WUHhPav+xYExS1jgn4ngMik3rI6CYJ0RahM/3T7MhS21jOdZ8YQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c739a4ed-23b3-41c0-3efc-08d6cc8e86f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:36:24.0274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKb2FraW0gWmhhbmcNCj4gU2VudDogTW9uZGF5LCBBcHJpbCAyOSwgMjAxOSAzOjQ4
IFBNDQo+IA0KPiBUaW1lIFNlZ21lbnQxKHRzZWcxKSBpcyBjb21wb3NlZCBvZiBQcm9wYWdhdGUg
U2VnbWVudChwcm9wX3NlZykgYW5kDQo+IFBoYXNlIFNlZ21lbmcxKHBoYXNlX3NlZzEpLiBUaGUg
cmFuZ2Ugb2YgVGltZSBTZWdtZW50MShwbHVzIDIpIGlzIDIgdXAgdG8NCj4gMTYgYWNjb3JkaW5n
IHRvIGxhdGVzdCByZWZlcmVuY2UgbWFudWFsLiBUaGF0IG1lYW5zIHRoZSBtaW5pbXVtIHZhbHVl
IG9mDQo+IFBST1BTRUcgYW5kIFBTRUcxIGJpdCBmaWVsZCBpcyAwLiBTbyBjaGFuZ2UgLnRzZWcx
IG1pbiB2YWx1ZSB0byAyLg0KPiANCg0KSSBzYXcgbGF0ZXN0IE1YNlEgUk0gc3RpbGwgaW5kaWNh
dGVzIGl0J3MgNC0xNi4NCkNhbiB5b3UgaGVscCBkb3VibGUgY2hlY2sgd2l0aCBJQyBndXlzIHdo
ZXRoZXIgYWxsIFJNIG9mIHJlbGF0ZWQgY2hpcHMNCm5lZWQgdXBkYXRlPw0KDQpSZWdhcmRzDQpE
b25nIEFpc2hlbmcNCg0KPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAyICst
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2Fu
L2ZsZXhjYW4uYyBpbmRleA0KPiBlMzUwODNmZjMxZWUuLjJlYTM1ZWY0YWEyNyAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9jYW4v
ZmxleGNhbi5jDQo+IEBAIC0zMjcsNyArMzI3LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmbGV4
Y2FuX2RldnR5cGVfZGF0YQ0KPiBmc2xfbHMxMDIxYV9yMl9kZXZ0eXBlX2RhdGEgPSB7DQo+IA0K
PiAgc3RhdGljIGNvbnN0IHN0cnVjdCBjYW5fYml0dGltaW5nX2NvbnN0IGZsZXhjYW5fYml0dGlt
aW5nX2NvbnN0ID0gew0KPiAgCS5uYW1lID0gRFJWX05BTUUsDQo+IC0JLnRzZWcxX21pbiA9IDQs
DQo+ICsJLnRzZWcxX21pbiA9IDIsDQo+ICAJLnRzZWcxX21heCA9IDE2LA0KPiAgCS50c2VnMl9t
aW4gPSAyLA0KPiAgCS50c2VnMl9tYXggPSA4LA0KPiAtLQ0KPiAyLjE3LjENCg0K
