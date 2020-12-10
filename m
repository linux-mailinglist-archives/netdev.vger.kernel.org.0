Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A62D5887
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389034AbgLJKrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:47:21 -0500
Received: from mail-am6eur05on2042.outbound.protection.outlook.com ([40.107.22.42]:32128
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389008AbgLJKrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 05:47:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmE85EbcT47/7RU6m/6p+fmCRQEGqLvY3O2BbqqByr2LK0961OquliMWLM1X038YWd9C3fk6zrOBLfS+sB6eYceyo5PI+obzpOaGvK0LwppMgXCv4zioY0WsaVYcoBxs3pDVBMB4yUSjt16gkYS5nCO5DOhfvCVBiaU6D6knwHE9B+BwmOCb8wT8zYlH8iy8YDHEsVMpruzX/yV/oqF4+vUVzF3ZeAhkFTIEBJu6xi1WEQV7Z1u54MZ0o6AiyvM90DjZJOu7KeYHYnocv6fFtUIE45C3WjdspmJ5dPF4Ev8a8nFaLJ589IfWjtic1xpW00H9AbAFOs/etyHjjoFGgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy+hR0HIZqIwBtijAhSGihPPObYF0Eiz3ubjO4MxJk8=;
 b=ZAFMxOtgexeezhg3rc2PJP3L7VyRqZSJ8xki5At1VOz1HAKFnBe4VwegnHhZGMhN/+iG88sAhDjKVEIAUC3KpeRd09DXAWyfaW4e6WK7dKeqZXk8KgmAH3CtiJqgKqYZ1JJ4xA9hXTwfIgbj4TInADufE8aiYlIwvrhDy/uDsAb6PJftxdef2BELCEQ8UqhTBCO9KKPVXT96EUyv7l1lGHQetbXZYLyMH2mzXVRAGJXJECaayPnH4it11eSSXclg2XcmrJOmfN9dQhYENIzRYTYqMM0BRZBx/7ZUmC/SKSgOkaFiVvX6ZAKjNDb9s6kGEeu3PIwzGnWW3I2d2BTQrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy+hR0HIZqIwBtijAhSGihPPObYF0Eiz3ubjO4MxJk8=;
 b=BLp9/z9NV/43vZAOMHlhC004WIbk3rCBSVICXR++EmRNgeHtSCCGP8D5Vvc0RR04bj7Y9PiHZvTICvTOlbuuItwlseBSLRxC/csWOTpIhVwlltmIt+JP1QqhebziVVLTLqc9QGJwBgx55Lm+DfL9uD8qR81S8pw2QgLmHMzrRgQ=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR0402MB3895.eurprd04.prod.outlook.com (2603:10a6:209:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Thu, 10 Dec
 2020 10:46:18 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc%6]) with mapi id 15.20.3654.014; Thu, 10 Dec 2020
 10:46:18 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Patrick Havelange <patrick.havelange@essensium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
Thread-Topic: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
Thread-Index: AQHWyXtSU15lz2QhZ0iXI1B/qYMSiKnlgUwAgAfQMQCAABdiMIABcACAgABKVyCAAOyMgIAAAFrwgAAU/ICAAAskAA==
Date:   Thu, 10 Dec 2020 10:46:18 +0000
Message-ID: <AM6PR04MB3976B3C4CB46CF21CF74403FECCB0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
 <20201203135039.31474-2-patrick.havelange@essensium.com>
 <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <e488ed95-3672-fdcb-d678-fdd4eb9a8b4b@essensium.com>
 <AM6PR04MB3976F905489C0CB2ECD1A6FAECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <8c28d03a-8831-650c-cf17-9a744d084479@essensium.com>
 <AM6PR04MB3976721D38D6EAE91E6F3F37ECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <9a118a8d-ce39-c71b-9efe-3a4fc86041ee@essensium.com>
 <AM6PR04MB3976C893BE91E755D439EDFFECCB0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <51b57945-c238-0c58-ef12-562911a56f8a@essensium.com>
In-Reply-To: <51b57945-c238-0c58-ef12-562911a56f8a@essensium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: essensium.com; dkim=none (message not signed)
 header.d=none;essensium.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [81.196.28.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df9cea4a-24b9-4fad-63bf-08d89cf8d392
x-ms-traffictypediagnostic: AM6PR0402MB3895:
x-microsoft-antispam-prvs: <AM6PR0402MB389513724D6AC5B5ACC74D71ECCB0@AM6PR0402MB3895.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I7eFEdmCKCZmcSGq7W0z5YI5qnhPMdv+C+SmsUXqdN4jnRP63FnTDyA534mVLXvxyWYM+eiHCSi8ZYH6i6YHhE/slafa9ejpvEYkC/U9AmySkycD1oQF56lIcngrn22953rjM9Cn0UVawresba6Liu1D8Ec4Gb7rrKNPXlz3inF9V9IZOJ+wm8uTN6IDBd0iunRdjGDa6GrDgIx9RfEH28ZNFBXprezKXws5KXjnfMTVHpigEJ79+3Q/xO2azlPrfD3HjdYKfqin2/JtPuCuLNJLBVXR+r4EGhIVCeHnwlRyIbrz1BmYVlyaVzWtQ1ci
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(9686003)(44832011)(33656002)(71200400001)(83380400001)(5660300002)(66946007)(53546011)(2906002)(86362001)(6506007)(316002)(186003)(110136005)(76116006)(8936002)(4001150100001)(66446008)(52536014)(26005)(55016002)(66556008)(66476007)(64756008)(7696005)(8676002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UlFIR01ETUtLbktyZXh6ZUFTMUpLQXJWc1VCQXFNM3NGanFZWkpzM1RhL0JV?=
 =?utf-8?B?KzF1NGVqVXROVnpndXdkdjNRMnExQ2xhaWlTVlhpK2hGakc2U0lpdkMyaExW?=
 =?utf-8?B?bFVBOERWZm0zSWdiVnRucnNLa2t3T2hwZnhraVZBckg2MHFobmwxZ0ZudGg5?=
 =?utf-8?B?TmxpMXBIL0VQVGI0eXpNUFdUVkl3SDZtZE5BeVZtek5TSExVWnRIREVnK1BQ?=
 =?utf-8?B?dDNRNlYxYkhKOCtnYzVFVXpwK3djVGhaVmIxM2ZTSTg2eTUyTzRwRFdkU2Js?=
 =?utf-8?B?c2ttS3VTUldtalA2Yi9QNi9uZ0k5TDRiRUJBSWo3RzBUQ09sdmIvQXhuWWUw?=
 =?utf-8?B?U3Y3d3JZcWx1ZWdEY0dJWXhxN3VyWlJOdjlBQ25BM3hFVDIzRDhtM3l5b1d4?=
 =?utf-8?B?VWxGNFhVR2l6cE0xalQxenpsaVl4dlhjeWMzYXdoSDR0L00yTkZCWWZxU3ZT?=
 =?utf-8?B?KzJ1TVRJWFBldzg2RHBYdzRUVjBqTkdzekk4akxvVXRIMU14ZVNqeEN0WTcv?=
 =?utf-8?B?UE5uaWgyK0RHUVZDYWZYMk5DWTBBdlBiVSsyelpOQ0xnQ2F0L09aWW8rdEVv?=
 =?utf-8?B?eEYyQTFYNDV4eU5md21IOVlBQWNyNXNpbDVRQ3Zsc1Jqd1VTVzEyQ3BlY1Iz?=
 =?utf-8?B?UFNFcmpicHhxdnJjT2xvZElHVlZoVmZ3bXZaM1NPMVZmUERxTUt1ZW45M0E1?=
 =?utf-8?B?b0Q3QnUxMVNVYlBMeXg5U0FTTWN4dGFOdjdrNnVYZEpPWXRJVEpqSWUra2pJ?=
 =?utf-8?B?c0M0dkZTME9aTHhJQUIwV1ZHUFppKytJWGh6QU9RTmRyczgrZmVpZ3ZXaVVr?=
 =?utf-8?B?OElISDlzU29yNVU0UlJsMkRzRkxIbW0wNnNWakZpZ3VlUEJydUpOaFdVRUFN?=
 =?utf-8?B?SWxQdUFINzJCSy9hOWo1UGl4VkNRcjMwZFhrWW1JYXFYWDFhVUwwZWpUdU9Y?=
 =?utf-8?B?cU5pYm1YNHNidVpLTnZlMEU5cnJHLzdSZmNIVVZ1OFRlWTZBTU5vQ1dvYThs?=
 =?utf-8?B?YzdzN2xWZERybExERmZXQi9ibHpRZzlIVlYyMUhtWjA5bllVYlZXNGxzQlNy?=
 =?utf-8?B?UWRjUG9VbVJUOS9yMllUT2g1UlpMUzFYRHFLd2QxcDVMendHYlZTcTlmY2tw?=
 =?utf-8?B?dFVRVE1za1V4MlBqZmlsSkJld2xDeEU5eGFJTHhVN21CZzdGWFVMTm1YVTBv?=
 =?utf-8?B?amx0cTZ3UlZWa01hMzN5NHJqUElPMFVaa3hzOUx1cVBrUTdlRVBtalZCZWY1?=
 =?utf-8?B?aXRqa1d4RFdaVEllZlI5QittYkdEMkFHeWN6aVozZFRFc2gwT3A3Z3pSS0Vt?=
 =?utf-8?Q?443wrWYR1v8OI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df9cea4a-24b9-4fad-63bf-08d89cf8d392
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 10:46:18.7354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WxNgc/I6jkq8/LfAlYdFfOzgtly5E8mIqE4FYzhoCRayTOkZsrQxEjMofsy2jaMZMZRVIW9D7SVpO2pe3aOwzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3895
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYXRyaWNrIEhhdmVsYW5nZSA8
cGF0cmljay5oYXZlbGFuZ2VAZXNzZW5zaXVtLmNvbT4NCj4gU2VudDogMTAgRGVjZW1iZXIgMjAy
MCAxMjowNg0KPiBUbzogTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBueHAuY29tPjsgRGF2
aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgMS80XSBuZXQ6IGZyZWVz
Y2FsZS9mbWFuOiBTcGxpdCB0aGUgbWFpbiByZXNvdXJjZQ0KPiByZWdpb24gcmVzZXJ2YXRpb24N
Cj4gDQo+IE9uIDIwMjAtMTItMTAgMTA6MDUsIE1hZGFsaW4gQnVjdXIgd3JvdGU6DQo+ID4+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFBhdHJpY2sgSGF2ZWxhbmdlIDxw
YXRyaWNrLmhhdmVsYW5nZUBlc3NlbnNpdW0uY29tPg0KPiANCj4gW3NuaXBwZWRdDQo+IA0KPiA+
Pg0KPiA+PiBCdXQgdGhlbiB0aGF0IGNoYW5nZSB3b3VsZCBub3QgYmUgY29tcGF0aWJsZSB3aXRo
IHRoZSBleGlzdGluZyBkZXZpY2UNCj4gPj4gdHJlZXMgaW4gYWxyZWFkeSBleGlzdGluZyBoYXJk
d2FyZS4gSSdtIG5vdCBzdXJlIGhvdyB0byBoYW5kbGUgdGhhdA0KPiBjYXNlDQo+ID4+IHByb3Bl
cmx5Lg0KPiA+DQo+ID4gT25lIG5lZWRzIHRvIGJlIGJhY2t3YXJkcyBjb21wYXRpYmxlIHdpdGgg
dGhlIG9sZCBkZXZpY2UgdHJlZXMsIHNvIHdlIGRvDQo+IG5vdA0KPiA+IHJlYWxseSBoYXZlIGEg
c2ltcGxlIGFuc3dlciwgSSBrbm93Lg0KPiA+DQo+ID4+PiBJZiB3ZSB3YW50IHRvIGhhY2sgaXQs
DQo+ID4+PiBpbnN0ZWFkIG9mIHNwbGl0dGluZyBpb3JlbWFwcywgd2UgY2FuIHJlc2VydmUgNCBr
QiBpbiB0aGUgRk1hbiBkcml2ZXIsDQo+ID4+PiBhbmQga2VlcCB0aGUgaW9yZW1hcCBhcyBpdCBp
cyBub3csIHdpdGggdGhlIGJlbmVmaXQgb2YgbGVzcyBjb2RlIGNodXJuLg0KPiA+Pg0KPiA+PiBi
dXQgdGhlbiB0aGUgaW9yZW1hcCBhbmQgdGhlIG1lbW9yeSByZXNlcnZhdGlvbiBkbyBub3QgbWF0
Y2guIFdoeQ0KPiBib3RoZXINCj4gPj4gYXQgYWxsIHRoZW4gd2l0aCB0aGUgbWVtIHJlc2VydmF0
aW9uLCBqdXN0IGlvcmVtYXAgb25seSBhbmQgYmUgZG9uZQ0KPiB3aXRoDQo+ID4+IGl0LiBXaGF0
IEknbSBzYXlpbmcgaXMsIEkgZG9uJ3Qgc2VlIHRoZSBwb2ludCBvZiBoYXZpbmcgYSAiZmFrZSIN
Cj4gPj4gcmVzZXJ2YXRpb24gY2FsbCBpZiBpdCBkb2VzIG5vdCBjb3JyZXNwb25kIHRoYXQgd2hh
dCBpcyBiZWluZyB1c2VkLg0KPiA+DQo+ID4gVGhlIHJlc2VydmF0aW9uIGlzIG5vdCBmYWtlLCBp
dCBqdXN0IGNvdmVyaW5nIHRoZSBmaXJzdCBwb3J0aW9uIG9mIHRoZQ0KPiBpb3JlbWFwLg0KPiA+
IEFub3RoZXIgaHlwb3RoZXRpY2FsIEZNYW4gZHJpdmVyIHdvdWxkIHByZXN1bWFibHkgcmVzZXJ2
ZSBhbmQgaW9yZW1hcA0KPiBzdGFydGluZw0KPiA+IGZyb20gdGhlIHNhbWUgcG9pbnQsIHRodXMg
dGhlIGRlc2lyZWQgZXJyb3Igd291bGQgYmUgbWV0Lg0KPiA+DQo+ID4gUmVnYXJkaW5nIHJlbW92
aW5nIHJlc2VydmF0aW9uIGFsdG9nZXRoZXIsIHllcywgd2UgY2FuIGRvIHRoYXQsIGluIHRoZQ0K
PiBjaGlsZA0KPiA+IGRldmljZSBkcml2ZXJzLiBUaGF0IHdpbGwgZml4IHRoYXQgdXNlIGFmdGVy
IGZyZWUgaXNzdWUgeW91J3ZlIGZvdW5kIGFuZA0KPiBhbGlnbg0KPiA+IHdpdGggdGhlIGN1c3Rv
bSwgaGllcmFyY2hpY2FsIHN0cnVjdHVyZSBvZiB0aGUgRk1hbiBkZXZpY2VzL2RyaXZlcnMuIEJ1
dA0KPiB3b3VsZA0KPiA+IGxlYXZlIHRoZW0gd2l0aG91dCB0aGUgZG91YmxlIHVzZSBndWFyZCB3
ZSBoYXZlIHdoZW4gdXNpbmcgdGhlDQo+IHJlc2VydmF0aW9uLg0KPiA+DQo+ID4+PiBJbiB0aGUg
ZW5kLCB3aGF0IHRoZSByZXNlcnZhdGlvbiBpcyB0cnlpbmcgdG8gYWNoaWV2ZSBpcyB0byBtYWtl
IHN1cmUNCj4gPj4gdGhlcmUNCj4gPj4+IGlzIGEgc2luZ2xlIGRyaXZlciBjb250cm9sbGluZyBh
IGNlcnRhaW4gcGVyaXBlaGVyYWwsIGFuZCB0aGlzIGJhc2ljDQo+ID4+PiByZXF1aXJlbWVudCB3
b3VsZCBiZSBhZGRyZXNzZWQgYnkgdGhhdCBjaGFuZ2UgcGx1cyBkZXZtX29mX2lvbWFwKCkgZm9y
DQo+ID4+IGNoaWxkDQo+ID4+PiBkZXZpY2VzIChwb3J0cywgTUFDcykuDQo+ID4+DQo+ID4+IEFn
YWluLCBjb3JyZWN0IG1lIGlmIEknbSB3cm9uZywgYnV0IHdpdGggdGhlIGZha2UgbWVtIHJlc2Vy
dmF0aW9uLCBpdA0KPiA+PiB3b3VsZCAqbm90KiBtYWtlIHN1cmUgdGhhdCBhIHNpbmdsZSBkcml2
ZXIgaXMgY29udHJvbGxpbmcgYSBjZXJ0YWluDQo+ID4+IHBlcmlwaGVyYWwuDQo+ID4NCj4gPiBB
Y3R1YWxseSwgaXQgd291bGQuIElmIHRoZSBjdXJyZW50IEZNYW4gZHJpdmVyIHJlc2VydmVzIHRo
ZSBmaXJzdCBwYXJ0DQo+IG9mIHRoZSBGTWFuDQo+ID4gbWVtb3J5LCB0aGVuIGFub3RoZXIgRk1h
biBkcml2ZXIgKEkgZG8gbm90IGV4cGVjdCBhIHJhbmRvbSBkcml2ZXIgdHJ5aW5nDQo+IHRvIG1h
cCB0aGUNCj4gPiBGTWFuIHJlZ2lzdGVyIGFyZWEpDQo+IA0KPiBIYSEsIG5vdyBJIHVuZGVyc3Rh
bmQgeW91ciBwb2ludC4gSSBzdGlsbCB0aGluayBpdCBpcyBub3QgYSBjbGVhbg0KPiBzb2x1dGlv
biwgYXMgdGhlIHJlc2VydmF0aW9uIGRvIG5vdCBtYXRjaCB0aGUgaW9yZW1hcCB1c2FnZS4NCj4g
DQo+ID4gd291bGQgbGlrZWx5IHRyeSB0byB1c2UgdGhhdCBzYW1lIHBhcnQgKHdpdGggdGhlIHNh
bWUgb3INCj4gPiBhIGRpZmZlcmVudCBzaXplLCBpdCBkb2VzIG5vdCBtYXR0ZXIsIHRoZXJlIHdp
bGwgYmUgYW4gZXJyb3IgYW55d2F5KSBhbmQNCj4gdGhlDQo+ID4gcmVzZXJ2YXRpb24gYXR0ZW1w
dCB3aWxsIGZhaWwuIElmIHdlIGZpeCB0aGUgY2hpbGQgZGV2aWNlIGRyaXZlcnMsIHRoZW4NCj4g
dGhleQ0KPiA+IHdpbGwgaGF2ZSBub3JtYWwgbWFwcGluZ3MgYW5kIHJlc2VydmF0aW9ucy4NCj4g
Pg0KPiA+PiBNeSBwb2ludCBpcywgZWl0aGVyIGhhdmUgYSAqY29ycmVjdCogbWVtIHJlc2VydmF0
aW9uLCBvciBkb24ndCBoYXZlIG9uZQ0KPiA+PiBhdCBhbGwuIFRoZXJlIGlzIG5vIHBvaW50IGlu
IHRyeWluZyB0byBjaGVhdCB0aGUgc3lzdGVtLg0KPiA+DQo+ID4gTm93IHdlIGRvIG5vdCBoYXZl
IGNvcnJlY3QgcmVzZXJ2YXRpb25zIGZvciB0aGUgY2hpbGQgZGV2aWNlcyBiZWNhdXNlDQo+IHRo
ZQ0KPiA+IHBhcmVudCB0YWtlcyBpdCBhbGwgZm9yIGhpbXNlbGYuIFJlZHVjZSB0aGUgcGFyZW50
IHJlc2VydmF0aW9uIGFuZCBtYWtlDQo+IHJvb20NCj4gPiBmb3IgY29ycmVjdCByZXNlcnZhdGlv
bnMgZm9yIHRoZSBjaGlsZC4gVGhlIHR3by1zZWN0aW9ucyBjaGFuZ2UgeW91J3ZlDQo+IG1hZGUg
bWF5DQo+ID4gdHJ5IHRvIGJlIGNvcnJlY3QgYnV0IGl0J3Mgb3ZlcmtpbGwgZm9yIHRoZSBwdXJw
b3NlIG9mIGRldGVjdGluZyBkb3VibGUNCj4gdXNlLg0KPiANCj4gQnV0IGl0IGlzIG5vdCBvdmVy
a2lsbCBpZiB3ZSB3YW50IHRvIGRldGVjdCBwb3RlbnRpYWwgc3ViZHJpdmVycyBtYXBwaW5nDQo+
IHNlY3Rpb25zIHRoYXQgd291bGQgbm90IHN0YXJ0IGF0IHRoZSBtYWluIGZtYW4gcmVnaW9uIChi
dXQgc3RpbGwgcGFydCBvZg0KPiB0aGUgbWFpbiBmbWFuIHJlZ2lvbikuDQo+IA0KPiA+IEFuZCBJ
IGFsc28gZmluZCB0aGUgcGF0Y2ggdG8gb2JmdXNjYXRlIHRoZSBhbHJlYWR5IG5vdCBzbyByZWFk
YWJsZSBjb2RlDQo+IHNvIEknZA0KPiA+IG9wdCBmb3IgYSBzaW1wbGVyIGZpeC4NCj4gDQo+IEFz
IHNhaWQgYWxyZWFkeSwgSSdtIG5vdCBpbiBmYXZvciBvZiBoYXZpbmcgYSByZXNlcnZhdGlvbiB0
aGF0IGRvIG5vdA0KPiBtYXRjaCB0aGUgcmVhbCB1c2FnZS4NCj4gDQo+IEFuZCBpbiBteSBvcGlu
aW9uLCBoYXZpbmcgYSBtaXNtYXRjaCB3aXRoIHRoZSBtZW0gcmVzZXJ2YXRpb24gYW5kIHRoZQ0K
PiBtZW0gdXNhZ2UgaXMgYWxzbyB0aGUga2luZCBvZiBvYmZ1c2NhdGlvbiB0aGF0IHdlIHdhbnQg
dG8gYXZvaWQuDQo+IA0KPiBZZXMgbm93IHRoZSBjb2RlIGlzIHNsaWdodGx5IG1vcmUgY29tcGxl
eCwgYnV0IGl0IGlzIGFsc28gc2xpZ2h0bHkgbW9yZQ0KPiBjb3JyZWN0Lg0KPiANCj4gSSdtIG5v
dCBzZWVpbmcgY3VycmVudGx5IGFub3RoZXIgd2F5IG9uIGhvdyB0byBtYWtlIGl0IHNpbXBsZXIg
KmFuZCoNCj4gY29ycmVjdCBhdCB0aGUgc2FtZSB0aW1lLg0KDQoNCk9rLCB3ZSd2ZSB0YWtlbiBu
b3RlIG9uIHlvdXIgcmVwb3J0IGFuZCB3aWxsIHB1dCB0b2dldGhlciBhIGZpeC4NCg0KUmVnYXJk
cywNCk1hZGFsaW4NCg==
