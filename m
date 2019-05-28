Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382802C4B9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfE1Ksr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:48:47 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:33954
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbfE1Ksr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 06:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEcFRzlsG2+XBX8KYYVHl4Y0smHnVdCcHwW1TK41U/M=;
 b=MjXQO+Rctd/RGi6rRzV3M46fJvox3iRTSdWH78usLPoRAvWaOsqm1F1ZxYnZxQ1NE3m2emvqSJR6kge7QYsB7iO0tDtHesQ/C2ojkHiJtZuUs3QFG7r+SyMz30WKDMoCbTeu9u0DUtZd5kpnhSZsbSD7BfsmpiXUznmH6EKahEk=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB5880.eurprd05.prod.outlook.com (20.179.0.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 28 May 2019 10:48:41 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09%3]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 10:48:41 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>, Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Bug or mis configuration for mlx5e lag and multipath
Thread-Topic: Bug or mis configuration for mlx5e lag and multipath
Thread-Index: AQHVDq7V3EhKEOTvIkS9QlDIJnxOfKZ412uAgACkBICABu0DAA==
Date:   Tue, 28 May 2019 10:48:41 +0000
Message-ID: <e8277d2f-f671-b67a-135f-7e4c8ecbc557@mellanox.com>
References: <678285cb-0821-405a-57ae-0d72e96f9ef7@ucloud.cn>
 <8bbeec48-6bbc-260c-91e3-4b58290055b2@mellanox.com>
 <c670c82c-877e-199a-da17-891dd2de571d@ucloud.cn>
In-Reply-To: <c670c82c-877e-199a-da17-891dd2de571d@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
x-clientproxiedby: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39fa1f2a-593a-4dcd-bb3d-08d6e35a0c2c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR05MB5880;
x-ms-traffictypediagnostic: AM6PR05MB5880:
x-microsoft-antispam-prvs: <AM6PR05MB588039CCD2AF9825A9971CB1B51E0@AM6PR05MB5880.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(396003)(136003)(346002)(189003)(199004)(66556008)(64126003)(66476007)(6436002)(31686004)(66946007)(66446008)(64756008)(73956011)(65826007)(81156014)(81166006)(6512007)(68736007)(6636002)(8676002)(6486002)(8936002)(305945005)(7736002)(316002)(229853002)(102836004)(53546011)(6506007)(386003)(86362001)(52116002)(186003)(25786009)(26005)(6246003)(66066001)(65956001)(14454004)(99286004)(65806001)(486006)(2906002)(11346002)(446003)(476003)(2616005)(3846002)(6116002)(478600001)(71200400001)(71190400001)(53936002)(76176011)(4326008)(256004)(14444005)(5660300002)(36756003)(58126008)(31696002)(110136005)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5880;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VdLXkp94F5qvm0zYrloQ63+Dr6G51kDQMwEo6XV/LLM5y1HdbNPCFMR0k02NjGvh0ZmixbshT8nCB6+RL4bT+hAMnq/qg9dDcR2uKkwoHJCxlDhJ5RCg4ACh8J1ES3o+EcabkSccE2weBZsDJq2BLf2R1SirgyMXlxkgw3GPeaShJWbpIl60FXH671g9I66smXDbaeRenVMlnkm+OzlzSa6GYXHhA5K2404UViiFUNvc+La5VPIggTTV1DVtsv8rA6WqZp3WJcJTYDTm4zxZL1sxpGDexLrP6yY06n6OULOxpPzCG3BTCOLFkGyohg1JY+fx4Tn1NbIij1ugEGITSohDWss1M1feW73GuEkOgBTYriCqGVB/+yaaFrSTZLjsRiYNxxSRtK/PdT5X7s7lJZ04LfE+KKPbKj8+ZfJRoHQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20BC02ABC4C79B47B7DBBC9431631E27@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fa1f2a-593a-4dcd-bb3d-08d6e35a0c2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 10:48:41.5220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roid@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5880
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI0LzA1LzIwMTkgMDQ6MDIsIHdlbnh1IHdyb3RlOg0KPiBIaSwNCj4gDQo+IEkgY2Fu
IGdldCB0aGUgcmlnaHQgbG9nIGZyb20gZGVtc2cNCj4gDQo+IMKgbWx4NV9jb3JlIDAwMDA6ODE6
MDAuMDogbW9kaWZ5IGxhZyBtYXAgcG9ydCAxOjEgcG9ydCAyOjINCj4gDQo+IA0KPiBJIGRlYnVn
IHdpdGggdGhlIGRyaXZlciwgSSBmaW5kIHRoZSBydWxlIGJlIGFkZCBvbiBtbHhfcGYwdmYwIGFu
ZCB0aGUgcGVlciBvbmUgcGYxLA0KPiANCj4gU28gSSB0aGluayB0aGUgZXN3MCBhbmQgZXN3MSBi
b3RoIGhhdmUgdGhlIHJ1bGUuDQo+IA0KPiBUaGUgdGVzdCBjYXNlIGlzIGJhc2VkIG9uIHRoZSBt
YXN0ZXIgYnJhbmNoIG9mIHRoZSBuZXQgZ2l0IHRyZWUuDQoNCm9rIHRoYW5rcyBmb3IgcmVwb3J0
aW5nLiB3ZSdsbCBoYXZlIHRvIGNoZWNrIGl0Lg0KDQo+IA0KPiDlnKggMjAxOS81LzIzIDIzOjE1
LCBSb2kgRGF5YW4g5YaZ6YGTOg0KPj4NCj4+IE9uIDIwLzA1LzIwMTkgMDQ6NTMsIHdlbnh1IHdy
b3RlOg0KPj4+IEhpIFJvaSAmIFNhZWVkLA0KPj4+DQo+Pj4gSSBqdXN0IHRlc3QgdGhlIG1seDVl
IGxhZyBhbmQgbXV0aXBhdGggZmVhdHVyZS4gVGhlcmUgYXJlIHNvbWUgc3VpdHVhdGlvbiB0aGUg
b3V0Z29pbmcgY2FuJ3QgYmUgb2ZmbG9hZGVkLg0KPj4+DQo+Pj4gb3ZzIGNvbmZpZ3VyZWF0aW9u
IGFzIGZvbGxvd2luZy4NCj4+Pg0KPj4+ICMgb3ZzLXZzY3RsIHNob3cNCj4+PiBkZmQ3MWRmYi02
ZTIyLTQyM2UtYjA4OC1kMjAyMjEwM2FmNmINCj4+PiDCoMKgwqAgQnJpZGdlICJicjAiDQo+Pj4g
wqDCoMKgwqDCoMKgwqAgUG9ydCAibWx4X3BmMHZmMCINCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIEludGVyZmFjZSAibWx4X3BmMHZmMCINCj4+PiDCoMKgwqDCoMKgwqDCoCBQb3J0IGdyZQ0K
Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSW50ZXJmYWNlIGdyZQ0KPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB0eXBlOiBncmUNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgb3B0aW9uczoge2tleT0iMTAwMCIsIGxvY2FsX2lwPSIxNzIuMTY4LjE1Mi43NSIs
IHJlbW90ZV9pcD0iMTcyLjE2OC4xNTIuMjQxIn0NCj4+PiDCoMKgwqDCoMKgwqDCoCBQb3J0ICJi
cjAiDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBJbnRlcmZhY2UgImJyMCINCj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHlwZTogaW50ZXJuYWwNCj4+Pg0KPj4+IHNldCB0
aGUgbWx4NWUgZHJpdmVyOg0KPj4+DQo+Pj4NCj4+PiBtb2Rwcm9iZSBtbHg1X2NvcmUNCj4+PiBl
Y2hvIDAgPiAvc3lzL2NsYXNzL25ldC9ldGgyL2RldmljZS9zcmlvdl9udW12ZnMNCj4+PiBlY2hv
IDAgPiAvc3lzL2NsYXNzL25ldC9ldGgzL2RldmljZS9zcmlvdl9udW12ZnMNCj4+PiBlY2hvIDIg
PiAvc3lzL2NsYXNzL25ldC9ldGgyL2RldmljZS9zcmlvdl9udW12ZnMNCj4+PiBlY2hvIDIgPiAv
c3lzL2NsYXNzL25ldC9ldGgzL2RldmljZS9zcmlvdl9udW12ZnMNCj4+PiBsc3BjaSAtbm4gfCBn
cmVwIE1lbGxhbm94DQo+Pj4gZWNobyAwMDAwOjgxOjAwLjIgPiAvc3lzL2J1cy9wY2kvZHJpdmVy
cy9tbHg1X2NvcmUvdW5iaW5kDQo+Pj4gZWNobyAwMDAwOjgxOjAwLjMgPiAvc3lzL2J1cy9wY2kv
ZHJpdmVycy9tbHg1X2NvcmUvdW5iaW5kDQo+Pj4gZWNobyAwMDAwOjgxOjAzLjYgPiAvc3lzL2J1
cy9wY2kvZHJpdmVycy9tbHg1X2NvcmUvdW5iaW5kDQo+Pj4gZWNobyAwMDAwOjgxOjAzLjcgPiAv
c3lzL2J1cy9wY2kvZHJpdmVycy9tbHg1X2NvcmUvdW5iaW5kDQo+Pj4NCj4+PiBkZXZsaW5rIGRl
diBlc3dpdGNoIHNldCBwY2kvMDAwMDo4MTowMC4wwqAgbW9kZSBzd2l0Y2hkZXYgZW5jYXAgZW5h
YmxlDQo+Pj4gZGV2bGluayBkZXYgZXN3aXRjaCBzZXQgcGNpLzAwMDA6ODE6MDAuMcKgIG1vZGUg
c3dpdGNoZGV2IGVuY2FwIGVuYWJsZQ0KPj4+DQo+Pj4gbW9kcHJvYmUgYm9uZGluZyBtb2RlPTgw
Mi4zYWQgbWlpbW9uPTEwMCBsYWNwX3JhdGU9MQ0KPj4+IGlwIGwgZGVsIGRldiBib25kMA0KPj4+
IGlmY29uZmlnIG1seF9wMCBkb3duDQo+Pj4gaWZjb25maWcgbWx4X3AxIGRvd24NCj4+PiBpcCBs
IGFkZCBkZXYgYm9uZDAgdHlwZSBib25kIG1vZGUgODAyLjNhZA0KPj4+IGlmY29uZmlnIGJvbmQw
IDE3Mi4xNjguMTUyLjc1LzI0IHVwDQo+Pj4gZWNobyAxID4gL3N5cy9jbGFzcy9uZXQvYm9uZDAv
Ym9uZGluZy94bWl0X2hhc2hfcG9saWN5DQo+Pj4gaXAgbCBzZXQgZGV2IG1seF9wMCBtYXN0ZXIg
Ym9uZDANCj4+PiBpcCBsIHNldCBkZXYgbWx4X3AxIG1hc3RlciBib25kMA0KPj4+IGlmY29uZmln
IG1seF9wMCB1cA0KPj4+IGlmY29uZmlnIG1seF9wMSB1cA0KPj4+DQo+Pj4gc3lzdGVtY3RsIHN0
YXJ0IG9wZW52c3dpdGNoDQo+Pj4gb3ZzLXZzY3RsIHNldCBPcGVuX3ZTd2l0Y2ggLiBvdGhlcl9j
b25maWc6aHctb2ZmbG9hZD10cnVlDQo+Pj4gc3lzdGVtY3RsIHJlc3RhcnQgb3BlbnZzd2l0Y2gN
Cj4+Pg0KPj4+DQo+Pj4gbWx4X3BmMHZmMCBpcyBhc3NpZ25lZCB0byB2bS4gVGhlIHRjIHJ1bGUg
c2hvdyBpbl9odw0KPj4+DQo+Pj4gIyB0YyBmaWx0ZXIgbHMgZGV2IG1seF9wZjB2ZjAgaW5ncmVz
cw0KPj4+IGZpbHRlciBwcm90b2NvbCBpcCBwcmVmIDIgZmxvd2VyDQo+Pj4gZmlsdGVyIHByb3Rv
Y29sIGlwIHByZWYgMiBmbG93ZXIgaGFuZGxlIDB4MQ0KPj4+IMKgIGRzdF9tYWMgOGU6YzA6YmQ6
YmY6NzI6YzMNCj4+PiDCoCBzcmNfbWFjIDUyOjU0OjAwOjAwOjEyOjc1DQo+Pj4gwqAgZXRoX3R5
cGUgaXB2NA0KPj4+IMKgIGlwX3RvcyAwLzMNCj4+PiDCoCBpcF9mbGFncyBub2ZyYWcNCj4+PiDC
oCBpbl9odw0KPj4+IMKgwqDCoCBhY3Rpb24gb3JkZXIgMTogdHVubmVsX2tleSBzZXQNCj4+PiDC
oMKgwqAgc3JjX2lwIDE3Mi4xNjguMTUyLjc1DQo+Pj4gwqDCoMKgIGRzdF9pcCAxNzIuMTY4LjE1
Mi4yNDENCj4+PiDCoMKgwqAga2V5X2lkIDEwMDAgcGlwZQ0KPj4+IMKgwqDCoCBpbmRleCAyIHJl
ZiAxIGJpbmQgMQ0KPj4+IMKgDQo+Pj4gwqDCoMKgIGFjdGlvbiBvcmRlciAyOiBtaXJyZWQgKEVn
cmVzcyBSZWRpcmVjdCB0byBkZXZpY2UgZ3JlX3N5cykgc3RvbGVuDQo+Pj4gwqDCoMKgwqAgaW5k
ZXggMiByZWYgMSBiaW5kIDENCj4+Pg0KPj4+IEluIHRoZSB2bTrCoCB0aGUgbWx4NWUgZHJpdmVy
IGVuYWJsZSB4cHMgZGVmYXVsdCAoYnkgdGhlIHdheSBJIHRoaW5rIGl0IGlzIGJldHRlciBub3Qg
ZW5hYmxlIHhwcyBpbiBkZWZhdWx0IGtlcm5lbCBjYW4gc2VsZWN0IHF1ZXVlIGJ5IGVhY2ggZmxv
dykswqAgaW4gdGhlIGxhZyBtb2RlIGRpZmZlcmVudCB2ZiBxdWV1ZSBhc3NvY2lhdGUgd2l0aCBo
dyBQRi4NCj4+Pg0KPj4+IHdpdGggY29tbWFuZCB0YXNrc2V0IC1jIDIgcGluZyAxMC4wLjAuMjQx
DQo+Pj4NCj4+PiB0aGUgcGFja2V0IGNhbiBiZSBvZmZsb2FkZWQgLCB0aGUgb3V0Z29pbmcgcGYg
aXMgbWx4X3AwDQo+Pj4NCj4+PiBidXQgd2l0aCBjb21tYW5kIHRhc2tzZXQgLWMgMSBwaW5nIDEw
LjAuMC4yNDENCj4+Pg0KPj4+IHRoZSBwYWNrZXQgY2FuJ3QgYmUgb2ZmbG9hZGVkLCBJIGNhbiBj
YXB0dXJlIHRoZSBwYWNrZXQgb24gdGhlIG1seF9wZjB2ZjAsIHRoZSBvdXRnb2luZyBwZiBpcyBt
bHhfcDEuIEFsdGhyb3VnaCB0aGUgdGMgZmxvd2VyIHJ1bGUgc2hvdyBpbl9odw0KPj4+DQo+Pj4N
Cj4+PiBJIGNoZWNrIHdpdGggdGhlIGRyaXZlcsKgIGJvdGggbWx4X3BmMHZmMCBhbmQgcGVlciht
bHhfcDEpIGluc3RhbGwgdGhlIHRjIHJ1bGUgc3VjY2Vzcw0KPj4+DQo+Pj4gSSB0aGluayBpdCdz
IGEgcHJvYmxlbSBvZiBsYWcgbW9kZS4gT3IgSSBtaXNzIHNvbWUgY29uZmlndXJlYXRpb24/DQo+
Pj4NCj4+Pg0KPj4+IEJSDQo+Pj4NCj4+PiB3ZW54dQ0KPj4+DQo+Pj4NCj4+Pg0KPj4+DQo+Pj4N
Cj4+IEhpLA0KPj4NCj4+IHdlIG5lZWQgdG8gdmVyaWZ5IHRoZSBkcml2ZXIgZGV0ZWN0ZWQgdG8g
YmUgaW4gbGFnIG1vZGUgYW5kDQo+PiBkdXBsaWNhdGVkIHRoZSBvZmZsb2FkIHJ1bGUgdG8gYm90
aCBlc3dpdGNoZXMuDQo+PiBkbyB5b3Ugc2VlIGxhZyBtYXAgbWVzc2FnZXMgaW4gZG1lc2c/DQo+
PiBzb21ldGhpbmcgbGlrZSAibGFnIG1hcCBwb3J0IDE6MSBwb3J0IDI6MiINCj4+IHRoaXMgaXMg
dG8gbWFrZSBzdXJlIHRoZSBkcml2ZXIgYWN0dWFsbHkgaW4gbGFnIG1vZGUuDQo+PiBpbiB0aGlz
IG1vZGUgYSBydWxlIGFkZGVkIHRvIG1seF9wZjB2ZjAgd2lsbCBiZSBhZGRlZCB0byBlc3cgb2Yg
cGYwIGFuZCBlc3cgb2YgcGYxLg0KPj4gdGhlbiB3aGVuIHUgc2VuZCBhIHBhY2tldCBpdCBjb3Vs
ZCBiZSBoYW5kbGVkIGluIGVzdzAgb3IgZXN3MQ0KPj4gaWYgdGhlIHJ1bGUgaXMgbm90IGluIGVz
dzEgdGhlbiBpdCB3b250IGJlIG9mZmxvYWRlZCB3aGVuIHVzaW5nIHBmMS4NCj4+DQo+PiB0aGFu
a3MsDQo+PiBSb2kNCg==
