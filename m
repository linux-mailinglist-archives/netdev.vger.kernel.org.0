Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B0D3A7AFD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhFOJq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:46:29 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:25376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231187AbhFOJq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:46:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1RRct21LlV5pK2SmykrqDILrliC9BhqycfV/l4xuJMwPwtpV170CQVEvcApAN6YUOpAvuYCXKZKnOksqg2HxSiisrBPJNRkew3zzx+4ND61B8p6dj8G+w1wGFWd5zLlRU7X/M+jUotclP96YGWMvfdvBrsREWc5GB08xtMeX1woAw0pzsUdRtb+SSaqUlD65y4TBw0TL3AYXvS3AdhgpAx6Z3ckfng24LRr84FLZ240EXxPSJkH73wteqyz2tPiKPCeH1FC+GOHLOKUMfze8OjCv24TekKEenKm9RlQfQWtAlBbTrNUyURcr5BM8P5H6eOZ1rhwp9HwKrMnQx6FFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCWjFyxqUrLIsvR8UxOZfR0MZmWoEauRe6P70QlbyW8=;
 b=dnXXSSXMnEe/wJIoa81HPofxSeLPcE6bvwD0/3E0gKwCVnWbFcqL17kbNwYTB9sRLuefDzQSNFlIG+S4rLSVGN1yNts8tBhBqN2DNXfUmR8lWkCpKXlBWRntk3AhnhePrR/d2lc+ENClLx4SCfqiQgjCkEkwkt3KKXohxrqGdHDUGhPJ8PVJk5lfGhXgOMHxkBaGeQv3Dz5gXvpwbN1gnQC6vWJsSDEPjKHD5w0+Nj399v8A50eCz03PFr3jelg780j3ZVPHFKUpm+YxK9itzU2iOZkck9CehlmmH1v8FUWu3cnOZ9cvb/pHrqApHz0Omnz2/WLNJGFrh0UmCF+1yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCWjFyxqUrLIsvR8UxOZfR0MZmWoEauRe6P70QlbyW8=;
 b=MCJMeB/PFm/5zGoEQOQZv5eqCYlPOwsGDwEhmfY5c3tadTPAAztLyfRNID0PR6A+xJCqhoJ/QsAWZ7Bce1gnxmmeR+yUPtfF5tcGbt0A3tIDKTZmT6EiDIRO2xirmEp3/k2o/BvltaGbcaOSQPUL6qhLN39zpR2q8lVH7V2/YBQ=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB7PR04MB4011.eurprd04.prod.outlook.com (2603:10a6:5:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 09:44:19 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 09:44:19 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Topic: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Index: AQHXTfl8MjjmUYWreESzJP4N6mmsJar0KWqAgAADPwCACU1i0IAAMYOAgBdM6FA=
Date:   Tue, 15 Jun 2021 09:44:19 +0000
Message-ID: <DB7PR04MB5017DDA1D4A01D4629CEB670F8309@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
 <20210525124848.GC27498@hoboy.vegasvil.org>
 <DB7PR04MB5017E8CEA0DA148A4EB1EAF9F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210531134919.GA7888@hoboy.vegasvil.org>
In-Reply-To: <20210531134919.GA7888@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b635153-71f6-40ce-e28e-08d92fe225d1
x-ms-traffictypediagnostic: DB7PR04MB4011:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4011CF4499BF74634B02ECF3F8309@DB7PR04MB4011.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uMh6fPW3eVc+rJBnF0MEAdHSnEVWRXUfpm7iH38EfeU0vaBoQgZMwIYU2xni4Uu1mf5X4JPPbGdJkHUSvOWi7etQ9i+RPv8SZ2wOXpn4rui3DeO9DXw6f+YKI7XsAJg0VqCi1PvLj1pcAdeWJWXGCg2ugPJy3ROshnJRH3Wpjp3+lTLqvNGUnAZUN7YSUbR6RLP5acpYMrcZaYsJ8tmBEWNZD9un8URiAd/d/rMEwzKpyotGEi2OBNUv7Cd9UC7Z50v2SwG7yJAGHCxDmmxlKxyRlRyfonDl/jk8SFKYvM6nqDh7IdvvG2Yva35kiKfsNlbXgKuNX3zpaT88EGJrdGXBt+aM662bn00sqNIewABJcKoaQaUF10Y6pud0v5MAVQK9SjQKBW79xk00cvBEkUBx3ifOGExFKJKprdhlZk/ZQwnJjH6J8wLVS+qpkEoyAQyi2uH7UOUetUGd7zjAi3TMLD5aNnaLg13oeApZdwC5Ua4RwRGgiFcc/NsPuJEz7KA7rAAyjBwTNzHh6MaRnEIQl+aSrwW+MPnnZI6y70YLIfFq5Mfu3xoYX4OoJ4VnG+paSUm9A6BG3kMmlOQLyRdSQse8dZYE+2EkWRYOP3g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(8936002)(316002)(478600001)(64756008)(186003)(52536014)(55016002)(122000001)(2906002)(4326008)(38100700002)(7696005)(83380400001)(86362001)(76116006)(66556008)(6916009)(8676002)(53546011)(71200400001)(6506007)(54906003)(66446008)(66476007)(66946007)(33656002)(9686003)(5660300002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Yjl2Mll5S0FIUU5NRnBEbTJIQVpnT1BkblBkNS9RUTcxbXlraFFIKzF2OUJO?=
 =?gb2312?B?Y2hPN1k5TTlqRTQzdE9YbDVMdXZZUVE1d3d6MFlGeTFiamQyQmxYbzFQSnlj?=
 =?gb2312?B?YzlJUkpvbGFtbG9Qak1zVVFuM3VuM001UjVjQ3F0elQxOUJqWUhEZGNyWHZ6?=
 =?gb2312?B?SHZFZmFaNFNGb3VSNW0zZWpYTHpWSVhXSktJUktrV1FtUkdhTVhhb0NYMUVh?=
 =?gb2312?B?bWF5VnNMUTZscG9CSk9PMEcwWUtZK2FzMHFlMWZ4WFdWd01wVkEvcE9UNHo5?=
 =?gb2312?B?WEg5dDVnRXV6WVduZmp1amsvUUY1ZEtZSXROaEx3STlHWXhKS3FXWmhhU3hK?=
 =?gb2312?B?clVPcENnN21EWURWa1lQQjJaZjU2OVFZOU5FL0pRN3JxcUp6ODZ0a2ZFVnhw?=
 =?gb2312?B?cFIwbm1MZmJnQlJ5RHVHdG16bmFLMTdwNmpwV2dHY3hiQVRHbGVEdk1xKzBM?=
 =?gb2312?B?Q09kYXdzTG1wQ1pqbUhkalUrYktPNmtIN1k5VDVNVWZaN1REVFpqQWVyc0ph?=
 =?gb2312?B?N0xmYjFzb2FaWmF4NUxmM3pjQTF5d2VIdUd2TzRuaGlGVHBwNWc4Q2lraldS?=
 =?gb2312?B?dEVKb0NpdDdpbzY3aURLTy9vWU5kMjVaeWJ2dE45dDZuQVZNcUdPZ1puT20y?=
 =?gb2312?B?MHA1NVJsVGhGTGVSalVlaGFsc0xwRmhPYTAzWVFnSUdFQVc0WVpUc05Bc0Jy?=
 =?gb2312?B?YlV4cWJRZEZLVTBDUEoxanplanEyT3gwLzkvTWxaS3BQRER4K01mVjBNay9O?=
 =?gb2312?B?Z1dxRzg2Wkd6RjdjLy9jZ1JONW1zVXY2V2RPNFBxcDFQYWFCeGV6eG1zanZU?=
 =?gb2312?B?K2ZYQmJiVkU5WmtvZHZJT2VNa1JtakhoY3dUS284UU1OWGIvdFVFZ0RVVGp5?=
 =?gb2312?B?RnMyZzZNUExTV1ZFNlV3U0VVUUppMC80TG9yMGp6WFNiS0p3ay9EYllRM3F3?=
 =?gb2312?B?dDdObW82MmZxUEZudGo5VTJXbW1tdktDVzFabnU4S0syb2g2dlFIa2tWaWJ0?=
 =?gb2312?B?QTdQb2UyTzBYTVRNNmIwTUErcXhsOVhJNTVhS1NiNWhWcjRrOEp3NUwvNlR2?=
 =?gb2312?B?WEFPdUJzMzh6eTZoSlhhQ010c1N4Tmg4RHNtdjJYZ3pKUUc5K2RSaGNiVnIz?=
 =?gb2312?B?UEIwR01pTVhxZmhQRm8rVnd1RldhbkVBSzdSWUZIR1BITUNHa1J5OXgvMUpu?=
 =?gb2312?B?VzROR2NEdkhDb2Y5eUc5NWtNM0dlT2kvVG9ySnVOVGpEekdqd2tMZDdwRGFI?=
 =?gb2312?B?eHU3OElaUk5RR0xRM2lqZEJvbTZEMzc5b05WMEJCSHJ1NEVKL2IrZUJHd3Ax?=
 =?gb2312?B?T0hxYmxyRmgyb0Q3b1RiZHRQTGxEQzBDSndsa0xzYUhlUm95SVZ3czREbjgv?=
 =?gb2312?B?ekxUVHp5bUtmb3FKcnpTY1lpSmlpSXpkcld5QlNEQlhiR2NDTjdtNkdKRGZE?=
 =?gb2312?B?TnRvdC90NG1jNkpzL1dvYWFsdHFPSTdVOFZlK01sYW9PQXhYVkVLZEZCWGdj?=
 =?gb2312?B?RjFaTGt0Ukg0dHovVDdmZjMwdW9TUUNWVW1XMlo2ZzFIYm1FNkZEcjlIbGFZ?=
 =?gb2312?B?dFllV3A1a2M3Wmp1OGNTU0RWMDYxZ2x3ejhuMTBIb3RjZXlxRXJVL2s1Yzlo?=
 =?gb2312?B?Q2JzV29IUnB6VW9qaVdxR2xvUlgvd1lZWlBiNUpCcUFoUlBwbENxcDNuSXc3?=
 =?gb2312?B?d2xRemJWdVBnNG8wUHEyMjdmZDUybUNoZVk5ZnN6eHlGNlkvQ0t0MmlCM01B?=
 =?gb2312?Q?0Lhx3n6kOoHCKBs/KxkEV0Y+ZS37VZIIE6yx9FB?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b635153-71f6-40ce-e28e-08d92fe225d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 09:44:19.2182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 08xuBzlQfWaW1/MVMBPwIPQ5qH/KDDBLkHljV/lU11cZNfVrB1g0f7DPu4qPaKJHNT0nTGGnhKeYtnV3Fuej8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTC
MzHI1SAyMTo0OQ0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0
PjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBKYWt1YiBLaWNp
bnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MiwgNy83
XSBlbmV0Yzogc3VwcG9ydCBQVFAgZG9tYWluIHRpbWVzdGFtcA0KPiBjb252ZXJzaW9uDQo+IA0K
PiBPbiBNb24sIE1heSAzMSwgMjAyMSBhdCAxMToyNjoxOEFNICswMDAwLCBZLmIuIEx1IHdyb3Rl
Og0KPiA+IFNvLCB0aGUgdGltZXN0YW1wIGNvbnZlcnNpb24gY291bGQgYmUgaW4gc2tidWZmLmMu
DQo+ID4gVGhhdCdzIGdvb2QgdG8gZG8gdGhpcy4gQnV0IHRoZXJlIGFyZSBxdWl0ZSBhIGxvdCBv
ZiBkcml2ZXJzIHVzaW5nDQo+IHRpbWVzdGFtcGluZy4NCj4gPiBTaG91bGQgd2UgY29udmVydCBh
bGwgZHJpdmVycyB0byB1c2UgdGhlIGhlbHBlciwgb3IgbGV0IG90aGVycyBkbyB0aGlzIHdoZW4N
Cj4gdGhleSBuZWVkPw0KPiANCj4gSSB0aGluayB3ZSBzaG91bGQgY29udmVydCB0aGVtIGFsbC4g
IFllcywgaXQgaXMgd29yaywgYnV0IEkgd2lsbCBoZWxwLg0KPiBJIHJlYWxseSBsaWtlIHRoZSB2
Y2xvY2sgaWRlYSwgZXNwZWNpYWxseSBiZWNhdXNlIGl0IHdpbGwgd29yayB3aXRoIGV2ZXJ5IGNs
b2NrLg0KPiBBbHNvLCBhZGRpbmcgdGhlIGhlbHBlciB3aWxsIGJlIGEgbmljZSByZWZhY3Rvcmlu
ZyBhbGwgYnkgaXRzZWxmLg0KDQpJdCBzZWVtcyBzb2NrZXQuYyBfX3NvY2tfcmVjdl90aW1lc3Rh
bXAgbWF5IGJlIHRoZSBiZXR0ZXIgcGxhY2UuDQpIVyB0aW1lc3RhbXBzIGFyZSBoYW5kbGVkIGlu
IGl0IGJlZm9yZSBnb2luZyB0byB1c2VyIHNwYWNlLg0KSSBzZW50IG91dCBhIHYzIHBhdGNoIGZv
ciB5b3VyIHJldmlld2luZy4gTWF5YmUgd2UgZG9uoa90IGhhdmUgdG8gY29udmVydCBhbGwgZHJp
dmVycyB0byBhIGhlbHBlci4NClRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNCj4gDQo+IFRoYW5rcywN
Cj4gUmljaGFyZA0K
