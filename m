Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6842418A93C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCRXdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:33:53 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:16837
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726619AbgCRXdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 19:33:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbT+UfzEVNDpdrXK7tnRAeuykRr4SAhfoMEoeuTwogOu0YmXoQmWUtrEXRQzqeNaZCecXmCypVq7k1UtUly0ZfjRvl573OXYUQ8xgytlkezm5y03rWPU4n4dgQxTBj4bvvQq9nrZLio/BRxaUvhWXbUaVQpSSP99ZAiwGsCYVYbFKjrfJxx/0hEjQj15Jt/3DoWEhEwBzpO+L5a/E6ppInJd8MMP97puoipU1hpGz90kmlDx0oOw3oMZD35G2or+eAJ5AmQBEVPahTnGfjfOp9bdg+DLA9kks29E1OWyvqdm8l7YvR9dMvYQ8OwqEhxa7RnUF++hfOwBnwAN8+QZkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIQmgh8D8D1O4jquSxglyavQs1aY6SdFwg3SaxkBG5g=;
 b=JRlEPPJy9NdhoqvwJ4OespKhptqRdiDJp9fNCxj/JbeNIPnrFhoFaYcXTWDA0hBFxrO4ATP/hWii0cNAs3omlAxbxAs97lwXfuhsfot4WLG7jVN5c7aRwGCJSmCWs+O4+jEAGqxOh49L7PLE/XbcOKBux9L4Mwdw+TI4XJ/Gmo7Iq7jMxvaQgw9a3sxpcXZ9uvMXh5cWujv8NbDdOoULLQZQQ+T4qwXTrRApmg7TIrco0UldHEHbomJ59XB4IBwklI8wCiqaoMplp1iE0qpO/dl+WeF5dwoIifGSnRKtQqJc/bFq/wukJfnrHD90vtGwDxPmgzfWvMlh7fBZ5yHKIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIQmgh8D8D1O4jquSxglyavQs1aY6SdFwg3SaxkBG5g=;
 b=mU1CE5myzC/KfRdAaPJ+eV5KPY0WSV6OLo0cIv1dKdwFRyRfgtDsyvSQ6LMukPsN11WzGgrQs1t1/xDOSdJYea2jnyGI5DGN+RXFpyCMnKJPe97KJ+MVq9EXqtJ8f+iR+CVkV3gBfm0RfZdiDTYteyrx0F2c+y/K0sZXZYbBEoU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 18 Mar 2020 23:33:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 23:33:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/6] net/mlx5: Enable SW-defined RoCEv2 UDP
 source port
Thread-Topic: [PATCH mlx5-next 1/6] net/mlx5: Enable SW-defined RoCEv2 UDP
 source port
Thread-Index: AQHV/QsVgN26KcXZYUykNbA+YDRQuahPATyA
Date:   Wed, 18 Mar 2020 23:33:46 +0000
Message-ID: <56a58821295022d4726abcecb879ade05ecf45cd.camel@mellanox.com>
References: <20200318095300.45574-1-leon@kernel.org>
         <20200318095300.45574-2-leon@kernel.org>
In-Reply-To: <20200318095300.45574-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7306a621-5f6f-4aca-fcc4-08d7cb94cdb4
x-ms-traffictypediagnostic: VI1PR05MB5533:|VI1PR05MB5533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5533427CF8955ED80C2B589CBEF70@VI1PR05MB5533.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(199004)(54906003)(8936002)(36756003)(71200400001)(2906002)(8676002)(81156014)(66946007)(81166006)(26005)(66446008)(66476007)(66556008)(64756008)(186003)(2616005)(76116006)(5660300002)(91956017)(6506007)(478600001)(110136005)(86362001)(316002)(6512007)(4326008)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SnCdNwW8NwWAphTo3wwRdXYtDY8f0Ng4pGtZbr4sfRMoxkLd4XSYiAaad0ENV6FS7p124EHwMtFNPpSKGhOL/KtUUv/CsfNHrm5GuLphsAJqTPoAOuw7h+arcT24Hz0+FNY++FphFBC5N8QFvWRU0W4XHPpvPEnuKRu+1gK7QNI7tr3a9enaLMMheOZ0iV69J5C6BL2h7M79aJw2/Be3jGfjC/w/nkiPUhPLqDJTjG4J+VZMQeUKIxILY7Gs9M6KxNoRw9fHQ+IGlaSuB/r9NrHWiW3Ydt53tJEloKjIPz7XM9vyfvdnSafuv2TQfOhBcsJoLMa5bZwHetJrE1zFNubia/I/0he9WxAmCc+i+d++VagySNN2JlU6F8qg6qZkTVHszzN0n/a26um8P/SicGPqZuCsV2aF9TA2Lb8h3aAsBgz5SF2QLl7MD7dXc1hW
x-ms-exchange-antispam-messagedata: NsrcofDvxf1NL4WtRS5WbcuipjFH0dW0eyWsFQWHj9kLcKHD+u2z8BvW5f7HmAjekmxBPLVYJr57FzoZhLEtuUFXiITiB+R0C/ofqRhA3/s1Jvukfzn6Qw8m0Eoj01NBOLjfecZ+9UB9+OsmuDAb+w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1957963F9314064C921CBD86831DF5D4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7306a621-5f6f-4aca-fcc4-08d7cb94cdb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 23:33:46.2013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBPAo9k/DNRIDHlvQjGsrznQlh7ldcgeqADY5zBgPHZ9Z+MCnOVWyY6U3KIjQ5jAQtcu6KAfQ53oDrNO1Oz7rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTE4IGF0IDExOjUyICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IEZyb206IE1hcmsgWmhhbmcgPG1hcmt6QG1lbGxhbm94LmNvbT4NCj4gDQo+IFdoZW4gdGhp
cyBpcyBlbmFibGVkLCBVRFAgc291cmNlIHBvcnQgZm9yIFJvQ0V2MiBwYWNrZXRzIGFyZSBkZWZp
bmVkDQo+IGJ5IHNvZnR3YXJlIGluc3RlYWQgb2YgZmlybXdhcmUuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBNYXJrIFpoYW5nIDxtYXJrekBtZWxsYW5veC5jb20+DQo+IFJldmlld2VkLWJ5OiBNYW9y
IEdvdHRsaWViIDxtYW9yZ0BtZWxsYW5veC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IExlb24gUm9t
YW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gLS0tDQo+ICAuLi4vbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgICAgfCAzOQ0KPiArKysrKysrKysrKysrKysrKysr
DQo+ICBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaCAgICAgICAgICAgICAgICAgfCAgNSAr
Ky0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFp
bi5jDQo+IGluZGV4IDZiMzhlYzcyMjE1YS4uYmRjNzMzNzAyOTdiIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gQEAgLTU4NSw2
ICs1ODUsMzkgQEAgc3RhdGljIGludCBoYW5kbGVfaGNhX2NhcChzdHJ1Y3QgbWx4NV9jb3JlX2Rl
dg0KPiAqZGV2KQ0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgaGFu
ZGxlX2hjYV9jYXBfcm9jZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KPiArew0KPiArCWlu
dCBzZXRfc3ogPSBNTFg1X1NUX1NaX0JZVEVTKHNldF9oY2FfY2FwX2luKTsNCj4gKwl2b2lkICpz
ZXRfaGNhX2NhcDsNCj4gKwl2b2lkICpzZXRfY3R4Ow0KPiArCWludCBlcnI7DQo+ICsNCj4gKwlp
ZiAoIU1MWDVfQ0FQX0dFTihkZXYsIHJvY2UpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCWVy
ciA9IG1seDVfY29yZV9nZXRfY2FwcyhkZXYsIE1MWDVfQ0FQX1JPQ0UpOw0KPiArCWlmIChlcnIp
DQo+ICsJCXJldHVybiBlcnI7DQo+ICsNCj4gKwlpZiAoTUxYNV9DQVBfUk9DRShkZXYsIHN3X3Jf
cm9jZV9zcmNfdWRwX3BvcnQpIHx8DQo+ICsJICAgICFNTFg1X0NBUF9ST0NFX01BWChkZXYsIHN3
X3Jfcm9jZV9zcmNfdWRwX3BvcnQpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCXNldF9jdHgg
PSBremFsbG9jKHNldF9zeiwgR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKCFzZXRfY3R4KQ0KPiArCQly
ZXR1cm4gLUVOT01FTTsNCj4gKw0KDQphbGwgdGhlIHNpc3RlcnMgb2YgdGhpcyBmdW5jdGlvbiBh
bGxvY2F0ZSB0aGlzIGFuZCBmcmVlIGl0DQpjb25zZWN1dGl2ZWx5LCB3aHkgbm90IGFsbG9jYXRl
IGl0IGZyb20gb3V0c2lkZSBvbmNlLCBwYXNzIGl0IHRvIGFsbA0KaGFuZGxlX2hjYV9jYXBfeHl6
IGZ1bmN0aW9ucywgZWFjaCBvbmUgd2lsbCBtZW1zZXQgaXQgYW5kIHJldXNlIGl0Lg0Kc2VlIGJl
bG93Lg0KDQo+ICsJc2V0X2hjYV9jYXAgPSBNTFg1X0FERFJfT0Yoc2V0X2hjYV9jYXBfaW4sIHNl
dF9jdHgsDQo+IGNhcGFiaWxpdHkpOw0KPiArCW1lbWNweShzZXRfaGNhX2NhcCwgZGV2LT5jYXBz
LmhjYV9jdXJbTUxYNV9DQVBfUk9DRV0sDQo+ICsJICAgICAgIE1MWDVfU1RfU1pfQllURVMocm9j
ZV9jYXApKTsNCj4gKwlNTFg1X1NFVChyb2NlX2NhcCwgc2V0X2hjYV9jYXAsIHN3X3Jfcm9jZV9z
cmNfdWRwX3BvcnQsIDEpOw0KPiArDQo+ICsJZXJyID0gc2V0X2NhcHMoZGV2LCBzZXRfY3R4LCBz
ZXRfc3osDQo+IE1MWDVfU0VUX0hDQV9DQVBfT1BfTU9EX1JPQ0UpOw0KPiArDQoNCkRvIHdlIHJl
YWxseSBuZWVkIHRvIGZhaWwgdGhlIHdob2xlIGRyaXZlciBpZiB3ZSBqdXN0IHRyeSB0byBzZXQg
YSBub24NCm1hbmRhdG9yeSBjYXAgPw0KDQo+ICsJa2ZyZWUoc2V0X2N0eCk7DQo+ICsJcmV0dXJu
IGVycjsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCBzZXRfaGNhX2NhcChzdHJ1Y3QgbWx4NV9j
b3JlX2RldiAqZGV2KQ0KPiAgew0KPiAgCWludCBlcnI7DQoNCmxldCdzIGFsbG9jYXRlIHRoZSBz
ZXRfY3R4IGluIHRoaXMgcGFyZW50IGZ1bmN0aW9uIGFuZCBwYXNzIGl0IHRvIGFsbA0KaGNhIGNh
cCBoYW5kbGVyczsNCg0Kc2V0X3N6ID0gTUxYNV9TVF9TWl9CWVRFUyhzZXRfaGNhX2NhcF9pbik7
DQpzZXRfY3R4ID0ga3phbGxvYyhzZXRfc3osIEdGUF9LRVJORUwpOw0KDQo+IEBAIC02MDcsNiAr
NjQwLDEyIEBAIHN0YXRpYyBpbnQgc2V0X2hjYV9jYXAoc3RydWN0IG1seDVfY29yZV9kZXYNCj4g
KmRldikNCj4gIAkJZ290byBvdXQ7DQo+ICAJfQ0KPiAgDQo+ICsJZXJyID0gaGFuZGxlX2hjYV9j
YXBfcm9jZShkZXYpOw0KPiArCWlmIChlcnIpIHsNCj4gKwkJbWx4NV9jb3JlX2VycihkZXYsICJo
YW5kbGVfaGNhX2NhcF9yb2NlIGZhaWxlZFxuIik7DQo+ICsJCWdvdG8gb3V0Ow0KPiArCX0NCj4g
Kw0KPiAgb3V0Og0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L21seDUvbWx4NV9pZmMuaA0KPiBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5o
DQo+IGluZGV4IDIwOGJmMTEyN2JlNy4uYmIyMTdjM2YzMGRhIDEwMDY0NA0KPiAtLS0gYS9pbmNs
dWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L21seDUvbWx4
NV9pZmMuaA0KPiBAQCAtNzQsNiArNzQsNyBAQCBlbnVtIHsNCj4gIAlNTFg1X1NFVF9IQ0FfQ0FQ
X09QX01PRF9HRU5FUkFMX0RFVklDRSAgICAgICAgPSAweDAsDQo+ICAJTUxYNV9TRVRfSENBX0NB
UF9PUF9NT0RfT0RQICAgICAgICAgICAgICAgICAgID0gMHgyLA0KPiAgCU1MWDVfU0VUX0hDQV9D
QVBfT1BfTU9EX0FUT01JQyAgICAgICAgICAgICAgICA9IDB4MywNCj4gKwlNTFg1X1NFVF9IQ0Ff
Q0FQX09QX01PRF9ST0NFICAgICAgICAgICAgICAgICAgPSAweDQsDQo+ICB9Ow0KPiAgDQo+ICBl
bnVtIHsNCj4gQEAgLTkwMiw3ICs5MDMsOSBAQCBzdHJ1Y3QNCj4gbWx4NV9pZmNfcGVyX3Byb3Rv
Y29sX25ldHdvcmtpbmdfb2ZmbG9hZF9jYXBzX2JpdHMgew0KPiAgDQo+ICBzdHJ1Y3QgbWx4NV9p
ZmNfcm9jZV9jYXBfYml0cyB7DQo+ICAJdTggICAgICAgICByb2NlX2FwbVsweDFdOw0KPiAtCXU4
ICAgICAgICAgcmVzZXJ2ZWRfYXRfMVsweDFmXTsNCj4gKwl1OCAgICAgICAgIHJlc2VydmVkX2F0
XzFbMHgzXTsNCj4gKwl1OCAgICAgICAgIHN3X3Jfcm9jZV9zcmNfdWRwX3BvcnRbMHgxXTsNCj4g
Kwl1OCAgICAgICAgIHJlc2VydmVkX2F0XzVbMHgxYl07DQo+ICANCj4gIAl1OCAgICAgICAgIHJl
c2VydmVkX2F0XzIwWzB4NjBdOw0KPiAgDQo=
