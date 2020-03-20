Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3189018C48D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 02:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCTBQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 21:16:36 -0400
Received: from mail-eopbgr10040.outbound.protection.outlook.com ([40.107.1.40]:60483
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbgCTBQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 21:16:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+LRfHusjPkFWvZhDV4+0XMld8FQ53EdXdaGymGUxO1FFnQRyV2YWEw6i6bZhzcuQs+t9NE/YuAXuOOuIOks7ePwybAx/nx4rs06PbfQJ3id6L0S32aMUWIYoiPGIGUxNJ8aUSaMH6pkiXa3zZj+uVKF7RHeGai8GzXQVU4OFHh/lnvfcW2rjKmqfr03hUOUGBUhClnofTb/e8M65npoYdcVMdKbODbDksy4hs7TC+9idOJRMLjIBegx8rpiu2HAnlIhbqt2hYzFjkdtgOwVOKNTp54SQEi27CsFEnGTj2d17XwE3N1IDNpLQS95neo/ginGHS0bkxp1FJmg/pzoJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho89N30Y8f6CBdOnRVcfC8fXzqyCf4QONfETotS2Wfo=;
 b=VygOpYAMywFGgCHkEpXxS+Ohqss8eI36e52KrzXf7MVD2zPvMpjrJS4eNGCseZ+TAk2Z/8dir1Vx0xh/HAWIAL4eN+bwsx4c5vR7yIuqgAjMQwl8UOcusa5/HNZOE4vmB34/SAg9mIzjnt9poiGiSw+8Mu+y2ZeF9dNhWcZETghaxrkToGgsWqS8Qai+hXnVwR8cAhdjvIeKKMHtEzsvTfM9+VvBc4RcxbzhESEvsOZRnV6poJaZoRd7vOm40BLzzoklxR2rb4jDYZNlUjbnLgu5PxzYkl4uH6u4a7XkcyqIKPM0jx6ai6TDXg9Lh6+o7nhrRsvgIkkY162V6CPdSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho89N30Y8f6CBdOnRVcfC8fXzqyCf4QONfETotS2Wfo=;
 b=RbutYB7kFYBAw69lC/AwYz4C8+198ItJ8ZaBbwLqH5CpEDNPSrD3ViS0sSR851c6ZIbNgPdWrURpGGOhss82K/fWxs/BqlLTGUVFPT3CBbBgXUqkGouxm7XiD/g/3nvf1eQ4uhCbBxJ4iIJWJ+1QFBkuu6qF7zT0FowuxOJ4kN0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6736.eurprd05.prod.outlook.com (10.186.163.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.19; Fri, 20 Mar 2020 01:16:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 01:16:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH mlx5-next 1/6] net/mlx5: Enable SW-defined RoCEv2 UDP
 source port
Thread-Topic: [PATCH mlx5-next 1/6] net/mlx5: Enable SW-defined RoCEv2 UDP
 source port
Thread-Index: AQHV/QsVgN26KcXZYUykNbA+YDRQuahPATyAgABtbwCAAUGXgA==
Date:   Fri, 20 Mar 2020 01:16:28 +0000
Message-ID: <3cf47bdde036515903a40a8e5577f1559e2ee988.camel@mellanox.com>
References: <20200318095300.45574-1-leon@kernel.org>
         <20200318095300.45574-2-leon@kernel.org>
         <56a58821295022d4726abcecb879ade05ecf45cd.camel@mellanox.com>
         <20200319060524.GG126814@unreal>
In-Reply-To: <20200319060524.GG126814@unreal>
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
x-ms-office365-filtering-correlation-id: 88213c42-3110-4475-afbc-08d7cc6c50e0
x-ms-traffictypediagnostic: VI1PR05MB6736:|VI1PR05MB6736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB67369D0EEA739BAF4C680053BEF50@VI1PR05MB6736.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(66446008)(478600001)(64756008)(66946007)(66476007)(66556008)(5660300002)(6486002)(81156014)(6512007)(6506007)(71200400001)(8936002)(54906003)(8676002)(81166006)(316002)(91956017)(76116006)(6916009)(36756003)(2906002)(4326008)(2616005)(26005)(86362001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6736;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QgDnFBYKioD/AyTRSQiPIq93WacveRFNc4ERksQq478iX0WAAsU5+Ht67qsM7ho5UbyHgNB/t9GamuwG4VyyQak4RWAEvrPYCsrrXQ0kEF3N50+htfxt+crydWk6PMsrb6cMuCdIiK5yMGv6n6AJ2cWBkOKx34PG7hFNusiUVvyj+2sEBYbUX7xcJEmgOfr2dxvJjnfVrv/bcK1m7BqVcsCEeccnWHjtqXR6jpN93fxFkbLkvqmVqY0hInkvoYWm6OBoM4jUt7komw+A5COCOWiGVXUleMZdIhfV9iQ7t5PaafbJ5mRhNpPRqH/Y5AiTaEFWeCFPnXfpXBgtvAgWH9KEMyYomkJ9GTlUXq2tbNyPZr5IWpyCKVsvD0g5IKTMG3qUn7P+9ex/t/mCjl9hFSD3kJxDyqrIb6YkmIm/5biiUYcz0jk//i2/bTtwaRBb
x-ms-exchange-antispam-messagedata: eK1kYS+JAIjw1Hm/a0QSizJ6H+LaD9FlbSfqlrmqo7BlmaMXSoi0hK1Z+v9CTmzHfvQ/nYPDXKk0o30IyWCiyepmNOVTm9xslqX39YvfsKkP9xAYG8H7hDPSQDGVcH1Ml3oWH5WAw/VdZuFpprknKw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <06F7CB2F07A0CF469B62389848543EB2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88213c42-3110-4475-afbc-08d7cc6c50e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2020 01:16:28.0231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T6114QYFALqfzAMwfCqttr6jySLxG5nAJ2p0okWSvwdiHZRnlp8otN75Yv2gB50uAbw2krQ2dpP2ucibDray2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTE5IGF0IDA4OjA1ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFdlZCwgTWFyIDE4LCAyMDIwIGF0IDExOjMzOjQ2UE0gKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMC0wMy0xOCBhdCAxMTo1MiArMDIwMCwgTGVvbiBS
b21hbm92c2t5IHdyb3RlOg0KPiA+ID4gRnJvbTogTWFyayBaaGFuZyA8bWFya3pAbWVsbGFub3gu
Y29tPg0KPiA+ID4gDQo+ID4gPiBXaGVuIHRoaXMgaXMgZW5hYmxlZCwgVURQIHNvdXJjZSBwb3J0
IGZvciBSb0NFdjIgcGFja2V0cyBhcmUNCj4gPiA+IGRlZmluZWQNCj4gPiA+IGJ5IHNvZnR3YXJl
IGluc3RlYWQgb2YgZmlybXdhcmUuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IE1hcmsg
WmhhbmcgPG1hcmt6QG1lbGxhbm94LmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBNYW9yIEdvdHRs
aWViIDxtYW9yZ0BtZWxsYW5veC5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMZW9uIFJvbWFu
b3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICAuLi4vbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgICAgfCAzOQ0KPiA+ID4gKysrKysrKysr
KysrKysrKysrKw0KPiA+ID4gIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAg
ICAgICAgICB8ICA1ICsrLQ0KPiA+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KPiA+ID4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ID4gPiBpbmRleCA2YjM4ZWM3MjIx
NWEuLmJkYzczMzcwMjk3YiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gPiA+IEBAIC01ODUsNiArNTg1LDM5IEBA
IHN0YXRpYyBpbnQgaGFuZGxlX2hjYV9jYXAoc3RydWN0DQo+ID4gPiBtbHg1X2NvcmVfZGV2DQo+
ID4gPiAqZGV2KQ0KPiA+ID4gIAlyZXR1cm4gZXJyOw0KPiA+ID4gIH0NCj4gPiA+IA0KPiA+ID4g
K3N0YXRpYyBpbnQgaGFuZGxlX2hjYV9jYXBfcm9jZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2
KQ0KPiA+ID4gK3sNCj4gPiA+ICsJaW50IHNldF9zeiA9IE1MWDVfU1RfU1pfQllURVMoc2V0X2hj
YV9jYXBfaW4pOw0KPiA+ID4gKwl2b2lkICpzZXRfaGNhX2NhcDsNCj4gPiA+ICsJdm9pZCAqc2V0
X2N0eDsNCj4gPiA+ICsJaW50IGVycjsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKCFNTFg1X0NBUF9H
RU4oZGV2LCByb2NlKSkNCj4gPiA+ICsJCXJldHVybiAwOw0KPiA+ID4gKw0KPiA+ID4gKwllcnIg
PSBtbHg1X2NvcmVfZ2V0X2NhcHMoZGV2LCBNTFg1X0NBUF9ST0NFKTsNCj4gPiA+ICsJaWYgKGVy
cikNCj4gPiA+ICsJCXJldHVybiBlcnI7DQo+ID4gPiArDQo+ID4gPiArCWlmIChNTFg1X0NBUF9S
T0NFKGRldiwgc3dfcl9yb2NlX3NyY191ZHBfcG9ydCkgfHwNCj4gPiA+ICsJICAgICFNTFg1X0NB
UF9ST0NFX01BWChkZXYsIHN3X3Jfcm9jZV9zcmNfdWRwX3BvcnQpKQ0KPiA+ID4gKwkJcmV0dXJu
IDA7DQo+ID4gPiArDQo+ID4gPiArCXNldF9jdHggPSBremFsbG9jKHNldF9zeiwgR0ZQX0tFUk5F
TCk7DQo+ID4gPiArCWlmICghc2V0X2N0eCkNCj4gPiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiA+
ID4gKw0KPiA+IA0KPiA+IGFsbCB0aGUgc2lzdGVycyBvZiB0aGlzIGZ1bmN0aW9uIGFsbG9jYXRl
IHRoaXMgYW5kIGZyZWUgaXQNCj4gPiBjb25zZWN1dGl2ZWx5LCB3aHkgbm90IGFsbG9jYXRlIGl0
IGZyb20gb3V0c2lkZSBvbmNlLCBwYXNzIGl0IHRvDQo+ID4gYWxsDQo+ID4gaGFuZGxlX2hjYV9j
YXBfeHl6IGZ1bmN0aW9ucywgZWFjaCBvbmUgd2lsbCBtZW1zZXQgaXQgYW5kIHJldXNlIGl0Lg0K
PiA+IHNlZSBiZWxvdy4NCj4gDQo+IEFncmVlLCBJJ2xsIGRvIGl0Lg0KPiANCj4gPiA+ICsJc2V0
X2hjYV9jYXAgPSBNTFg1X0FERFJfT0Yoc2V0X2hjYV9jYXBfaW4sIHNldF9jdHgsDQo+ID4gPiBj
YXBhYmlsaXR5KTsNCj4gPiA+ICsJbWVtY3B5KHNldF9oY2FfY2FwLCBkZXYtPmNhcHMuaGNhX2N1
cltNTFg1X0NBUF9ST0NFXSwNCj4gPiA+ICsJICAgICAgIE1MWDVfU1RfU1pfQllURVMocm9jZV9j
YXApKTsNCj4gPiA+ICsJTUxYNV9TRVQocm9jZV9jYXAsIHNldF9oY2FfY2FwLCBzd19yX3JvY2Vf
c3JjX3VkcF9wb3J0LCAxKTsNCj4gPiA+ICsNCj4gPiA+ICsJZXJyID0gc2V0X2NhcHMoZGV2LCBz
ZXRfY3R4LCBzZXRfc3osDQo+ID4gPiBNTFg1X1NFVF9IQ0FfQ0FQX09QX01PRF9ST0NFKTsNCj4g
PiA+ICsNCj4gPiANCj4gPiBEbyB3ZSByZWFsbHkgbmVlZCB0byBmYWlsIHRoZSB3aG9sZSBkcml2
ZXIgaWYgd2UganVzdCB0cnkgdG8gc2V0IGENCj4gPiBub24NCj4gPiBtYW5kYXRvcnkgY2FwID8N
Cj4gDQo+IEl0IGlzIGxlc3MgaW1wb3J0YW50IHdoYXQgY2F1c2VkIHRvIGZhaWx1cmUsIGJ1dCB0
aGUgZmFjdCB0aGF0IGJhc2ljDQo+IG1seDVfY21kX2V4ZWMoKSBmYWlsZWQgZHVyaW5nIGluaXRp
YWxpemF0aW9uIGZsb3cuIEkgdGhpbmsgdGhhdCBpdA0KPiBpcyBiYWQgZW5vdWdoIHRvIHN0b3Ag
dGhlIGRyaXZlciwgYmVjYXVzZSBpdHMgb3BlcmF0aW9uIGlzIGdvaW5nIHRvDQo+IGJlIHVucmVs
aWFibGUuDQo+IA0KPiBQbGVhc2Ugc2hhcmUgeW91ciBlbmQtcmVzdWx0IGRlY2lzaW9uIG9uIHRo
YXQgYW5kIEknbGwgYWxpZ24gdG8gaXQuDQo+IA0KDQpkcml2ZXIgc3RhYmlsaXR5IGFuZCByZWxp
YWJpbGl0eSBpcyBub3QgYWZmZWN0ZWQgYnkgdGhpcyBmYWlsaW5nLCBzaW5jZQ0KZGVzaWduLXdp
c2Ugd2UgZG9uJ3QgY291bnQgb24gc2V0dGluZyB0aGUgY2FwcyBvbiB0aGlzIHN0YWdlLCB3ZSBx
dWVyeQ0KdGhlbSBhbnl3YXkgaW4gdGhlIG5leHQgc3RhZ2VzIG9mIHRoZSBkcml2ZXIgbG9hZC4N
Cg0KTWFueSByZWFzb24gdGhpcyBjb3VsZCBmYWlsLCBvbGQgRlcgdGhhdCBkb2Vzbid0IGhhbmRs
ZSB0aGlzIG5ldyBDQVANCnByb3Blcmx5LCBuZXcgRlcgd2hpY2ggaGFzIGEgYnVnIG9ubHkgaW4g
dGhlIG5ldyBmZWF0dXJlIGZsb3cuDQpUaGUgZHJpdmVyIHNob3VsZCBiZSByZXNpbGllbnQgYW5k
IHByb3ZpZGUgYmFzaWMgZnVuY3Rpb25hbGl0eSBvciBpbg0KdGhpcyBjYXNlIGp1c3QgZHJvcCB0
aGlzIGZlYXR1cmUsIHNpbmNlIG5leHQgY2FwIHF1ZXJ5IG9mIHRoaXMgZmVhdHVyZQ0Kd2lsbCBy
ZXR1cm4gMCwgYW5kIGRyaXZlciB3aWxsIG5vdCB0cnkgdG8gZW5hYmxlIHRoaXMgZmVhdHVyZSBh
bnl3YXkuDQoNCmlmIGl0IGlzIHNvbWV0aGluZyByZWFsbHkgZnVuZGFtZW50YWwgdGhhdCBjYXVz
ZWQgdGhlIGlzc3VlLCB0aGVuIGp1c3QNCmxldCBpdCBiZSwgaWYgd2UgZmFpbCBpbiBhIG1vcmUg
YWR2YW5jZWQgbWFuZGF0b3J5IHN0YWdlIHRoZW4gd2Ugd2lsbA0KZmFpbCBvbiB0aGF0IHN0YWdl
LCBpZiB3ZSBkaWRuJ3QsIHRoZW4gaXQgaXMgYSB3aW4gd2luLg0KDQoNCj4gPiA+ICsJa2ZyZWUo
c2V0X2N0eCk7DQo+ID4gPiArCXJldHVybiBlcnI7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4g
IHN0YXRpYyBpbnQgc2V0X2hjYV9jYXAoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCj4gPiA+
ICB7DQo+ID4gPiAgCWludCBlcnI7DQo+ID4gDQo+ID4gbGV0J3MgYWxsb2NhdGUgdGhlIHNldF9j
dHggaW4gdGhpcyBwYXJlbnQgZnVuY3Rpb24gYW5kIHBhc3MgaXQgdG8NCj4gPiBhbGwNCj4gPiBo
Y2EgY2FwIGhhbmRsZXJzOw0KPiA+IA0KPiA+IHNldF9zeiA9IE1MWDVfU1RfU1pfQllURVMoc2V0
X2hjYV9jYXBfaW4pOw0KPiA+IHNldF9jdHggPSBremFsbG9jKHNldF9zeiwgR0ZQX0tFUk5FTCk7
DQo+IA0KPiBJJ20gZG9pbmcgaXQgbm93Lg0KPiANCg0KQXdlc29tZSwgVGhhbmtzICENCg==
