Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F5C9F2D0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfH0TBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:01:48 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:41703
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbfH0TBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 15:01:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6Id6SPF8Q5fhjCDCROq23aUzqgc/FWTJhaZCWmb0tgdHN6Du7hvVUgZyovuW/sFGx9blCxHSFejHk49F/sa9d4f81JyfIowdeHJicsJU44rSqURftapHo8SU+dbDpqyZcEpxHXvihKrKMBmXWMkeZZWaaIpYpUcRBxfaxwTfwwsONW9hiWeBBP/PnAgePAkhaX0Viq/WhUR2tR6/79yXmNqSQooJRAUbMEyebASbbAWj0rSMxEKdfQ87Wsogyb48P/u1qZT5NWL/Mo3+NWlb+l/UOE/dusyWqglG1rKIVHbngyUmUBKzJMcVye/FWdwUhDGjP7FlzFnTAOGdwuQzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNLkANFGEgcTB/Ua4bzqzolWAzQyWJwxqpoVXp53B2A=;
 b=ksBVHZ6Z26dKni3QvOcKFGZjB9gAnBC1ASAUOH6mB7sF2cFB7bCQQ/BDYq4kxnzxuDLvhIWpBd4S7iDl/lJYMExrJ1w3dXiAkyia294L89dn6LsQtL56TH+egWlvoQPnvCcHkATR0gZ8UAjfHSV/J53YeKB+uPrMHick3CHnnbhsjICuwlVFIW7VUxTuT3YkTpYYaLR6hKKsSWcPP8TRDJovuPr1K7vD2pigJ6apmaEtYm3k7BeckeumJe0nrVLtNMjQYHCuZLrdDA/977I3L+7OrO08iihtDsa6h3fE5TptjRZurRpCJl8a9BXddllAWiMt07lURGC6Vrfy6Wy2sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNLkANFGEgcTB/Ua4bzqzolWAzQyWJwxqpoVXp53B2A=;
 b=gmCdD1grdNY7s5s6OrpNc6Xv+pEjdQFSkyjuK6vBPcl27X2Un8VoJHwWEeAF9QjPrA9JBPI4r7JPCP3ObtuxZ06VthrSceaMVmUpq2bUbGtZO0S/+GiODU2TX26qRatkniTsCadPElyI9ZeOSfmz+RDSATA+K3P2/R20MA0ZXjU=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2367.eurprd05.prod.outlook.com (10.169.134.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 19:01:41 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 19:01:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "liudongxu3@huawei.com" <liudongxu3@huawei.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: Adding parameter detection in
 __ethtool_get_link_ksettings.
Thread-Topic: [PATCH] net: Adding parameter detection in
 __ethtool_get_link_ksettings.
Thread-Index: AQHVW98/VX5+StK7vkq8amtg1gppeacNFYEAgAAZMICAAi1FAA==
Date:   Tue, 27 Aug 2019 19:01:41 +0000
Message-ID: <0db9e18a4dd81d9a6025a2d8cda343b585d91fc4.camel@mellanox.com>
References: <aa0a372e-a169-7d78-0782-505cbdab8f90@gmail.com>
         <20190826094705.10544-1-liudongxu3@huawei.com>
In-Reply-To: <20190826094705.10544-1-liudongxu3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9279b0c4-f2f2-492b-ef54-08d72b20ff29
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2367;
x-ms-traffictypediagnostic: VI1PR0501MB2367:
x-microsoft-antispam-prvs: <VI1PR0501MB236764457F92E206F236C50DBEA00@VI1PR0501MB2367.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(199004)(189003)(51234002)(71190400001)(478600001)(6436002)(66066001)(71200400001)(86362001)(81156014)(81166006)(8676002)(5660300002)(6512007)(91956017)(66946007)(6116002)(118296001)(66556008)(76116006)(8936002)(36756003)(66446008)(3846002)(186003)(64756008)(6506007)(2501003)(305945005)(2906002)(58126008)(486006)(66476007)(6246003)(2616005)(25786009)(476003)(6486002)(446003)(110136005)(102836004)(45080400002)(14444005)(14454004)(229853002)(99286004)(11346002)(7736002)(54906003)(4326008)(256004)(316002)(26005)(76176011)(53546011)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2367;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sDCKmtdWd/kumqGRB8dS5K5yTlkmCxJLaDsAAH6TA7YUBfyhcRAdyF6uvHKJR1Jynr2lPVF2Zugep4fcVE0s9NAHwbwIDQZlyKVDAdjcI5AgX8bvo/ui9RzgKucpRTgSd64BppfK8rFCN1uHfhszd0EBOrD4KnYiKDLtJluN/xN7JLEL4QAGTG9QuJwS0GsJUHVlawQAL2bgowDZq7Xl9mI/KoIuF+OXSebMITwWn/sheOtMHvxdOCiaIn8eSX5FTr8YN/MuoyB5FPlmkYwUxYIKj5hk3WtKEcAD4dY0pcCS+90WvXSrfOePW0QtRBaWYYn0krkYByhYOyqAtJL9QPDGXwe9KR9lWhKk4nA6czx1JEG6ac9Kp0Zk/vtoFOG6E3cWI0aAlM/9h8Y+O+4u3TTQtkEVRJpdHyBctOpvZs4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4083D17FA7B5D14A9BCAD9E20D061DEF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9279b0c4-f2f2-492b-ef54-08d72b20ff29
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 19:01:41.4761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0SFfuXhct77/HAWPCAppp3soHLmEVwNojUY7ZYdtpCuOJxCw+3PoMpyk8U64vsWAje3fYT8M+D91R/d3jNGiXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2367
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTI2IGF0IDE3OjQ3ICswODAwLCBEb25neHUgTGl1IHdyb3RlOg0KPiA+
IE9uIDgvMjYvMTkgOToyMyBBTSwgRG9uZ3h1IExpdSB3cm90ZToNCj4gPiBUaGUgX19ldGh0b29s
X2dldF9saW5rX2tzZXR0aW5ncyBzeW1ib2wgd2lsbCBiZSBleHBvcnRlZCwNCj4gPiBhbmQgZXh0
ZXJuYWwgdXNlcnMgbWF5IHVzZSBhbiBpbGxlZ2FsIGFkZHJlc3MuDQo+ID4gV2Ugc2hvdWxkIGNo
ZWNrIHRoZSBwYXJhbWV0ZXJzIGJlZm9yZSB1c2luZyB0aGVtLA0KPiA+IG90aGVyd2lzZSB0aGUg
c3lzdGVtIHdpbGwgY3Jhc2guDQo+ID4gDQo+ID4gWyA4OTgwLjk5MTEzNF0gQlVHOiB1bmFibGUg
dG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXINCj4gPiBkZXJlZmVyZW5jZSBhdCAgICAgICAg
ICAgKG51bGwpDQo+ID4gWyA4OTgwLjk5MzA0OV0gSVA6IFs8ZmZmZmZmZmY4MTU1YWNhNz5dDQo+
ID4gX19ldGh0b29sX2dldF9saW5rX2tzZXR0aW5ncysweDI3LzB4MTQwDQo+ID4gWyA4OTgwLjk5
NDI4NV0gUEdEIDANCj4gPiBbIDg5ODAuOTk1MDEzXSBPb3BzOiAwMDAwIFsjMV0gU01QDQo+ID4g
WyA4OTgwLjk5NTg5Nl0gTW9kdWxlcyBsaW5rZWQgaW46IHNjaF9pbmdyZXNzIC4uLg0KPiA+IFsg
ODk4MS4wMTMyMjBdIENQVTogMyBQSUQ6IDI1MTc0IENvbW06IGt3b3JrZXIvMzozIFRhaW50ZWQ6
DQo+ID4gRyAgICAgICAgICAgTyAgIC0tLS1WLS0tLS0tLSAgIDMuMTAuMC0zMjcuMzYuNTguNC54
ODZfNjQgIzENCj4gPiBbIDg5ODEuMDE3NjY3XSBXb3JrcXVldWU6IGV2ZW50cyBsaW5rd2F0Y2hf
ZXZlbnQNCj4gPiBbIDg5ODEuMDE4NjUyXSB0YXNrOiBmZmZmODgwMGE4MzQ4MDAwIHRpOiBmZmZm
ODgwMGIwNDVjMDAwIHRhc2sudGk6DQo+ID4gZmZmZjg4MDBiMDQ1YzAwMA0KPiA+IFsgODk4MS4w
MjA0MThdIFJJUDogMDAxMDpbPGZmZmZmZmZmODE1NWFjYTc+XSAgWzxmZmZmZmZmZjgxNTVhY2E3
Pl0NCj4gPiBfX2V0aHRvb2xfZ2V0X2xpbmtfa3NldHRpbmdzKzB4MjcvMHgxNDANCj4gPiBbIDg5
ODEuMDIyMzgzXSBSU1A6IDAwMTg6ZmZmZjg4MDBiMDQ1ZmM4OCAgRUZMQUdTOiAwMDAxMDIwMg0K
PiA+IFsgODk4MS4wMjM0NTNdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwYjA0
NWZjYWMgUkNYOg0KPiA+IDAwMDAwMDAwMDAwMDAwMDANCj4gPiBbIDg5ODEuMDI0NzI2XSBSRFg6
IGZmZmY4ODAwYjY1OGY2MDAgUlNJOiBmZmZmODgwMGIwNDVmY2FjIFJESToNCj4gPiBmZmZmODgw
MjI5NmUwMDAwDQo+ID4gWyA4OTgxLjAyNjAwMF0gUkJQOiBmZmZmODgwMGIwNDVmYzk4IFIwODog
MDAwMDAwMDAwMDAwMDAwMCBSMDk6DQo+ID4gMDAwMDAwMDAwMDAwMDAwMQ0KPiA+IFsgODk4MS4w
MjcyNzNdIFIxMDogMDAwMDAwMDAwMDAwNzNlMCBSMTE6IDAwMDAwODJiMGNjOGFkZWEgUjEyOg0K
PiA+IGZmZmY4ODAyMjk2ZTAwMDANCj4gPiBbIDg5ODEuMDI4NTYxXSBSMTM6IGZmZmY4ODAwYjU2
NmU4YzAgUjE0OiBmZmZmODgwMGI2NThmNjAwIFIxNToNCj4gPiBmZmZmODgwMGI1NjZlMDAwDQo+
ID4gWyA4OTgxLjAyOTg0MV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApDQo+ID4gR1M6ZmZm
Zjg4MDIzZWQ4MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+ID4gWyA4OTgxLjAz
MTcxNV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMw0K
PiA+IFsgODk4MS4wMzI4NDVdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwYjM5
YTkwMDAgQ1I0Og0KPiA+IDAwMDAwMDAwMDAzNDA3ZTANCj4gPiBbIDg5ODEuMDM0MTM3XSBEUjA6
IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjoNCj4gPiAwMDAwMDAw
MDAwMDAwMDAwDQo+ID4gWyA4OTgxLjAzNTQyN10gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjog
MDAwMDAwMDBmZmZlMGZmMCBEUjc6DQo+ID4gMDAwMDAwMDAwMDAwMDQwMA0KPiA+IFsgODk4MS4w
MzY3MDJdIFN0YWNrOg0KPiA+IFsgODk4MS4wMzc0MDZdICBmZmZmODgwMGI2NThmNjAwIDAwMDAw
MDAwMDAwMDljNDAgZmZmZjg4MDBiMDQ1ZmNlOA0KPiA+IGZmZmZmZmZmYTA0N2E3MWQNCj4gPiBb
IDg5ODEuMDM5MjM4XSAgMDAwMDAwMDAwMDAwMDA0ZCBmZmZmODgwMGIwNDVmY2M4IGZmZmY4ODAw
YjA0NWZkMjgNCj4gPiBmZmZmZmZmZjgxNWNiMTk4DQo+ID4gWyA4OTgxLjA0MTA3MF0gIGZmZmY4
ODAwYjA0NWZjZDggZmZmZmZmZmY4MTA4MDdlNiAwMDAwMDAwMGU4MjEyOTUxDQo+ID4gMDAwMDAw
MDAwMDAwMDAwMQ0KPiA+IFsgODk4MS4wNDI5MTBdIENhbGwgVHJhY2U6DQo+ID4gWyA4OTgxLjA0
MzY2MF0gIFs8ZmZmZmZmZmZhMDQ3YTcxZD5dDQo+ID4gYm9uZF91cGRhdGVfc3BlZWRfZHVwbGV4
KzB4M2QvMHg5MCBbYm9uZGluZ10NCj4gPiBbIDg5ODEuMDQ1NDI0XSAgWzxmZmZmZmZmZjgxNWNi
MTk4Pl0gPyBpbmV0ZGV2X2V2ZW50KzB4MzgvMHg1MzANCj4gPiBbIDg5ODEuMDQ2NTU0XSAgWzxm
ZmZmZmZmZjgxMDgwN2U2Pl0gPyBwdXRfb25saW5lX2NwdXMrMHg1Ni8weDgwDQo+ID4gWyA4OTgx
LjA0NzY4OF0gIFs8ZmZmZmZmZmZhMDQ4MGQ2Nz5dIGJvbmRfbmV0ZGV2X2V2ZW50KzB4MTM3LzB4
MzYwDQo+ID4gW2JvbmRpbmddDQo+ID4gLi4uDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogRG9u
Z3h1IExpdSA8bGl1ZG9uZ3h1M0BodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvY29yZS9l
dGh0b29sLmMgfCAyICsrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZXRodG9vbC5jIGIvbmV0L2NvcmUvZXRodG9v
bC5jIGluZGV4IA0KPiA+IDYyODhlNjkuLjlhNTBiNjQgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2Nv
cmUvZXRodG9vbC5jDQo+ID4gKysrIGIvbmV0L2NvcmUvZXRodG9vbC5jDQo+ID4gQEAgLTU0NSw2
ICs1NDUsOCBAQCBpbnQgX19ldGh0b29sX2dldF9saW5rX2tzZXR0aW5ncyhzdHJ1Y3QNCj4gPiBu
ZXRfZGV2aWNlIA0KPiA+ICpkZXYsICB7DQo+ID4gIAlBU1NFUlRfUlROTCgpOw0KPiA+ICANCj4g
PiArCWlmICghZGV2IHx8ICFkZXYtPmV0aHRvb2xfb3BzKQ0KPiA+ICsJCXJldHVybiAtRU9QTk9U
U1VQUDsNCj4gPiBJIGRvIG5vdCBiZWxpZXZlIGRldiBjYW4gcG9zc2libHkgYmUgTlVMTCBhdCB0
aGlzIHBvaW50Lg0KPiA+ICAJaWYgKCFkZXYtPmV0aHRvb2xfb3BzLT5nZXRfbGlua19rc2V0dGlu
Z3MpDQo+ID4gIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ICANCj4gPiANCj4gPiBJIHRyaWVk
IHRvIGZpbmQgYW4gYXBwcm9wcmlhdGUgRml4ZXM6IHRhZy4NCj4gPiBJdCBzZWVtcyB0aGlzIHBh
cnRpY3VsYXIgYnVnIHdhcyBhZGRlZCBlaXRoZXIgYnkNCj4gPiBGaXhlczogOTg1NjkwOWMyYWJi
ICgibmV0OiBib25kaW5nOiB1c2UgX19ldGh0b29sX2dldF9rc2V0dGluZ3MiKQ0KPiA+IG9yIGdl
bmVyaWNhbGx5IGluIDoNCj4gPiBGaXhlczogM2YxYWM3YTcwMGQwICgibmV0OiBldGh0b29sOiBh
ZGQgbmV3IEVUSFRPT0xfeExJTktTRVRUSU5HUw0KPiA+IEFQSSIpDQo+IA0KPiBJbiBmYWN0LCAi
ZGV2LT5ldGh0b29sX29wcyIgaXMgYSBudWxsIHBvaW50ZXIgaW4gbXkgZW52aXJvbm1lbnQuDQo+
IEkgZGlkbid0IGdldCB0aGUgY2FzZSB3aGVyZSAiZGV2IiBpcyBhIG51bGwgcG9pbnRlci4NCg0K
ZGV2IGNhbid0IGJlIGEgbnVsbCBwb2ludGVyIHNpbmNlIGJvbmQgZHJpdmVyIGd1YXJhbnRlZXMg
dGhhdA0KYW5kIHRoZXJlIGlzIGEgY2hlY2sgZm9yIHRoZSBjYXNlIHdoZXJlIGl0IGNvdWxkIGJl
IG51bGwgaW4gDQpib25kX3NsYXZlX25ldGRldl9ldmVudC4NCg0KWW91IGNhbiBkcm9wIHRoZSAi
IWRldiIgY2hlY2ssIHNpbmNlIGFsc28gaXQgc2hvdWxkIGJlIHRoZSBjYWxsZXINCnJlc3BvbnNp
YmlsaXR5IGFuZCB3ZSBzaG91bGQgYXZvaWQgY2x1dHRlcmluZyB0aGUgbmV0IGNvcmUgY29kZSB3
aXRoDQpzdWNoIHJlZHVuZGFudCBjaGVja3MuDQoNCj4gTWF5YmUgImlmICghZGV2LT5ldGh0b29s
X29wcykiIGlzIG1vcmUgYWNjdXJhdGUgZm9yIHRoaXMgYnVnLg0KPiANCg0KQWxzbyBpIGFtIG5v
dCBzdXJlIGFib3V0IHRoaXMsIGNvdWxkIGJlIGEgYnVnIGluIHRoZSBkZXZpY2UgZHJpdmVyIHlv
dXINCmVuc2xhdmluZy4NCg0KYWxsb2NfbmV0ZGV2X21xcyB3aWxsIGFzc2lnbiAmZGVmYXVsdF9l
dGh0b29sX29wcyB0byBkZXYtPmV0aHRvb2xfb3BzICwNCmlmIHVzZXIgcHJvdmlkZWQgc2V0dXAg
Y2FsbGJhY2sgZGlkbid0IGFzc2lnbiB0aGUgZHJpdmVyIHNwZWNpZmljDQpldGh0b29sX29wcy4N
Cg0Kc28gdGhlIGRldmljZSBkcml2ZXIgbXVzdCBiZSBkb2luZyBzb21ldGhpbmcgd3JvbmcsIG92
ZXJ3cml0aW5nIGRlZnVsdA0KZXRodG9vbF9vcHMgd2l0aCBhIE5VTEwgcG9pbnRlciBtYXliZSA/
IGFuZCB3aHkgPw0KDQoNCj4gSSBmb3VuZCB0aGlzIGJ1ZyBpbiB2ZXJzaW9uIDMuMTAsIHRoZSBm
dW5jdGlvbiBuYW1lIHdhcw0KPiBfX2V0aHRvb2xfZ2V0X3NldHRpbmdzLg0KPiBBZnRlciAzZjFh
YzdhNzAwZDAgKCJuZXQ6IGV0aHRvb2w6IGFkZCBuZXcgRVRIVE9PTF94TElOS1NFVFRJTkdTDQo+
IEFQSSIpLA0KPiBUaGlzIGZ1bmN0aW9uIGV2b2x2ZWQgaW50byBfX2V0aHRvb2xfZ2V0X2xpbmtf
a3NldHRpbmdzLg0KPiANCg==
