Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC96A2A7F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfH2XEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:04:20 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:43662
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727826AbfH2XET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:04:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=am3AgZQp/KIL9/+URjz4g0xPtFway7Cph03W5G1Bgey9qS8QJeeSB8c8cyF/yhiRzELj4qcXhuxplGXRDkLfH+Rg3UIp82Lawj1KCyYQLADrxd1qCIFyA7rR89YMhrQLAGomoBHfkMjm2odufsig6opnze8OgkpHCA8am0LqgDE4H5aAXBAH0Yr4fE7Acy1nfRK/iqoeCSFih03cVjJi3aMm6rVz6kqgt4okuBdGmW4EFSNPtd41PTe4mOB7FlMOWUZ1OjzTGvVggVRAT28E8Ok10IkQr1/AdeNMn23okoQaOPMCy4RewJ914N7TEIYpk3N+M1ez23qOhmxscvR5jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9zfCnDM25DzQrjFX2X1dAI/jxxnCiR2MaqzslfIg3k=;
 b=SyVSSBs9C5cx+gRUSM+JWKuEaYgmh00T8v6G9L/8mG8ZnKos2biuwV1T5jwKGKbaN2aidTauaUYZbv5UkojnDhMDXA6R4ltpxyuUYt5aVSIlfrnvyLKdfEYOMzGYbtdr2dcWjWYENDuQc5W3wdrKFojDuacuOKjQFBkXszCYPm5hzl23LTyMKcRSi4LMUHbZvpIbq5tqKofwiUrz7tigQpz+xZJB+hgF6EYZP+CDGsQ4lLgiEkjE8AfVBQCoy+6rirdXdKSZkFWe+vCW2Yb8nfVTTjXXUJ73rnV3cskXrs8p/90JdsjPUs6RX81mO4kyn9pNJaffqp0AQahDjuvl0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9zfCnDM25DzQrjFX2X1dAI/jxxnCiR2MaqzslfIg3k=;
 b=nQLFGuWxfZKuDT7OHRnhNrQB1OKruQXXJmT7znxtYZsMHbGByEtBFoZXjlm2a5vxucUM3MKw0oI0RHHC/fLsyoRlO+nvpwpX8oqyGh6R1eaoQEH6uf3kNIPLbnnR4gY61yKZRi0DCGc5/yD0CAsPVNT6EIA8hi/hjjd0kOOiai4=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2544.eurprd05.prod.outlook.com (10.168.136.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 23:04:09 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:04:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        haiyangz <haiyangz@microsoft.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: linux-next: Tree for Aug 29 (mlx5)
Thread-Topic: linux-next: Tree for Aug 29 (mlx5)
Thread-Index: AQHVXqOWWrDg6HQUkEyJ2ZhpB0y05acSijuAgAAa0ICAAAHvgIAAF92A
Date:   Thu, 29 Aug 2019 23:04:09 +0000
Message-ID: <82c4fad3fc394693a596597df0d73cc5235f7025.camel@mellanox.com>
References: <20190829210845.41a9e193@canb.auug.org.au>
         <3cbf3e88-53b5-0eb3-9863-c4031b9aed9f@infradead.org>
         <52bcddef-fcf2-8de5-d15a-9e7ee2d5b14d@infradead.org>
         <c92d20e27268f515e0d4c8a28f92c0da041c2acc.camel@mellanox.com>
         <DM6PR21MB13379A89D3A57DCFD6E0D419CAA20@DM6PR21MB1337.namprd21.prod.outlook.com>
In-Reply-To: <DM6PR21MB13379A89D3A57DCFD6E0D419CAA20@DM6PR21MB1337.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a82be220-2cd3-40ce-3887-08d72cd53376
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2544;
x-ms-traffictypediagnostic: VI1PR0501MB2544:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2544E21C755C67914B2C032CBEA20@VI1PR0501MB2544.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(53754006)(189003)(199004)(52314003)(13464003)(305945005)(1511001)(71200400001)(7736002)(14454004)(71190400001)(2501003)(66066001)(99286004)(3846002)(6116002)(58126008)(6246003)(26005)(54906003)(107886003)(110136005)(53936002)(11346002)(446003)(316002)(118296001)(2906002)(256004)(6486002)(86362001)(6436002)(186003)(2201001)(6512007)(8936002)(8676002)(91956017)(76116006)(66946007)(5660300002)(81156014)(66476007)(229853002)(486006)(64756008)(66556008)(66446008)(76176011)(476003)(102836004)(2616005)(25786009)(81166006)(53546011)(36756003)(4326008)(6506007)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2544;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qsQ4G9sSpwAJDl8WcawRnJfbCw7FLSAW3SNolLJrnYQmUg0eXaymzhiNyR67xNjIGyJlnW19XsKOHfwhASUYtsB4URP0UETQCqZwBkfwHbg+11M7JXWsbBZltccp5mtQ6gsPXwnO/cPA5fdLqeGlDqLwqnm+iJvgLbpRYCEvwrg9KSxPfiU7zmsHUwUDoRDd/qCa1Dz4QdGtJ8Gegy5hLgTLDBWag8SCEX7qGWkaiZrznfEjz9NhSCljxtRXX2h4rIFYONkARvmIvXwmY5VS/Mv2RA19ThakbBnkn8Run5Kx4H7jKjFSUWv0ZH+OyIEJ145kvCkPNkCnvv3OlwKVwHSDE4MQMOXme+9E4MqcmaY3IMh1G/qyfLIMxEbOGupxQQ1+JWDxFcoogXIgC/GTtCcVuzrLijnah9dnZqyPDr0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68B36D1ECD9E99498F794B51581C6AE9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82be220-2cd3-40ce-3887-08d72cd53376
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:04:09.8056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NArBkGyyRi5kUGrDpA/44mYwxlgB0p4JPRJkYUurZCgYNXEV77Y+TB0dN4aNOgvftmQ1WfbJt1GwQKA8Dcrkeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTI5IGF0IDIxOjQ4ICswMDAwLCBIYWl5YW5nIFpoYW5nIHdyb3RlOg0K
PiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAyOSwgMjAx
OSAyOjMyIFBNDQo+ID4gVG86IHNmckBjYW5iLmF1dWcub3JnLmF1OyBFcmFuIEJlbiBFbGlzaGEg
PGVyYW5iZUBtZWxsYW5veC5jb20+Ow0KPiA+IGxpbnV4LQ0KPiA+IG5leHRAdmdlci5rZXJuZWwu
b3JnOyByZHVubGFwQGluZnJhZGVhZC5vcmc7IEhhaXlhbmcgWmhhbmcNCj4gPiA8aGFpeWFuZ3pA
bWljcm9zb2Z0LmNvbT4NCj4gPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgTGVvbg0KPiA+IFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5v
eC5jb20+DQo+ID4gU3ViamVjdDogUmU6IGxpbnV4LW5leHQ6IFRyZWUgZm9yIEF1ZyAyOSAobWx4
NSkNCj4gPiANCj4gPiBPbiBUaHUsIDIwMTktMDgtMjkgYXQgMTI6NTUgLTA3MDAsIFJhbmR5IER1
bmxhcCB3cm90ZToNCj4gPiA+IE9uIDgvMjkvMTkgMTI6NTQgUE0sIFJhbmR5IER1bmxhcCB3cm90
ZToNCj4gPiA+ID4gT24gOC8yOS8xOSA0OjA4IEFNLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3RlOg0K
PiA+ID4gPiA+IEhpIGFsbCwNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBDaGFuZ2VzIHNpbmNlIDIw
MTkwODI4Og0KPiA+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gb24geDg2XzY0Og0KPiA+ID4g
PiB3aGVuIENPTkZJR19QQ0lfSFlQRVJWPW0NCj4gPiA+IA0KPiA+ID4gYW5kIENPTkZJR19QQ0lf
SFlQRVJWX0lOVEVSRkFDRT1tDQo+ID4gPiANCj4gPiANCj4gPiBIYWl5YW5nIGFuZCBFcmFuLCBJ
IHRoaW5rIENPTkZJR19QQ0lfSFlQRVJWX0lOVEVSRkFDRSB3YXMgbmV2ZXINCj4gPiBzdXBwb3Nl
ZCB0byBiZSBhIG1vZHVsZSA/IGl0IHN1cHBvc2VkIHRvIHByb3ZpZGUgYW4gYWx3YXlzDQo+ID4g
YXZhaWxhYmxlDQo+ID4gaW50ZXJmYWNlIHRvIGRyaXZlcnMgLi4NCj4gPiANCj4gPiBBbnl3YXks
IG1heWJlIHdlIG5lZWQgdG8gaW1wbHkgQ09ORklHX1BDSV9IWVBFUlZfSU5URVJGQUNFIGluIG1s
eDUuDQo+IA0KPiBUaGUgc3ltYm9saWMgZGVwZW5kZW5jeSBieSBkcml2ZXIgbWx4NWUsICBhdXRv
bWF0aWNhbGx5IHRyaWdnZXJzDQo+IGxvYWRpbmcgb2YNCj4gcGNpX2h5cGVydl9pbnRlcmZhY2Ug
bW9kdWxlLiBBbmQgdGhpcyBtb2R1bGUgY2FuIGJlIGxvYWRlZCBpbiBhbnkNCj4gcGxhdGZvcm1z
Lg0KPiANCg0KVGhpcyBvbmx5IHdvcmtzIHdoZW4gYm90aCBhcmUgbW9kdWxlcy4gDQoNCg0KPiBD
dXJyZW50bHksIG1seDVlIGRyaXZlciBoYXMgI2lmDQo+IElTX0VOQUJMRUQoQ09ORklHX1BDSV9I
WVBFUlZfSU5URVJGQUNFKQ0KPiBhcm91bmQgdGhlIGNvZGUgdXNpbmcgdGhlIGludGVyZmFjZS4N
Cj4gDQo+IEkgYWdyZWUgLS0NCj4gQWRkaW5nICJzZWxlY3QgUENJX0hZUEVSVl9JTlRFUkZBQ0Ui
IGZvciBtbHg1ZSB3aWxsIGNsZWFuIHVwIHRoZXNlDQo+ICNpZidzLg0KPiANCg0KTm8sIG5vdCAi
c2VsZWN0IiwgImltcGx5Ii4NCg0KaWYgb25lIHdhbnRzIFBDSV9IWVBFUlZfSU5URVJGQUNFIG9m
ZiwgaW1wbHkgd2lsbCBrZWVwIGl0IG9mZiBmb3IgeW91Lg0KDQo+IFRoYW5rcywNCj4gLSBIYWl5
YW5nDQo=
