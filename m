Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9617911A5BE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfLKISy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:18:54 -0500
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:61255
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726983AbfLKISy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 03:18:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST6BRCcFMs4urWpWbQ59skGOAECebBuWNvHDb1EI4UlscgxxifxVEn6pmdRxumAcbjqtgsk7d8LO99UVfeIqxqW6wxRHCXCECITlrxdY+4v9R5rs6RdjnbYST2wAPYO8sWJday5N74kXa0iqszQ7Q6oUx4eHFaHq6o/cBzX7n831DH0GlG6bqZ1V4DgOBgyckCDf+hoY/ph2R9AQu+aFz9kXYqqTGx05Y1n0M2nOt5ApeiqOqr5+3ZZQ/2qEAOh8vXNed9GRezlE5ou6BJqDAL1uG5lLk2zMGzp+dOiDynNeIvCpvayv7NGXfEPSfIYCGbGY7imc6YdnuGa4Blt+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7/IHfq5BoAYpB12cfE281hJsmBMogiDYQS3WGfJJfk=;
 b=kA+ADbmRFyRZu+BnW2uWvGlHGvXPShg3Ox3WGs6wD1ggRzp9fkEIO/IglMJgmod4VyWRybApLsmNvtxR+nb00zSZK9o1UZWFCSttFitidagPoatdD/jHpFDdRyrKsGHdGHt96mP27PImT2ALK+o/eB1NQSAfnoDI6DWsgKDTpXN7HREbeUxgG4iNMaouHJ/I5F3CR/pMMwc9dmw3LW3x53ZszSOnRu9b+lqdlQfr1p0R13qUX53T6K4cXDkeDQeZA0xgbqVNvEoYOIxV1ByscnrLqSNtxTbXwprhxo+fIjqZ+J7OZY0Chzo4JHM4unQJvX99ucYdoLVtPSAkkON6Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7/IHfq5BoAYpB12cfE281hJsmBMogiDYQS3WGfJJfk=;
 b=IFVnCOSP0zbyH6bu2XFtXswCbQ/AhjT4ddjIXjM0cmt5TuoD7oydlXSVGMp7T2L3np+WhH8irLtbQWyLN3JvGQN14XzU4onlVoP+LfbZpafKJNWJ8ryBqlLN7+zX5dYYOJVgtQ/56plgtcnVOSmnZD88WLpv/oV9XCEMErrMj3k=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3139.eurprd05.prod.outlook.com (10.170.126.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 11 Dec 2019 08:18:49 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 08:18:49 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>,
        "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Topic: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Index: AQHVr0HRTHfT+Yv+wkScuH1zWzCUpaezYX0AgADY+oCAAF48AA==
Date:   Wed, 11 Dec 2019 08:18:49 +0000
Message-ID: <33140b46-baaf-87ef-ea6f-0e2e0434253b@mellanox.com>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
 <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
 <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
 <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
In-Reply-To: <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d73e339-f7e2-4a6a-5966-08d77e12c034
x-ms-traffictypediagnostic: AM4PR05MB3139:|AM4PR05MB3139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3139B9E36F0CEC0552FB2997CF5A0@AM4PR05MB3139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(189003)(199004)(6512007)(6486002)(64756008)(31686004)(8676002)(66446008)(66556008)(36756003)(81156014)(81166006)(31696002)(8936002)(66946007)(66476007)(86362001)(2906002)(2616005)(478600001)(52116002)(966005)(71200400001)(26005)(6506007)(53546011)(110136005)(54906003)(107886003)(186003)(4326008)(316002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3139;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WpxiSI+HmfnECn13kZbEXtte663IwrJ2O51z4ni3GPCrYASGqKr3w2xOH9lmnf+fkMXgaRnewAjuFHxUJZBSJV1C3BHxBiZrRZbOQkQp0u/oNzZsBtFIKd08P4m9GBsSU8eoJ7UG1odWHhy0iHIrRf2QGWTouE+T1S9yldqmU/drpESqd34JxaopUcPkuHSByP+Wy6bfW38MS4hiBS5eGGDK+GJfRacrTBiy1ZD2J6Fe+miIJ/QU+CFohSd4Op2pPBXdiBP4MY0ie9WExtnhrCC9w0cz0IiZ/QzMFL0Plgbiz6n3DD0+jRwscUoHG04bR9iKZM1eSE3eHcaW5e/OGgQEMV4OljWHRXLPcMikIVnD48DSJ5AZ+HTloell59+t0HFyxa+zOErs2wRMjt6Jv4FrDToTDiyFG/j8xJ1hzeU2D0hdtjriVSbyxODrLbt3p7DeHesqTjriw9kdVebCp802nRHEDmG4PSsWUckvH1w=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86F2D4F6CC6C07439F7B091D007D4816@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d73e339-f7e2-4a6a-5966-08d77e12c034
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 08:18:49.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yKdgqEIVXpC13MtoI8lTy8iKY+YSLbk18NfjhSGPVhSV3SA/p/YP47EDKijrD990yrGijBWlH4JovtMZip4KaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTEvMjAxOSA0OjQxIEFNLCB3ZW54dSB3cm90ZToNCg0KPiBPbiAxMi8xMC8yMDE5IDc6
NDQgUE0sIFBhdWwgQmxha2V5IHdyb3RlOg0KPj4gT24gMTIvMTAvMjAxOSAxMjowOCBQTSwgd2Vu
eHVAdWNsb3VkLmNuIHdyb3RlOg0KPj4+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+
Pj4NCj4+PiBBZGQgbWx4NWVfcmVwX2luZHJfc2V0dXBfZnRfY2IgdG8gc3VwcG9ydCBpbmRyIGJs
b2NrIHNldHVwDQo+Pj4gaW4gRlQgbW9kZS4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IHdlbnh1
IDx3ZW54dUB1Y2xvdWQuY24+DQo+Pj4gLS0tDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysr
DQo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDM3IGluc2VydGlvbnMoKykNCj4+Pg0KPj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4+PiBp
bmRleCA2ZjMwNGY2Li5lMGRhMTdjIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPj4+IEBAIC03NDgsNiArNzQ4LDQw
IEBAIHN0YXRpYyBpbnQgbWx4NWVfcmVwX2luZHJfc2V0dXBfdGNfY2IoZW51bSB0Y19zZXR1cF90
eXBlIHR5cGUsDQo+Pj4gICAgCX0NCj4+PiAgICB9DQo+Pj4gICAgDQo+Pj4gK3N0YXRpYyBpbnQg
bWx4NWVfcmVwX2luZHJfc2V0dXBfZnRfY2IoZW51bSB0Y19zZXR1cF90eXBlIHR5cGUsDQo+Pj4g
KwkJCQkgICAgICB2b2lkICp0eXBlX2RhdGEsIHZvaWQgKmluZHJfcHJpdikNCj4+PiArew0KPj4+
ICsJc3RydWN0IG1seDVlX3JlcF9pbmRyX2Jsb2NrX3ByaXYgKnByaXYgPSBpbmRyX3ByaXY7DQo+
Pj4gKwlzdHJ1Y3QgbWx4NWVfcHJpdiAqbXByaXYgPSBuZXRkZXZfcHJpdihwcml2LT5ycHJpdi0+
bmV0ZGV2KTsNCj4+PiArCXN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdyA9IG1wcml2LT5tZGV2LT5w
cml2LmVzd2l0Y2g7DQo+Pj4gKwlzdHJ1Y3QgZmxvd19jbHNfb2ZmbG9hZCAqZiA9IHR5cGVfZGF0
YTsNCj4+PiArCXN0cnVjdCBmbG93X2Nsc19vZmZsb2FkIGNsc19mbG93ZXI7DQo+Pj4gKwl1bnNp
Z25lZCBsb25nIGZsYWdzOw0KPj4+ICsJaW50IGVycjsNCj4+PiArDQo+Pj4gKwlmbGFncyA9IE1M
WDVfVENfRkxBRyhFR1JFU1MpIHwNCj4+PiArCQlNTFg1X1RDX0ZMQUcoRVNXX09GRkxPQUQpIHwN
Cj4+PiArCQlNTFg1X1RDX0ZMQUcoRlRfT0ZGTE9BRCk7DQo+Pj4gKw0KPj4+ICsJc3dpdGNoICh0
eXBlKSB7DQo+Pj4gKwljYXNlIFRDX1NFVFVQX0NMU0ZMT1dFUjoNCj4+PiArCQlpZiAoIW1seDVf
ZXN3aXRjaF9wcmlvc19zdXBwb3J0ZWQoZXN3KSB8fCBmLT5jb21tb24uY2hhaW5faW5kZXgpDQo+
Pj4gKwkJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4+PiArDQo+Pj4gKwkJLyogUmUtdXNlIHRjIG9m
ZmxvYWQgcGF0aCBieSBtb3ZpbmcgdGhlIGZ0IGZsb3cgdG8gdGhlDQo+Pj4gKwkJICogcmVzZXJ2
ZWQgZnQgY2hhaW4uDQo+Pj4gKwkJICovDQo+Pj4gKwkJbWVtY3B5KCZjbHNfZmxvd2VyLCBmLCBz
aXplb2YoKmYpKTsNCj4+PiArCQljbHNfZmxvd2VyLmNvbW1vbi5jaGFpbl9pbmRleCA9IEZEQl9G
VF9DSEFJTjsNCj4+PiArCQllcnIgPSBtbHg1ZV9yZXBfaW5kcl9vZmZsb2FkKHByaXYtPm5ldGRl
diwgJmNsc19mbG93ZXIsIHByaXYsDQo+Pj4gKwkJCQkJICAgICBmbGFncyk7DQo+Pj4gKwkJbWVt
Y3B5KCZmLT5zdGF0cywgJmNsc19mbG93ZXIuc3RhdHMsIHNpemVvZihmLT5zdGF0cykpOw0KPj4+
ICsJCXJldHVybiBlcnI7DQo+Pj4gKwlkZWZhdWx0Og0KPj4+ICsJCXJldHVybiAtRU9QTk9UU1VQ
UDsNCj4+PiArCX0NCj4+PiArfQ0KPj4+ICsNCj4+PiAgICBzdGF0aWMgdm9pZCBtbHg1ZV9yZXBf
aW5kcl9ibG9ja191bmJpbmQodm9pZCAqY2JfcHJpdikNCj4+PiAgICB7DQo+Pj4gICAgCXN0cnVj
dCBtbHg1ZV9yZXBfaW5kcl9ibG9ja19wcml2ICppbmRyX3ByaXYgPSBjYl9wcml2Ow0KPj4+IEBA
IC04MjUsNiArODU5LDkgQEAgaW50IG1seDVlX3JlcF9pbmRyX3NldHVwX2NiKHN0cnVjdCBuZXRf
ZGV2aWNlICpuZXRkZXYsIHZvaWQgKmNiX3ByaXYsDQo+Pj4gICAgCWNhc2UgVENfU0VUVVBfQkxP
Q0s6DQo+Pj4gICAgCQlyZXR1cm4gbWx4NWVfcmVwX2luZHJfc2V0dXBfYmxvY2sobmV0ZGV2LCBj
Yl9wcml2LCB0eXBlX2RhdGEsDQo+Pj4gICAgCQkJCQkJICBtbHg1ZV9yZXBfaW5kcl9zZXR1cF90
Y19jYik7DQo+Pj4gKwljYXNlIFRDX1NFVFVQX0ZUOg0KPj4+ICsJCXJldHVybiBtbHg1ZV9yZXBf
aW5kcl9zZXR1cF9ibG9jayhuZXRkZXYsIGNiX3ByaXYsIHR5cGVfZGF0YSwNCj4+PiArCQkJCQkJ
ICBtbHg1ZV9yZXBfaW5kcl9zZXR1cF9mdF9jYik7DQo+Pj4gICAgCWRlZmF1bHQ6DQo+Pj4gICAg
CQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+Pj4gICAgCX0NCj4+ICtjYyBTYWVlZA0KPj4NCj4+DQo+
PiBUaGlzIGxvb2tzIGdvb2QgdG8gbWUsIGJ1dCBpdCBzaG91bGQgYmUgb24gdG9wIG9mIGEgcGF0
Y2ggdGhhdCB3aWxsDQo+PiBhY3R1YWwgYWxsb3dzIHRoZSBpbmRpcmVjdCBCSU5EIGlmIHRoZSBu
ZnQNCj4+DQo+PiB0YWJsZSBkZXZpY2UgaXMgYSB0dW5uZWwgZGV2aWNlLiBJcyB0aGF0IHVwc3Ry
ZWFtPyBJZiBzbyB3aGljaCBwYXRjaD8NCj4+DQo+Pg0KPj4gQ3VycmVudGx5ICg1LjUuMC1yYzEr
KSwgbmZ0X3JlZ2lzdGVyX2Zsb3d0YWJsZV9uZXRfaG9va3MgY2FsbHMNCj4+IG5mX2Zsb3dfdGFi
bGVfb2ZmbG9hZF9zZXR1cCB3aGljaCB3aWxsIHNlZQ0KPj4NCj4+IHRoYXQgdGhlIHR1bm5lbCBk
ZXZpY2UgZG9lc24ndCBoYXZlIG5kb19zZXR1cF90YyBhbmQgcmV0dXJuDQo+PiAtRU9QTk9UU1VQ
UE9SVEVELg0KPiBUaGUgcmVsYXRlZCBwYXRjaMKgIGh0dHA6Ly9wYXRjaHdvcmsub3psYWJzLm9y
Zy9wYXRjaC8xMjA2OTM1Lw0KPg0KPiBpcyB3YWl0aW5nIGZvciB1cHN0cmVhbQ0KDQpJIHNlZSwg
dGhhbmtzLg0KDQoNCg==
