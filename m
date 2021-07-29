Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F76C3DA894
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhG2QLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:11:30 -0400
Received: from mail-vi1eur05on2098.outbound.protection.outlook.com ([40.107.21.98]:64452
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234568AbhG2QKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 12:10:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oy7wyj7PHx7FHzk6+pJrJ8ddR2wOxeWpcNDaObp+6N6ZHxH5pgva7WtdUsvH/pJlh+KLm5SG83SYhJ6TUyIj4GCIMq4RmIS0VJPD8BVQzr288u90y/7YCK1UN1jTgnB/n7zVE9nMk1ThILZLc4TIm3A5SydVXL+eef/BsiZPFvlNVKq+OEbgX/tcogM9RtfaJinOWHR4cCqNbgLhy3giTI1aFP2SQG8weUgrHYLwGgMn+4Ep2zDQnT9GWlH1mxVndvCdiKwah1/GieI+TF8b5IhHJZ9My9Ru7gdUSMdjWOoEOatZVbaDAKMcIl5Gi/qkXkJT+7M9AZfzE/dXZVMIEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S857HzPVGbfHCN1FCXWYhSDOW/Fba6b1afe+kWFBbxI=;
 b=c/U/44vh/NsEaXvdaOi8wsl1aUbfSAsUaCtKvXcHVYnYlUfHlR1/HX80WxgRIPAsvSsuniL1nztG6398nOe77l/94j77rVfCKgh+aXlBM2/SKqZqVr0P08xzwGNjQHcOXbOb9mz40xwVnDjqOExHat2sD49H9XWYps+MEOaRIAw2O+XkYotWKcupHnIGA55Xv2QhqqIj2GMpXTT3XU2TpQU7u2DwWzOGi+uqmqqoa9OeEPhlXn5HS9RUGIocgCDvStFNFUIKaIcpfMNI+kUfJaynY0GhKYJUlzYWTBXyJcLRchGoZ8CmOktQosN3DTaOeuuYYrXGS9pHMpAKS7eTLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S857HzPVGbfHCN1FCXWYhSDOW/Fba6b1afe+kWFBbxI=;
 b=Z0jIfjhhHsQ5BIPYbtqMarQWVTjPz0ub5sONfTyiyWDfEbv2vepD5HD7W07OrEJfvftAU8fgJfgvutTMTsKSp23nkpw/n1OuJOAROaPRQKHIBe7murY9nP3HZZDQUpC442tsyeHk8x+OqbcQ2GucX9tAmSWqG25EKWTTxc7Gghw=
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com (2603:10a6:20b:287::7)
 by AM9PR03MB6946.eurprd03.prod.outlook.com (2603:10a6:20b:2d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 16:10:06 +0000
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::5900:9630:4661:9b0d]) by AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::5900:9630:4661:9b0d%6]) with mapi id 15.20.4373.020; Thu, 29 Jul 2021
 16:10:06 +0000
From:   =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <Stefan.Maetje@esd.eu>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: [PATCH 1/1] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Thread-Topic: [PATCH 1/1] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Thread-Index: AQHXg/BfD66NKH5sTUuvHL9pAkN8h6tZi4UAgACU/YA=
Date:   Thu, 29 Jul 2021 16:10:06 +0000
Message-ID: <59f2f6a6544eebc9824a72f0da52f98b4673cbe3.camel@esd.eu>
References: <20210728203647.15240-1-Stefan.Maetje@esd.eu>
         <20210728203647.15240-2-Stefan.Maetje@esd.eu>
         <20210729071650.77e274e4zobv5uwo@pengutronix.de>
In-Reply-To: <20210729071650.77e274e4zobv5uwo@pengutronix.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28f796bc-35af-4596-07f7-08d952ab54dd
x-ms-traffictypediagnostic: AM9PR03MB6946:
x-microsoft-antispam-prvs: <AM9PR03MB69462A4B9FC47AB04D1AD90281EB9@AM9PR03MB6946.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fC8Z/bcDhdy97W1oFSPihJRQmLBsHfuhHBaumVOBsx00QYQTbeornEpXbVrABJ+f7HOUBj0RZEYW9IEBw9Ofv58M+6tam1pR2nu5Lc2vfmjDQcgTNNTz+ZVqnenz4g9loGBc37O5teYjH5OeMtLRTknGARvu9ZH+MttnguE1OwPwH3d02kBOqeF9nHISnL3mQ9aX4i8At9jhrMA70ZdQ03rN7Tqy6ztFj5bgU+YSZtu9Wbdg7wUY1jTKtcNEPUkTy1yjSmg+s31zkNfqdx3YhquFKeSlQ13PT/pxfopQqd8WvFB1MUAzKzujdonM0X1e21X6eXfh3I0rqoVqnK3wVhYXZfkEbR9sKeN5HlhuAgKIPEqMI3Wgv/aU742b7/lscT/XJ+Tv+NkWBhmRR6W6vr5exw6gV3ZPdDP1SGdLbm93/KCzKrgMQOY1+6WEsv3r2SuARZkb5cjrqYN5FUlQHBrYpNx8XK04F9AWczPo2rNqobYKpAyCRQEu5K3U1qaA9XEeTGJMDN/DGwCsNdPQ9yz0fcvk8PNdDPa8w9zHliPm1nihs3BtNDpBaeOuNdt9eMgc5LixDJDU7GrLBCuWwFAJsCSFAEWwE9NJ3JNlzuEMoGRO83RPA0/2ChwbUfp/rGCV4J4gBqkxYDZk8GRZolCyYY8pAve5aJL7PoPLwlBQC9/Y/RNy7xIC6bfWokIuoWtIdjBsq5m3Dmdec8y+yD8Sb2LebGYzbSfgtxCYhMeHB3HHRN2/X05Bd9xU4WlQNX6WcUr4nC2udI9jfBz784hiekp/YCbjeUnnfRJg5M86snKms2fGwtpzygpa9OEte+S5pTyNwGx14UxbqEGgeqXeaiF4OyaD2lQWjQJRgSU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR03MB6929.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(4326008)(2616005)(86362001)(6486002)(66446008)(66946007)(186003)(91956017)(85182001)(53546011)(64756008)(54906003)(71200400001)(316002)(26005)(36756003)(966005)(85202003)(66556008)(76116006)(6916009)(38070700005)(66476007)(508600001)(83380400001)(8676002)(6512007)(6506007)(15974865002)(8936002)(38100700002)(2906002)(122000001)(5660300002)(66574015)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djhvQndpT0l5Y0xuMXFsQ0FHbk02cTJTMmM3dzdybHdsTGtWeWhGSno1cVdM?=
 =?utf-8?B?c3doWHQrK0RZdHROUFk5QTVIeFBpUjZydFY0RE9VMXJSdlVwUGY5Wk9HcFVu?=
 =?utf-8?B?YmttTk0xRU1EM1lqWnQxaFdqYU84NGlMWUlXNGdmQWhiSHhCRjVQZmNkbnc3?=
 =?utf-8?B?dUx4V01wU0dPcjB4TTRLNXJ3OXRweStxQVNVcHVlTjkvWDJRalZWcjJwWEk2?=
 =?utf-8?B?UGg4Q2h0T3ltZGJJNElXZmdWaXplNW9MdUtLYVNOZ0ZCNXlYV0VaM3BlL3Bm?=
 =?utf-8?B?WGZ6bnlqVituOTNaZ2dRZkRrRUFsTnoyQ1NQQktRL1R2ajBpU0tZLzZGencw?=
 =?utf-8?B?QVNXSkRCbjBPT29scTc0dlYxT2FPSGtyRnNhYUZsTWdLNlV6dHZvaDBoeGNj?=
 =?utf-8?B?VkdFY0JabTlWZkpQenZ4SGVZSTJ3Z2hqcGF6K2Vob1pDeW1haE90b2dJcENK?=
 =?utf-8?B?UVNsSWxZK01aUndhaEtYUHAvb0ZjaktUVEVpU09HeEZrUmNpend2UnU2M2RO?=
 =?utf-8?B?U2IzRXRRZ3NDejV1anU0KzhiaHJjUFNZY0dGSWF4Z25xNVFsVkQwUWhxMnlx?=
 =?utf-8?B?TkI3U0xLeVh0SXFoc0JHdk9BR0FZTlpRWnlTNnRUazhnRkcrV1NzNS9CYmRM?=
 =?utf-8?B?RERTUm1hUFZPbGoyNXlHSmRJN0wzOG1xMjRaVlFsSTNxNGhVdW9EU0NOMXl2?=
 =?utf-8?B?bnB1Ky9mVnJXUk4rWE5UV05DS0dldWw5WEFCaGVnNVhHSklONkd4eTFGbG1y?=
 =?utf-8?B?RjdvQ2JkZEVHc2FkcHZUVFYrK0Z2SEx5S0FJZDcxTlhSYXo2dWZnQUhyM2J4?=
 =?utf-8?B?ZWhIY2tESFFZUUlhZjA1blRyYVdqVEFnTkJ5RXE0OERzUFZPd2ZpYnVhTGlv?=
 =?utf-8?B?NUVtU0RpOVVqRlgxbCtPVFVGeFBNTjJSWU13ZUdVSURQNktUQndSUHJyOTVj?=
 =?utf-8?B?WEJhQ3RqL2VZMlZoM1cwTURCRVVXV2dwQ2kxbm0xZGJlUFg5S3ZNdXM2MnFQ?=
 =?utf-8?B?QlFRUkR3SGM0Y3UvcDNLN0x5ckkxcHVPUXRzcHgzaWNsaklqcHM5MFdWeDBM?=
 =?utf-8?B?Zzlzb0hCWFFNY01ocTRPUXlMbFRKSUpGd0FZSEtpQ1p2QlBaUHNsT1dvOWEr?=
 =?utf-8?B?dFplVml3bnhGYXhpNHc5TDZTQ1V4akpDNHVteW1YL0JyVjJSQWxFNWRCSmZw?=
 =?utf-8?B?aENkeEd5WW4xdGl4TFFWdHY3K0JUYjU4RTRwOENiL2tVVmtwZXppQ2RncTFs?=
 =?utf-8?B?R0s3K3lzeng1d3NtSk8wZkR2c3hjSGtjL3pOdnJPczVZMXc1eks1alJ4MzB4?=
 =?utf-8?B?UDZhRFNxREZseGNJSithc1RKbk12RFVEM3RUYWt0OTVESElqNFBoazI3Vith?=
 =?utf-8?B?bk91dHV1NHdUdkJEb0JmaDVpVHZDQTB5T0NkZGFEb3grbUpTOThjTmxWZml4?=
 =?utf-8?B?UCsxREZLbHMxNXc3STdpMktuRkdDc29VVE12MzRNaVgxMitLbWhCQmxrZ2Fr?=
 =?utf-8?B?SFlTR003Qkp5ekdQbXN6SkFjbUVEOWg3a2RzY0gxSFhMdEVLdHNwVU5vSlBO?=
 =?utf-8?B?T3c2R2dXSHhTV1F6djBQT1ZzNk5jSlRSVHNtL1NUc1FDdUQzYjZCY3ZwT2xY?=
 =?utf-8?B?SjRPVyswSnZTYlJNS3Bzc28waHRQQklzaWVZVnB2WS83YXFKc21QZkZhOFkz?=
 =?utf-8?B?azZCSTYwUHFvdWJZbEo5QkdMWTV4QjRXZHkyOC8xbjVsdUljZkFsMjBLRjFR?=
 =?utf-8?Q?4CX9iDcxV2iVs1WQpJf+7wWMxA4W9lj/I1uRogb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1856D58F02F33141AF797A9E2A550FA3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR03MB6929.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f796bc-35af-4596-07f7-08d952ab54dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2021 16:10:06.5924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y+DraeCaOKgR6peH/1qZF+3tnO3ON9tUFSo3OtYtIEJWLLe2wVLGi5ns7/gr3qtUwKFPfNIIvtblWKdejWJUNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6946
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW0gRG9ubmVyc3RhZywgZGVuIDI5LjA3LjIwMjEsIDA5OjE2ICswMjAwIHNjaHJpZWIgTWFyYyBL
bGVpbmUtQnVkZGU6DQo+IE9uIDI4LjA3LjIwMjEgMjI6MzY6NDcsIFN0ZWZhbiBNw6R0amUgd3Jv
dGU6DQo+ID4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgZm9yIHRoZSBQQ0kgYmFzZWQgUENJZS80
MDIgQ0FOIGludGVyZmFjZSBmYW1pbHkNCj4gPiBmcm9tIGVzZCBHbWJIIHRoYXQgaXMgYXZhaWxh
YmxlIHdpdGggdmFyaW91cyBmb3JtIGZhY3RvcnMNCj4gPiAoaHR0cHM6Ly9lc2QuZXUvZW4vcHJv
ZHVjdHMvNDAyLXNlcmllcy1jYW4taW50ZXJmYWNlcykuDQo+ID4gDQo+ID4gQWxsIGJvYXJkcyB1
dGlsaXplIGEgRlBHQSBiYXNlZCBDQU4gY29udHJvbGxlciBzb2x1dGlvbiBkZXZlbG9wZWQNCj4g
PiBieSBlc2QgKGVzZEFDQykuIEZvciBtb3JlIGluZm9ybWF0aW9uIG9uIHRoZSBlc2RBQ0Mgc2Vl
DQo+ID4gaHR0cHM6Ly9lc2QuZXUvZW4vcHJvZHVjdHMvZXNkYWNjLg0KPiANCj4gVGhhbmtzIGZv
ciB0aGUgcGF0Y2ghDQo+IA0KPiA+IFRoaXMgZHJpdmVyIGRldGVjdHMgYWxsIGF2YWlsYWJsZSBD
QU4gaW50ZXJmYWNlIGJvYXJkcyBidXQgYXRtLg0KPiA+IG9wZXJhdGVzIHRoZSBDQU4tRkQgY2Fw
YWJsZSBkZXZpY2VzIGluIENsYXNzaWMtQ0FOIG1vZGUgb25seSENCj4gDQo+IEFyZSB5b3UgcGxh
bmluZyB0byBjaGFuZ2UgdGhpcz8NCg0KWWVzLCB3ZSB3aWxsIHByb3ZpZGUgc3VwcG9ydCBmb3Ig
Q0FOLUZEIHRvby4gSSBtZW50aW9uZWQgdGhpcyBhbHJlYWR5IGluIHRoZSANCmNvdmVyIGxldHRl
ci4gU2hvdWxkIEkgbWVudGlvbiB0aGlzIGV4cGxpY2l0ZWx5IGluIHRoZSBjb21taXQgZGVzY3Jp
cHRpb24gdG9vPw0KDQoNCj4gRm9yIG5vdyBqdXN0IHNvbWUgbml0cGlja3M6DQo+IA0KPiBDb21w
aWxhdGlvbiB0aHJvd3MgdGhpcyBlcnJvciBtZXNzYWdlIG9uIDMyIGJpdCBBUk06DQo+IA0KPiA+
IGRyaXZlcnMvbmV0L2Nhbi9lc2QvZXNkNDAyX3BjaS5jOiBJbiBmdW5jdGlvbg0KPiA+IOKAmHBj
aTQwMl9pbml0X2RtYeKAmTogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIA0KPiA+IGRyaXZlcnMvbmV0L2Nhbi9lc2QvZXNkNDAyX3BjaS5jOjMwNDozMjog
d2FybmluZzogcmlnaHQgc2hpZnQgY291bnQgPj0gd2lkdGggb2YgdHlwZSBbLVdzaGlmdC1jb3Vu
dC0NCj4gPiBvdmVyZmxvd10gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIA0KPiA+ICAgMzA0IHwgIGlvd3JpdGUzMigodTMyKShjYXJkLT5kbWFf
aG5kID4+DQo+ID4gMzIpLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIA0KPiA+ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCj4gPiAgDQo+ID4g
Q0hFQ0sgICAvc3J2L3dvcmsvZnJvZ2dlci9zb2NrZXRjYW4vbGludXgvZHJpdmVycy9uZXQvY2Fu
L2VzZC9lc2Q0MDJfcGNpLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICANCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCj4gPiBkcml2ZXJzL25ldC9jYW4vZXNk
L2VzZDQwMl9wY2kuYzozMDQ6NDI6IHdhcm5pbmc6IHNoaWZ0IHRvbyBiaWcgKDMyKSBmb3IgdHlw
ZSB1bnNpZ25lZCBpbnQgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQoNCkknbGwgY2hhbmdl
IHRoaXMgdG8gDQoNCglpb3dyaXRlMzIoMFUsIGNhcmQtPmFkZHJfcGNpZXAgKyBQQ0k0MDJfUENJ
RVBfT0ZfQk1fQUREUl9ISSk7DQoNCndoaWNoIGlzIGVub3VnaCBmb3Igbm93IGJlY2F1c2UgdGhl
IGNhcmQtPmRtYV9obmQgdmFsdWUgaXMgbGltaXRlZCB0byBhIDMyLWJpdCBhZGRyZXNzIHdpdGgg
DQpwY2lfc2V0X2NvbnNpc3RlbnRfZG1hX21hc2soKSBhdG0uDQoNCg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9jYW4vZXNkL01ha2VmaWxlIGIvZHJpdmVycy9uZXQvY2FuL2VzZC9NYWtl
ZmlsZQ0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5h
OTYwZThiOTdjNmYNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2Fu
L2VzZC9NYWtlZmlsZQ0KPiA+IEBAIC0wLDAgKzEsMTEgQEANCj4gPiArIyBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+ID4gKyMNCj4gPiArIyAgTWFrZWZpbGUgZm9yIGVz
ZCBnbWJoIEVTREFDQyBjb250cm9sbGVyIGRyaXZlcg0KPiA+ICsjDQo+ID4gK2VzZF80MDJfcGNp
LXkgOj0gZXNkYWNjLm8gZXNkNDAyX3BjaS5vDQo+ID4gKw0KPiA+ICtpZmVxICgkKENPTkZJR19D
QU5fRVNEXzQwMl9QQ0kpLCkNCj4gPiArb2JqLW0gKz0gZXNkXzQwMl9wY2kubw0KPiA+ICtlbHNl
DQo+ID4gK29iai0kKENPTkZJR19DQU5fRVNEXzQwMl9QQ0kpICs9IGVzZF80MDJfcGNpLm8NCj4g
PiArZW5kaWYNCj4gDQo+IFdoeSBkbyB5b3UgYnVpbGQgdGhlIGRyaXZlciwgaWYgaXQgaGFzIG5v
dCBiZWVuIGVuYWJsZWQ/DQoNCkkgd2FzIG5vdCBhd2FyZSBvZiB0aGF0IGZhY3QgYW5kIGl0IHdh
cyBub3QgaW50ZW5kZWQuDQoNCj4gVGhlIHN0cmFpZ2h0IGZvcndhcmQgd2F5IHRvIGJ1aWxkIHRo
ZSBkcml2ZXIgd291bGQgYmU6DQo+IA0KPiA+IG9iai0kKENPTkZJR19DQU5fRVNEXzQwMl9QQ0kp
ICs9IGVzZF80MDJfcGNpLm8NCj4gPiANCj4gPiBlc2RfNDAyX3BjaS1vYmpzIDo9IGVzZGFjYy5v
IGVzZDQwMl9wY2kubw0KPiANCj4gWW91IGNhbiByZW5hbWUgdGhlIGVzZF80MDJfcGNpLmMgdG8g
ZXNkXzQwMl9wY2ktY29yZS5jIHRvIGF2b2lkDQo+IGluY29uc2lzdGVudCBuYW1pbmcsIChDIGZp
bGUgaXMgY2FsbGVkIGVzZDQwMl9wY2kuYywgd2hpbGUgdGhlIGRyaXZlcg0KPiBtb2R1bGUgaXMg
ZXNkXzQwMl9wY2kua28pDQo+IA0KPiBNYXJjDQoNCkkgd2lsbCBjaGFuZ2UgdGhlIE1ha2VmaWxl
IGluY29ycG9yYXRpbmcgeW91ciByZWNvbW1lbmRhdGlvbnMuDQoNCg0KQmVzdCByZWdhcmRzLA0K
DQpTdGVmYW4gTcOkdGplDQpTeXN0ZW0gRGVzaWduDQoNClBob25lOiArNDktNTExLTM3Mjk4LTE0
Ng0KRS1NYWlsOiBzdGVmYW4ubWFldGplQGVzZC5ldQ0KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fDQplc2QgZWxlY3Ryb25pY3MgZ21iaA0KVmFocmVud2FsZGVyIFN0ci4g
MjA3DQozMDE2NSBIYW5ub3Zlcg0Kd3d3LmVzZC5ldQ0KDQpRdWFsaXR5IFByb2R1Y3RzIOKAkyBN
YWRlIGluIEdlcm1hbnkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0K
DQpSZWdpc3RlciBIYW5ub3ZlciBIUkIgNTEzNzMgLSBWQVQtSUQgREUgMTE1NjcyODMyDQpHZW5l
cmFsIE1hbmFnZXI6IEtsYXVzIERldGVyaW5nDQoNCg==
