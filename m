Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E2E10E4E4
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 04:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfLBDmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 22:42:20 -0500
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:28130
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727285AbfLBDmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 22:42:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UM5v8aIlRdOLcxmV995p4M+F3B4fSm1b5goA4q7ALO0kl2YIOyvzY80v6EA1reMKgQsSYfjvR831+Hv13KTb92bEQdx0qFeQKqG6TilmUkKWgMTN6xxWr6XQNsZpOGKgpJ+vJy8VZ/zQQLiwmi/lCFo3cTC5F6OfZvNq4IlOdFzCQHPK77AVCsxuACAUoC8/EuOhsCpNAZkQfwGbHPbLIGGFWCmvdQA3HA+JaTyFN+tPNC1T7zHfaEv1eXpiSAzY82o++Mly62xbbaOczhONwrlPxMAsl/RIEcpzpotCtY8C7bcckc4gt9qRCIilRXNV/BB4Naisg0k6wIkSTSep1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Dtx1vSqQEfGMAo5PsuAQSNEBUa9e6+XqpNyQIeSrAA=;
 b=UujogP6I33hhEWHISU1S+kTNZ8iOhPKEFLzkD3YAY7STjc8QnLtMN0OPOSEImOCHD9EOoZkNUIosFgLh77G3h1aE4d6sA4WdnnwyQzhNPXoeQO86Fg7NUSax1R+/MVu9g+rQaenLpNJmz+4mrUn5q8vwTfuo9euwxEdWpd6eLRvwjt6pfuRW4cS0T1r8BhyhAF0DNHd8QtYZhEd90Vq1CG6cNjNvUfYHmMLzYQxP0KSM+IPE/2xoH9PQkhw7A6GSmYt6mOaA10N1xA0qyyN/9a7ySB8XS3yXdvQnbozWW94q8nRMdGu/1eBSGHAJpXabY+MkzLbQtEzSIhT/7gGGYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Dtx1vSqQEfGMAo5PsuAQSNEBUa9e6+XqpNyQIeSrAA=;
 b=EHhytyY79igGJWTbHjffX3Gx3biLU6Vt+9Hf/Se0DAWlVXyVLg4CeQdjt4LWWAF0X7JgInC/LqkLh07013nskucM8TRlsc3NLnEQ9jMHMMbseFhff+oSh4dcRcmpntipO/FBo6dYI4Q0bN7v/JF8DtUUX5lhVbuSqCOrD3M4ZvA=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3533.eurprd04.prod.outlook.com (52.134.5.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Mon, 2 Dec 2019 03:42:13 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 03:42:13 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net,stable 1/1] net: fec: match the dev_id
 between probe and remove
Thread-Topic: [EXT] Re: [PATCH net,stable 1/1] net: fec: match the dev_id
 between probe and remove
Thread-Index: AQHVpn/jrt25MiDjN0mpVyW3r4862qekLDsAgAHkeqCAACCfAIAABVYQ
Date:   Mon, 2 Dec 2019 03:42:13 +0000
Message-ID: <VI1PR0402MB3600C3F9F1DAA24EC6C81B79FF430@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1575009408-30362-1-git-send-email-fugang.duan@nxp.com>
 <20191130.122742.343376576614064539.davem@davemloft.net>
 <VI1PR0402MB3600232AF1CF9203704DCE83FF430@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <f6c05c83-4784-7017-187c-3262a3b45622@gmail.com>
In-Reply-To: <f6c05c83-4784-7017-187c-3262a3b45622@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-Mentions: f.fainelli@gmail.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7c45f67b-e8e3-4dd1-1af4-08d776d99e9f
x-ms-traffictypediagnostic: VI1PR0402MB3533:
x-microsoft-antispam-prvs: <VI1PR0402MB3533359F612C2F58263F0787FF430@VI1PR0402MB3533.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(189003)(199004)(74316002)(76176011)(53546011)(11346002)(6506007)(110136005)(71200400001)(71190400001)(14444005)(256004)(66446008)(76116006)(3846002)(229853002)(8676002)(5660300002)(14454004)(6116002)(99286004)(64756008)(66556008)(66946007)(66476007)(52536014)(9686003)(81166006)(305945005)(8936002)(81156014)(4326008)(7736002)(6246003)(2906002)(55016002)(86362001)(66066001)(6436002)(33656002)(102836004)(478600001)(26005)(186003)(316002)(446003)(7696005)(25786009)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3533;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VaOaSfLh+OZMAiGULc1EJK21X5K9W8OEG6dy6IEoAmW64KYIEawcAeJ5XnV5wwWQ2FFUs/pznN7tGWVGjTAcj8FUID/4BpZhgultyYdXBhACvPdjN6Aiss3IvoQiyfD5LfyTIkIGG2omqLgJzARH7Dl9lVlbMxM78VF8fLE7rtl77dlXBqLe2KlJHoVDRdmyT4iPaFmkPehAL0f11gDvpIXlBEuZt5RFvnQC6OUTI1nCKqikDT7cAOf61RxPaCiFgRsMXNcY/t8wOGd9q9Ab5TnFjmXcV8eiMZ0cePHZqle87MUoVFUUQ9dQJFtOOLo1OWVPE7Oop8KWI3bzT/0VxsMonaixVxhJPa3OfwDnaw3bxZigwRyUkw9wTbgwWnhxSaDb/kqtj1v0dhOAIMr0d/9CA3g+Gqkz/oSyJn6D7uoGrINuAFfSBPfUmRbkb6oA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c45f67b-e8e3-4dd1-1af4-08d776d99e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 03:42:13.5843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OF5R59l+POO54dolAlcV9K1Im6XhAr+lGSsdbMewvV544vxTdJN2X2MubbsLf0SGxy6LwskvQv0pc3wWLc14LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+IFNlbnQ6IE1vbmRh
eSwgRGVjZW1iZXIgMiwgMjAxOSAxMToxOCBBTQ0KPiBPbiAxMi8xLzIwMTkgNzowNCBQTSwgQW5k
eSBEdWFuIHdyb3RlOg0KPiA+IEZyb206IG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPG5l
dGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4gU2VudDogU3VuZGF5LCBEZWNlbWJlciAx
LCAyMDE5IDQ6MjggQU0NCj4gPj4gRnJvbTogQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29t
Pg0KPiA+PiBEYXRlOiBGcmksIDI5IE5vdiAyMDE5IDA2OjQwOjI4ICswMDAwDQo+ID4+DQo+ID4+
PiBUZXN0IGRldmljZSBiaW5kL3VuYmluZCBvbiBpLk1YOFFNIHBsYXRmb3JtOg0KPiA+Pj4gZWNo
byA1YjA0MDAwMC5ldGhlcm5ldCA+IC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvZmVjL3VuYmlu
ZA0KPiA+Pj4gZWNobyA1YjA0MDAwMC5ldGhlcm5ldCA+IC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZl
cnMvZmVjL2JpbmQNCj4gPj4+DQo+ID4+PiBlcnJvciBsb2c6DQo+ID4+PiBwcHMgcHBzMDogbmV3
IFBQUyBzb3VyY2UgcHRwMCAvc3lzL2J1cy9wbGF0Zm9ybS9kcml2ZXJzL2ZlYy9iaW5kDQo+ID4+
PiBmZWM6IHByb2JlIG9mIDViMDQwMDAwLmV0aGVybmV0IGZhaWxlZCB3aXRoIGVycm9yIC0yDQo+
ID4+Pg0KPiA+Pj4gSXQgc2hvdWxkIGRlY3JlYXNlIHRoZSBkZXZfaWQgd2hlbiBkZXZpY2UgaXMg
dW5iaW5kZWQuIFNvIGxldCB0aGUNCj4gPj4+IGZlY19kZXZfaWQgYXMgZ2xvYmFsIHZhcmlhYmxl
IGFuZCBsZXQgdGhlIGNvdW50IG1hdGNoIGluDQo+ID4+PiAucHJvYmUoKSBhbmQgLnJlbXZvZSgp
Lg0KPiA+Pj4NCj4gPj4+IFJlcG9ydGVkLWJ5OiBzaGl2YW5pLnBhdGVsIDxzaGl2YW5pLnBhdGVs
QHZvbGFuc3lzdGVjaC5jb20+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBGdWdhbmcgRHVhbiA8ZnVn
YW5nLmR1YW5AbnhwLmNvbT4NCj4gPj4NCj4gPj4gVGhpcyBpcyBub3QgY29ycmVjdC4NCj4gPj4N
Cj4gPj4gTm90aGluZyBzYXlzIHRoYXQgdGhlcmUgaXMgYSBkaXJlY3QgY29ycmVsYXRpb24gYmV0
d2VlbiB0aGUgZGV2aWNlcw0KPiA+PiBhZGRlZCBhbmQgdGhlIG9uZXMgcmVtb3ZlZCwgbm9yIHRo
ZSBvcmRlciBpbiB3aGljaCB0aGVzZSBvcGVyYXRpb25zDQo+ID4+IG9jY3VyIHJlbGF0aXZlIHRv
IGVhY2hvdGhlci4NCj4gPj4NCj4gPj4gVGhpcyBkZXZfaWQgYWxsb2NhdGlvbiBpcyBidWdneSBi
ZWNhdXNlIHlvdSBhcmVuJ3QgdXNpbmcgYSBwcm9wZXIgSUQNCj4gPj4gYWxsb2NhdGlvbiBzY2hl
bWUgc3VjaCBhcyBJRFIuDQo+ID4gRGF2aWQsIHlvdSBhcmUgY29ycmVjdC4gVGhlcmUgc3RpbGwg
aGFzIGlzc3VlIHRvIHN1cHBvcnQgYmluZC91bmJpbmQNCj4gPiBmZWF0dXJlIGV2ZW4gaWYgdXNl
IElEUiB0byBhbGxvY2F0ZSBJRCBiZWNhdXNlIGVuZXQgaW5zdGFuY2UjMSBkZXBlbmQNCj4gPiBv
biBpbnN0YW5jZSMwIGludGVybmFsIE1ESU8gYnVzIGZvciBzb21lIHBsYXRmb3JtcyBhbmQgd2Ug
ZG9uJ3Qga25vdw0KPiB3aG8gaXMgdGhlIHJlYWwgaW5zdGFuY2UjMCB3aGlsZSBiaW5naW5nIHRo
ZSBkZXZpY2UuDQo+ID4NCj4gPiBEbyB5b3UgaGF2ZSBhbnkgc3VnZ2VzdGlvbiB0byBpbXBsZW1l
bnQgdGhlIGJpbmQvdW5iaW5kIGZlYXR1cmUgd2l0aA0KPiBjdXJyZW50IGRlcGVuZGVuY2U/DQo+
ID4gVGhhbmtzLg0KPiANCj4gQ2FuIHlvdSB1c2UgdGhlIGRldmljZSBkcml2ZXIgbW9kZWwgdG8g
cmVmbGVjdCB0aGUgbGluayBiZXR3ZWVuIHRoZSBNRElPIGJ1cw0KPiBkZXZpY2UsIGl0cyBwYXJl
bnQgRXRoZXJuZXQgY29udHJvbGxlciBhbmQgdGhlIHNlY29uZCBpbnN0YW5jZSBFdGhlcm5ldA0K
PiBjb250cm9sbGVyPyBCZSBpdCB0aHJvdWdoIHRoZSB1c2Ugb2YgZGV2aWNlIGxpbmtzLCBvciBh
biBhY3R1YWwNCj4gZGV2LT5wYXJlbnQgcmVsYXRpb25zaGlwPw0KDQpGb3IgZGV2aWNlIGRlcGVu
ZGVuY2UsIGRldmljZSBsaW5rcyBtYXliZSB0aGUgZ29vZCBzb2x1dGlvbi4NClNpbmNlIHRoZXJl
IGluc3RhbmNlIzEgb25seSBkZXBlbmRzIG9uIGluc3RhbmNlIzAgaW50ZXJuYWwgbWRpbyBidXMs
DQptYXliZSBoaXZlIG9mZiBtZGlvIGJ1cyBkcml2ZXIgZnJvbSBpbnN0YW5jZUAwIGlzIGEgYmV0
dGVyIHNvbHV0aW9uLg0KDQpARmxvcmlhbiBGYWluZWxsaSwgVGhhbmtzIGZvciB5b3VyIHN1Z2dl
c3Rpb24uDQoNCkFuZHkNCj4gLS0NCj4gRmxvcmlhbg0K
