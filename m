Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF27B2A2539
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgKBHbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:31:20 -0500
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:8993
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbgKBHbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 02:31:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bm5mF2PRU59n4O0BG9GUC6yGVuI5Y8vEh1vl7mP336d2LY94kB7vzawuO9iW1ynLE6zWtgSSmNkoasSdM7M7zMurYBkEvbOvkPdEROIRRyPiTrqyeKFQ7d4A2UWIyqzQr9oyHru0MQms5UXh/O7W0Tm3NRIkv83URi6Dn82SZQZn9Mi+DcKF+qcOSLiEcRW3PPk6awtIROEGMGKDG9vFstD7IL4soJCpjBgIIGgUsjiahrn66sx8/20wcssDzgbLMVKvWj2fTYIMLxBhFmu4uJ/JpmWvDKizGS9HkdtmJEzRqTRjGNQ876eYR63LrJE9ZMRpNPqywvTiL99XQM9lpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YV9QV6QDX9A+c1optl1HvK27PimN5yIKKjZXoRJjpo=;
 b=UfHQDZx0cfa28elKAdmX9++bJwiuR/vTL/Rs7oMGomLZVSSa2hGlRlMODnGWdD4KpM8tViaZAvRRyES/UPTHrXfwa1vcH6CN4r7HQZX1cGfnEGhVdu7WZNs43Jma0VB/HotpeY6UPluGlrGAZ+M2a55jl2xdGJjy5ZPentiwZkwSUCxHTN3lGC5B/ie8qd8FKReHobxChGXcczr/rDMJHlQNVSrKUp2ANEx4fltTo4dB5bNATvUt6SJwxGQqc9BmuBbQo03gRcsK+96G9nYED7wm51+6Q5Ri6oeE8exifhN7Ia8AJToVE4mlXUSoGXaroKLHD7AVH92efscwoKZSiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YV9QV6QDX9A+c1optl1HvK27PimN5yIKKjZXoRJjpo=;
 b=NQYG6ETjTsObhvlf+gWusrF0LgdFYgdaQyz+XgHyKSKyP30jhDXIZF/4w2iKKUsHUiWa+qhhlAkm5Jwe7q4Ccw3XmC6RhRsNd2v51P+t1GL4y5Pgoh9nqUxvGhmZXza1YLAeMEf9bNJlUBOFOrnG69bGkRd4EXCg9kC+v6gsWL0=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by BYAPR02MB5861.namprd02.prod.outlook.com (2603:10b6:a03:11f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 2 Nov
 2020 07:31:17 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780%4]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 07:31:16 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Michal Simek <michals@xilinx.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
Thread-Topic: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
Thread-Index: AQHWr63uS/hX4KZfZEO8S/T67co/NKm0cgKAgAACKYA=
Date:   Mon, 2 Nov 2020 07:31:16 +0000
Message-ID: <BYAPR02MB56388293FE47BE39604EB115C7100@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <20201031174721.1080756-1-andrew@lunn.ch>
 <20201031174721.1080756-3-andrew@lunn.ch>
 <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
In-Reply-To: <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [47.8.106.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2fe2319e-0a59-44dd-6ca8-08d87f0148f5
x-ms-traffictypediagnostic: BYAPR02MB5861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB5861E4BDA8315600B3870E5FC7100@BYAPR02MB5861.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p+vEGIZHuuE6lpYRWzdH9878Y27k64WrdOv8pGHHuGl83F4Ce/s1KmJKjSwa0rDAyj0b74UrqMkBQeJywK8BDqEWsVHW/7BMRhX91pM8ZHYlBQmqfygrReL8oAIVOGqTHBCVedUfy+uDuRqWWnNlMetCcTWPIlcXiRXc52ExOjyTaFEOpdKwWq8cpgJRda+1W3oj4nBYMM4PUKX+0M/H//D3jyRg8qrcukevH+9XUqPjGirjcUgDQZPISB2I8D0wp7yX7Dumu7b5b2h3AXX+dJX5nAVzF/r0pCrEQdbfSeHyh+c0LXgFJXJpVPuq9lscX40BCZ91lMugKMfDQhNR6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(136003)(346002)(396003)(366004)(7696005)(8936002)(64756008)(2906002)(53546011)(6506007)(5660300002)(478600001)(76116006)(71200400001)(8676002)(66556008)(66446008)(86362001)(66476007)(52536014)(55016002)(66946007)(33656002)(110136005)(9686003)(107886003)(26005)(83380400001)(54906003)(4326008)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1Wde336R5rc7lkZoxvni1HBAoRae93FWYq4PbQl/5HjGzb3ku1OTuZ5TkZVO4I/A+P8GVSUwcDwsiOtyagSlXgtMlym6pR1TX9Y2wekNcaWHcWptT4OERJ41BhtE6nOCUTCEbwxPbEcCbshLa+N2Gv5NN715WyrvTB51JLmIGFJap8dujL7Sfeo2VOZwTtVQ5U5AdRle2nuNFC7vlAbBiGwHM4jCmOKqe04xrJYUuV+KCkHhgo01mndY1cji6FEgxVPDlkIsnI1f3P5dYcPJ8MnZlPjKS6FshKRTXJ2cmcTVFZdiBBkGdoGY2AiPQlqyS4ZAYSWjPk+cd4gfbZofroRdpeJasSxMrAUzuDxL7fnxAS+BlbtOA4xuCr39Sk9iQzvKcnFnCh2bbyJoNSXNX3VGC3dnyoiuirv3A314teJ41ES1oXt2GFr42bDgVeqfyNpiCp0wzqFQXRF5WHEpfVz1onx8hJ+4lYJyYq+nE91zXCayGkkeEhafgCpoiEPxCyOp+CKKtuxA5HzjMwscZmjRIXsZsXuQVlGFgh0uVj9zgZ+CndxbrqhXj3XMLiMbJQAI/lb/CejqeS7V1VA7jQRi1f6D4ijfFPk3LY71qHK4IOMN3bP/9VuyFkBTG7SC6J6C9MyjfO3gDirmLgZ4hA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe2319e-0a59-44dd-6ca8-08d87f0148f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 07:31:16.7724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOlzxKtXVLX/aE1Mhg511+T2K7UaqPn+449DydP8U20/U9XPpBcK/bSbiRdOp91sLgiMLN/3dC3BkMqk2zZ3Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWNoYWwgU2ltZWsgPG1pY2hh
bC5zaW1la0B4aWxpbnguY29tPg0KPiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDIsIDIwMjAgMTI6
NTEgUE0NCj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+
OyBNaWNoYWwgU2ltZWsgPG1pY2hhbHNAeGlsaW54LmNvbT47DQo+IFJhZGhleSBTaHlhbSBQYW5k
ZXkgPHJhZGhleXNAeGlsaW54LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAy
LzNdIGRyaXZlcnM6IG5ldDogeGlsaW54X2VtYWNsaXRlOiBGaXggLVdwb2ludGVyLQ0KPiB0by1p
bnQtY2FzdCB3YXJuaW5ncyB3aXRoIFc9MQ0KPiANCj4gDQo+IA0KPiBPbiAzMS4gMTAuIDIwIDE4
OjQ3LCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC8veGlsaW54
L3hpbGlueF9lbWFjbGl0ZS5jOjM0MTozNTogd2FybmluZzogY2FzdCBmcm9tDQo+IHBvaW50ZXIg
dG8gaW50ZWdlciBvZiBkaWZmZXJlbnQgc2l6ZSBbLVdwb2ludGVyLXRvLWludC1jYXN0XQ0KPiA+
ICAgMzQxIHwgICBhZGRyID0gKHZvaWQgX19pb21lbSBfX2ZvcmNlICopKCh1MzIgX19mb3JjZSlh
ZGRyIF4NCj4gPg0KPiA+IFVzZSBsb25nIGluc3RlYWQgb2YgdTMyIHRvIGF2b2lkIHByb2JsZW1z
IG9uIDY0IGJpdCBzeXN0ZW1zLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEx1bm4g
PGFuZHJld0BsdW5uLmNoPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC94aWxp
bngveGlsaW54X2VtYWNsaXRlLmMgfCAxMCArKysrKy0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9lbWFjbGl0ZS5jDQo+ID4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2VtYWNsaXRlLmMNCj4gPiBpbmRleCAyYzk4
ZTRjYzA3YTUuLmY1NmMxZmQwMTA2MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC94aWxpbngveGlsaW54X2VtYWNsaXRlLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC94aWxpbngveGlsaW54X2VtYWNsaXRlLmMNCj4gPiBAQCAtOTcsNyArOTcsNyBAQA0KPiA+
ICAjZGVmaW5lIEFMSUdOTUVOVAkJNA0KPiA+DQo+ID4gIC8qIEJVRkZFUl9BTElHTihhZHIpIGNh
bGN1bGF0ZXMgdGhlIG51bWJlciBvZiBieXRlcyB0byB0aGUgbmV4dA0KPiA+IGFsaWdubWVudC4g
Ki8gLSNkZWZpbmUgQlVGRkVSX0FMSUdOKGFkcikgKChBTElHTk1FTlQgLSAoKHUzMilhZHIpKSAl
DQo+ID4gQUxJR05NRU5UKQ0KPiA+ICsjZGVmaW5lIEJVRkZFUl9BTElHTihhZHIpICgoQUxJR05N
RU5UIC0gKChsb25nKWFkcikpICUgQUxJR05NRU5UKQ0KPiANCj4gSSBjYW4ndCBzZWUgYW55IHJl
YXNvbiB0byBjaGFuZ2UgdW5zaWduZWQgdHlwZSB0byBzaWduZWQgb25lLg0KQWdyZWUuIEFsc28s
IEkgdGhpbmsgd2UgY2FuIGdldCByaWQgb2YgdGhpcyBjdXN0b20gQlVGRkVSX0FMSUdODQptYWNy
byBhbmQgc2ltcGx5IGNhbGxpbmcgc2tiX3Jlc2VydmUoc2tiLCBORVRfSVBfQUxJR04pDQp3aWxs
IG1ha2UgdGhlIHByb3RvY29sIGhlYWRlciB0byBiZSBhbGlnbmVkIG9uIGF0IA0KbGVhc3QgYSA0
LWJ5dGUgYm91bmRhcnk/DQoNCj4gDQo+ID4NCj4gPiAgI2lmZGVmIF9fQklHX0VORElBTg0KPiA+
ICAjZGVmaW5lIHhlbWFjbGl0ZV9yZWFkbAkJaW9yZWFkMzJiZQ0KPiA+IEBAIC0zMzgsNyArMzM4
LDcgQEAgc3RhdGljIGludCB4ZW1hY2xpdGVfc2VuZF9kYXRhKHN0cnVjdCBuZXRfbG9jYWwNCj4g
KmRydmRhdGEsIHU4ICpkYXRhLA0KPiA+ICAJCSAqIGlmIGl0IGlzIGNvbmZpZ3VyZWQgaW4gSFcN
Cj4gPiAgCQkgKi8NCj4gPg0KPiA+IC0JCWFkZHIgPSAodm9pZCBfX2lvbWVtIF9fZm9yY2UgKiko
KHUzMiBfX2ZvcmNlKWFkZHIgXg0KPiA+ICsJCWFkZHIgPSAodm9pZCBfX2lvbWVtIF9fZm9yY2Ug
KikoKGxvbmcgX19mb3JjZSlhZGRyIF4NCj4gDQo+IGRpdHRvLg0KPiANCj4gPiAgCQkJCQkJIFhF
TF9CVUZGRVJfT0ZGU0VUKTsNCj4gPiAgCQlyZWdfZGF0YSA9IHhlbWFjbGl0ZV9yZWFkbChhZGRy
ICsgWEVMX1RTUl9PRkZTRVQpOw0KPiA+DQo+ID4gQEAgLTM5OSw3ICszOTksNyBAQCBzdGF0aWMg
dTE2IHhlbWFjbGl0ZV9yZWN2X2RhdGEoc3RydWN0IG5ldF9sb2NhbA0KPiAqZHJ2ZGF0YSwgdTgg
KmRhdGEsIGludCBtYXhsZW4pDQo+ID4gIAkJICogd2lsbCBjb3JyZWN0IG9uIHN1YnNlcXVlbnQg
Y2FsbHMNCj4gPiAgCQkgKi8NCj4gPiAgCQlpZiAoZHJ2ZGF0YS0+cnhfcGluZ19wb25nICE9IDAp
DQo+ID4gLQkJCWFkZHIgPSAodm9pZCBfX2lvbWVtIF9fZm9yY2UgKikoKHUzMiBfX2ZvcmNlKWFk
ZHIgXg0KPiA+ICsJCQlhZGRyID0gKHZvaWQgX19pb21lbSBfX2ZvcmNlICopKChsb25nIF9fZm9y
Y2UpYWRkcg0KPiBeDQo+IA0KPiBkaXR0by4NCj4gDQo+ID4NCj4gWEVMX0JVRkZFUl9PRkZTRVQp
Ow0KPiA+ICAJCWVsc2UNCj4gPiAgCQkJcmV0dXJuIDA7CS8qIE5vIGRhdGEgd2FzIGF2YWlsYWJs
ZSAqLw0KPiA+IEBAIC0xMTkyLDkgKzExOTIsOSBAQCBzdGF0aWMgaW50IHhlbWFjbGl0ZV9vZl9w
cm9iZShzdHJ1Y3QNCj4gcGxhdGZvcm1fZGV2aWNlICpvZmRldikNCj4gPiAgCX0NCj4gPg0KPiA+
ICAJZGV2X2luZm8oZGV2LA0KPiA+IC0JCSAiWGlsaW54IEVtYWNMaXRlIGF0IDB4JTA4WCBtYXBw
ZWQgdG8gMHglMDhYLCBpcnE9JWRcbiIsDQo+ID4gKwkJICJYaWxpbnggRW1hY0xpdGUgYXQgMHgl
MDhYIG1hcHBlZCB0byAweCUwOGxYLCBpcnE9JWRcbiIsDQo+ID4gIAkJICh1bnNpZ25lZCBpbnQg
X19mb3JjZSluZGV2LT5tZW1fc3RhcnQsDQo+ID4gLQkJICh1bnNpZ25lZCBpbnQgX19mb3JjZSls
cC0+YmFzZV9hZGRyLCBuZGV2LT5pcnEpOw0KPiA+ICsJCSAodW5zaWduZWQgbG9uZyBfX2ZvcmNl
KWxwLT5iYXNlX2FkZHIsIG5kZXYtPmlycSk7DQo+IA0KPiBUaGlzIGlzIGRpZmZlcmVudCBjYXNl
IGJ1dCBJIGRvbid0IHRoaW5rIGFkZHJlc3MgY2FuIGJlIHNpZ25lZCB0eXBlIGhlcmUgdG9vLg0K
PiANCj4gPiAgCXJldHVybiAwOw0KPiA+DQo+ID4gIGVycm9yOg0KPiA+DQo+IA0KPiBUaGFua3Ms
DQo+IE1pY2hhbA0K
