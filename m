Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA0293134
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgJSW0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:26:36 -0400
Received: from mail-eopbgr670050.outbound.protection.outlook.com ([40.107.67.50]:45312
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726441AbgJSW0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 18:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atdoljathzF+TQzlAkagdH4uHeIU0fYlrv9+B4x7NnJbZmsUKneZVdZJCc0lYRQAvIGVqQIBeRd8ef0nulq9HzysCMC29KfrOojnHyqdE5hoADyoObFzi+MRrYQysKfaeysiHt574s6hvm4kZd78ZrkBcH+0Bszt6yrbWFZN1q0LKbd9Dn9SgLhQIGCWun/NjwFgBs1kxn6dyPntaEQHoiJVXG2MOLtXsKgo2ZSfVIPeqdTTDb5B4i1I+vJ4Ll6gujt0XzeD/PRKbgDfID9BsksFIZX5+r2dtOHkAz2u1/gz3DRefuyjQ/ERNk+rxjf98fucNv89QFVjFN6tNbZk/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UjM8JYXHkZVpz5kuYgT+BX8AOg4HXgIvXHJp/6aKN0=;
 b=Xo5NNLNvSdoKp+4i+CBa9/arekn+PaorGCjEbEWxfmKugdfK/a+Mx1RGhl6T8A9UkNqa01non9pBTf3dSdwdEV0DWdO+V6FRSWR+rWy3gnQbUkHxsTagOwhAuRbzGlMMj2UQrClIdWFuUWQr0fQOHibwPrcMesp+PmQ687magm84B9J78IZ/tENcJHbXXDZRiYynt5gckCcWrW2AEGXoDQ/tXDaYPDMtshU/VgfkXPIK9EK0i4mbLs/I0/k2j3SPekAg6nQZzTik2mzjoXToZLfROWTXGAbP/ys+pMavK48nYSqqf6jjbl1DO11FmhOWM31oPr3h6rQwrJyPeh6m9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UjM8JYXHkZVpz5kuYgT+BX8AOg4HXgIvXHJp/6aKN0=;
 b=e7DGM1hVMvZr347LTNxGx7eqMNNtwiRJBFo2Q2phKvyRNIyxnRyVQFESM5xS+RhnPwo9jYitgQotypFiOgQDOHe7hOHCb7XUFuEFL0RGp1JkBWf9jLRPeJywyvYOlkTUcXHGra0aBH0sXBH+Kbq8uKb/sWzyF0bgcpijZmUPh4k=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1145.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 22:26:31 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 22:26:31 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Thread-Topic: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Thread-Index: AQHWpll91HNTpw9Y2UKmWJkWbB3A/amfa2WAgAAGtgCAAAONAIAAA8gAgAADvgCAAAPnAA==
Date:   Mon, 19 Oct 2020 22:26:30 +0000
Message-ID: <365985c08396cb01032b57fcd9f423cfe8d4efa1.camel@calian.com>
References: <20201019204913.467287-1-robert.hancock@calian.com>
         <20201019210852.GW1551@shell.armlinux.org.uk>
         <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
         <20201019214536.GX139700@lunn.ch>
         <1f3243e15a8600dd9876b97410b450029674c50c.camel@calian.com>
         <20201019221232.GB139700@lunn.ch>
In-Reply-To: <20201019221232.GB139700@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ba5b08b-dc64-4252-5c8c-08d8747e074b
x-ms-traffictypediagnostic: YTOPR0101MB1145:
x-microsoft-antispam-prvs: <YTOPR0101MB1145B10B979CA6C8EE09DBBAEC1E0@YTOPR0101MB1145.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g4c916S5Bj7XEwAPSurqeYJyXq8/bWzUziO6sPNVm3bXkpfIRSxpwcfH0HPPdTAIKxxPpnUUMCmFqCWoocmVc0MGilUysDQd1jNBjBHR/zvORXpmiUIHppiyNiFYmXfnYc/8jhX937AhhBxIShAvQvxIPIFHZOEqK4idRvvdlOLFEXTBbJPy3MPdGIojXQNZiORgKmmp2F8Er5z3CEP4kTwlE7NjBNpt03Y2cREN44FuzYlbQWc4jL73yi92sr8a16+1uCgvAqzc1zGpU0idUHgUZE4bwAe2PPKmaq+kSfSUHAEuIxngvqecDo4aeZOLtAHEhk9FSRcW8FckxSgoFFlgY1+sYdsZzXvuYDrZPX3cOYVc1bf9tNdf83xu0jYW5H79m43w7Bhyq6ARWFFgrvG7tZwaVjPM4ukkDz0H3e2yOBZvm1HFS+RoNpU2H1tpKLPlVGdmj8LWEvApMwry1iLu8iWn0ndU4MzWpm5csxs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(136003)(346002)(376002)(396003)(64756008)(2906002)(66476007)(44832011)(66556008)(36756003)(91956017)(76116006)(66446008)(2616005)(8936002)(86362001)(4326008)(6916009)(83380400001)(8676002)(6506007)(54906003)(478600001)(6512007)(15974865002)(66946007)(71200400001)(186003)(5660300002)(26005)(4001150100001)(6486002)(316002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DR+XgAE1XuDt7Sav9e+ebuuCopPaS1XTcMLgBcnhl2CLVICm2a8zFiNRFWFV3ahIWtGZUs+9r4MsNdIk1fxB37Ub8hI80KimquD8hQkIYyJoT5ExYCS3pIPrZmibHgaUHhhcijIQlAC6PpDbWtD3r07gCytIr3Ltj7hzVN1D7hg4+I64Swka9n51y47vqUPEFuHy9LSQwH/KkOT9YxdAj+5XJjzfOrZ1pBjnp628UvxfbJUkQK/JRz58whhAcxT7X8suxLPkjoRAJFU3ma2Oc6slXU9M9Z/5yq92zSSz4Myz9FJlr8BvzuOuSp5JFQnWMPo+vH0aiU/XnH70YgySwl3nyv9HqjePWv27noISqtuYnIBNoxmlMTaYQZM+MBlayP/RAgf8e/IUgauZbSR2Ciz+NN09OB4VOW/+80a0jzxyWxJekPQlc2xgYG02vl3376B64rICNWKkeKi//6DIppFk3BdXt5loI62bIPpqRrG62hBT8fshbKt/RIj706PEFcqAEkg25tXybfx66RpnhRKUnFrHAfx8uWN3H+IZ/yL6RJ6/ZVcycUH26N5eiTjpQBTmwGKnEuJv+guhp4g2Q8N6hQ4kmhEp9JXV4Lz/ayRhhgc2l82UP29xIQFH3i6hcQAbbLIBScQTnyvX1ulA0A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCF87E4E4CE7E14E83DAAAF182F970F0@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba5b08b-dc64-4252-5c8c-08d8747e074b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 22:26:30.9386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qy8UKjmbgy1FKTqrnqV/jdDEKtqfbrtqkvfu9b9YKthIJ3e4vZuePctwPqFXSl7A1wnJej/4OFx/HH/aSouVh+9W3RjnYuLvKonZn7a+554=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTIwIGF0IDAwOjEyICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBJIHRoaW5rIGluIG15IGNhc2UgdGhvc2UgZXh0cmEgbW9kZXMgb25seSBzdXBwb3J0ZWQgaW4g
U0dNSUkgbW9kZSwNCj4gPiBsaWtlDQo+ID4gMTAgYW5kIDEwME1icHMgbW9kZXMsIGVmZmVjdGl2
ZWx5IGdldCBmaWx0ZXJlZCBvdXQgYmVjYXVzZSB0aGUgTUFDDQo+ID4gZG9lc24ndCBzdXBwb3J0
IHRoZW0gaW4gdGhlIDEwMDBCYXNlWCBtb2RlIGVpdGhlci4NCj4gDQo+IFRoZXJlIGFyZSBkaWZm
ZXJlbnQgdGhpbmdzIGhlcmUuIFdoYXQgZXRodG9vbCByZXBvcnRzLCBhbmQgd2hhdCBpcw0KPiBw
cm9ncmFtbWVkIGludG8gdGhlIGFkdmVydGlzZSByZWdpc3Rlci4gQ2xlYXJseSwgeW91IGRvbid0
IHdhbnQgaXQNCj4gYWR2ZXJ0aXNpbmcgMTAgYW5kIDEwMCBtb2Rlcy4gSWYgc29tZWJvZHkgY29u
bmVjdHMgaXQgdG8gYSAxMEhhbGYNCj4gbGluaw0KPiBwYXJ0bmVyLCB5b3UgbmVlZCBhdXRvLWdl
dCB0byBmYWlsLiBZb3UgZG9uJ3Qgd2FudCBhdXRvLW5lZyB0bw0KPiBzdWNjZWVkLCBhbmQgdGhl
biBhbGwgdGhlIGZyYW1lcyBnZXQgdGhyb3duIGF3YXkgd2l0aCBiYWQgQ1JDcywNCj4gb3ZlcnJ1
bnMgZXRjLg0KPiANCg0KUmlnaHQsIEkgZG9uJ3Qga25vdyB0aGF0IHdlIGhhdmUgZGlyZWN0IGNv
bnRyb2wgb3ZlciB3aGF0IHRoZSBQSFkgaXMNCmFkdmVydGlzaW5nIHRvIHRoZSBjb3BwZXIgc2lk
ZSBpbiB0aGlzIGNhc2UuIEkgdGhpbmsgaXQncyBiYXNlZCBvbiBpdHMNCmF1dG8tbWFnaWNhbCB0
cmFuc2xhdGlvbiBvZiB0aGUgMTAwMEJhc2VYIGFkdmVydGlzZW1lbnRzIGZyb20gdGhlDQpQQ1Mv
UE1BIFBIWSBpbiB0aGlzIGNhc2UsIHdoZXJlIHdlIG9ubHkgZXZlciBhZHZlcnRpc2UgMTAwMCBt
b2RlcyBpbg0KMTAwMEJhc2VYIG1vZGUgKG5vdCBzdXJlIGlmIGFueSBvdGhlciBzcGVlZHMgYXJl
IGV2ZW4gZGVmaW5lZCBmb3IgdGhvc2UNCm1lc3NhZ2VzKS4gUHJlc3VtYWJseSB0aGUgODhFMTEx
MSBpcyBzbWFydCBlbm91Z2ggdG8gb25seSBhZHZlcnRpc2UNCjEwMDAgbW9kZXMgb24gdGhlIGNv
cHBlciBzaWRlIHdoZW4gaW4gMTAwMEJhc2VYIG1vZGUuDQoNCj4gPiBUaGUgYXV0by1uZWdvdGlh
dGlvbiBpcyBhIGJpdCBvZiBhIHdlaXJkIHRoaW5nIGluIHRoaXMgY2FzZSwgYXMNCj4gPiB0aGVy
ZQ0KPiA+IGFyZSB0d28gbmVnb3RpYXRpb25zIG9jY3VycmluZywgdGhlIDEwMDBCYXNlWCBiZXR3
ZWVuIHRoZSBQQ1MvUE1BDQo+ID4gUEhZDQo+ID4gYW5kIHRoZSBtb2R1bGUgUEhZLCBhbmQgdGhl
IDEwMDBCYXNlVCBiZXR3ZWVuIHRoZSBtb2R1bGUgUEhZIGFuZA0KPiA+IHRoZQ0KPiA+IGNvcHBl
ciBsaW5rIHBhcnRuZXIuIEkgYmVsaWV2ZSB0aGUgODhFMTExMSBoYXMgc29tZSBzbWFydHMgdG8g
ZGVsYXkNCj4gPiB0aGUNCj4gPiBjb3BwZXIgbmVnb3RpYXRpb24gdW50aWwgaXQgZ2V0cyB0aGUg
YWR2ZXJ0aXNlbWVudCBvdmVyIDEwMDBCYXNlWCwNCj4gPiB1c2VzDQo+ID4gdGhvc2UgdG8gZmln
dXJlIG91dCBpdHMgYWR2ZXJ0aXNlbWVudCwgYW5kIHRoZW4gdXNlcyB0aGUgY29wcGVyDQo+ID4g
bGluaw0KPiA+IHBhcnRuZXIncyByZXNwb25zZSB0byBkZXRlcm1pbmUgdGhlIDEwMDBCYXNlWCBy
ZXNwb25zZS4NCj4gDQo+IEJ1dCBhcyBmYXIgYXMgaSBrbm93IHlvdSBjYW4gb25seSByZXBvcnQg
ZHVwbGV4IGFuZCBwYXVzZSBvdmVyDQo+IDEwMDBCYXNlWCwgbm90IHNwZWVkLCBzaW5jZSBpdCBp
cyBhbHdheXMgMUcuDQo+IA0KPiBJdCB3b3VsZCBiZSBpbnRlcmVzdGluZyB0byBydW4gZXRodG9v
bCBvbiB0aGUgbGluayBwYXJ0bmVyIHRvIHNlZQ0KPiB3aGF0DQo+IGl0IHRoaW5rcyB0aGUgU0ZQ
IGlzIGFkdmVydGlzaW5nLiBJZiBpdCBqdXN0IDEwMDBCYXNlVC9GdWxsPw0KDQpXZWxsIHRoZSBk
ZXZpY2UgaXMgcGx1Z2dlZCBpbnRvIGEgTGludXggUEMgb24gdGhlIG90aGVyIGVuZCwgYnV0DQp1
bmZvcnR1bmF0ZWx5IGV0aHRvb2wgZG9lc24ndCBzZWVtIHRvIHJlcG9ydCB0aGUgbGluayBwYXJ0
bmVyDQphZHZlcnRpc2VtZW50cyBvbiB0aGF0IGFkYXB0ZXIsIG9ubHkgdGhlIGhvc3QgYWR2ZXJ0
aXNlbWVudHMgKEludGVsDQo4MjU3NEwsIGUxMDAwZSkuDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sN
ClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQWR2YW5jZWQgVGVjaG5vbG9naWVzIA0Kd3d3LmNh
bGlhbi5jb20NCg==
