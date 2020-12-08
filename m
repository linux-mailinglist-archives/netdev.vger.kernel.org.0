Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0AD2D2146
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgLHDHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:07:54 -0500
Received: from mail-eopbgr20085.outbound.protection.outlook.com ([40.107.2.85]:45985
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726607AbgLHDHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 22:07:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsSHWG050zUnFWXcgMvNzv9AomO4LE0vq21OvIrw3bovlJ7/ubJQhEL2iuQfKIZHBHBP+r4Q6Iga/0XzqEknIAVjTxepiPhkFadoP2DO+IJEm+F90roUtM4JxMQ3KqMvqe8Cfj3BBO+mRgb+YErZ9FLx/X/p642c1susq+M+fE7CFFx4T0gC/d4j+Sf+3VHmyxFokO/kOaydQA9E30rzT8M0/QUBZKlmszLgfdN8NjR0DVHkAduQj9E3Gr8cUS7Y+3NG158IDpXFExhzlou8NU2aNT2hR1blzzBlgiaBvcH+hCNRTUICYI7W8T9DmzWxjgKVxEAQFEDtf7198UGBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6to9MY6xqw3zsCTmVuKb4F0vmF4jqxRe1DpgXcbjjw0=;
 b=IhxHx4HlWOJ0gDYkVZpoxQnp7jTOV2EAbImlBVRZ41Zu+98a0pNADZcM72tXvmYakjF1Ls9Ex3Cg1vMpOXNhzg4qbRWEroJsyt2GMEr1U7BUy4qKLay+414pxONaZSTHOs/tbrUYxyGrxX3qO46EIcYt6xMnZ+DhlrTRFQqikW70/N5rpdUVV5gzdb9C7Y9PBrTxxqmSp3e7CgXEu9j1RgHHP/CXvmbUv/hz+8wTMVkJg75Rn04XQgEUjlszoOKlhe9wFmEfanH4h5kFp2ATYXcuqtc9MaRivm2dBQ9KGoiRT0zzR/mKmtvYzHVskPRmFd+TR8PFzDbslvhLkfRZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6to9MY6xqw3zsCTmVuKb4F0vmF4jqxRe1DpgXcbjjw0=;
 b=ct68XrkUjMfjPXeo8NZM09awnn5pyNHAuDTlarceQCzeDj2QaPbBW9dbWEYTk1H5iCOi5gGGR4f4Rhj/4hXK26awFuNv5mjvZ0jgjeLawfy+CfZGm1fGqvq30paQbAj9hoa0ICzSE5UyB/QDfjHv3Q7ggSdSm6p/AB3foyj+ENc=
Received: from VE1PR04MB6768.eurprd04.prod.outlook.com (2603:10a6:803:129::26)
 by VI1PR04MB4541.eurprd04.prod.outlook.com (2603:10a6:803:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 03:07:02 +0000
Received: from VE1PR04MB6768.eurprd04.prod.outlook.com
 ([fe80::581:1102:2aee:85a3]) by VE1PR04MB6768.eurprd04.prod.outlook.com
 ([fe80::581:1102:2aee:85a3%5]) with mapi id 15.20.3632.024; Tue, 8 Dec 2020
 03:07:02 +0000
From:   Qiang Zhao <qiang.zhao@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Leo Li <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
Thread-Topic: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
Thread-Index: AQHWyztk1aPl4Ezq8EmmnoJXVMcDbano+wGAgAAE+YCAA4cq0A==
Date:   Tue, 8 Dec 2020 03:07:02 +0000
Message-ID: <VE1PR04MB676805F3EEDF86A8BE370F8691CD0@VE1PR04MB6768.eurprd04.prod.outlook.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
In-Reply-To: <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d6d587e3-cd09-4cb1-8fe7-08d89b2655dd
x-ms-traffictypediagnostic: VI1PR04MB4541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB454113E098A5CD21C3DD34F791CD0@VI1PR04MB4541.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yd/v14aGrzEh7ZsW3cMw9ETjpf2OS/ob0go/dPFLViMCk3AAbJSIIL+S4m8TEGFTLqBJosC842+gVabmT65dNa7VtC5Di18aBQuwKGG649zDqtSxQAIZCwlxhqdtx324pToDvlpwOSnV1T8kNekhGZrHUwSd3X8+xgMc3WHEYV750+A0rnGEzVCY3DtaXB8J1OhMDxHh0KYS1yv47S/vMplfXp8oV9OL1YLl/UtxvQ85vSXO8UEyf/gHb/P6v1eYdfRV/zBHzf0hw98VwNPwLzUpeDJwpkc13xH3eM1Clysx8lQRL6jYmAgGSre4qbLPKDh3Eysbrpop4cfu2j52Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6768.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(4326008)(186003)(6506007)(86362001)(508600001)(55016002)(71200400001)(33656002)(110136005)(66446008)(7696005)(64756008)(9686003)(53546011)(54906003)(8936002)(5660300002)(76116006)(52536014)(26005)(66946007)(83380400001)(2906002)(44832011)(66556008)(8676002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?NkN4dVdlYWVOWUV0QUtPUzRNMG9hWnAxSmFUK084aEFKb2dJZmxmc0JiYWJy?=
 =?gb2312?B?MkRERnhhYXhCemJXc0ZKWkRKbXlTZ2pYNmhJbUVJWnR4RXpURlIwQWpLN3Nn?=
 =?gb2312?B?NXM1d1U0TFNSeVVhb3l0RkRNZVlRVzVRRTFkRHhIUXNKNXdEK2UzZDA5SzVI?=
 =?gb2312?B?TUFsTzd2Ui9jV0ltc1NtQWJJOTNlTVRqVWE3ckJNOU1WVGx0bmNjVHVHZnpp?=
 =?gb2312?B?M3lRUGJ5cHFqeGhzcTJhUXNmalZia3RUZXNleHovNkI0cUFWQTJQbHpORm82?=
 =?gb2312?B?TDBpdGw5djdlRkU0UElBS21WNmVrZXpiVEdLck11UG1tdzBpNnRsblVGSDR1?=
 =?gb2312?B?TEJjdnd3cFBDWkhZMnZ3eGxRMy8vekdmdEdhMlJBUzdhN25EZU1rMVdKRytu?=
 =?gb2312?B?cFZiaVB4SjdzVCtyWXBoK1RTQU1CR3FEZzhOb0g5Tmt0d2cwS1BBNVZOb0Fp?=
 =?gb2312?B?VC9ZVDcreDg1Q3QzeENEdjdQL0Q5VUtiVWM2Y3RYdWFyVjZCTE9qV0hIR3ZC?=
 =?gb2312?B?d2MrM0N1ZWl3S2pZTVRWNkpubnB6eVJKTkQ4SWZ6NEtaRGFyRDRvc3IwbTFG?=
 =?gb2312?B?SlZPSWJHMmJqR0kzVFNXanhVTGxpWFMrcGFXdWVmQVZiTFhnSjUwY2xUZ0lY?=
 =?gb2312?B?eElycllZQjNlNDlCTUc1S3ROdU4vM1ZEbEhjYWZpYXNIeVJRRDNjNFo3TW9O?=
 =?gb2312?B?V25GWWpCenhEQm84cDhORXBleGRCVFVxUWFOdXYvaTI3amNOSTQyQ3k0MkxW?=
 =?gb2312?B?ODJqQld5R2dSUU8rQUcvZWJWNnlJVTNQMDRiNkZxdVhkYkEyK05SWW5YZXZR?=
 =?gb2312?B?eUdrVlNZQm43RUhBYkJCLzZEY0RwM1ZwS2dPSnR4QytpbDBiS0JKU0xBMFg5?=
 =?gb2312?B?SmMvZ3JHL0VDYU55U3psNFdjUDI0bVlHY2czekxFV3YwbTQ1Q0JROVpOQktJ?=
 =?gb2312?B?NDFPR05WTU0xemxCVDBWYm9xSXdaTThVZ05XQTBpTWlJbVBnMFNYVUlNZ01i?=
 =?gb2312?B?MEw2bUkraGxOM2ZuVFphRnVMTDdQcVJFN3JWbUNKSGJEUFUvNXBkYk1NOEU4?=
 =?gb2312?B?eFdQeXBQTnRXcUc1SWtCUlppK2svOFFERnJBSHhxakpacTFiL0czWWxsMTRS?=
 =?gb2312?B?cDFORmZqZSttcG9kRmRvS3JvM2RjMWZUd2FicEJoeUN5dkVxeXRqZmxyQ291?=
 =?gb2312?B?SG83MGtsYWtlTy9ab3B6Y3pHNWgwR3J3RmV6S09wWjJ3TmRSOEhZcVZoYXly?=
 =?gb2312?B?UEpINFRheHBzYi9WTkp5eWJzcVJCWTcvclZSNmo4YWFGcUxLYytrNWg0bitq?=
 =?gb2312?Q?cT73xw4zAhw3c=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6768.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d587e3-cd09-4cb1-8fe7-08d89b2655dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 03:07:02.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZKfFh6QtVTqoPl/gPFUYuqTz7+pyHyQx2NrwGEfXY/4XLtZVSGxmNGPMRzcXaudnNSqwByQEqP3HK56JNawTBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4541
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYvMTIvMjAyMCAwNToxMiwgUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0Bw
cmV2YXMuZGs+IHdyb3RlOg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJv
bTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+DQo+IFNlbnQ6
IDIwMjDE6jEy1MI2yNUgNToxMg0KPiBUbzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4NCj4gQ2M6IExlbyBMaSA8bGVveWFuZy5saUBueHAuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gUWlhbmcgWmhhbyA8cWlhbmcuemhhb0BueHAuY29tPjsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZzsgVmxhZGltaXIgT2x0ZWFuDQo+IDx2bGFkaW1pci5vbHRlYW5AbnhwLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwMC8yMF0gZXRoZXJuZXQ6IHVjY19nZXRoOiBhc3Nv
cnRlZCBmaXhlcyBhbmQNCj4gc2ltcGxpZmljYXRpb25zDQo+IA0KPiBPbiAwNS8xMi8yMDIwIDIx
LjUzLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiBPbiBTYXQsICA1IERlYyAyMDIwIDIwOjE3
OjIzICswMTAwIFJhc211cyBWaWxsZW1vZXMgd3JvdGU6DQo+ID4+IFdoaWxlIHRyeWluZyB0byBm
aWd1cmUgb3V0IGhvdyB0byBhbGxvdyBidW1waW5nIHRoZSBNVFUgd2l0aCB0aGUNCj4gPj4gdWNj
X2dldGggZHJpdmVyLCBJIGZlbGwgaW50byBhIHJhYmJpdCBob2xlIGFuZCBzdHVtYmxlZCBvbiBh
IHdob2xlDQo+ID4+IGJ1bmNoIG9mIGlzc3VlcyBvZiB2YXJ5aW5nIGltcG9ydGFuY2UgLSBzb21l
IGFyZSBvdXRyaWdodCBidWcgZml4ZXMsDQo+ID4+IHdoaWxlIG1vc3QgYXJlIGEgbWF0dGVyIG9m
IHNpbXBsaWZ5aW5nIHRoZSBjb2RlIHRvIG1ha2UgaXQgbW9yZQ0KPiA+PiBhY2Nlc3NpYmxlLg0K
PiA+Pg0KPiA+PiBBdCB0aGUgZW5kIG9mIGRpZ2dpbmcgYXJvdW5kIHRoZSBjb2RlIGFuZCBkYXRh
IHNoZWV0IHRvIGZpZ3VyZSBvdXQNCj4gPj4gaG93IGl0IGFsbCB3b3JrcywgSSB0aGluayB0aGUg
TVRVIGlzc3VlIG1pZ2h0IGJlIGZpeGVkIGJ5IGENCj4gPj4gb25lLWxpbmVyLCBidXQgSSdtIG5v
dCBzdXJlIGl0IGNhbiBiZSB0aGF0IHNpbXBsZS4gSXQgZG9lcyBzZWVtIHRvDQo+ID4+IHdvcmsg
KHBpbmcgLXMgWCB3b3JrcyBmb3IgbGFyZ2VyIHZhbHVlcyBvZiBYLCBhbmQgd2lyZXNoYXJrIGNv
bmZpcm1zDQo+ID4+IHRoYXQgdGhlIHBhY2tldHMgYXJlIG5vdCBmcmFnbWVudGVkKS4NCj4gPj4N
Cj4gPj4gUmUgcGF0Y2ggMiwgc29tZW9uZSBpbiBOWFAgc2hvdWxkIGNoZWNrIGhvdyB0aGUgaGFy
ZHdhcmUgYWN0dWFsbHkNCj4gPj4gd29ya3MgYW5kIG1ha2UgYW4gdXBkYXRlZCByZWZlcmVuY2Ug
bWFudWFsIGF2YWlsYWJsZS4NCj4gPg0KPiA+IExvb2tzIGxpa2UgYSBuaWNlIGNsZWFuIHVwIG9u
IGEgcXVpY2sgbG9vay4NCj4gPg0KPiA+IFBsZWFzZSBzZXBhcmF0ZSBwYXRjaGVzIDEgYW5kIDEx
ICh3aGljaCBhcmUgdGhlIHR3byBidWcgZml4ZXMgSSBzZWUpDQo+IA0KPiBJIHRoaW5rIHBhdGNo
IDIgaXMgYSBidWcgZml4IGFzIHdlbGwsIGJ1dCBJJ2QgbGlrZSBzb21lb25lIGZyb20gTlhQIHRv
IGNvbW1lbnQuDQoNCkl0ICdzIG9rIGZvciBtZS4NCg0KDQpCZXN0IFJlZ2FyZHMsDQpRaWFuZyBa
aGFvDQo=
