Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8E915CF9D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 02:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgBNBzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 20:55:14 -0500
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:54246
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728335AbgBNBzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 20:55:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhmUQCmNu7ohQ8u3XdeRpTPSofknxFw2IitStIqa/37Vdy0vDW7rzVlkjFKKuMOXoTCgAchkBPvXs7oPOqqiFHIF0KINGMh6ipj6CGsuFFcCmxKaHuX2rDw4PW0oPN1CNgUlZmOC5/vTz7clxo/UUvQEOaB05UkG7njPMe5HgwkDuDxCGEAI8CJULqgddeDFCozWTfEAyk4dX8act5a0jgjXB6BBMh1o5Jwg/yv2wFFRJ/3WtiAq2q09z/1rlqCOZX31g9aLrBywRc8qMgsbWDXXqc+mmXvSQYJH4m2adex/Jiv1uRr5qkOug1ib4Yx9ypxxeBZkhIC1rke+PIf+bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rov56aQLZmUgRiNMewgKtpN6b2rafI2P1vIQJITu5wU=;
 b=gjqkJ7o0abZyhdlRfN81GcFklwoy2ztUSJ1mvS84K4T0QQPAm3KDqcd5UOZTkCiz8TeXMf11oTiyWoPsSl1v5/k3rBzwrXA2a1Phj0WAZWLYv6/r1VLzhniUwsG+vesk5o9d/1H2V7GUCOtzcig1wDlEa0Ss8WwcgfKFbP+9VJDVf0rz/AqO2Blry6DH686q+w5TL7LTTVaDLUNsAo6ZT654PH6e7Ctm/6c6QZsxfdoEIuMHP3oiIg/V9UVGAvnMSOGrEp1P6+YWxoS9IVp//ZEENvfyWq6q+ICE8TMrpW8HgxVBZw7DjbqSifTDbCpBUmrR9nP6FnaTW5JlBvaLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rov56aQLZmUgRiNMewgKtpN6b2rafI2P1vIQJITu5wU=;
 b=dogiLyDuYrUGmbeGnS13ywocWEAEGO7cSRCkj++kWd82/nIIrk/Wod5qB21icn64gtH8NNZzQOsePXGXpUU3odCmpblEERVNS3pQ1w1Xbf4N0Wfob1yHJMn5bsuyzLPBXYQna6sCOVEAJ9RVdr0Z1kZYp/Wm09B4YVfQck81vmY=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4153.eurprd04.prod.outlook.com (52.134.111.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 14 Feb 2020 01:55:09 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 01:55:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>
Subject: RE: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Topic: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Index: AQHVOIgqonFULiHPO0eSKFSJ3ULGeqbbAsWQgAAINwCAAC3BgIE/m36AgABmuxA=
Date:   Fri, 14 Feb 2020 01:55:08 +0000
Message-ID: <DB7PR04MB461896B6CC3EDC7009BCD741E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
 <20200213192027.4813-1-michael@walle.cc>
In-Reply-To: <20200213192027.4813-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [222.93.234.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5641ccd2-bb16-4297-d2d3-08d7b0f0ebc0
x-ms-traffictypediagnostic: DB7PR04MB4153:|DB7PR04MB4153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4153FFD478D0A12FE7E871A5E6150@DB7PR04MB4153.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(199004)(189003)(81156014)(186003)(54906003)(7696005)(66446008)(8676002)(26005)(110136005)(8936002)(6506007)(64756008)(76116006)(66556008)(66476007)(2906002)(45080400002)(81166006)(5660300002)(53546011)(316002)(71200400001)(66946007)(86362001)(4326008)(52536014)(55016002)(478600001)(33656002)(9686003)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4153;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IaTbPDiobdX97eeAiXHSpSvPhHP/JYt6Ijzl92kds5j6MAeI/Z5RPlVIlYkPp5gmvMf6odmO9prspy3E78bQgWEQgaFsmIzGseJYuW72AEendfRNOunVAPIts8SLCQhJnxkV4Jhy0350Jenq3ZeNVOxaqmkuVH03YR5MDxLZiJmbAzSUGkbiTggKzGtV4vmwq//3VPQWJdxOysRGFyELkQuip/bQkQy504paSY73wWjs3Dpw37BqUWPNDz3z3SE9zSIYxVoLYY5dwvss76fnJF/Kcz46jdQ4G/roET9/cvksanwBXORi016BkLGtTokN/18R22GuSylzCTAsCUHTfce6CTSjPpOtJALG7yq0eHS0+3aK6fBiOywzobZYKQnamKAQ+c+gWA+rhwmdzyiDPWNPoJ1GwHtUQTw3JTWlmSA6yzq+gemDleEqCTGJEb+JXvw+QFFMo8rTCXXxwUAIElPUsTDim9Uk7jsqSDOxLCZX9DrvAkRcr96BtSSS9JuVPghjcaYDhmEWYRrgJqBPTA==
x-ms-exchange-antispam-messagedata: 1+ExnZPGJDv0aMvx+tWM+QQvteK61q89CanJBG5RngVKq0GMD/ts70g/4Nlzp4G7+Ndmvu9ufcyfg+xTjBjIFbz9yv076YuZ8Jxb59pbTkrS0kgHJnDnw+MzTcrpaPjt2YLesC0WwcEAJVxkTxY6IQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5641ccd2-bb16-4297-d2d3-08d7b0f0ebc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 01:55:08.9027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rThqpCst0MHuYkba2+qy/KYipfV+AUTDCo7/j0CuNx2bJrvGV4RqwUZXN6hAuPU/cL8qpAkO/kKuYbLeC76Tww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNaWNoYWwsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWlj
aGFlbCBXYWxsZSA8bWljaGFlbEB3YWxsZS5jYz4NCj4gU2VudDogMjAyMMTqMtTCMTTI1SAzOjIw
DQo+IFRvOiBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBDYzogSm9h
a2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IHdnQGdyYW5kZWdnZXIuY29tOw0K
PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBQYW5r
YWogQmFuc2FsDQo+IDxwYW5rYWouYmFuc2FsQG54cC5jb20+OyBNaWNoYWVsIFdhbGxlIDxtaWNo
YWVsQHdhbGxlLmNjPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvOF0gY2FuOiBmbGV4Y2FuOiBh
ZGQgQ0FOIEZEIHN1cHBvcnQgZm9yIE5YUCBGbGV4Y2FuDQo+IA0KPiBIaSwNCj4gDQo+ID4+PiBB
cmUgeW91IHByZXBhcmVkIHRvIGFkZCBiYWNrIHRoZXNlIHBhdGNoZXMgYXMgdGhleSBhcmUgbmVj
ZXNzYXJ5IGZvcg0KPiA+Pj4gRmxleGNhbiBDQU4gRkQ/IEFuZCB0aGlzIEZsZXhjYW4gQ0FOIEZE
IHBhdGNoIHNldCBpcyBiYXNlZCBvbiB0aGVzZQ0KPiA+Pj4gcGF0Y2hlcy4NCj4gPj4NCj4gPj4g
WWVzLCB0aGVzZSBwYXRjaGVzIHdpbGwgYmUgYWRkZWQgYmFjay4NCj4gPg0KPiA+SSd2ZSBjbGVh
bmVkIHVwIHRoZSBmaXJzdCBwYXRjaCBhIGJpdCwgYW5kIHB1c2hlZCBldmVyeXRoaW5nIHRvIHRo
ZQ0KPiA+dGVzdGluZyBicmFuY2guIENhbiB5b3UgZ2l2ZSBpdCBhIHRlc3QuDQo+IA0KPiBXaGF0
IGhhcHBlbmQgdG8gdGhhdCBicmFuY2g/IEZXSVcgSSd2ZSBqdXN0IHRyaWVkIHRoZSBwYXRjaGVz
IG9uIGEgY3VzdG9tDQo+IGJvYXJkIHdpdGggYSBMUzEwMjhBIFNvQy4gQm90aCBDQU4gYW5kIENB
Ti1GRCBhcmUgd29ya2luZy4gSSd2ZSB0ZXN0ZWQNCj4gYWdhaW5zdCBhIFBlYWt0ZWNoIFVTQiBD
QU4gYWRhcHRlci4gSSdkIGxvdmUgdG8gc2VlIHRoZXNlIHBhdGNoZXMgdXBzdHJlYW0sDQo+IGJl
Y2F1c2Ugb3VyIGJvYXJkIGFsc28gb2ZmZXJzIENBTiBhbmQgYmFzaWMgc3VwcG9ydCBmb3IgaXQg
anVzdCBtYWRlIGl0DQo+IHVwc3RyZWFtIFsxXS4NClRoZSBGbGV4Q0FOIENBTiBGRCByZWxhdGVk
IHBhdGNoZXMgaGF2ZSBzdGF5ZWQgaW4gbGludXgtY2FuLW5leHQvZmxleGNhbiBicmFuY2ggZm9y
IGEgbG9uZyB0aW1lLCBJIHN0aWxsIGRvbid0IGtub3cgd2h5IE1hcmMgZG9lc24ndCBtZXJnZSB0
aGVtIGludG8gTGludXggbWFpbmxpbmUuDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9ta2wvbGludXgtY2FuLW5leHQuZ2l0L3RyZWUvP2g9ZmxleGNhbg0K
QWxzbyBtdXN0IGhvcGUgdGhhdCB0aGlzIHBhdGNoIHNldCBjYW4gYmUgdXBzdHJlYW1lZCBzb29u
LiA6LSkNCg0KPiBJZiB0aGVzZSBwYXRjaGVzIGFyZSB1cHN0cmVhbSwgb25seSB0aGUgZGV2aWNl
IHRyZWUgbm9kZXMgc2VlbXMgdG8gYmUgbWlzc2luZy4NCj4gSSBkb24ndCBrbm93IHdoYXQgaGFz
IGhhcHBlbmVkIHRvIFsyXS4gQnV0IHRoZSBwYXRjaCBkb2Vzbid0IHNlZW0gdG8gYmUNCj4gbmVj
ZXNzYXJ5Lg0KWWVzLCB0aGlzIHBhdGNoIGlzIHVubmVjZXNzYXJ5LiBJIGhhdmUgTkFDS2VkIHRo
aXMgcGF0Y2ggZm9yIHRoYXQsIGFjY29yZGluZyB0byBGbGV4Q0FOIEludGVncmF0ZWQgR3VpZGUs
IENUUkwxW0NMS1NSQ109MCBzZWxlY3Qgb3NjaWxsYXRvciBjbG9jayBhbmQgQ1RSTDFbQ0xLU1JD
XT0xIHNlbGVjdCBwZXJpcGhlcmFsIGNsb2NrLg0KQnV0IGl0IGlzIGFjdHVhbGx5IGRlY2lkZWQg
YnkgU29DIGludGVncmF0aW9uLCBmb3IgaS5NWCwgdGhlIGRlc2lnbiBpcyBkaWZmZXJlbnQuDQpJ
IGhhdmUgbm90IHVwc3RyZWFtIGkuTVggRmxleENBTiBkZXZpY2UgdHJlZSBub2Rlcywgc2luY2Ug
aXQncyBkZXBlbmRlbmN5IGhhdmUgbm90IHVwc3RyZWFtZWQgeWV0Lg0KDQo+IFBhbmthaiBhbHJl
YWR5IHNlbmQgYSBwYXRjaCB0byBhZGQgdGhlIGRldmljZSBub2RlIHRvIHRoZSBMUzEwMjhBIFsz
XS4NCj4gVGhhdHMgYmFzaWNhbGx5IHRoZSBzYW1lIEkndmUgdXNlZCwgb25seSB0aGF0IG1pbmUg
ZGlkbid0IGhhZCB0aGUNCj4gImZzbCxsczEwMjhhcjEtZmxleGNhbiIgY29tcGF0aWJsaXR5IHN0
cmluZywgYnV0IG9ubHkgdGhlICJseDIxNjBhcjEtZmxleGNhbiINCj4gd2hpY2ggaXMgdGhlIGNv
cnJlY3Qgd2F5IHRvIHVzZSBpdCwgcmlnaHQ/DQpZb3UgY2FuIHNlZSBiZWxvdyB0YWJsZSBmcm9t
IEZsZXhDQU4gZHJpdmVyLCAiZnNsLGx4MjE2MGFyMS1mbGV4Y2FuIiBzdXBwb3J0cyBDQU4gRkQs
IHlvdSBjYW4gdXNlIHRoaXMgY29tcGF0aWJsZSBzdHJpbmcuDQpzdGF0aWMgY29uc3Qgc3RydWN0
IG9mX2RldmljZV9pZCBmbGV4Y2FuX29mX21hdGNoW10gPSB7DQoJeyAuY29tcGF0aWJsZSA9ICJm
c2wsaW14OHFtLWZsZXhjYW4iLCAuZGF0YSA9ICZmc2xfaW14OHFtX2RldnR5cGVfZGF0YSwgfSwN
Cgl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg2cS1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lteDZx
X2RldnR5cGVfZGF0YSwgfSwNCgl7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyOC1mbGV4Y2FuIiwg
LmRhdGEgPSAmZnNsX2lteDI4X2RldnR5cGVfZGF0YSwgfSwNCgl7IC5jb21wYXRpYmxlID0gImZz
bCxpbXg1My1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lteDI1X2RldnR5cGVfZGF0YSwgfSwNCgl7
IC5jb21wYXRpYmxlID0gImZzbCxpbXgzNS1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lteDI1X2Rl
dnR5cGVfZGF0YSwgfSwNCgl7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyNS1mbGV4Y2FuIiwgLmRh
dGEgPSAmZnNsX2lteDI1X2RldnR5cGVfZGF0YSwgfSwNCgl7IC5jb21wYXRpYmxlID0gImZzbCxw
MTAxMC1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX3AxMDEwX2RldnR5cGVfZGF0YSwgfSwNCgl7IC5j
b21wYXRpYmxlID0gImZzbCx2ZjYxMC1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX3ZmNjEwX2RldnR5
cGVfZGF0YSwgfSwNCgl7IC5jb21wYXRpYmxlID0gImZzbCxsczEwMjFhcjItZmxleGNhbiIsIC5k
YXRhID0gJmZzbF9sczEwMjFhX3IyX2RldnR5cGVfZGF0YSwgfSwNCgl7IC5jb21wYXRpYmxlID0g
ImZzbCxseDIxNjBhcjEtZmxleGNhbiIsIC5kYXRhID0gJmZzbF9seDIxNjBhX3IxX2RldnR5cGVf
ZGF0YSwgfSwNCgl7IC8qIHNlbnRpbmVsICovIH0sDQp9Ow0KDQo+IFNvcnJ5IGZvciBwdXR0aW5n
IHRoaXMgYWxsIGluIG9uZSBtYWlsLCBidXQgSSd2ZSBqdXN0IHN1YnNjcmliZWQgdG8gbGludXgt
Y2FuIGFuZA0KPiB0aGVyZSBpcyBubyBtZXNzYWdlIGFyY2hpdmUgb24gbG9yZS5rZXJuZWwub3Jn
IGZvciBpdCA6Lw0KPiANCj4gWzFdDQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rp
b24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmxvcmUua2VyDQo+IG5lbC5vcmclMkZs
a21sJTJGMjAyMDAyMTIwNzM2MTcuR0ExMTA5NiU0MGRyYWdvbiUyRiZhbXA7ZGF0YT0wMiUNCj4g
N0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5jb20lN0NkMjc4ZmRjMDI3YTU0YmM5ZjU3YjA4
ZDdiMGI5ZDINCj4gZWYlN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0Mw
JTdDNjM3MTcyMTg0NDczNDY2DQo+IDE4OCZhbXA7c2RhdGE9ZmJJT3JJRzRQaEw1ZjRTYzdQOXNU
RnclMkZvTm9pbnolMkZkNTZUeUxqbkhkbjglM0QmDQo+IGFtcDtyZXNlcnZlZD0wDQo+IFsyXQ0K
PiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0
cHMlM0ElMkYlMkZ3d3cuc3ANCj4gaW5pY3MubmV0JTJGbGlzdHMlMkZsaW51eC1jYW4lMkZtc2cw
MTU4NC5odG1sJmFtcDtkYXRhPTAyJTdDMDElN0NxaWENCj4gbmdxaW5nLnpoYW5nJTQwbnhwLmNv
bSU3Q2QyNzhmZGMwMjdhNTRiYzlmNTdiMDhkN2IwYjlkMmVmJTdDNjg2ZWENCj4gMWQzYmMyYjRj
NmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzcxNzIxODQ0NzM0NjYxODgmYW1wO3NkDQo+
IGF0YT1CWENJY0V6TlhOMXJoNSUyRkxLalI4Y2lNM2daJTJGZGtsMyUyQkRBb2hoZmdnMVBRJTNE
JmFtcDtyZQ0KPiBzZXJ2ZWQ9MA0KPiBbM10NCj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJv
dGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGd3d3LnNwDQo+IGluaWNzLm5l
dCUyRmxpc3RzJTJGbGludXgtY2FuJTJGbXNnMDE1NzcuaHRtbCZhbXA7ZGF0YT0wMiU3QzAxJTdD
cWlhDQo+IG5ncWluZy56aGFuZyU0MG54cC5jb20lN0NkMjc4ZmRjMDI3YTU0YmM5ZjU3YjA4ZDdi
MGI5ZDJlZiU3QzY4NmVhDQo+IDFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdD
NjM3MTcyMTg0NDczNDY2MTg4JmFtcDtzZA0KPiBhdGE9OU82Vmc2OWUlMkZOYlIybjFGJTJCS0tL
aUVxR21ZUEhPNHFMQ1RFdUNRaFJTNFUlM0QmYW1wO3INCj4gZXNlcnZlZD0wDQo+IA0KPiAtbWlj
aGFlbA0K
