Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9E3AE295
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 07:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFUFH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 01:07:28 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:51943 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhFUFH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 01:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1624251911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X+6otECDTSmS9s6CPZB4RLr5CRV2IjfQPEvksEKyJDc=;
        b=K6nNi1FEs71QLKGqzsWUAAMz3NMvhs04oR+xwPioM67h1GwRc4elxDmsgox1LHtOdohehr
        rPKzY9aJQcL26QjflQOShNym48ApNKxiX9iu6BzGBz4WkRB+LPH4ZNJi0o+dDnZe8uioKQ
        3rrcFHWN30b84zpUJGaQDvh42vQH7Os=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-4J33kvm-NoK3C09A3LSJdA-1; Mon, 21 Jun 2021 01:05:09 -0400
X-MC-Unique: 4J33kvm-NoK3C09A3LSJdA-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB4950.namprd19.prod.outlook.com (2603:10b6:303:f3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Mon, 21 Jun
 2021 05:05:06 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4219.024; Mon, 21 Jun 2021
 05:05:06 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAhoACAAB2SAIAAfDEAgAC87YCAAnCRAIARoG6AgABPWYCAABqdAIAD22mAgAArJoA=
Date:   Mon, 21 Jun 2021 05:05:06 +0000
Message-ID: <298d6268-00d0-cfcf-3689-bd074cbd8e16@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
 <YLuPZTXFrJ9KjNpl@lunn.ch>
 <9a838afe-83e7-b575-db49-f210022966d5@maxlinear.com>
 <334b52a6-30e8-0869-6ffb-52e9955235ff@maxlinear.com>
 <YMynL9c9MpfdC7Se@lunn.ch>
 <2f6c23fd-724e-c9e0-83f2-791cb747d846@maxlinear.com>
 <YM/5z1hgIkx6Fq6I@lunn.ch>
In-Reply-To: <YM/5z1hgIkx6Fq6I@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4471ad9-8bd4-4807-e113-08d9347222e9
x-ms-traffictypediagnostic: CO1PR19MB4950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB495095C5BF732ED853D1C09EBD0A9@CO1PR19MB4950.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: oQZshgCD/WZryXbg5swRtZHf82R3pBX3bJbkjI7Aema6tdirTy/TIlTTLEdZ+pOAYXfwrVm291IoOFOoKPf1vPuwU1rOD9PRc6VP4ZToxq4CJLlPFK65NiDl2D/E0G8eZKz7uSShRPVN4RCHc0B7SqNErHWSpTC9717b3twlpug/swibu6K+2J25lpB80d/bHIr3rwjpPGFLmzjWUIabtJB+lVr99+TTzo2qMFIATyfVwwwb25E6V7QV8Th3QC/PpjjPDKlYwKFaq3i7RlmQsq9lOUQVzGOR3+1obCKYGjT7PFFfwDs8nX7R+vwLO1r52AiRgavkwZSjC/E3jbRj8dNs1CCzc9IgnH0fzfIpRMfMjqvkhNyqnno79Q91xPw5sK9dNhVN9dKvN0VnrBhSd6+F5bpND2RqWrlgZrVrhiUVvq1LnDKQsi5O9JK6aQEq6zCxL6Z3N6fgeygy4IX31vJy8SQ4J7FGgYk0tmbRIzp553txStbkBQmsGQXHxP3/tC9uvJT4z6pbAlVU+HK57oJFDMDqksuZKh9lS7zBDM+0edzzHEhJaYYdpDBZWU1SYWkeRZ3VVN7BNcJhyIM9w3j8W2/K9lXyf5BoHI6ilqJ6O5BppO/8P/Y7x2KlAurnVD31csmPG8fwI7Gk3vpNa0w2IYLhDBVGypzyB6YiQv0OHmzF3V/K3PjzZExGErtK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39850400004)(136003)(396003)(376002)(86362001)(122000001)(38100700002)(36756003)(6486002)(26005)(6916009)(6512007)(31686004)(71200400001)(8936002)(107886003)(54906003)(4326008)(2906002)(8676002)(6506007)(2616005)(316002)(5660300002)(53546011)(478600001)(186003)(66556008)(91956017)(66946007)(76116006)(66476007)(64756008)(66446008)(4744005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHkvamF1cHUyMy91TXdyVDFha1NzNjlBZURaUWdmaU9JMHRoUFVydC9oL0xT?=
 =?utf-8?B?MTdLVk92Q3kzeE5tcmJHK3JCZ3FyVnlRa0xyY09seGVaSlMrMC9jR0lyVkxU?=
 =?utf-8?B?eGNBUTgzZGVHU0hVYzA5QWQ5MFViTlRJKzdjc3ZEbHoyZ0Nyb1ZIMlZ6bUJP?=
 =?utf-8?B?TnFPSXk0SG9SRzNLKytlSUlqTEpaSGRGRWRnQWNDbjh1RTJYeGV2ZXE0UE1X?=
 =?utf-8?B?S3R5Zk9rdWJFcjdnT2QyQkNmQnJUdUFWVldnQ01GVmprdzNuTW9UWnNjUVBl?=
 =?utf-8?B?UGNydG1kdVVDbm9QTWF5bUE2WEdaNUhZcmo2cWlvZGR0QjVzTDdxU0pabTB4?=
 =?utf-8?B?YmJ0aFk0Z3VyNUlIZmJzMzNUYzJDQlJnVHduaVRudjgzeitxU1RrSWFJMG5x?=
 =?utf-8?B?Mmo5aTN2c1psQmJ5YXpSR002R2tyYkZGVW54cmErM2pmMFNQMS9jNGliSFhJ?=
 =?utf-8?B?TVhqMGJRZWlGbU5DYS9KSURXOVRjL2VyeVdwVEJtZ0JmQ0p0VXMwckpCVUdj?=
 =?utf-8?B?UXNmWDdoK01ySVY1YUhLMWkwL2hOYkVjZmhGTjNVekRlaHhPS2lYTjdEUWpB?=
 =?utf-8?B?OWpENS82U1EwM3JEeDlsY0dBTFFlMWk0ZjlOQlhkOGdVSjNHcDMvbnYwbzE4?=
 =?utf-8?B?bFZ0UzNLQ01ZTDZFYTlPV0ZiK01xbTJNczNyOG5IblFYL0pnRzlzVkdlMTRY?=
 =?utf-8?B?aHltcCt2UG9TUEdvUjg2NVkzaW1kRVl2NXR5RGZGem1ZSkdCbXFHeW9wcTRP?=
 =?utf-8?B?cDFJS3VDdDdIVEFMTGtqOHZuN1dCcDUwSDF1VW1lYXVSTklndEcyY0dOME44?=
 =?utf-8?B?aEV5blZPVW1EUUZSVWFwcEFRdW1STWlvMUdEd1hQeWxpN202SEtlNG9PQTUv?=
 =?utf-8?B?aU1mazZZRjg5OUJ1eVJZRlRDK3N6KzA2ejdyYmNkLzV1WHpSc3plMDdPd1I2?=
 =?utf-8?B?QTRqWlpWdDYzQUN2b0ZudHRrUVlCWERKWHNqTEVXUmdtN2pPYTN4aWI1ZE1L?=
 =?utf-8?B?aWhGV1l2MFB3T0RrNGVybmVCTDNzVlEvZHJJNW11SWdMUkpxWWt5N0hHWkx2?=
 =?utf-8?B?SjFpREcvVHIrVENucGpWR0hlaDJEdS8vNnBTM200bkVQTW5VK0VHTU50YW1r?=
 =?utf-8?B?Y0pqRm5WcVUyekgvODhDaFZMa3JGU1hxWUVXVUJxaExwOTdLNVBTblEzVnlh?=
 =?utf-8?B?UTFkRGR5VnJ1QW5hNGRwcDgwUXROYW94TTI5bTJ0Nmg4MjhZMk8vWEZ0STJ5?=
 =?utf-8?B?azFqS3ZHLzB0bW9DZlhuYU1zVEsvZFVvbE94emJIUjcrK2hlZld1cGZObVJY?=
 =?utf-8?B?YnhlMkE0R0VvSTM1MTVEZ0pWSm0yengxZWpHakM0QXJtdk41TzRueFI1a1pC?=
 =?utf-8?B?andDTjhLcStsTUdVSnF5RnRaS2tDT20zN1RScnhEU000Sm1WbWZ0YVcyQWlS?=
 =?utf-8?B?MDVjUm1MODR4WWRBdUpVSTJma21NL093R3RRZHBLNGtFWVBIVklaemUyMmNC?=
 =?utf-8?B?anJ4LzQxS2VIUXdnYVREKzFZeTZlSXVtNnU3WlVkOVhOeW94U3dSVC9RVmFL?=
 =?utf-8?B?dE1tc29UbVpMaUFZUDNYUFlnRk9SaUlrYmNhTW4xY3M2eFd6ZWVHdWQ0Y09D?=
 =?utf-8?B?NlFUdmw0cFE5cWpIV0FVMTBhRWdLZnlVTVhxd1JoeTF0WTdjc0JoNWhCT08v?=
 =?utf-8?B?N21NQmhTd1R1SzNQaStWaWZlMXVDbjFqNUNFS29zcjZWZVlCMHo4UFNQSytv?=
 =?utf-8?Q?0QyxDke8y4UyVPsljY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4471ad9-8bd4-4807-e113-08d9347222e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 05:05:06.4905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E8gwK7Xk/XCO/tzJmih6IjkLkpzY3YEVTm34xz/fmC0IvznVfyNpCM79Cd9Yd0e3u8+db5KVnVI6Vei1RqBT0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB4950
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <BA6BE5A43075544CB3AF0EDD2D43151F@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEvNi8yMDIxIDEwOjMwIGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gVGhpcyBlbWFpbCB3
YXMgc2VudCBmcm9tIG91dHNpZGUgb2YgTWF4TGluZWFyLg0KPg0KPg0KPiBPbiBGcmksIEp1biAx
OCwgMjAyMSBhdCAwMzozNjozNVBNICswMDAwLCBMaWFuZyBYdSB3cm90ZToNCj4+IE9uIDE4LzYv
MjAyMSAxMDowMSBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+Pj4gVGhpcyBlbWFpbCB3YXMgc2Vu
dCBmcm9tIG91dHNpZGUgb2YgTWF4TGluZWFyLg0KPj4+DQo+Pj4NCj4+Pj4gTmV0LW5leHQ6DQo+
Pj4+DQo+Pj4+IGludCBnZW5waHlfbG9vcGJhY2soc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwg
Ym9vbCBlbmFibGUpDQo+Pj4+IHsNCj4+Pj4gICAgICAgIGlmIChlbmFibGUpIHsNCj4+Pj4gICAg
ICAgICAgICB1MTYgdmFsLCBjdGwgPSBCTUNSX0xPT1BCQUNLOw0KPj4+PiAgICAgICAgICAgIGlu
dCByZXQ7DQo+Pj4+DQo+Pj4+ICAgICAgICAgICAgaWYgKHBoeWRldi0+c3BlZWQgPT0gU1BFRURf
MTAwMCkNCj4+Pj4gICAgICAgICAgICAgICAgY3RsIHw9IEJNQ1JfU1BFRUQxMDAwOw0KPj4+PiAg
ICAgICAgICAgIGVsc2UgaWYgKHBoeWRldi0+c3BlZWQgPT0gU1BFRURfMTAwKQ0KPj4+PiAgICAg
ICAgICAgICAgICBjdGwgfD0gQk1DUl9TUEVFRDEwMDsNCj4+IFRoZSBwcm9ibGVtIGhhcHBlbnMg
aW4gdGhlIHNwZWVkIGNoYW5nZSBubyBtYXR0ZXIgaXQncyBmb3JjZWQgb3INCj4+IGF1dG8tbmVn
IGluIG91ciBkZXZpY2UuDQo+IFlvdSBzYXkgc3BlZWQgY2hhbmdlLiBTbyBkbyB5b3UganVzdCBu
ZWVkIHRvIGFkZCBzdXBwb3J0IGZvciAxME1icHMsDQo+IHNvIHRoZXJlIGlzIG5vIHNwZWVkIGNo
YW5nZT8gT3IgYXJlIHlvdSBzYXlpbmcgcGh5ZGV2LT5zcGVlZCBkb2VzIG5vdA0KPiBtYXRjaCB0
aGUgYWN0dWFsIHNwZWVkPw0KPg0KPiAgICAgICAgQW5kcmV3DQo+DQpXZSBoYXZlIDIuNUcgbGlu
ayBzcGVlZCwgc28gbWlzbWF0Y2ggaGFwcGVucy4NCg0KDQpUaGFua3MgJiBSZWdhcmRzLA0KDQpY
dSBMaWFuZw0KDQo=

