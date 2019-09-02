Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94905A5788
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbfIBNQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 09:16:38 -0400
Received: from mail-eopbgr1410110.outbound.protection.outlook.com ([40.107.141.110]:19425
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729983AbfIBNQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 09:16:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmqYHhGdEr1TZixBB0xI6v9/MpQPe6sy/wfj+HAgpN992R70EiliHdfvyrXsT0Y5M8cicDEsSDwvTFaFLR4IB7swLBi0esTz2yyibX7X7wD5wclYPKmx8I1wZwyMuhX1ePHhIC5D20FZBIKyU3AMaVaNF8lhrYYJL8Y/Pg4J0BeV5xllcgXmKzefFLAkC6ln93S3mF2gWCUkbuylAjGKDURRc/3OvGpEYzfAb2RUO5rTmMaMfxb0dTrvjw01F443U1GvLmdR9PuBkrtKwFDZqVvNI24KzxFKtoxGvQIq5M44NbrHkkwqtyiHeuUfakMS6InSmUW+DZ+HH5GmptBTJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ll1MPDM8CwRGSncq1MvW6TEFDpjZk3yQjumbcuoYew=;
 b=mJeE2jWI5TRdfrLBH4SbzpdZQbwe6YPOsIsuEFvOM+MCZ4LNPQH8OCbIQuAgJmPZQpALgGeidxAw7Is996upt2oFBLh7gNionOWvKswGQNviF6DSbHCnJNT8tI5F45PAxKLINjIr/wj99FAkIPvbwbtMKvB9lehWPiuPUpg8pvNRlQNCLMhEkQfqgHfu1Q0QdYzY2VywiXasVTzmRISf053HaS5AyLjMF2hvskWHx65UzYSelZ+4P2qUN1EX5eKNVVxj4UqB45ac9q0GLw8QypLbubHI/J5IohIDOnsDv23IsAMPP8O4siAVyYB6QjJeYaQhSRlj+my9XvwitMB+nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ll1MPDM8CwRGSncq1MvW6TEFDpjZk3yQjumbcuoYew=;
 b=sJAGH6EgsIgMhY/yqdVlBlixXLqwRvabDuxJg7DRGUkGecijsXngs+IM6N7fqbXCq9iau+Qvpvp0MN0+IEL4zBpWsxMeAS0Mv8KrVpaFIVbwS7cdPqpkMSwxBeRMIRhPjFVZfDR4I+OnkMndrIXLIViknZHV5dLSn8liIrV3CRg=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB2528.jpnprd01.prod.outlook.com (20.177.105.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 13:16:20 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::10cb:fc85:630a:9731]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::10cb:fc85:630a:9731%7]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 13:16:20 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Biju Das <biju.das@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
CC:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: RE: [net-next 0/3] ravb: Remove use of undocumented registers
Thread-Topic: [net-next 0/3] ravb: Remove use of undocumented registers
Thread-Index: AQHVYWVZjB9QVcK1g0SbN95xC7vuJacYCqGAgABRwqA=
Date:   Mon, 2 Sep 2019 13:16:20 +0000
Message-ID: <TYAPR01MB2285D3BD0F2CCD2F72AA1B1FB7BE0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <CAMuHMdXQypGJ_oqUndOcf02GCqxEGEOK15+jnS5ehqdUJ+A8aw@mail.gmail.com>
In-Reply-To: <CAMuHMdXQypGJ_oqUndOcf02GCqxEGEOK15+jnS5ehqdUJ+A8aw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d920395e-4c21-43ef-3d45-08d72fa7beb4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TYAPR01MB2528;
x-ms-traffictypediagnostic: TYAPR01MB2528:|TYAPR01MB2528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB2528F3DFABF56FA91F9BDEA4B7BE0@TYAPR01MB2528.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(39850400004)(366004)(376002)(136003)(189003)(199004)(229853002)(86362001)(25786009)(7736002)(305945005)(256004)(33656002)(71200400001)(4326008)(8936002)(66556008)(81166006)(81156014)(8676002)(71190400001)(76116006)(66946007)(66476007)(5660300002)(52536014)(64756008)(476003)(486006)(446003)(11346002)(66446008)(186003)(3846002)(26005)(2906002)(14454004)(55016002)(6116002)(99286004)(9686003)(53936002)(316002)(110136005)(6436002)(478600001)(54906003)(7696005)(76176011)(102836004)(74316002)(6246003)(6506007)(53546011)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2528;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5ilqEzJichD5o6TYF8LsOzgH5ZI845sIv/wkPdk7VnSVIreyYzUjxO9KqOZ1WdAgK9GJAIPmFcoGEhVT7/xY0DAvj+GfU4uC/jEjt1SU710zwcgOx5Ro7aMXGHRKJ1HZsU7+I7cwbAGq8+bNW2XP3aOKg3467Imx96Yh14kNIuyXaJ11huaKvcj474TJ9WDkl2xv85nbriiocZjSchseCb1vkRGC7qbE2fyu1qHnYowIitmdISyhQL3PUKiN0TC16rknUgtOQLSwiJuKkUyAgQyO3H1r7ad5qbsEBdyt8QMJNUcUPH1Cl38NmOgyKa+nJz2ZGViegz2jvy0b5PaODM75Vt9qPxHaoqxT32dULIDKdniegklykz0MlYHJYCr6puHKvLvg35H6ab+8u9XcSgrwSjwp/CPWKDtHDfaEKS8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d920395e-4c21-43ef-3d45-08d72fa7beb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 13:16:20.0472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzUACY4diKaCQRHiOGc/Tqu4A66J/kuHMgEV5GNVSF0XaSpzTmAkxLHW/fRchrLUwIU8czFzyQBq+WcYNTa1Po2Llu6/RIrXJZjf1nYSJJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2528
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gR2VlcnQsDQoNCj4gRnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0
ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4NCj4gT24gQmVoYWxmIE9mIEdlZXJ0IFV5dHRlcmhv
ZXZlbg0KPiBTZW50OiAwMiBTZXB0ZW1iZXIgMjAxOSAwOToxNg0KPiANCj4gSGkgU2ltb24sIEJp
anUsIEZhYnJpemlvLA0KPiANCj4gT24gTW9uLCBTZXAgMiwgMjAxOSBhdCAxMDowNiBBTSBTaW1v
biBIb3JtYW4NCj4gPGhvcm1zK3JlbmVzYXNAdmVyZ2UubmV0LmF1PiB3cm90ZToNCj4gPiB0aGlz
IHNob3J0IHNlcmllcyBjbGVhbnMgdXAgdGhlIFJBVkIgZHJpdmVyIGEgbGl0dGxlLg0KPiA+DQo+
ID4gVGhlIGZpcnN0IHBhdGNoIGNvcnJlY3RzIHRoZSBzcGVsbGluZyBvZiB0aGUgRkJQIGZpZWxk
IG9mIFNGTyByZWdpc3Rlci4NCj4gPiBUaGlzIHJlZ2lzdGVyIGZpZWxkIGlzIHVudXNlZCBhbmQg
c2hvdWxkIGhhdmUgbm8gcnVuLXRpbWUgZWZmZWN0Lg0KPiA+DQo+ID4gVGhlIHJlbWFpbmluZyB0
d28gcGF0Y2hlcyByZW1vdmUgdGhlIHVzZSBvZiB1bmRvY3VtZW50ZWQgcmVnaXN0ZXJzDQo+ID4g
YWZ0ZXIgc29tZSBjb25zdWx0YXRpb24gd2l0aCB0aGUgaW50ZXJuYWwgUmVuZXNhcyBCU1AgdGVh
bS4NCj4gPg0KPiA+IEFsbCBwYXRjaGVzIGhhdmUgYmVlbiBsaWdodGx5IHRlc3RlZCBvbjoNCj4g
PiAqIEUzIEViaXN1DQo+ID4gKiBIMyBTYWx2YXRvci1YUyAoRVMyLjApDQo+ID4gKiBNMy1XIFNh
bHZhdG9yLVhTDQo+ID4gKiBNMy1OIFNhbHZhdG9yLVhTDQo+IA0KPiBJdCB3b3VsZCBiZSBnb29k
IGlmIHNvbWVvbmUgY291bGQgdGVzdCB0aGlzIG9uIGFuIFItQ2FyIEdlbjIgYm9hcmQNCj4gdGhh
dCB1c2VzIHJhdmIgKGl3ZzIyZCBvciBpd2cyM3MpLg0KDQpJJ3ZlIHRyaWVkIHRoaXMgc2VyaWVz
ICsgbmV0LW5leHQgb24gdGhlIGl3ZzIzcyBoYXZlbid0IHNlZW4gYW55IGlzc3VlcyBmcm9tIGEg
cXVpY2sgc2FuaXR5IHRlc3QuDQoNCktpbmQgcmVnYXJkcywgQ2hyaXMNCg0KPiANCj4gVGhhbmtz
IQ0KPiANCj4gPiBLYXp1eWEgTWl6dWd1Y2hpICgyKToNCj4gPiAgIHJhdmI6IGNvcnJlY3QgdHlw
byBpbiBGQlAgZmllbGQgb2YgU0ZPIHJlZ2lzdGVyDQo+ID4gICByYXZiOiBSZW1vdmUgdW5kb2N1
bWVudGVkIHByb2Nlc3NpbmcNCj4gPg0KPiA+IFNpbW9uIEhvcm1hbiAoMSk6DQo+ID4gICByYXZi
OiBUUk9DUiByZWdpc3RlciBpcyBvbmx5IHByZXNlbnQgb24gUi1DYXIgR2VuMw0KPiANCj4gR3J7
b2V0amUsZWV0aW5nfXMsDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBHZWVydA0KPiAN
Cj4gLS0NCj4gR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51eCBiZXlv
bmQgaWEzMiAtLSBnZWVydEBsaW51eC0NCj4gbTY4ay5vcmcNCj4gDQo+IEluIHBlcnNvbmFsIGNv
bnZlcnNhdGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJIGNhbGwgbXlzZWxmIGEgaGFja2Vy
LiBCdXQNCj4gd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qgc2F5ICJwcm9n
cmFtbWVyIiBvciBzb21ldGhpbmcgbGlrZSB0aGF0Lg0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
