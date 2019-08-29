Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBEA2A96
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfH2XPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:15:18 -0400
Received: from mail-eopbgr740122.outbound.protection.outlook.com ([40.107.74.122]:55584
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbfH2XPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:15:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwehzuSoBGy4z+Js9T9DJ2skILrmJtU8/juPC5rrYeRJ0AlOiNZEExdPy7yzt4KOOUrnLy6QKYMaKtCrUZa8dTFqrMTIRr1RN7oWOmOWJ0q/Wr1+jwH5HOVGYV7WrTyfjNBwELcO+xHi9d1OQZslJlcVKG2OBIuB/DzTyocomfIhcDfPyeIgvzo6eAbbw6kCdKMhLT81DuwM4nm0ww4K8mgIZoQaU8Ww3g2AWoTlOMZlyoBH/oIXmw//Y/yW2ARqNqaQtO3Z0bT/UacOMpKUGFQAXjYjuYs/VM5VuH0FWVfJFlMk4lEGOt7wvnpu/PI6UE1JRH/7DXn1URUoHq4LLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlNRV//skibfOfHD9C0z5Cf8q1KXli/rWCnX6Wf7CpA=;
 b=KGDZSQ38k5YzfXEKvjgHwBAPcq+N19WAc6jmP9AJ+Zr0wCzdz0fzPX2EFsG62E8iveG/QPzpShtQxOjWUnCEQCimbWScsPOsdZqIowaPDHKCodtvnGgomLAZbVH76TBGmv+DBgMJAdDN3dTeUqpBIxJ7kQJ33g7FbKnCcHd12uHqBmROTHKhJa2somENwkZvJ3SidVFy/jy9qlQjoh3MyOZ3v3JbmMgUHu4+tym/RnVWbcvs4OsZCWr8yiT9TVjpmsb5BbqZUhRiBRLUS78KFaHhk9g/84btDA4hWUp3HTWJYTRxiPaA3UarylXkJi+npjXavmi8uFlYpTiXZLNwfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlNRV//skibfOfHD9C0z5Cf8q1KXli/rWCnX6Wf7CpA=;
 b=eWigUC5aVzGfZhAh/YnVi/hNCdKyj9Z4xBz2GrOMynAz/7SszdrrmfTesNVN0kDy6ne6zoYaGiS134JDdltLS/aUv79/xxnjGz4zzP7kDC12v//3ziICqGCcdP0YVMQCEbLcHtJVwzPWeciJ7x26A9LagbKmOqFf8/+l6JikOXM=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1321.namprd21.prod.outlook.com (20.179.53.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.5; Thu, 29 Aug 2019 23:15:11 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Thu, 29 Aug 2019
 23:15:11 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: RE: linux-next: Tree for Aug 29 (mlx5)
Thread-Topic: linux-next: Tree for Aug 29 (mlx5)
Thread-Index: AQHVXqOWWrDg6HQUkEyJ2ZhpB0y05acSijuAgAAa0ICAAAHvgIAAF92AgAAB4iA=
Date:   Thu, 29 Aug 2019 23:15:11 +0000
Message-ID: <DM6PR21MB1337AC27F2C5CB88C40CC3BCCAA20@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <20190829210845.41a9e193@canb.auug.org.au>
         <3cbf3e88-53b5-0eb3-9863-c4031b9aed9f@infradead.org>
         <52bcddef-fcf2-8de5-d15a-9e7ee2d5b14d@infradead.org>
         <c92d20e27268f515e0d4c8a28f92c0da041c2acc.camel@mellanox.com>
         <DM6PR21MB13379A89D3A57DCFD6E0D419CAA20@DM6PR21MB1337.namprd21.prod.outlook.com>
 <82c4fad3fc394693a596597df0d73cc5235f7025.camel@mellanox.com>
In-Reply-To: <82c4fad3fc394693a596597df0d73cc5235f7025.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-29T23:15:10.5186883Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=51707ac0-fe25-4708-b2b3-1a4dfe70e2b3;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:210d:4c73:691f:4cc4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e98fbe9e-d876-471f-53b7-08d72cd6bdfc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1321;
x-ms-traffictypediagnostic: DM6PR21MB1321:
x-microsoft-antispam-prvs: <DM6PR21MB13213C5FBA36A7827ABDDF90CAA20@DM6PR21MB1321.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(13464003)(199004)(189003)(52314003)(53754006)(22452003)(55016002)(316002)(110136005)(2201001)(6246003)(71200400001)(66476007)(4326008)(81156014)(53936002)(81166006)(52536014)(6116002)(8936002)(33656002)(71190400001)(10090500001)(476003)(46003)(8676002)(11346002)(86362001)(256004)(25786009)(186003)(5660300002)(229853002)(66556008)(99286004)(66446008)(7736002)(76176011)(53546011)(2501003)(6506007)(478600001)(7696005)(102836004)(446003)(486006)(10290500003)(64756008)(2906002)(9686003)(54906003)(66946007)(74316002)(8990500004)(76116006)(6436002)(305945005)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1321;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aaetr4li4dLehgho5AcvTycGwmV+DqYBCi/lpWtFdSAbLaXdgVAtahMQdWB2YmXYA/6l4Eu/gX2a5YAZngDmIP/8vs/+lvTcinT28koalc9Kqsfv/m+UfuxhbpwELywSJ76LES+uZbfr9/FgSplmaZIVzK0nPjK5Wh7YV+v70l2yIGcA3MMhr7j2VwdLVpY3V9k8dS5VS4Nt7wufcNtUSqPDKNND2pTqMcdtNyZv5X6qqk8vhqCgt5E0EESkRHETeV2i55xDyMDQ4mKRlscF92frYd3BbayVfGRminfVrO0mQZvbE1XKsBjizzYr6ZQwcl6G67ae1/Y/HS7qDlHY9lbZrXp/HPQslE2avq2epQpDr+SDGAbCZeDfjovIlC08i7FC0jGVNzyUd6kTi3pf/6LlZys1Fxsa+As6eVeGx/I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98fbe9e-d876-471f-53b7-08d72cd6bdfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:15:11.6396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Y0zURpKgxGswEUDiJ6rZgjII73b6wD0RXyK45atinrnO5uIluYtUiWzY8q1DLRLYfvLGwweluBH/QnMVdA6cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1321
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMjksIDIwMTkg
NDowNCBQTQ0KPiBUbzogc2ZyQGNhbmIuYXV1Zy5vcmcuYXU7IEVyYW4gQmVuIEVsaXNoYSA8ZXJh
bmJlQG1lbGxhbm94LmNvbT47IGxpbnV4LQ0KPiBuZXh0QHZnZXIua2VybmVsLm9yZzsgcmR1bmxh
cEBpbmZyYWRlYWQub3JnOyBIYWl5YW5nIFpoYW5nDQo+IDxoYWl5YW5nekBtaWNyb3NvZnQuY29t
Pg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgTGVvbg0KPiBSb21hbm92c2t5IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiBTdWJqZWN0
OiBSZTogbGludXgtbmV4dDogVHJlZSBmb3IgQXVnIDI5IChtbHg1KQ0KPiANCj4gT24gVGh1LCAy
MDE5LTA4LTI5IGF0IDIxOjQ4ICswMDAwLCBIYWl5YW5nIFpoYW5nIHdyb3RlOg0KPiA+ID4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVl
ZG1AbWVsbGFub3guY29tPg0KPiA+ID4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAyOSwgMjAxOSAy
OjMyIFBNDQo+ID4gPiBUbzogc2ZyQGNhbmIuYXV1Zy5vcmcuYXU7IEVyYW4gQmVuIEVsaXNoYSA8
ZXJhbmJlQG1lbGxhbm94LmNvbT47DQo+ID4gPiBsaW51eC0NCj4gPiA+IG5leHRAdmdlci5rZXJu
ZWwub3JnOyByZHVubGFwQGluZnJhZGVhZC5vcmc7IEhhaXlhbmcgWmhhbmcNCj4gPiA+IDxoYWl5
YW5nekBtaWNyb3NvZnQuY29tPg0KPiA+ID4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IExlb24NCj4gPiA+IFJvbWFub3Zza3kgPGxlb25y
b0BtZWxsYW5veC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogbGludXgtbmV4dDogVHJlZSBmb3Ig
QXVnIDI5IChtbHg1KQ0KPiA+ID4NCj4gPiA+IE9uIFRodSwgMjAxOS0wOC0yOSBhdCAxMjo1NSAt
MDcwMCwgUmFuZHkgRHVubGFwIHdyb3RlOg0KPiA+ID4gPiBPbiA4LzI5LzE5IDEyOjU0IFBNLCBS
YW5keSBEdW5sYXAgd3JvdGU6DQo+ID4gPiA+ID4gT24gOC8yOS8xOSA0OjA4IEFNLCBTdGVwaGVu
IFJvdGh3ZWxsIHdyb3RlOg0KPiA+ID4gPiA+ID4gSGkgYWxsLA0KPiA+ID4gPiA+ID4NCj4gPiA+
ID4gPiA+IENoYW5nZXMgc2luY2UgMjAxOTA4Mjg6DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gb24geDg2XzY0Og0KPiA+ID4gPiA+IHdoZW4gQ09ORklHX1BDSV9IWVBFUlY9bQ0K
PiA+ID4gPg0KPiA+ID4gPiBhbmQgQ09ORklHX1BDSV9IWVBFUlZfSU5URVJGQUNFPW0NCj4gPiA+
ID4NCj4gPiA+DQo+ID4gPiBIYWl5YW5nIGFuZCBFcmFuLCBJIHRoaW5rIENPTkZJR19QQ0lfSFlQ
RVJWX0lOVEVSRkFDRSB3YXMgbmV2ZXINCj4gPiA+IHN1cHBvc2VkIHRvIGJlIGEgbW9kdWxlID8g
aXQgc3VwcG9zZWQgdG8gcHJvdmlkZSBhbiBhbHdheXMgYXZhaWxhYmxlDQo+ID4gPiBpbnRlcmZh
Y2UgdG8gZHJpdmVycyAuLg0KPiA+ID4NCj4gPiA+IEFueXdheSwgbWF5YmUgd2UgbmVlZCB0byBp
bXBseSBDT05GSUdfUENJX0hZUEVSVl9JTlRFUkZBQ0UgaW4NCj4gbWx4NS4NCj4gPg0KPiA+IFRo
ZSBzeW1ib2xpYyBkZXBlbmRlbmN5IGJ5IGRyaXZlciBtbHg1ZSwgIGF1dG9tYXRpY2FsbHkgdHJp
Z2dlcnMNCj4gPiBsb2FkaW5nIG9mIHBjaV9oeXBlcnZfaW50ZXJmYWNlIG1vZHVsZS4gQW5kIHRo
aXMgbW9kdWxlIGNhbiBiZSBsb2FkZWQNCj4gPiBpbiBhbnkgcGxhdGZvcm1zLg0KPiA+DQo+IA0K
PiBUaGlzIG9ubHkgd29ya3Mgd2hlbiBib3RoIGFyZSBtb2R1bGVzLg0KPiANCj4gDQo+ID4gQ3Vy
cmVudGx5LCBtbHg1ZSBkcml2ZXIgaGFzICNpZg0KPiA+IElTX0VOQUJMRUQoQ09ORklHX1BDSV9I
WVBFUlZfSU5URVJGQUNFKQ0KPiA+IGFyb3VuZCB0aGUgY29kZSB1c2luZyB0aGUgaW50ZXJmYWNl
Lg0KPiA+DQo+ID4gSSBhZ3JlZSAtLQ0KPiA+IEFkZGluZyAic2VsZWN0IFBDSV9IWVBFUlZfSU5U
RVJGQUNFIiBmb3IgbWx4NWUgd2lsbCBjbGVhbiB1cCB0aGVzZQ0KPiA+ICNpZidzLg0KPiA+DQo+
IA0KPiBObywgbm90ICJzZWxlY3QiLCAiaW1wbHkiLg0KPiANCj4gaWYgb25lIHdhbnRzIFBDSV9I
WVBFUlZfSU5URVJGQUNFIG9mZiwgaW1wbHkgd2lsbCBrZWVwIGl0IG9mZiBmb3IgeW91Lg0KDQpU
aGlzIGxvb2tzIGdvb2QuDQoNCi0gSGFpeWFuZw0K
