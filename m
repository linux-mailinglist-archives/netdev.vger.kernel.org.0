Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319EE1186E6
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfLJLpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:45:02 -0500
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:24214
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727370AbfLJLpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 06:45:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RB5yl2ZTmyTx3eWBzP6U+jF7q+mxkXm4nq80Ea9hL2JrrGsnJvmAjbHPS9rSrL8njWr900PJdy70/WA92YiS/zKHL8uDvbV2ICdEcJ+Vw/6WKKzYyM02Jd83Us/eO/Z2VcNUTzDuuywRzD5Xf0VDM7RSndGI56ifryXrRqI49iAM+v5x4H0W3x+1Jg66FqwfqAk7UipXzYdHXE16n/3EBNAeH7lhcMP5ZsZbGa2zg0DRLR7k4h8WMjOROyTBrMRuM16zqnGimacE7TTF3UWeWzNVGpKMngfdZUTNqGjuT9CPg7blrBtd8J0hFlWL1/XVzC/OyCkG1t7smJ3Svpbpkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Fi/3lXp5p7X7NLkL6RKbjesOBl3ZZKKjo78MkY+/7w=;
 b=RXRRYeyTrMLoW4HVJezjfNCi2vXbH7KV1Zj460SHSYsKogdfRv1HHKW/fv5C6c/IA1DtYFgo0THSd79SkSg45TmQOQtUzaMXJgSHDGLydIkaTrvDBPh7TjU+fi6QQPH+xvBszQTMIV2uTtF7XIyuJ3PTfI1Uj0WMSiWhVlntkFyYkg0fgBs72VfjGKTK8PRW2Qk5fbfqDlb8CHLDWjqRu+Mg5jw6nvUJml9/ISKEzeev1UbRInuv+8P8u0PlgGVJXKC6H/FhDn2VAnZAPMYYwx/yqmw9WW3LCLZu7GYMz3dSkGICvldUCMF6rdoeCLS/H+vMHU6l92wfCKC1tJXNRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Fi/3lXp5p7X7NLkL6RKbjesOBl3ZZKKjo78MkY+/7w=;
 b=BxkFwSkDN0ihX6qf3oAixL+tGmL6pl8du/SIZHpVKjF3VW/BZI63kxrY1Wuf+8Fmayl8fpqHJ5N0k0QqZJ3TjelmCUSTmqLY9Gqnnogorhu9G3+Wagmzdk+2f6FAa8cwySkR+mtjcddRq47czfgYLi72H8i/Fww5lq0y7PDUfIs=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3428.eurprd05.prod.outlook.com (10.171.186.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 11:44:57 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 11:44:57 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Topic: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Index: AQHVr0HRTHfT+Yv+wkScuH1zWzCUpaezP/YA
Date:   Tue, 10 Dec 2019 11:44:57 +0000
Message-ID: <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
 <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0202CA0036.eurprd02.prod.outlook.com
 (2603:10a6:208:1::49) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: abce1984-a866-4f97-b9c9-08d77d66617f
x-ms-traffictypediagnostic: AM4PR05MB3428:
x-microsoft-antispam-prvs: <AM4PR05MB34285A5567ADE3A0A0FAB633CF5B0@AM4PR05MB3428.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(189003)(199004)(66446008)(66946007)(6506007)(54906003)(81156014)(81166006)(64756008)(66476007)(66556008)(8676002)(5660300002)(2906002)(6512007)(36756003)(31686004)(6486002)(316002)(71200400001)(478600001)(6916009)(86362001)(52116002)(53546011)(186003)(31696002)(8936002)(2616005)(26005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3428;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z+SMooiomRDrzUCfYBPYB9eoaHIn6xOeAgk3PJ3Is4IlaybZuMky7w/rnd5evBpbfPZhBXrQwm/XQG1nN+O77GHPTUxq98EkOx3g9u4kZuHOGmD6RaLn/5cihZB5oVVC1QgDu6YrXmYaEdXXhXIn/KBXZn5pZ+KoB1TJxbrlkHoBEWlw/rLI4fS88UqManN/0GQ8x1fyQcqBoAZ/DWgG2tJOtfF62mkVz1K6ftCNp2+u+/gk4PavhRF1q3YB7rOXlgVXAk/wdy3JE3+COM+EM5xYELO0LykKmoFwI1M75hOom5jzXVRHbMGRUXlzhDoDuK75iAvRRw94TxQLdbT+rZoy6u48CUbrDvH0sIiKxB3PXk7rEyR+3hzA5a70o35j1np25U+EfM1Tk2PjxRv4s8gBHEdK3w3jJtSf65VRAAl3Vz+Ap3Suy3TXtXcb+CiM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <82360BC51A4EF4478121EA20E77E8836@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abce1984-a866-4f97-b9c9-08d77d66617f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 11:44:57.4160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MDTMGLC2dnfY+OKQZiJSRhEQbDzstpn+1Uy0Yo83MgwjA6oUwdaocVrP65GMFTBSthFQURNR70MHvl5ZG5P2ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3428
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMi8xMC8yMDE5IDEyOjA4IFBNLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6DQo+IEZyb206
IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+DQo+IEFkZCBtbHg1ZV9yZXBfaW5kcl9zZXR1cF9m
dF9jYiB0byBzdXBwb3J0IGluZHIgYmxvY2sgc2V0dXANCj4gaW4gRlQgbW9kZS4NCj4NCj4gU2ln
bmVkLW9mZi1ieTogd2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCj4gLS0tDQo+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIHwgMzcgKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDM3IGluc2VydGlvbnMoKykNCj4NCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9y
ZXAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0K
PiBpbmRleCA2ZjMwNGY2Li5lMGRhMTdjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+IEBAIC03NDgsNiArNzQ4LDQwIEBA
IHN0YXRpYyBpbnQgbWx4NWVfcmVwX2luZHJfc2V0dXBfdGNfY2IoZW51bSB0Y19zZXR1cF90eXBl
IHR5cGUsDQo+ICAgCX0NCj4gICB9DQo+ICAgDQo+ICtzdGF0aWMgaW50IG1seDVlX3JlcF9pbmRy
X3NldHVwX2Z0X2NiKGVudW0gdGNfc2V0dXBfdHlwZSB0eXBlLA0KPiArCQkJCSAgICAgIHZvaWQg
KnR5cGVfZGF0YSwgdm9pZCAqaW5kcl9wcml2KQ0KPiArew0KPiArCXN0cnVjdCBtbHg1ZV9yZXBf
aW5kcl9ibG9ja19wcml2ICpwcml2ID0gaW5kcl9wcml2Ow0KPiArCXN0cnVjdCBtbHg1ZV9wcml2
ICptcHJpdiA9IG5ldGRldl9wcml2KHByaXYtPnJwcml2LT5uZXRkZXYpOw0KPiArCXN0cnVjdCBt
bHg1X2Vzd2l0Y2ggKmVzdyA9IG1wcml2LT5tZGV2LT5wcml2LmVzd2l0Y2g7DQo+ICsJc3RydWN0
IGZsb3dfY2xzX29mZmxvYWQgKmYgPSB0eXBlX2RhdGE7DQo+ICsJc3RydWN0IGZsb3dfY2xzX29m
ZmxvYWQgY2xzX2Zsb3dlcjsNCj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArCWludCBlcnI7
DQo+ICsNCj4gKwlmbGFncyA9IE1MWDVfVENfRkxBRyhFR1JFU1MpIHwNCj4gKwkJTUxYNV9UQ19G
TEFHKEVTV19PRkZMT0FEKSB8DQo+ICsJCU1MWDVfVENfRkxBRyhGVF9PRkZMT0FEKTsNCj4gKw0K
PiArCXN3aXRjaCAodHlwZSkgew0KPiArCWNhc2UgVENfU0VUVVBfQ0xTRkxPV0VSOg0KPiArCQlp
ZiAoIW1seDVfZXN3aXRjaF9wcmlvc19zdXBwb3J0ZWQoZXN3KSB8fCBmLT5jb21tb24uY2hhaW5f
aW5kZXgpDQo+ICsJCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICsNCj4gKwkJLyogUmUtdXNlIHRj
IG9mZmxvYWQgcGF0aCBieSBtb3ZpbmcgdGhlIGZ0IGZsb3cgdG8gdGhlDQo+ICsJCSAqIHJlc2Vy
dmVkIGZ0IGNoYWluLg0KPiArCQkgKi8NCj4gKwkJbWVtY3B5KCZjbHNfZmxvd2VyLCBmLCBzaXpl
b2YoKmYpKTsNCj4gKwkJY2xzX2Zsb3dlci5jb21tb24uY2hhaW5faW5kZXggPSBGREJfRlRfQ0hB
SU47DQo+ICsJCWVyciA9IG1seDVlX3JlcF9pbmRyX29mZmxvYWQocHJpdi0+bmV0ZGV2LCAmY2xz
X2Zsb3dlciwgcHJpdiwNCj4gKwkJCQkJICAgICBmbGFncyk7DQo+ICsJCW1lbWNweSgmZi0+c3Rh
dHMsICZjbHNfZmxvd2VyLnN0YXRzLCBzaXplb2YoZi0+c3RhdHMpKTsNCj4gKwkJcmV0dXJuIGVy
cjsNCj4gKwlkZWZhdWx0Og0KPiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICsJfQ0KPiArfQ0K
PiArDQo+ICAgc3RhdGljIHZvaWQgbWx4NWVfcmVwX2luZHJfYmxvY2tfdW5iaW5kKHZvaWQgKmNi
X3ByaXYpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgbWx4NWVfcmVwX2luZHJfYmxvY2tfcHJpdiAqaW5k
cl9wcml2ID0gY2JfcHJpdjsNCj4gQEAgLTgyNSw2ICs4NTksOSBAQCBpbnQgbWx4NWVfcmVwX2lu
ZHJfc2V0dXBfY2Ioc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiwgdm9pZCAqY2JfcHJpdiwNCj4g
ICAJY2FzZSBUQ19TRVRVUF9CTE9DSzoNCj4gICAJCXJldHVybiBtbHg1ZV9yZXBfaW5kcl9zZXR1
cF9ibG9jayhuZXRkZXYsIGNiX3ByaXYsIHR5cGVfZGF0YSwNCj4gICAJCQkJCQkgIG1seDVlX3Jl
cF9pbmRyX3NldHVwX3RjX2NiKTsNCj4gKwljYXNlIFRDX1NFVFVQX0ZUOg0KPiArCQlyZXR1cm4g
bWx4NWVfcmVwX2luZHJfc2V0dXBfYmxvY2sobmV0ZGV2LCBjYl9wcml2LCB0eXBlX2RhdGEsDQo+
ICsJCQkJCQkgIG1seDVlX3JlcF9pbmRyX3NldHVwX2Z0X2NiKTsNCj4gICAJZGVmYXVsdDoNCj4g
ICAJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gICAJfQ0KDQoNCitjYyBTYWVlZA0KDQoNClRoaXMg
bG9va3MgZ29vZCB0byBtZSwgYnV0IGl0IHNob3VsZCBiZSBvbiB0b3Agb2YgYSBwYXRjaCB0aGF0
IHdpbGwgDQphY3R1YWwgYWxsb3dzIHRoZSBpbmRpcmVjdCBCSU5EIGlmIHRoZSBuZnQNCg0KdGFi
bGUgZGV2aWNlIGlzIGEgdHVubmVsIGRldmljZS4gSXMgdGhhdCB1cHN0cmVhbT8gSWYgc28gd2hp
Y2ggcGF0Y2g/DQoNCg0KQ3VycmVudGx5ICg1LjUuMC1yYzErKSwgbmZ0X3JlZ2lzdGVyX2Zsb3d0
YWJsZV9uZXRfaG9va3MgY2FsbHMgDQpuZl9mbG93X3RhYmxlX29mZmxvYWRfc2V0dXAgd2hpY2gg
d2lsbCBzZWUNCg0KdGhhdCB0aGUgdHVubmVsIGRldmljZSBkb2Vzbid0IGhhdmUgbmRvX3NldHVw
X3RjIGFuZCByZXR1cm4gDQotRU9QTk9UU1VQUE9SVEVELg0KDQoNClRoYW5rcywNCg0KUGF1bC4N
Cg0KDQoNCg==
