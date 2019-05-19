Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB29227E5
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfESRkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:40:14 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:28790
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbfESRkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 13:40:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peI8KtcrOpm8vwYtI5vJQTy/zmsRcIVmA+nf0QK1Syk=;
 b=cOhz2WtVrR/j3kK4jh3swjzg0zK6iyWNHpKOsoGBGF+sNXW86ickpnEh6ycQrlLuVJygT1Rr2Eq4pp4BOHXlo4xH+Jh7esrroUvClMlQCXA+qKXxe+nqwcYIRXKWuDYJv4x4Hb5ai5C+CqEB4aNi639cYmibujdPGJSHvTKFTmY=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB4872.eurprd05.prod.outlook.com (20.177.34.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Sun, 19 May 2019 08:07:51 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09%3]) with mapi id 15.20.1900.019; Sun, 19 May 2019
 08:07:51 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Add bonding device for indr block to offload
 the packet received from bonding device
Thread-Topic: [PATCH] net/mlx5e: Add bonding device for indr block to offload
 the packet received from bonding device
Thread-Index: AQHVDImgZwwRAFd2YUeQN9PHcM5WDqZyGsuA
Date:   Sun, 19 May 2019 08:07:50 +0000
Message-ID: <ce580dfa-05f7-9df4-2a18-1459c1772d67@mellanox.com>
References: <1558081318-15810-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1558081318-15810-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-clientproxiedby: AM0PR02CA0073.eurprd02.prod.outlook.com
 (2603:10a6:208:154::14) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6cbedf0-1c53-4f47-2402-08d6dc3113cc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4872;
x-ms-traffictypediagnostic: AM6PR05MB4872:
x-microsoft-antispam-prvs: <AM6PR05MB4872BE5686FDF2507FD82CE5B5050@AM6PR05MB4872.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 00429279BA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39850400004)(376002)(396003)(366004)(189003)(199004)(64126003)(386003)(476003)(36756003)(65826007)(4326008)(76176011)(305945005)(11346002)(2616005)(53546011)(486006)(6506007)(6512007)(6116002)(3846002)(52116002)(6486002)(478600001)(2906002)(2501003)(14454004)(6436002)(316002)(71200400001)(71190400001)(7736002)(102836004)(25786009)(8936002)(110136005)(81166006)(65806001)(64756008)(31686004)(58126008)(66476007)(446003)(86362001)(256004)(14444005)(66556008)(53936002)(66446008)(68736007)(73956011)(26005)(81156014)(186003)(6636002)(229853002)(99286004)(8676002)(66946007)(66066001)(65956001)(5660300002)(6246003)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4872;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PPnjh6pebKpLJITvBONnE/nX9dHYA8huA2/NsoZr9tEvag73oCSy5q0ntSkWthLqjEm666qFbWcUP26mqL7dox5vhMh4Koxm3Y2cbh/9aUk1uymAfZhRDQ4jr8E2+IT6jwit9Og3mGW9BYLe5R+2EtvAZbhnUaFpj5lerMNzytBTRoUP2PU0B9osHTtpUQ8J0+lDnTgmRQrZGkQWH7NSEj1onKok3UFIjZ+yPwfAgcUrPT5gdTcfCglZN5nWrDPVbj0/PRY5ktkWMJhMKhBFE64vQacL11CIGRAka0c+Z/xPvJKGFepK3il3q1bnIGylwX5nD/VTI5efFvPGdtnJMTC2Ht5vvQlwQ4kAmYLeT160MZdvqZADgOSbROUBb6d6siS+v2zByLpX54/3tFEl7gxHihVqvIIWDVbeidh17QA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E430197922857241883720C7BF5BD5AB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cbedf0-1c53-4f47-2402-08d6dc3113cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2019 08:07:51.0280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDE3LzA1LzIwMTkgMTE6MjEsIHdlbnh1QHVjbG91ZC5jbiB3cm90ZToNCj4gRnJvbTog
d2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCj4gDQo+IFRoZSBtbHg1ZSBzdXBwb3J0IHRoZSBsYWcg
bW9kZS4gV2hlbiBhZGQgbWx4X3AwIGFuZCBtbHhfcDEgdG8gYm9uZDAuDQo+IHBhY2tldCByZWNl
aXZlZCBmcm9tIG1seF9wMCBvciBtbHhfcDEgYW5kIGluIHRoZSBpbmdyZXNzIHRjIGZsb3dlcg0K
PiBmb3J3YXJkIHRvIHZmMC4gVGhlIHRjIHJ1bGUgY2FuJ3QgYmUgb2ZmbG9hZGVkIGZvciB0aGUg
bm9uIGluZHINCj4gcmVqaXN0b3IgYmxvY2sgZm9yIHRoZSBib25kaW5nIGRldmljZS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IC0tLQ0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIHwgMSArDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gaW5kZXggOTFlMjRmMS4uMTM0ZmEw
YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3JlcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9yZXAuYw0KPiBAQCAtNzk2LDYgKzc5Niw3IEBAIHN0YXRpYyBpbnQgbWx4NWVfbmljX3Jl
cF9uZXRkZXZpY2VfZXZlbnQoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwNCj4gIAlzdHJ1Y3Qg
bmV0X2RldmljZSAqbmV0ZGV2ID0gbmV0ZGV2X25vdGlmaWVyX2luZm9fdG9fZGV2KHB0cik7DQo+
ICANCj4gIAlpZiAoIW1seDVlX3RjX3R1bl9kZXZpY2VfdG9fb2ZmbG9hZChwcml2LCBuZXRkZXYp
ICYmDQo+ICsJICAgICFuZXRpZl9pc19ib25kX21hc3RlcihuZXRkZXYpICYmDQo+ICAJICAgICFp
c192bGFuX2RldihuZXRkZXYpKQ0KPiAgCQlyZXR1cm4gTk9USUZZX09LOw0KPiAgDQo+IA0KDQpo
bW0uIGlzIHRoaXMgdGhlIG9ubHkgdGhpbmcgYmxvY2tlZCB5b3UgZnJvbSBvZmZsb2FkaW5nIGlu
ZGlyZWN0IGZyb20gYm9uZD8NCndoZW4gdSBhZGQgdGhlIHJ1bGUgZnJvbSBib25kIGxpa2UgdGhp
cyB0aGlzIGFsc28gbmVlZCB0byBtYWtlIHN1cmUgdGhlIHJ1bGUNCmlzIGR1cGxpY2F0ZWQgdG8g
Ym90aCBlc3dpdGNoZXMgaW4gaXNfcGVlcl9mbG93X25lZWRlZCgpLg0KDQp0b2RheSB3ZSBzdXBw
b3J0IGJvbmQgb2ZmbG9hZGluZyBieSB1c2luZyBzaGFyZWQgdGMgYmxvY2suDQppLmUuIHlvdSBh
ZGQgYSBzaGFyZWQgdGMgYmxvY2sgdG8gYm9uZCBhbmQgaXRzIHNsYXZlcy4NCnRoZW4gYWxsIHJ1
bGVzIHlvdSBhZGQgdG8gdGhlIHNoYXJlZCBibG9jayBpbnN0ZWFkIG9mIGEgc3BlY2lmaWMgaW50
ZXJmYWNlLg0KDQp0aGlzIGlzIGFsc28gaG93IE9WUyBjdXJyZW50bHkgb2ZmbG9hZCB0aGUgcnVs
ZXMgd2l0aCBib25kLg0Kd2hlbiB1IGFkZCBhIGJvbmQgcG9ydCwgb3ZzIGFkZHMgYSBzaGFyZWQg
dGMgYmxvY2sgdG8gdGhlIHNsYXZlcy4NCnRoZW4gbmV3IHJ1bGVzIGFkZGVkIHRvIHRoZSB0YyBi
bG9jayBpbnN0ZWFkIG9mIHRoZSBib25kIGludGVyZmFjZS4NCg0K
