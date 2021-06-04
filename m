Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E40139B922
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDMlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:41:15 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:27773 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhFDMlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 08:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622810367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jv1nQTO4qittmgHzrAj1jGHd3JWw1a/QRQWPG2XkMyE=;
        b=bCm52BXSNGcpcfNk7vc5zrju2CuARVdLW306QUp3sUmbsFKKlNHInC0r+o7wgxgvr51e/K
        jfRJfn9HZwT4oUeRCOC2QnWMmXcWY0nUOLJzcUHS7WHXODSakVQVwDuWz3tDV5CxlslGUn
        YPBnbkBrGKwCqdwsdgSiRTlO0KPVsEE=
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-egPoAETeN3C6lyBcVlI9dg-1; Fri, 04 Jun 2021 08:39:24 -0400
X-MC-Unique: egPoAETeN3C6lyBcVlI9dg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB5062.namprd19.prod.outlook.com (2603:10b6:303:f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 12:39:22 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:39:21 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsCAhAAgABiiACAAAMRAIAAAx2AgAAaBQCAAA2gAIABMgEAgAAIRoA=
Date:   Fri, 4 Jun 2021 12:39:21 +0000
Message-ID: <79cd96b9-4724-1f34-55cf-9faf1d7707ed@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
 <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
 <YLjzeMpRDIUV9OAI@lunn.ch>
 <1e580c98-3a0c-2e60-17e3-01ad8bfd69d9@maxlinear.com>
 <YLkL6MWJCheuUJv1@lunn.ch>
 <627eca5a-04a5-5b73-2f7e-fab372d74fd3@maxlinear.com>
 <YLoYCEut5MIzikUQ@lunn.ch>
In-Reply-To: <YLoYCEut5MIzikUQ@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [27.104.174.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 138378a6-6909-4605-a856-08d92755c75b
x-ms-traffictypediagnostic: CO1PR19MB5062:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB5062B15FBA18B8D0D05B6430BD3B9@CO1PR19MB5062.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hiZny4i9Wne+CmNRYc+sB0nj9psnpNj2BxqonlnN5UirEnXEKxwrB6SzsqXkwBf7SddbEXTEXslACPiLX1CHfe/IGfurGTAMG1733gquDFKfMR2npmNQR3QOoX/Two4Chqjh69vxnQVVHRRwo6Oo9uD3LTgVI9mHTv9KqY5XS44e6I3Cpl4naZ/nCfGk3XfutD7zR1jUWYHwE/vJWxFZmIrPKcaV9RS2L7cPdlBp6ZvFn2Poxt2PSdny0prOgV4RNH2O6Xs9e88N5pZPo+NRD+LDWM55hckO0r8MaLPPI23dEb3BlZcAyHY1+n+R8DZi+siY+XljEeSoYC9u6sIw8rDzCOVDb5l/XBEe47UTaoDQUvedS9KnS0WIFQQXqfHMDwW6S1emXlTILMnWSzUooLrLAZZAVGXh6T/0wucrzmbNB3mdN6LOVlauy42WEO2JPdCoavuKMb9J6dsbYoniO01fupQq2XS/BvK8gOTPqqpLFtU1vx0HJ0HrXnvOM4OjAPl4GLUoZQT3PAPAQVRcBvafUrPnM98bRIZLFavsQIu82JLLub/c1X/7wxW7LIqn6pMUQ7dO91At2wqTvdPaKOy4+9/LCYcSeX2hTKflqOZ3F5i4uOg59X9XbcGIJ/EE95G+PfdjifFZJrBMfJqV/V+AZ+Qu1e4Wx0dKiMw2TXzcBuXIS/XynfBfwtwrO9p8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(76116006)(4744005)(91956017)(66446008)(122000001)(186003)(26005)(71200400001)(31696002)(498600001)(8676002)(8936002)(66946007)(66556008)(66476007)(64756008)(4326008)(54906003)(107886003)(2906002)(2616005)(6916009)(36756003)(6506007)(53546011)(86362001)(38100700002)(6512007)(6486002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?OE1oOEJxaHNzcXJGQlFBY2JVdGRYam0yR2trbmZpLzdKQ2dwQUF5MldzU1ZL?=
 =?utf-8?B?OXJKN1hibzhBS1FKR1pISnlqSkNZMXdvRzhtRUdHbDFWcnJMODNBbUdxVi9H?=
 =?utf-8?B?TEJPN2lEaGJvSDVXQzN6OW1LMXdkZXJia3cwckwyY0pVMWdaMjFQRWNsRE10?=
 =?utf-8?B?NDk0aDY3L3l5MXhHS0xzbUhMWjU4MXQ1WG9aeGxxTk9ub0dBbklJVmp6Z2Fx?=
 =?utf-8?B?cENtSmNnaWloSCtYVEhjVTFQYUk2NFVyWXRHYkU2UlpqYmE4ZnNrdHJ1cnBo?=
 =?utf-8?B?K2JMYS82MklpMHUzaFR0N1A3TDdIbWRoUVI4MEtjWklvN0VhYit4RWpnSC9E?=
 =?utf-8?B?aHo2TklOOVZSc25UNzFPOCs1allnMWg3RlpoVHlpcG9oQjdGeGZaQ3lDaFAz?=
 =?utf-8?B?YU1JZ1hwT0t3d2RXa0VPbFkrRjNYOHE5eUhUVS9teElVa09UbXduVzhsSXgr?=
 =?utf-8?B?Z0grU2RlcXJmV0YyS2pnMjRYOU9YU3l0RjhaSGpscnlOSEpQaUdJZTVUNW1w?=
 =?utf-8?B?b2ZBVUo4R091OHg2cG1zR3ZlSTdJVUJMcjRrdXdhU3NvRnE5ZXJpbjJLWVcv?=
 =?utf-8?B?RXhVRjdaOVpDRVUrL2tyRi9Vd0JBTHpPS0pFaEQxY2ZaOVhnS0V0akpQa2Vr?=
 =?utf-8?B?a1lkT3FvL1RwMnk3Nm9Wc2lyQnQyazJSYTRDYUhEcnVMQ2tPVE5OS1NUcHJq?=
 =?utf-8?B?SS94Qnpqb25QTDVCUE90RlpscEsxWTNGZlMzQjFwZnRpdGhQbHV3cEZVWVNo?=
 =?utf-8?B?aGphYm9GYTBQazVUbWZvaGJrb1Y5bEpHYk9lQmtVOU5mUDBVbm01MklUQlVw?=
 =?utf-8?B?U2lRdVNabEo5bEx0ZUh5ejFUbktKZk9OOGFuK2hrdlY2QVRDQ0NRRExneXRN?=
 =?utf-8?B?cXRWRmFvN3lUTE0ySFY0TEF5bmZId2p4ZFE2MmtSVkczTEpKeXk3aTFwUHp0?=
 =?utf-8?B?UFNTTmcvQm0xVjZkT1B0azBQbnpUQUVqZlFKaksyT1Jncy8wNFNKdDRQZ2ZR?=
 =?utf-8?B?Ujl3TmUyY0lOdkJHRFoxejVaUkxHbHdOaFdKT0tONnNjN2dQeE5CV3A4Y3Z4?=
 =?utf-8?B?aGpPZWZtV0NyQmhqbWFEcFFEVklaSWpoY0t2SHdBQlNJa0N3M0N0NWI2Smt5?=
 =?utf-8?B?dGlpdE9iOHVqODlmZE5XU3YrUEJhYStkR0JIRUdmdlVyR3JHY2UrS0tLNkIw?=
 =?utf-8?B?TXFlK3ZZeW9pYlpwU3ZQNll4T1Zsby9HVTVhcjY5VTlEcXFYUzRsMUxlaWI1?=
 =?utf-8?B?NlJGOHVNbDNxSXFBcUpMTnFlalYzWUh4TlQ4ekFpK2Y2TXRrVGdDSDVuSk54?=
 =?utf-8?B?Qy8rbHBrNndBTUtEdkU4LzFkeXBIci9tZ25LNEJjVi9vdnNDVGR3TEd1SG9n?=
 =?utf-8?B?c3o1eFRhMGFTaytGUFQ1ZFJhYjRuOXF2ODJPd2w3ZFJXaEFuclEraURjM1ht?=
 =?utf-8?B?WTVqdlFSZDE0VjE2ZnBRSXcwQ0RuWDdtc3VPdFlLQ0NQcmUzNFZJYTZyay90?=
 =?utf-8?B?RUEzNjZIeEtrZm5OZVlqS3NZQTlLZXFLdmlqWEVzUnd6QTVadS9RazZML3Jp?=
 =?utf-8?B?UUJGTkdFZ1ZLa2ZIWDlKLzA2K1NISWx4elR3eDNyb3ZhMEFqOVRjblVOMjVZ?=
 =?utf-8?B?b3Y0Rks1UU9oUWtUVFFrRDFpNSsxb3M1Y1h1OXlIQVowYm80c1daTDhZeTZS?=
 =?utf-8?B?Qm0xa3o2NWlRY2c1cllTZkx4N3VQUjJrMVFLcjJXTXBDK3ZtVGtDdVBGUHBP?=
 =?utf-8?Q?PvUGmFbuUSACbBVNtIE5T8nZlryFif0LchDHqDB?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138378a6-6909-4605-a856-08d92755c75b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 12:39:21.8403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9SO2sHOUkYpk05hW9RE0Sn+9uxPvGDu6UP+BOFE6ySSDSoz9K0CT6kEgA3faBiOJDIJCQ+4vDeEZPXJtiQi/Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB5062
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <67DD0040B543994EAC2161082D587145@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC82LzIwMjEgODowOSBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4+IEluIG9uZSBvZiBvdXIg
cHJvZHVjdCAoaW4gZGV2ZWxvcGluZyksIHRoZSBOSUMgZHJpdmVyIGNhbiBkZWNpZGUgdG8NCj4+
IHN3aXRjaCB0byAybmQgZmlybXdhcmUuDQo+IFRoZXJlIGFyZSBjdXJyZW50bHkgbm8gc3lzdGVt
cyBsaWtlIHRoaXMgaW4gTGludXguIFNvIHRoaXMgaXMgZ29pbmcgdG8NCj4gbmVlZCBuZXcgc3Vw
cG9ydC4gSWRlYWxseSwgd2UgZG9uJ3Qgd2FudCB0aGUgTUFDIGludm9sdmVkIGluIHRoaXMNCj4g
c3dpdGNoLCBiZWNhdXNlIHRoZW4geW91IG5lZWQgdG8gdGVhY2ggZXZlcnkgTUFDIGRyaXZlciBp
biBsaW51eCBhYm91dA0KPiBob3cgeW91ciBQSFkgaXMgc3BlY2lhbC4NCj4NCj4gSSB3b3VsZCBz
YXksIGZvciB0aGUgbW9tZW50LCBmb3JnZXQgYWJvdXQgdGhpcyBzZXR1cC4gV2hlbiB5b3Ugc3Vi
bWl0DQo+IHN1cHBvcnQgZm9yIGl0LCB3ZSBjYW4gbG9vayBhdCB0aGUgYmlnZ2VyIHBpY3R1cmUs
IGFuZCBzZWUgaG93IGJlc3QgdG8NCj4gc3VwcG9ydCBpdC4NCj4NCj4gU28gcGxlYXNlIHB1dCB0
aGUgZmlybXdhcmUgdmVyc2lvbiBwcmludCBpbiB0aGUgZHJpdmVyIHByb2JlDQo+IGZ1bmN0aW9u
LiBUaGF0IHNob3VsZCB3b3JrIGZvciB0aGUgZGV2aWNlcyB0aGUgZHJpdmVyIGN1cnJlbnRseQ0K
PiBzdXBwb3J0cy4NCj4NCj4gICAgICAgICAgICBBbmRyZXcNCj4NCk9LDQoNCg==

