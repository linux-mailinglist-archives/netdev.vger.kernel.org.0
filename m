Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7415B1EC
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 21:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgBLUdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 15:33:52 -0500
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:1120
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727111AbgBLUdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 15:33:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGzsiYPp+d8v1dxKlwZlEELfdhlXU1eXnJPE/5e0apuoFDUGYC/0amO2rfwiobQ8HUwW3zTP6/hx1wfjBuOj0fxc8crNltkZW3ALjdjXP1D9aOBJendoYIHuOiMCWjyoHEagrA7ZHIvVQFC1K/ikMZt36v4VxeZS3P8ZC3uw2WT1tZr0NL2r5DPv5clyWoh6XbDaGfzugzN803J07h3gr3ayEoEhlkTN5mg1xc0qSIwFCC9OyT07iGOq7Dr/Yqvznx9yvEEKrkRYeaBfUoAGazmuucx1p8ogX0fRcClDzUhxYWwXZvOIWYlQpXVUWlbMJ6RYq0lCOuO94CrvjrdsmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZKyhCksXOHnRlsyryq6WucA5jdXzWmabHXP65N8wn8=;
 b=StmLGp25wXkx5/pwLfcrl8E0hLSwVwBDXGAEPOFY2sbBLfKUikVCIB0eyJmxyGvySX/tIzFOSZx0Ra1bt0NrgJlKQn9Zsk9Cna403a9zBZWPTH8+gT12A8/7BT3QvIMsY39VAvY8RVidYi+SYMMb5Kz+Ed3nJEkK+F6xGztEPqQXVOqerd1nctjMaNoi2V6446SSs7F6pgr/DKh6nSx6Ndn2S0PYE6FFn8UNadBnlPW6LSbSJNJpot3vcg2FNIp6hlTkP7mE+EuF60KimeeS2uDnhnsIhcJmDY/2NbMpBalZeUEmDi8ri/xJ2/Ndxq99jUEmmM5P/fxli0Bfr8oFdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZKyhCksXOHnRlsyryq6WucA5jdXzWmabHXP65N8wn8=;
 b=cbqx48beR6jqutYCzXg8ckO9JPImTsX0GOcllZJGYkvS6lI7vtf8+Kuf2kxTulQJLcGX6lB1nVOPKOuc2N2XyzOPoNU/iswXff1jfoTtxuhlTy9sit0i3wysqROQn9AlFEIDb5e4w9CMoxkAGjfP3cGpXPbxQnGIYWF3EtMkito=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3134.eurprd05.prod.outlook.com (10.170.237.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.28; Wed, 12 Feb 2020 20:33:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 20:33:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "vfalico@gmail.com" <vfalico@gmail.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Rosenbaum <alexr@mellanox.com>
Subject: Re: [RFC PATCH 1/4] net/core: Introduce master_xmit_slave_get
Thread-Topic: [RFC PATCH 1/4] net/core: Introduce master_xmit_slave_get
Thread-Index: AQHV1EuKE2VPB79zBkWoYagTrztDIqgYHqsA
Date:   Wed, 12 Feb 2020 20:33:08 +0000
Message-ID: <ddd3dccc215db626e6e3195555a6dece39422ce1.camel@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com>
         <20200126132126.9981-2-maorg@mellanox.com>
In-Reply-To: <20200126132126.9981-2-maorg@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fbacd84e-1e39-415a-2640-08d7affac561
x-ms-traffictypediagnostic: VI1PR05MB3134:|VI1PR05MB3134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3134DC1D16C92F57D1A856AFBE1B0@VI1PR05MB3134.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(189003)(199004)(4326008)(5660300002)(76116006)(54906003)(107886003)(186003)(91956017)(64756008)(8676002)(81166006)(8936002)(6512007)(66476007)(66446008)(66556008)(66946007)(81156014)(6486002)(71200400001)(478600001)(36756003)(6636002)(26005)(2616005)(316002)(6506007)(110136005)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3134;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AQOLouiW0bVrjajI9ygaV2sMsoX2/dwdZOXmlpRhL+nvnKes6L6twfJukUI+rkoyr+JwwWMdduCR5npCjzPx1ZRLOVjOpaW3qCMynH+RzA2ySBOSkeEKF1aJcGhjvWpTTFG3JgSWy/GDCkm8iLRoaxEthQLtzDI0p27MfVnJQsUqneMic99Uh5Pakf6Aw0xqXCN3oz6Ols/WpS7hN746qGDIYLlSGkswt6S8x9k+/H9UA3PB+arv+pcFhJ9bYUiDe3Rlbfa/Sc4xZN2PYak7OA9jXTf0nUgWhjGAjFQFWwe3/BdaxHvg0n5Lx5WitQIetcHreP+7ro7+AMjL9tUY4t0vQeT21ipdSDKa3I4t5OCo0oumkmWhV4UJUgXmA2MVP4TQxGT77IO6FCfwAyCehJIYZyqRZzfJ2vHD0llViPI0GEXnznmkOyu772lSmQLO
x-ms-exchange-antispam-messagedata: aFE8CSVli3vMqZTspdwRWzva2+BBOMG5TSSstlaXo8SJIkNDk8cne4f+JRHR+uRwFovxlkcjRySFnXt9lCl/ciZq2raW30ZIFwduIp3h2CGi4qjZX+fuR6ULTWW5y7fXBfmXWWwZNsARrRj6JfhlwA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B84C9A8200BE3646A891564DBE75BB88@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbacd84e-1e39-415a-2640-08d7affac561
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 20:33:08.2888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: My+186s1OA/db3N+wx0RLMdXThpTko/Y97vXWuegDX/Z0v/i9xxoRfDDzzuKEQMEp3zsUK30yrd/8eRgGSC/QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAxLTI2IGF0IDE1OjIxICswMjAwLCBNYW9yIEdvdHRsaWViIHdyb3RlOg0K
PiBBZGQgbmV3IG5kbyB0byBnZXQgdGhlIHhtaXQgc2xhdmUgb2YgbWFzdGVyIGRldmljZS4NCj4g
V2hlbiBzbGF2ZSBzZWxlY3Rpb24gbWV0aG9kIGlzIGJhc2VkIG9uIGhhc2gsIHRoZW4gdGhlIHVz
ZXIgY2FuIGFzaw0KPiB0bw0KPiBnZXQgdGhlIHhtaXQgc2xhdmUgYXNzdW1lIGFsbCB0aGUgc2xh
dmVzIGNhbiB0cmFuc21pdCBieSBzZXR0aW5nIHRoZQ0KPiBMQUdfRkxBR1NfSEFTSF9BTExfU0xB
VkVTIGJpdCBpbiB0aGUgZmxhZ3MgYXJndW1lbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYW9y
IEdvdHRsaWViIDxtYW9yZ0BtZWxsYW5veC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9u
ZXRkZXZpY2UuaCB8ICAzICsrKw0KPiAgaW5jbHVkZS9uZXQvbGFnLmggICAgICAgICB8IDE5ICsr
KysrKysrKysrKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmggYi9pbmNsdWRlL2xp
bnV4L25ldGRldmljZS5oDQo+IGluZGV4IDExYmRmNmNiMzBiZC4uZmFiYTRhYTA5NGU1IDEwMDY0
NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQo+ICsrKyBiL2luY2x1ZGUvbGlu
dXgvbmV0ZGV2aWNlLmgNCj4gQEAgLTEzNzksNiArMTM3OSw5IEBAIHN0cnVjdCBuZXRfZGV2aWNl
X29wcyB7DQo+ICAJCQkJCQkgc3RydWN0IG5ldGxpbmtfZXh0X2Fjaw0KPiAqZXh0YWNrKTsNCj4g
IAlpbnQJCQkoKm5kb19kZWxfc2xhdmUpKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsDQo+ICAJ
CQkJCQkgc3RydWN0IG5ldF9kZXZpY2UNCj4gKnNsYXZlX2Rldik7DQo+ICsJc3RydWN0IG5ldF9k
ZXZpY2UqCSgqbmRvX3htaXRfc2xhdmVfZ2V0KShzdHJ1Y3QNCj4gbmV0X2RldmljZSAqbWFzdGVy
X2RldiwNCj4gKwkJCQkJCSAgICAgIHN0cnVjdCBza19idWZmDQo+ICpza2IsDQo+ICsJCQkJCQkg
ICAgICBpbnQgbGFnKTsNCj4gIAluZXRkZXZfZmVhdHVyZXNfdAkoKm5kb19maXhfZmVhdHVyZXMp
KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+ICAJCQkJCQkgICAgbmV0ZGV2X2ZlYXR1cmVzX3QN
Cj4gZmVhdHVyZXMpOw0KPiAgCWludAkJCSgqbmRvX3NldF9mZWF0dXJlcykoc3RydWN0IG5ldF9k
ZXZpY2UNCj4gKmRldiwNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2xhZy5oIGIvaW5jbHVk
ZS9uZXQvbGFnLmgNCj4gaW5kZXggOTViODgwZTZmZGRlLi5jNzEwZGFmOGY1N2EgMTAwNjQ0DQo+
IC0tLSBhL2luY2x1ZGUvbmV0L2xhZy5oDQo+ICsrKyBiL2luY2x1ZGUvbmV0L2xhZy5oDQo+IEBA
IC02LDYgKzYsMjUgQEANCj4gICNpbmNsdWRlIDxsaW51eC9pZl90ZWFtLmg+DQo+ICAjaW5jbHVk
ZSA8bmV0L2JvbmRpbmcuaD4NCj4gIA0KPiArZW51bSBsYWdfZ2V0X3NsYXZlc19mbGFncyB7DQo+
ICsJTEFHX0ZMQUdTX0hBU0hfQUxMX1NMQVZFUyA9IDE8PDANCj4gK307DQo+ICsNCj4gK3N0YXRp
YyBpbmxpbmUNCj4gK3N0cnVjdCBuZXRfZGV2aWNlICptYXN0ZXJfeG1pdF9zbGF2ZV9nZXQoc3Ry
dWN0IG5ldF9kZXZpY2UNCj4gKm1hc3Rlcl9kZXYsDQo+ICsJCQkJCSBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLA0KPiArCQkJCQkgaW50IGZsYWdzKQ0KPiArew0KPiArCWNvbnN0IHN0cnVjdCBuZXRfZGV2
aWNlX29wcyAqb3BzID0gbWFzdGVyX2Rldi0+bmV0ZGV2X29wczsNCj4gKwlzdHJ1Y3QgbmV0X2Rl
dmljZSAqc2xhdmUgPSBOVUxMOw0KPiArDQo+ICsJcmN1X3JlYWRfbG9jaygpOw0KPiArCWlmIChv
cHMtPm5kb194bWl0X3NsYXZlX2dldCkNCj4gKwkJc2xhdmUgPSBvcHMtPm5kb194bWl0X3NsYXZl
X2dldChtYXN0ZXJfZGV2LCBza2IsDQo+IGZsYWdzKTsNCg0Kd2hhdCBpcyB0aGUgcHVycG9zZSBv
ZiB0aGUgcmN1ID8gQXJlbid0IHlvdSBzdXBwb3NlZCB0byBkZXZfaG9sZChzbGF2ZSkNCnVuZGVy
IHRoZSByY3UgPw0KDQphbmQgdGhlIGNhbGxlciBzaG91bGQgYmUgcmVzcG9uc2libGUgdG8gaXNz
dWUgdGhlIGRldl9wdXQoKSAuLiANCg0Kb3RoZXJ3aXNlIHNsYXZlIGlzIG5vdCBndWFyYW50ZWVk
IHRvIHN0aWNrIGFyb3VuZCBhZnRlciB0aGlzIG5kbw0KcmV0dXJucy4gb3IgaSBhbSBtaXNzaW5n
IHNvbWUgYXNzdW1wdGlvbnMgdGhhdCBhcmUgbm90IGxpc3RlZCBpbiB0aGlzDQpwYXRjaHNldCBj
b21taXQgbWVzc2FnZXMgb3IgY292ZXIgbGV0dGVyLg0KDQpQbGVhc2UgY2xhcmlmeS4NCg0KDQo+
ICsJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICsJcmV0dXJuIHNsYXZlOw0KPiArfQ0KPiArDQo+ICBz
dGF0aWMgaW5saW5lIGJvb2wgbmV0X2xhZ19wb3J0X2Rldl90eGFibGUoY29uc3Qgc3RydWN0IG5l
dF9kZXZpY2UNCj4gKnBvcnRfZGV2KQ0KPiAgew0KPiAgCWlmIChuZXRpZl9pc190ZWFtX3BvcnQo
cG9ydF9kZXYpKQ0K
