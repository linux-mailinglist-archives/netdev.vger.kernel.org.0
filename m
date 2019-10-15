Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA51D814E
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389396AbfJOUqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:46:12 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:26454
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388006AbfJOUqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQrxR2PYLKmvjNIfohpiuqz4ZCC+QPhLHz9i9I5oCDgY5n1+HWZRsMmF0fVtUDNCbPlSlfXFleqN8CRmdGTysRVGiJhYDILNnqe5RHH17Z+Zzk0sK5zkA5oI1Q9HFCwkMbO8mRSvU+7ZX/VGjEJfkkyh6aRdQPZ+kltEcf1gawxpwEAuryFi98H7eSb8ZYhCbUuigh7uDOxxjiquKxmq6F/GrUu95HxiOjD0w+NpQmXu387T1hqCQ/wIy3M8ZdHHacVnSmQZBG2r1p8dqLL/YMHMI0FJBmvBAg+27wh4bhw1ibYqh/zAMOwpmCvz43eX95nZSJaFwp1EJ/J3F2FfEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEoy93dylzJgHW/kQ30xyW1wBH6RpQB0f6MritAeCdU=;
 b=bV3Z84RGr4g/dYOuYaILZgeuJqCoxQhYXTJWzWaAX55Xv8LSoCoJUwj+cBz+G0dqYsTkHX0gA2euEFnzn7vNiTRvEWowX6zRWFufM58us9aVRPNajVHLXvZL00VBTlNs53Ysmonu1w1vgrOZqusUrZdn6E4WgMvLZAkC8ZRofhH23sDQc8za/EQo1O1MEqob8YU16VYTc7DPcLUn2oo5gA7FWHlQuSd8ZD0qZ8LI8RoBA6qhDa+eJlg3n/gCBVm2TWj33AgijQhduzqy2Wc4KmpmQ8yyPYJjs1lou8twZRMJQUA9PX/bQ/CRbo9uB7+z9DOD2F3w+QsuVIsBvzDzvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEoy93dylzJgHW/kQ30xyW1wBH6RpQB0f6MritAeCdU=;
 b=gqoEG4V+AiLI609/npeVJA5NqC3U8ktwu7KjBe/lnM+l3SZeP6NzRWgOPCbmC3ezr56EY4PlqjPj5JC4aqxZwQRwZ3O68NeRQ2BmE2p3DR/NNNQxV/Omo/yY7wLrKBaQOThNFLFV6wLSIfj1kFSTX5x41xApD1CD6LRpECy09Eg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4672.eurprd05.prod.outlook.com (20.176.7.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 20:45:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:45:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Alex Vesker <valex@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Thread-Topic: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Thread-Index: AQHVd5k2ehJGGBwDhUKLDvUQMK7npKdEXQCAgAAMLQCAAAdLAIAAHWiAgAFY0ICAFligAIAABG0A
Date:   Tue, 15 Oct 2019 20:45:26 +0000
Message-ID: <e8d0c475b8972d5620a7d79e44be4afe3cd41625.camel@mellanox.com>
References: <20190930141316.GG29694@zn.tnic>
         <20190930154535.GC22120@unicorn.suse.cz> <20190930162910.GI29694@zn.tnic>
         <20190930095516.0f55513a@hermes.lan> <20190930184031.GJ29694@zn.tnic>
         <20191001151439.GA24815@unicorn.suse.cz>
         <c72fceed58cdcb6093f1c1323416426c8237782b.camel@mellanox.com>
In-Reply-To: <c72fceed58cdcb6093f1c1323416426c8237782b.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b0c37df-4c78-4175-c7e8-08d751b09be4
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB4672:|VI1PR05MB4672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB46721771E1B07DA01DE26015BE930@VI1PR05MB4672.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(189003)(199004)(43544003)(81156014)(66066001)(81166006)(71200400001)(99286004)(5660300002)(76176011)(7736002)(71190400001)(76116006)(6506007)(91956017)(6246003)(64756008)(66476007)(6436002)(66556008)(66946007)(6512007)(8676002)(186003)(8936002)(102836004)(26005)(25786009)(4001150100001)(66446008)(229853002)(316002)(2501003)(110136005)(54906003)(476003)(2906002)(4326008)(36756003)(86362001)(305945005)(486006)(14454004)(256004)(6486002)(2616005)(6116002)(478600001)(58126008)(11346002)(446003)(118296001)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4672;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6YE7IipTiz5dGy8nHOcJ0WLZQQlaBA6mVsguv+9PNsMSfE80Qu2gaN3K+6rjajtLCSjy3x1gDE9J5EUHkjLS0mB57pq1IJkDre106ROfYP1xr7YZ7SklpWHeN7ngPdvQmaOnMH/qtPeK2ejKvlSI19xswmnKf2oUmW8QLZRRoXpMpbFFNLwGgh09QUt59fWYychmVROMwBZOhiTafwxx/nZK6I8MOwortjxvhAaS4B8+9pqkbJzkzH87hM5SUiBSyhJG6TePspuKH8UxrJIJ3yrufQWsTG949TSex+Emz/pyBTPUtJ+dyUNtjxr2GW/4cUUwpsuXiWDLIozboBzWtXwXhHha256g51c0Prwlma0AyvftdWhlikOFE6WAD/GdKHULeeBe6BmclKkwio+SWEBAahWv5LnAurcoj1MDTT0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E5BD8252ADA804998B9A1C24B038DBF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0c37df-4c78-4175-c7e8-08d751b09be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:45:26.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +2JjGjIALa0CfddwdyOHJZTcDoA7y1k0JlUBJCP+iK56kYhUsrI6at4XVAwbobmDDRU4DjsZOGliHujHxKOpXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTE1IGF0IDIwOjI5ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gT24gVHVlLCAyMDE5LTEwLTAxIGF0IDE3OjE0ICswMjAwLCBNaWNoYWwgS3ViZWNlayB3cm90
ZToNCj4gPiBPbiBNb24sIFNlcCAzMCwgMjAxOSBhdCAwODo0MDozMVBNICswMjAwLCBCb3Jpc2xh
diBQZXRrb3Ygd3JvdGU6DQo+ID4gPiBPbiBNb24sIFNlcCAzMCwgMjAxOSBhdCAwOTo1NToxNkFN
IC0wNzAwLCBTdGVwaGVuIEhlbW1pbmdlcg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+IENvdWxkIGFs
c28gdXMgZGl2X3U2NF9yZW0gaGVyZT8NCj4gPiA+IA0KPiA+ID4gWWFoLCB0aGUgYmVsb3cgc2Vl
bXMgdG8gd29yayBhbmQgdGhlIHJlc3VsdGluZyBhc20gbG9va3Mgc2Vuc2libGUNCj4gPiA+IHRv
IG1lDQo+ID4gPiBidXQgc29tZW9uZSBzaG91bGQgZGVmaW5pdGVseSBkb3VibGUtY2hlY2sgbWUg
YXMgSSBkb24ndCBrbm93DQo+ID4gPiB0aGlzDQo+ID4gPiBjb2RlDQo+ID4gPiBhdCBhbGwuDQo+
ID4gPiANCj4gPiA+IFRoeC4NCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdA0KPiA+ID4gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3RlZXJpbmcvZHJfaWNtX3Bvb2wu
Yw0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3RlZXJp
bmcvZHJfaWNtX3Bvb2wuYw0KPiA+ID4gaW5kZXggOTEzZjFlNWFhYWYyLi5iNDMwMjY1OGU1Zjgg
MTAwNjQ0DQo+ID4gPiAtLS0NCj4gPiA+IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL3N0ZWVyaW5nL2RyX2ljbV9wb29sLmMNCj4gPiA+ICsrKw0KPiA+ID4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3RlZXJpbmcvZHJfaWNtX3Bvb2wu
Yw0KPiA+ID4gQEAgLTEzNyw3ICsxMzcsNyBAQCBkcl9pY21fcG9vbF9tcl9jcmVhdGUoc3RydWN0
IG1seDVkcl9pY21fcG9vbA0KPiA+ID4gKnBvb2wsDQo+ID4gPiAgDQo+ID4gPiAgCWljbV9tci0+
aWNtX3N0YXJ0X2FkZHIgPSBpY21fbXItPmRtLmFkZHI7DQo+ID4gPiAgDQo+ID4gPiAtCWFsaWdu
X2RpZmYgPSBpY21fbXItPmljbV9zdGFydF9hZGRyICUgYWxpZ25fYmFzZTsNCj4gPiA+ICsJZGl2
X3U2NF9yZW0oaWNtX21yLT5pY21fc3RhcnRfYWRkciwgYWxpZ25fYmFzZSwgJmFsaWduX2RpZmYp
Ow0KPiA+ID4gIAlpZiAoYWxpZ25fZGlmZikNCj4gPiA+ICAJCWljbV9tci0+dXNlZF9sZW5ndGgg
PSBhbGlnbl9iYXNlIC0gYWxpZ25fZGlmZjsNCj4gPiA+ICANCj4gPiA+IA0KPiA+IA0KPiA+IFdo
aWxlIHRoaXMgZml4ZXMgMzItYml0IGJ1aWxkcywgaXQgYnJlYWtzIDY0LWJpdCBvbmVzIGFzIGFs
aWduX2RpZmYNCj4gPiBpcw0KPiA+IDY0LWJpdCBhbmQgZGl2X3U2NF9yZW0gZXhwZWN0cyBwb2lu
dGVyIHRvIHUzMi4gOi0oDQo+ID4gDQo+ID4gSSBjaGVja2VkIHRoYXQgYWxpZ25fYmFzZSBpcyBh
bHdheXMgYSBwb3dlciBvZiB0d28gc28gdGhhdCB3ZSBjb3VsZA0KPiA+IGdldA0KPiA+IGF3YXkg
d2l0aA0KPiA+IA0KPiA+IAlhbGlnbl9kaWZmID0gaWNtX21yLT5pY21fc3RhcnRfYWRkciAmIChh
bGlnbl9iYXNlIC0gMSkNCj4gPiANCj4gPiBJJ20gbm90IHN1cmUsIGhvd2V2ZXIsIGlmIGl0J3Mg
c2FmZSB0byBhc3N1bWUgYWxpZ25fYmFzZSB3aWxsDQo+ID4gYWx3YXlzDQo+ID4gaGF2ZSB0byBi
ZSBhIHBvd2VyIG9mIHR3byBvciBpZiB3ZSBzaG91bGQgYWRkIGEgY2hlY2sgZm9yIHNhZmV0eS4N
Cj4gPiANCj4gPiAoQ2MtaW5nIGFsc28gYXV0aG9yIG9mIGNvbW1pdCAyOWNmOGZlYmQxODUgKCJu
ZXQvbWx4NTogRFIsIElDTSBwb29sDQo+ID4gbWVtb3J5IGFsbG9jYXRvciIpLikNCj4gPiANCj4g
DQo+IFRoYW5rcyBldmVyeW9uZSBmb3IgeW91ciBpbnB1dCBvbiB0aGlzLCBBbGV4IHdpbGwgdGFr
ZSBjYXJlIG9mIHRoaXMNCj4gYW5kDQo+IHdlIHdpbGwgc3VibWl0IGEgcGF0Y2ggLi4NCj4gDQoN
ClBsZWFzZSBkaXNyZWdhcmQsIGkgc2VlIHRoaXMgd2FzIGZpeGVkIGluIA0KIltuZXRdIG1seDU6
IGF2b2lkIDY0LWJpdCBkaXZpc2lvbiBpbiBkcl9pY21fcG9vbF9tcl9jcmVhdGUoKSINCg0KSnVz
dCBjYW1lIGJhY2sgZnJvbSBhIGxvbmcgdmFjYXRpb24sIGdvdCBhIGxvdCBvZiBjYXRjaGluZyB1
cCB0byBkbw0KOikuLiANCg0K
