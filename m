Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB6514892
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFKv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:51:27 -0400
Received: from mail-eopbgr00086.outbound.protection.outlook.com ([40.107.0.86]:17476
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbfEFKv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 06:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEVqmwu/RGld1WpP8ELMPJZv5R+AUhpK7kcO1AE7pEE=;
 b=GmMIbuzRD6l9pJle8wwxueNtql80C79zuKAhgO7WS9XNf4JEbu4elAD/lEJsoQelXPufs1JeME7MxzEpLFDK1e4G/XP92jzv8kMdkzvK85+UFbmX0kTSKJ5a83WwAxw1T7wIIQ22sGziQ1tj4aVG+5SgdGIj7XhqyvCw6waMxbM=
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com (10.169.150.142) by
 AM5PR0501MB2484.eurprd05.prod.outlook.com (10.169.153.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Mon, 6 May 2019 10:51:24 +0000
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a]) by AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 10:51:24 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 11/15] net/mlx5: Add support for FW reporter dump
Thread-Topic: [net-next 11/15] net/mlx5: Add support for FW reporter dump
Thread-Index: AQHVAton26WYhA1KEUucrX0hQSsEEKZcrmoAgAE/KYA=
Date:   Mon, 6 May 2019 10:51:24 +0000
Message-ID: <923129a3-d5e0-3b1e-932c-efdc96dba676@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-12-saeedm@mellanox.com>
 <20190505154902.GF31501@nanopsycho.orion>
In-Reply-To: <20190505154902.GF31501@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM4PR0101CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::44) To AM5PR0501MB2546.eurprd05.prod.outlook.com
 (2603:10a6:203:c::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1003bf3c-1f92-42a3-7a9e-08d6d210c825
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM5PR0501MB2484;
x-ms-traffictypediagnostic: AM5PR0501MB2484:
x-microsoft-antispam-prvs: <AM5PR0501MB2484F42BC4E8AF4764CE15E7D9300@AM5PR0501MB2484.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(136003)(39860400002)(189003)(199004)(68736007)(305945005)(316002)(7736002)(107886003)(31696002)(6512007)(53546011)(386003)(2616005)(11346002)(6246003)(86362001)(26005)(6506007)(65826007)(102836004)(186003)(66476007)(66556008)(66946007)(446003)(66446008)(73956011)(64756008)(76176011)(52116002)(6636002)(53936002)(65806001)(65956001)(66066001)(71190400001)(71200400001)(64126003)(4326008)(6486002)(14444005)(31686004)(256004)(6436002)(8676002)(99286004)(110136005)(54906003)(58126008)(25786009)(476003)(486006)(229853002)(3846002)(6116002)(478600001)(2906002)(81156014)(81166006)(5660300002)(36756003)(8936002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0501MB2484;H:AM5PR0501MB2546.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +eyLkRRyk+kw/dpi9uZLpKA5BejptbOixcT6D9QI3iaDHvob6gAF1lOYKgb2qbP3S4+y/4Zo/vl8oR/1JRgUXRzeC014l8gA4hgRGHJ08MRnWyFaAiwZzyHoiHC46XOoScG7JQLNz3pollsVTKJhAE8Y4SM21MKhk8/Gww9Q5cidnP7P1VsOENdhI8nMURxGuN/byvvnWkgTsGBNzy6v3cVGMPsVaJEpwh7ECHYJP4ZNd1LBM45BdKXgLa4hgP5yAc28WbphX0brfIy0VVOYS6wQXjiYJNNot5GYMHHcrm6PVe8pHhA8pqTOhjeY6RvQO8xenYmX5BL25SBMQ9XUK+zo3kSa2c9D2S+cJlc655rvxviuNawPlXqsPe6Rwv4MVC84Xuu7mPSiELxJ7unB0expc5hEF73wZVhEBxPvn4E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A88EC254557D1A4982A31B0FDDF295E4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1003bf3c-1f92-42a3-7a9e-08d6d210c825
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 10:51:24.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0501MB2484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvNS8yMDE5IDY6NDkgUE0sIEppcmkgUGlya28gd3JvdGU6DQo+IFN1biwgTWF5IDA1
LCAyMDE5IGF0IDAyOjMzOjI3QU0gQ0VTVCwgc2FlZWRtQG1lbGxhbm94LmNvbSB3cm90ZToNCj4+
IEZyb206IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4+DQo+PiBBZGQgc3Vw
cG9ydCBvZiBkdW1wIGNhbGxiYWNrIGZvciBtbHg1IEZXIHJlcG9ydGVyLg0KPj4gT25jZSB3ZSB0
cmlnZ2VyIEZXIGR1bXAsIHRoZSBGVyB3aWxsIHdyaXRlIHRoZSBjb3JlIGR1bXAgdG8gaXRzIHJh
dyBkYXRhDQo+PiBidWZmZXIuIFRoZSB0cmFjZXIgdHJhbnNsYXRlcyB0aGUgcmF3IGRhdGEgdG8g
dHJhY2VzIGFuZCBzYXZlIGl0IHRvIGENCj4+IGJ1ZmZlci4gT25jZSBkdW1wIGlzIGRvbmUsIHRo
ZSBzYXZlZCB0cmFjZXMgZGF0YSBpcyBmaWxsZWQgYXMgb2JqZWN0cw0KPj4gaW50byB0aGUgZHVt
cCBidWZmZXIuDQo+Pg0KPiANCj4gWy4uLl0NCj4gDQo+PiArc3RhdGljIHZvaWQgbWx4NV9md190
cmFjZXJfc2F2ZV90cmFjZShzdHJ1Y3QgbWx4NV9md190cmFjZXIgKnRyYWNlciwNCj4+ICsJCQkJ
ICAgICAgdTY0IHRpbWVzdGFtcCwgYm9vbCBsb3N0LA0KPj4gKwkJCQkgICAgICB1OCBldmVudF9p
ZCwgY2hhciAqbXNnKQ0KPj4gK3sNCj4+ICsJY2hhciAqc2F2ZWRfdHJhY2VzID0gdHJhY2VyLT5z
YnVmZi50cmFjZXNfYnVmZjsNCj4+ICsJdTMyIG9mZnNldDsNCj4+ICsNCj4+ICsJbXV0ZXhfbG9j
aygmdHJhY2VyLT5zYnVmZi5sb2NrKTsNCj4+ICsJb2Zmc2V0ID0gdHJhY2VyLT5zYnVmZi5zYXZl
ZF90cmFjZXNfaW5kZXggKiBUUkFDRV9TVFJfTElORTsNCj4+ICsJc25wcmludGYoc2F2ZWRfdHJh
Y2VzICsgb2Zmc2V0LCBUUkFDRV9TVFJfTElORSwNCj4+ICsJCSAiJXMgWzB4JWxseF0gJWQgWzB4
JXhdICVzIiwgZGV2X25hbWUoJnRyYWNlci0+ZGV2LT5wZGV2LT5kZXYpLA0KPj4gKwkJIHRpbWVz
dGFtcCwgbG9zdCwgZXZlbnRfaWQsIG1zZyk7DQo+IA0KPiBQbGVhc2UgZm9ybWF0IHRoaXMgdXNp
bmcgZm1zZyBoZWxwZXJzIGluc3RlYWQuDQo+IA0KDQpTYW1lIGhlcmUsIEkgd2FudCB0byBrZWVw
IHRoZSBmb3JtYXQgYXMgaXMsIG5vdCBjaGFuZ2UgaXQuDQo+IA0KPj4gKw0KPj4gKwl0cmFjZXIt
PnNidWZmLnNhdmVkX3RyYWNlc19pbmRleCA9DQo+PiArCQkodHJhY2VyLT5zYnVmZi5zYXZlZF90
cmFjZXNfaW5kZXggKyAxKSAmIChTQVZFRF9UUkFDRVNfTlVNIC0gMSk7DQo+PiArCW11dGV4X3Vu
bG9jaygmdHJhY2VyLT5zYnVmZi5sb2NrKTsNCj4+ICt9DQo+IA0KPiBbLi4uXQ0KPiANCg==
