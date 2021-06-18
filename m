Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430A73ACF85
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhFRP5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:57:19 -0400
Received: from mail-am6eur05on2121.outbound.protection.outlook.com ([40.107.22.121]:60768
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233880AbhFRP5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 11:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhXFhapIM7jnW1fF7XEgSVxrvIuNaEgWa/sZCNVRbpOvK6b3cPnttSzOVHi7qKtQXQX1LuUAUs2tEv52uSycoUNkzeOnv9cxqlxc8p9BasLepa4JmlDl8qiB49NopfUBq4iiWya+vCeFEyHCTLNsfm8UwtPaNzEzypTzoHC3a4zqJYRSKevDcGAdcKnWeZp6Oqd7k9YxaKIoY5hL38tf/SepsL/SlAPM9fkgGJKG9Zn8OARYpqAN/RI0yj4wBuxqN4uAtXa0yfGjA0Cpiy4I5kpLYbn2CcqN7I0/UoicPt63kpklBERhnP/Ky+xChxr/UVl00WrL/EqfbjmOcpyXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8Ka/0EGeRkeJhv3oIJA2qDAVhuUETLGrn4gUC/KU84=;
 b=I+dOz8NxvFAkz6i0jQSNJ6ZvSszEGJbVbZ56te09KzykSLl2vgb/DZpgYmIvDGyGxBjb2bOqOYMfDilVqeCTojR+dK7HU7NKEDsWmuOpbyiyBUbf6rogHDO7EH2jgYSvt760IzRJqWIvQG7GJbqfnCUtoHPYbrPgsILsCv2CCDYvpelDrnR2Dg8dy2gnUilYOD88XelZFzmIUGTjdc7qeZNrF5kPMGCkNHrtrBInh6kSY9yhR1xLETfYpxiP/5IfS5WAVW3P2WOFI660u1tMxip4ohT68WqkTcPCyPt36clcf++VviBVZWu2Bwwrhwar351B7rsupnLO93fv1W4SPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8Ka/0EGeRkeJhv3oIJA2qDAVhuUETLGrn4gUC/KU84=;
 b=QfmliiZFR+UM3Fs+G7CxAKuHc0beZ6tXuqImRqUAa+0b/FFBmjHOedlt1Za0Ho4ubjzdBjIPIzO1RihiGkBsZtNTJP8jXmBJi0kaL4NAoMdX5hSkqlIQbTGbh6MvLRyU7xO68NfH24TacOBDFDOe7FwwPLCA9EvW4N51Wy/Nyd8=
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com (2603:10a6:20b:287::7)
 by AM0PR03MB4673.eurprd03.prod.outlook.com (2603:10a6:208:c1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Fri, 18 Jun
 2021 15:55:04 +0000
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::c4c0:ee3a:ce51:d987]) by AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::c4c0:ee3a:ce51:d987%9]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 15:55:04 +0000
From:   =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <Stefan.Maetje@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "thomas.kopp@microchip.com" <thomas.kopp@microchip.com>
Subject: Re: CAN-FD Transmitter Delay Compensation (TDC) on mcp2518fd
Thread-Topic: CAN-FD Transmitter Delay Compensation (TDC) on mcp2518fd
Thread-Index: AQHXZD+/nQ0t8qi7EkO6mYlVLyUTP6sZ074AgAAYXIA=
Date:   Fri, 18 Jun 2021 15:55:04 +0000
Message-ID: <e90cbad2467e2ef42db1e4a14ecdfd8c512965ea.camel@esd.eu>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
         <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
         <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
         <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
         <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com>
         <20210618124447.47cy7hyqp53d4tjh@pengutronix.de>
         <CAMZ6RqJCZB6Q79JYfxD7PGboPwMndDQRKsuUEk5Q34fj2vOcYg@mail.gmail.com>
In-Reply-To: <CAMZ6RqJCZB6Q79JYfxD7PGboPwMndDQRKsuUEk5Q34fj2vOcYg@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1 
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=esd.eu;
x-originating-ip: [2003:eb:9f14:1c01:fc7b:2448:5d72:e520]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb948677-7b43-4d5b-dee1-08d932717007
x-ms-traffictypediagnostic: AM0PR03MB4673:
x-microsoft-antispam-prvs: <AM0PR03MB4673F333F959C0EB85497B94810D9@AM0PR03MB4673.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TZOLdLnWjoGTVmeRYYJShDqhKCMEb3Ug/LJ31+piHlou84gi/ahq205F//LDzcEnArYNqKIG0Uufh/uoJl6U2oonDckCx+2S1yX/dDXISCUDzX1eDNIteBcC+KLE/BrVCQz71U99ei5+dnZx6jvEVoWOcp2qIiDv6ayXvbY/4fDrVvaxuZY1ioD8PsxHwY2U4ED+U0TBeDOIHCx8uPGkoQz9Z7llitPiRx6MaYXot0BmTNJcNIYLeAjPR2+TFMVbD5dha2XbxR1oyYXhvOsUmRf9K97ccBpstOlstZ6lZ18xopKKMcw0dfJQvViWD/acz+8+E3IeLi7YSsu2ZPumGPnf0X+vDPI2np4BdS6SOq0ORrku72x0yEwzwL2SAeCd6HTA/P3c8weEoKeMRcE/wfGBOSAOcsyMfu0XEn/5tQpOp8aKEyEO7Gpdm/7+ljc2CvZHB3Z+8o6Kd9LDS34a8LWblTsjNMZ9v75TOW4XG02bg6LcKAdD83Vo5GH7ImkNdXLMGq7CyGyXQG41vZzjV/zgDXZbEqFPxw8AFzcWPaVQfl3MxPM/GLQkae81m66FB9VZuOCm3LveqZ609gjMBdb26BfKqa3798jnwJrJS9QEIFvFXRF8ajeM2bs311f0vrPhrsWOUsyokKfJDuTT75FZd9mTV/KWv1HlYdVG8kOIsslu5NRhLLbwgjYlZqTKlDEHqWx2w2hT+eEDCKfGwZAk7PsNrLhuhVWXoiIU/94=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR03MB6929.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39830400003)(136003)(54906003)(6486002)(91956017)(110136005)(85182001)(478600001)(76116006)(64756008)(83380400001)(66556008)(122000001)(316002)(66446008)(86362001)(53546011)(966005)(36756003)(66946007)(66476007)(4326008)(186003)(6506007)(6512007)(2616005)(8936002)(8676002)(2906002)(5660300002)(71200400001)(85202003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVFiYmNhZHB6Y1F1V2VkZUVHdEkwdTZBUWZNeHIzaHF4SjIrYWdKZ2VEb01C?=
 =?utf-8?B?NFhsK2pBUGtLTHBhZk9WV2VXRzdKNmoyWVh0a0tVL3Zod1VrdkYwZDdUamow?=
 =?utf-8?B?MkJzMnpBYWxlcUtpcEJuTnlJNHgzR1hFK0NnbUpLaEZOeUtseUNXMm1idkdS?=
 =?utf-8?B?OW8xZ1lFREF4ZHNMMHhnOHhlVXhoekdrODUwQVM4U0RtUE16Z1BBWk1pNWNl?=
 =?utf-8?B?OWFyYmZrMkplenRuR0NmNlhLNnMyQ2ZKZFBvcXE1MWVBeTNRV3hwWmNZTW1U?=
 =?utf-8?B?Qmw2bnZpdlFLdzVzdnEyYUg2UGdkZDUwM05lOWtwMVl5WXp2VDZ1NkFqWTRK?=
 =?utf-8?B?MHhEVVphRmpYY3FiUEVUV09URnRyRFhzYWxId0tNQWhrU3dXTDdpTFpjcTlG?=
 =?utf-8?B?bk85YkRWS0xpZXp0Um5VUHlncE9lQ3VLeUtVNEcvZElYU2VIdHFiQjJtaXcw?=
 =?utf-8?B?SFFtSjVCYXY5RkVvbGRsaWhQZ2I3UGttbWJBeHV2WmE1Z1NpbDVQTVU5bUc1?=
 =?utf-8?B?Qnh5b0YreDI4RE9PTnhZOTkxY1FwRHcxem1JYWg2UTRlVlhlVm5QbjdnZURu?=
 =?utf-8?B?Qzc5RWJ6ekpJdGdHQVhYUVlDTkVDQU5EbWlqOGRMSHpDdlJnZmk0UmwzZFlm?=
 =?utf-8?B?b2RFcUVjYXBsaWhycDBHbDdBSGtvL21EUGZseGdSVFFSK0t2NzRYaytsVjNH?=
 =?utf-8?B?V2hwYUxUWFdRKzhEUXNRRDdUcEpVNzhrQmg3Mmw0NzZyTUxBMVY4d295Lysw?=
 =?utf-8?B?RDBVRFlBb09pb2kyK01wYnFZUHpOc3IvYlpsWWZoeVVUZG1GdWdZSE9rUFBu?=
 =?utf-8?B?OE9mMUV0YXlDcktjY2tDYWc1cmlFS0JUQTlrVnhmSWJVbWh4M1prdmkxbEY4?=
 =?utf-8?B?V3RHZ2NuVE1DU2wwSTNUNElvRk5SQjFtdTBLaUF6Z1FoTkpld0hNZ3JJaXRW?=
 =?utf-8?B?eG9MRS9rdDkxMXBNSEhXTzNtSTdDa2FjTzdrYW1VamsrbE0xT3ZRVzhkd0Fs?=
 =?utf-8?B?U2VaWjNiSCtrMy9ZU0pYRW1wRTRnM1Y0ZitzNFJScjhOL2dId0todkhwMnly?=
 =?utf-8?B?eEVJdFExQjA1Y01BRUloeFp1TXZBa3hsdW15ejJZT0QyN2NVN3NRM0NvT3pE?=
 =?utf-8?B?dWZwc0lRWVFGMXdXRUxMNll0ME5wM1FEQU9jbU5SY2xxczZ2aUdtTUx1SlUy?=
 =?utf-8?B?VUNZbzU0dkZpRTFEYW9PS2ZpUkxFckdjMmlKN290Y1ZJSk81QmlNY0hHQmhY?=
 =?utf-8?B?THRDUVJ3b0U5aHdTUWhCaWE4REpOTEhxK0JEK3NpbU1XMlVWWDBDaXIrVlhU?=
 =?utf-8?B?cWh6enVBb1phdHFESHFubEhxMUxnNEYzbW9rdlUycU9acUpFN0t1MXZZSzZL?=
 =?utf-8?B?eXB0WWl4U09uQ1ZHUEFKN0FhRi9vVG5KWURFNi9YNVRwQkhWeC9yYkxvZ2JR?=
 =?utf-8?B?cXRpMCs3akxKdlh4Vno5bHZFS0hqTjJSQUpNaWVVWk92T2sxRGpuUStLYi92?=
 =?utf-8?B?eDZ2ODkxQzVxVUNYdUZTOG5aSVNOa2xRckpDYUpRL1BqT2ZsSGdPTWttaytX?=
 =?utf-8?B?OTNCZTNFOWdnektuK3VTRkpDbURWSy8wblZWTmQyc2hjNUVwVWFDeXRzWDVi?=
 =?utf-8?B?UFYxNi85Q2FLNWJ2enVaV1dOY2Y0aEVZcEt4ZlA2YTBkaXZYbzA3NjdVZ3RP?=
 =?utf-8?B?djMvSjNCQ2dDNFdVWXMxRW1HdWliZ0VkbTYrdSt6MitOYm9XL2ozSndra1lU?=
 =?utf-8?B?WXFDNjdOL2YzVVdqaFBoNlY3TEN4R24rNmQzVzVFZ3NtNmxYSGdKSXJOenZv?=
 =?utf-8?B?cEk4cEhOc0c0NFdMc0REZTZFYjIwTHZrV1VZdnlUVk5VZFdYN1psWFVCVHAz?=
 =?utf-8?Q?U42Nqi3xzpiMb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E12CD710F7C1A64286DEBB9A5A3DCFE2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR03MB6929.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb948677-7b43-4d5b-dee1-08d932717007
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2021 15:55:04.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dq2nC/7oevLFTPwJkEiPlzrpDgN2PtAZJyGTgrvxq73L4DpqhySyuSIxOd7MblRrN4xCQLx/uQrv3+ZgHvO14w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4673
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW0gRnJlaXRhZywgZGVuIDE4LjA2LjIwMjEsIDIzOjI3ICswOTAwIHNjaHJpZWIgVmluY2VudCBN
QUlMSE9MOg0KPiBPbiBGcmkuIDE4IEp1biAyMDIxIGF0IDIxOjQ0LCBNYXJjIEtsZWluZS1CdWRk
ZSA8bWtsQHBlbmd1dHJvbml4LmRlPiB3cm90ZToNCj4gPiBPbiAxOC4wNi4yMDIxIDIwOjE3OjUx
LCBWaW5jZW50IE1BSUxIT0wgd3JvdGU6DQo+ID4gPiA+ID4gSSBqdXN0IG5vdGljZWQgaW4gdGhl
IG1jcDI1MThmZCBkYXRhIHNoZWV0Og0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gYml0IDE0LTgg
VERDT1s2OjBdOiBUcmFuc21pdHRlciBEZWxheSBDb21wZW5zYXRpb24gT2Zmc2V0IGJpdHM7DQo+
ID4gPiA+ID4gPiBTZWNvbmRhcnkgU2FtcGxlIFBvaW50IChTU1ApIFR3b+KAmXMgY29tcGxlbWVu
dDsgb2Zmc2V0IGNhbiBiZQ0KPiA+ID4gPiA+ID4gcG9zaXRpdmUsDQo+ID4gPiA+ID4gPiB6ZXJv
LCBvciBuZWdhdGl2ZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gMDExIDExMTEgPSA2MyB4
IFRTWVNDTEsNCj4gPiA+ID4gPiA+IC4uLg0KPiA+ID4gPiA+ID4gMDAwIDAwMDAgPSAwIHggVFNZ
U0NMSw0KPiA+ID4gPiA+ID4gLi4uDQo+ID4gPiA+ID4gPiAxMTEgMTExMSA9IOKAkzY0IHggVFNZ
U0NMSw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEhhdmUgeW91IHRha2VzIHRoaXMgaW50byBhY2Nv
dW50Pw0KPiA+ID4gPiANCj4gPiA+ID4gSSBoYXZlIG5vdC4gQW5kIEkgZmFpbCB0byB1bmRlcnN0
YW5kIHdoYXQgd291bGQgYmUgdGhlIHBoeXNpY2FsDQo+ID4gPiA+IG1lYW5pbmcgaWYgVERDTyBp
cyB6ZXJvIG9yIG5lZ2F0aXZlLg0KPiA+IA0KPiA+IFRoZSBtY3AyNXh4ZmQgZmFtaWx5IGRhdGEg
c2hlZXQgc2F5czoNCj4gPiANCj4gPiA+IFNTUCA9IFREQ1YgKyBURENPDQo+ID4gPiA+IFREQ1Yg
aW5kaWNhdGVzIHRoZSBwb3NpdGlvbiBvZiB0aGUgYml0IHN0YXJ0IG9uIHRoZSBSWCBwaW4uDQo+
ID4gDQo+ID4gSWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSBpbiBhdXRvbWF0aWMgbW9kZSBURENW
IGlzIG1lYXN1cmVkIGJ5IHRoZSBDQU4NCj4gPiBjb250cm9sbGVyIGFuZCByZWZsZWN0cyB0aGUg
dHJhbnNjZWl2ZXIgZGVsYXkuDQo+IA0KPiBZZXMuIEkgcGhyYXNlZCBpdCBwb29ybHkgYnV0IHRo
aXMgaXMgd2hhdCBJIHdhbnRlZCB0byBzYXkuIEl0IGlzDQo+IHRoZSBkZWxheSB0byBwcm9wYWdh
dGUgZnJvbSB0aGUgVFggcGluIHRvIHRoZSBSWCBwaW4uDQo+IA0KPiBJZiBURENPID0gMCB0aGVu
IFNTUCA9IFREQ1YgKyAwID0gVERDViB0aHVzIHRoZSBtZWFzdXJlbWVudA0KPiBvY2N1cnMgYXQg
dGhlIGJpdCBzdGFydCBvbiB0aGUgUlggcGluLg0KPiANCj4gPiBJIGRvbid0IGtub3cgd2h5IHlv
dSB3YW50DQo+ID4gdG8gc3VidHJhY3QgYSB0aW1lIGZyb20gdGhhdC4uLi4NCj4gPiANCj4gPiBU
aGUgcmVzdCBvZiB0aGUgcmVsZXZhbnQgcmVnaXN0ZXJzOg0KPiA+IA0KPiA+ID4gVERDTU9EWzE6
MF06IFRyYW5zbWl0dGVyIERlbGF5IENvbXBlbnNhdGlvbiBNb2RlIGJpdHM7IFNlY29uZGFyeSBT
YW1wbGUNCj4gPiA+IFBvaW50IChTU1ApDQo+ID4gPiAxMC0xMSA9IEF1dG87IG1lYXN1cmUgZGVs
YXkgYW5kIGFkZCBURENPLg0KPiA+ID4gMDEgPSBNYW51YWw7IERvIG5vdCBtZWFzdXJlLCB1c2Ug
VERDViArIFREQ08gZnJvbSByZWdpc3Rlcg0KPiA+ID4gMDAgPSBUREMgRGlzYWJsZWQNCj4gPiA+
IA0KPiA+ID4gVERDT1s2OjBdOiBUcmFuc21pdHRlciBEZWxheSBDb21wZW5zYXRpb24gT2Zmc2V0
IGJpdHM7IFNlY29uZGFyeSBTYW1wbGUNCj4gPiA+IFBvaW50IChTU1ApDQo+ID4gPiBUd2/igJlz
IGNvbXBsZW1lbnQ7IG9mZnNldCBjYW4gYmUgcG9zaXRpdmUsIHplcm8sIG9yIG5lZ2F0aXZlLg0K
PiA+ID4gMDExIDExMTEgPSA2MyB4IFRTWVNDTEsNCj4gPiA+IC4uLg0KPiA+ID4gMDAwIDAwMDAg
PSAwIHggVFNZU0NMSw0KPiA+ID4gLi4uDQo+ID4gPiAxMTEgMTExMSA9IOKAkzY0IHggVFNZU0NM
Sw0KPiA+ID4gDQo+ID4gPiBURENWWzU6MF06IFRyYW5zbWl0dGVyIERlbGF5IENvbXBlbnNhdGlv
biBWYWx1ZSBiaXRzOyBTZWNvbmRhcnkgU2FtcGxlDQo+ID4gPiBQb2ludCAoU1NQKQ0KPiA+ID4g
MTEgMTExMSA9IDYzIHggVFNZU0NMSw0KPiA+ID4gLi4uDQo+ID4gPiAwMCAwMDAwID0gMCB4IFRT
WVNDTEsNCj4gDQo+IEFzaWRlIGZyb20gdGhlIG5lZ2F0aXZlIFREQ08sIHRoZSByZXN0IGlzIHN0
YW5kYXJkIHN0dWZmLiBXZSBjYW4NCj4gbm90ZSB0aGUgYWJzZW5jZSBvZiB0aGUgVERDRiBidXQg
dGhhdCdzIG5vdCBhIGJsb2NrZXIuDQo+IA0KPiA+ID4gPiBJZiBURENPIGlzIHplcm8sIHRoZSBt
ZWFzdXJlbWVudCBvY2N1cnMgb24gdGhlIGJpdCBzdGFydCB3aGVuIGFsbA0KPiA+ID4gPiB0aGUg
cmluZ2luZyBvY2N1cnMuIFRoYXQgaXMgYSByZWFsbHkgYmFkIGNob2ljZSB0byBkbyB0aGUNCj4g
PiA+ID4gbWVhc3VyZW1lbnQuIElmIGl0IGlzIG5lZ2F0aXZlLCBpdCBtZWFucyB0aGF0IHlvdSBh
cmUgbWVhc3VyaW5nIHRoZQ0KPiA+ID4gPiBwcmV2aW91cyBiaXQgb19PICE/DQo+ID4gDQo+ID4g
SSBkb24ndCBrbm93Li4uDQo+ID4gDQo+ID4gPiA+IE1heWJlIEkgYW0gbWlzc2luZyBzb21ldGhp
bmcgYnV0IEkganVzdCBkbyBub3QgZ2V0IGl0Lg0KPiA+ID4gPiANCj4gPiA+ID4gSSBiZWxpZXZl
IHlvdSBzdGFydGVkIHRvIGltcGxlbWVudCB0aGUgbWNwMjUxOGZkLg0KPiA+IA0KPiA+IE5vIEkn
dmUganVzdCBsb29rZWQgaW50byB0aGUgcmVnaXN0ZXIgZGVzY3JpcHRpb24uDQo+IA0KPiBPSy4g
Rm9yIHlvdXIgaW5mb3JtYXRpb24sIHRoZSBFVEFTIEVTNTh4IEZEIGRldmljZXMgZG8gbm90IGFs
bG93DQo+IHRoZSB1c2Ugb2YgbWFudWFsIG1vZGUgZm9yIFREQ1YuIFRoZSBtaWNyb2NvbnRyb2xs
ZXIgZnJvbQ0KPiBNaWNyb2NoaXAgc3VwcG9ydHMgaXQgYnV0IEVUQVMgZmlybXdhcmUgb25seSBl
eHBvc2VzIHRoZQ0KPiBhdXRvbWF0aWMgVERDViBtb2RlLiBTbyBpdCBjYW4gbm90IGJlIHVzZWQg
dG8gdGVzdCB3aGF0IHdvdWxkDQo+IG9jY3VyIGlmIFNTUCA9IDAuDQo+IA0KPiBJIHdpbGwgcHJl
cGFyZSBhIHBhdGNoIHRvIGFsbG93IHplcm8gdmFsdWUgZm9yIGJvdGggVERDViBhbmQNCj4gVERD
TyAoSSBhbSBhIGJpdCBzYWQgYmVjYXVzZSBJIHByZWZlciB0aGUgY3VycmVudCBkZXNpZ24sIGJ1
dCBpZg0KPiBJU08gYWxsb3dzIGl0LCBJIGZlZWwgbGlrZSBJIGhhdmUgbm8gY2hvaWNlKS4gIEhv
d2V2ZXIsIEkgcmVmdXNlDQo+IHRvIGFsbG93IHRoZSBuZWdhdGl2ZSBURENPIHZhbHVlIHVubGVz
cyBzb21lb25lIGlzIGFibGUgdG8NCj4gZXhwbGFpbiB0aGUgcmF0aW9uYWxlLg0KDQpIaSwNCg0K
cGVyaGFwcyBJIGNhbiBzaGVkIHNvbWUgbGlnaHQgb24gdGhlIGlkZWEgd2h5IGl0IGlzIGEgZ29v
ZCBpZGVhIHRvIGFsbG93DQpuZWdhdGl2ZSBUREMgb2Zmc2V0IHZhbHVlcy4gVGhlcmVmb3JlIEkg
d291bGQgZGVzY3JpYmUgdGhlIFREQyByZWdpc3Rlcg0KaW50ZXJmYWNlIG9mIHRoZSBFU0RBQ0Mg
Q0FOLUZEIGNvbnRyb2xsZXIgb2Ygb3VyIGNvbXBhbnkgKHNlZSANCmh0dHBzOi8vZXNkLmV1L2Vu
L3Byb2R1Y3RzL2VzZGFjYykuDQoNClJlZ2lzdGVyIGRlc2NyaXB0aW9uIG9mIFREQy1DQU4tRkQg
cmVnaXN0ZXIgKHJlc2VydmVkIGJpdHMgbm90IHNob3duKToNCg0KYml0cyBbNS4uMF0sIFJPOiBU
REMgTWVhc3VyZWQgKFREQ21lYXMpDQoJQ3VycmVudGx5IG1lYXN1cmVkIFREQyB2YWx1ZSwgbmVl
ZHMgYmF1ZHJhdGUgdG8gYmUgc2V0IGFuZCBDQU4gdHJhZmZpYw0KDQpiaXRzIFsyMS4uMTZdLCBS
L1c6IFREQyBvZmZzZXQgKFREQ29mZnMpDQoJRGVwZW5kaW5nIG9uIHRoZSBzZWxlY3RlZCBtb2Rl
IChzZWUgVERDIG1vZGUpDQoJLSBBdXRvIFREQywgYXV0b21hdGljIG1vZGUgKGRlZmF1bHQpDQoJ
CXNpZ25lZCBvZmZzZXQgb250byBtZWFzdXJlZCBUREMgKFREQ2VmZiA9IFREQ21lYXMgKyBURENv
ZmZzKSwNCgkJaW50ZXJwcmV0ZWQgYXMgNi1iaXQgdHdvJ3MgY29tcGxlbWVudCB2YWx1ZQ0KCS0g
TWFudWFsIFREQw0KCQlhYnNvbHV0ZSB1bnNpZ25lZCBvZmZzZXQgKFREQ2VmZiA9IFREQ29mZnMp
LA0KCQlpbnRlcnByZXRlZCBhcyA2LWJpdCB1bnNpZ25lZCB2YWx1ZQ0KCS0gT3RoZXIgbW9kZXMN
CgkJaWdub3JlZA0KCUluIGVpdGhlciBjYXNlIFREQyBvZmZzZXQgaXMgYSBudW1iZXIgb2YgQ0FO
IGNsb2NrIGN5Y2xlcy4NCg0KYml0cyBbMzEuLjMwXSwgUi9XOiBUREMgbW9kZQ0KCTAwID0gQXV0
byBUREMNCgkwMSA9IE1hbnVhbCBUREMNCgkxMCA9IHJlc2VydmVkDQoJMTEgPSBUREMgb2ZmDQoN
ClNvIGluIGF1dG9tYXRpYyBtb2RlIHRoZSBnb2FsIGlzIHRvIGJlIGFibGUgdG8gbW92ZSB0aGUg
cmVhbCBzYW1wbGUgcG9pbnQNCmZvcndhcmQgYW5kKCEpIGJhY2t3YXJkIGZyb20gdGhlIG1lYXN1
cmVkIHRyYW5zbWl0dGVyIGRlbGF5LiBUaGVyZWZvcmUgdGhlDQpURENvZmZzIGlzIGludGVycHJl
dGVkIGFzIDYtYml0IHR3bydzIGNvbXBsZW1lbnQgdmFsdWUgdG8gbWFrZSBuZWdhdGl2ZSBvZmZz
ZXRzDQpwb3NzaWJsZSBhbmQgdG8gZGVjcmVhc2UgdGhlIGVmZmVjdGl2ZSAodXNlZCkgVERDZWZm
IGJlbG93IHRoZSBtZWFzdXJlZCB2YWx1ZQ0KVERDbWVhcy4NCg0KQXMgZmFyIGFzIEkgaGF2ZSB1
bmRlcnN0b29kIG91ciBGUEdBIGd1eSB0aGUgVERDbWVhcyB2YWx1ZSBpcyB0aGUgbnVtYmVyIG9m
DQpjbG9jayBjeWNsZXMgY291bnRlZCBmcm9tIHRoZSBzdGFydCBvZiB0cmFuc21pdHRpbmcgYSBk
b21pbmFudCBiaXQgdW50aWwgdGhlDQpkb21pbmFudCBzdGF0ZSByZWFjaGVzIHRoZSBSWCBwaW4u
DQoNCkR1cmluZyB0aGUgZGF0YSBwaGFzZSB0aGUgc2FtcGxlIHBvaW50IGlzIGNvbnRyb2xsZWQg
YnkgdGhlIHRzZWcgdmFsdWVzIHNldCBmb3INCnRoZSBkYXRhIHBoYXNlIGJ1dCBpcyBtb3ZlZCBh
ZGRpdGlvbmFsbHkgYnkgdGhlIG51bWJlciBvZiBjbG9ja3Mgc3BlY2lmaWVkIGJ5DQpURENlZmYg
KG9yIFNTUCBpbiB0aGUgbWNwMjUxOGZkIGNhc2UpLg0KDQpCZXN0IHJlZ2FyZHMsDQogICAgU3Rl
ZmFuDQoNClBTOiBJJ20gaW50ZXJlc3RlZCBpbiB0aGlzIHRvcGljIGJlY2F1c2UgSSdtIGluIHRo
ZSBwcm9jZXNzIG9mIHByZXBhcmluZyBhDQpTb2NrZXRDQU4gZHJpdmVyIGZvciBvdXIgRVNEQUND
IGJhc2UgUENJZS80MDIgQ0FOIGludGVyZmFjZSBmYW1pbHkuDQoNCg==
