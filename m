Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858D839DD92
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhFGNaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:30:24 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:31234 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGNaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1623072510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLZwAMPGB8EcN2kPV8gb8ibpTRMhi2INMS9MbQebcDo=;
        b=GuWcEsOgPnaRNULADMYbhFfwj1kRgy3YL68/5ioHrTCwsltsxGcPOQtf3hmVFT4ebIWBOf
        GNiEfg9NRzHmzuJ+VqSD2t8inh9/NqH7re2yVRj6vToivuMj8SYZHU9PYp3O+dVGYDazHU
        NhqE5EJg2XHAJc3KpAOxl+C+w6ID680=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-0CH0ARUnNjqAXZ2mYnK2lg-1; Mon, 07 Jun 2021 09:28:29 -0400
X-MC-Unique: 0CH0ARUnNjqAXZ2mYnK2lg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MW3PR19MB4201.namprd19.prod.outlook.com (2603:10b6:303:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 13:28:25 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.029; Mon, 7 Jun 2021
 13:28:25 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsDxf8AgAAKPYCAAIK/AIAAdxsAgAC11ICAAnP2gIAAiT2AgAAUSAA=
Date:   Mon, 7 Jun 2021 13:28:25 +0000
Message-ID: <aa8c628a-b0fc-a938-42a6-364f63031e1d@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <YLoZWho/5a60wqPu@lunn.ch>
 <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
 <YLqPnpNXbd6o019o@lunn.ch>
 <f965ae22-c5a8-ec52-322f-33ae04b76404@maxlinear.com>
 <YLuMDyg2IIpalOIo@lunn.ch>
 <f329dca8-9962-0b43-eaa7-cbed838d5dc0@maxlinear.com>
 <YL4N9XMFKOrRdH4l@lunn.ch>
In-Reply-To: <YL4N9XMFKOrRdH4l@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b08dd6ef-5fc1-4ba3-296b-08d929b82102
x-ms-traffictypediagnostic: MW3PR19MB4201:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR19MB4201AE2CD2726C405D9CBCAFBD389@MW3PR19MB4201.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: RvKifMsjtP6CJGVdkgXGkDdhytGk8TU85Mfk5oxXjoSpvgJWKgYX9iHL/0CV0wcWW/njIYtZQb9KgGMm3NJ9kJzCJAx5RmYuvoRvSngDZ3LooqTTHe7B6PLroDMw4kj28lmfiFgsk5snYLgMSqXcZxiUYTt821trsCtWM6zpPfopyV9Vp7hN/4LSmsVTtz+h9bYySIigEm823+7Yx+ne7YC5QZkryaexkxT31tfIYzaOJYzkAUExy6BrcSM0zJzmJSq7F/A13vH287QgJwY/eDKYtFi8F+SKQeJVDK2znKRT/YkPHer/Ew10Fp/CkN5xONKtdsrIY7jwZ4Q28VH9AejSD3TL6KJM/pS/QSoYw4G7/MutDBrd9Pe361ONA3/VWva6x1rJxXEtsUvbc3gFvteyS8gbEqLeaFqAoCAy1CfNqefvTAGJ9cx11SZ8nOpsd4nhyAiw4h6xYr2/xb3VhheNTGaWjFcvAEzayh3OCygPRK/SQ6A/xGXrJW+CsMPXLLWv9VZUhot8l+OnEQe4f9xhe0su50b/BHfCUlqT+b7sbZOGgfMyQZZiShBezfKH/i4mvBhaKr4JzrOib3fzsWDgxixT7dlOQ5vqWL2Rr8GpLwF5R6DSHrg0soyquGICBIvtmrcatTwUBREQqnmWTWjJThj4IzsEyDY7f87eNrEnT0jT4WmG3T9nWClkAo+1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(376002)(346002)(136003)(36756003)(6916009)(26005)(186003)(31686004)(91956017)(76116006)(66476007)(66446008)(66556008)(71200400001)(6506007)(53546011)(122000001)(6512007)(478600001)(66946007)(64756008)(8676002)(2616005)(6486002)(107886003)(54906003)(2906002)(5660300002)(31696002)(4326008)(4744005)(38100700002)(316002)(86362001)(83380400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?bktqSStMRW5LQVk4aks0cnd0R1Z4TWFGeHRHMlgxdGRYd1hlU0I2TytlSFFU?=
 =?utf-8?B?Mnc1MUdENmQ3Q1Q0UmZValRwNjIxUDViVm5xV2hvano5WjBkTGdYVm9qTW9O?=
 =?utf-8?B?bmRzYUpLK3JtM0s4aVlYS3ZON2MxaUlJRVpZczB6SDV6eVp5a0hOcjRHRncy?=
 =?utf-8?B?QzV4V0lxeVoxMGxTR3ByVXJTNVRxSE9ZLzFDUVBPL1hiMEJKU1J2YXF1ekJM?=
 =?utf-8?B?WjRPK1dOQmYvTUlMQnorRUZ6NG1TTzRVc0EvTjN3Q2dteW42bTRzRWxoOWU2?=
 =?utf-8?B?a1BKcnpPaFJiWFhkRlRNOEFGOFJkZHZhNVhBRUhueWFFRzBXeTI1UjhjV2lR?=
 =?utf-8?B?S3ExRkszQWwrN256akF0cnFhSlk4V0hyeUFSRXRZcUdpZUFvcjVac2E5RFhP?=
 =?utf-8?B?Y0h1bDhrMElpWENpSlREclp2elNSVytuOCswcHEzdENZUHVsYUtHT3RybHVO?=
 =?utf-8?B?bDFiYzVhRmtMeTNLTGlVYkF2d1FiWEhCT3c2TllGZitidTFZTGFxZ0kvNkIy?=
 =?utf-8?B?UXp2cGhpYy9Mc0kxR1QwRW9LT1BJZTVlRlRtQk83alAxaU44amlJcGJMSDdQ?=
 =?utf-8?B?ZUxmSG16dDhUaFBIaHRKZXlhUEZtVnlPdnhqWXFKKys4ZmVUMVQxd0ttTDlU?=
 =?utf-8?B?akFnNnlHaE1HcC8rV3VTQVBPWVI4Wi8wcVBQOTFaZGUxeVJrYUl5b2xhc1FR?=
 =?utf-8?B?S1Ftdlc0VEw2RjlqcHI2S1A2S1RZRlFHUDh3TVhvWlVSNnlZbUExN0hpOFA5?=
 =?utf-8?B?NkMySFdOcXJqUVl6ek1wZ2M1TE9YMVd3R1JkazNBY2VWZUh6VGJvZ05Ca2xN?=
 =?utf-8?B?N1oxTWFmWGhQMEtDeTZUMmZ1Yi9lNFE2cFBscnNJT1RRQ3dQdlAvNUJ1QmhI?=
 =?utf-8?B?YTBVNEhZUlJBK01pckhidGpJd0lwbWJlWmFFM1JjU0NCY3JJeExlQ2JtNUh5?=
 =?utf-8?B?Vlg1Ni92dmtjd0pYZmdlTmNuZDJ4QkJDYWhybGYxUWNFUHlWOStOajYvNXdh?=
 =?utf-8?B?Zml2QjhRWE1pU1JndDZQVUkxcFBib3l2aVViN201QlM1UzgrY3d5U01UVGNw?=
 =?utf-8?B?ZTl4RVhhWHliQkxaWjU2S1VxbDl5Q0tRQ0RKUytYM1hUb2QrQm1yMzNoWFNn?=
 =?utf-8?B?dUJxNldxSkQycTBWZmpQWmM0NmxUTEJxZGFIN0N2VzFvMGRtT0cvYmhzMlla?=
 =?utf-8?B?TXNqVmt4VXFUenB2ZE1HcGxyQU1tV0lITC9oMndBYjFFdkQ5MVVOQko4OEVx?=
 =?utf-8?B?aEFVZzVBdjZ6NUdveU9vVGxCSG9GQTNzUEpKdjRtTVFmYWtaV1BwTllCdzNa?=
 =?utf-8?B?ekRYV0g4T0xnT1dhd3h4UnNvZDVkejRzWVZoOVZ1RXcvYlBvZk83R1Y3a21w?=
 =?utf-8?B?UHArMVlHTjJlZmlkeUdFTFRQc0dieFlHNDZYejB4bk1RYk9WSmpzajFsNEpG?=
 =?utf-8?B?WUJuOGNIekEwaFg2QW01Tk9wd1pGS3lNaERGT3QrMWlZUVUrQ1owcGUrbjND?=
 =?utf-8?B?MjY2NGJVdElnMWFZMkZhaloyK3FrR1M0SjNnSHJUK0ZVbkk3dHVhV0R2SUth?=
 =?utf-8?B?eHJqSkVGU3VJRlM0cUtsd2FKRGFxM1Q5TmpzYVQ4d0tuYXFZNmJHTkJuVkc3?=
 =?utf-8?B?c2xEd09yQ2lPVTByRy9WaDV5WXorZDNGZ2RpbW1WYzQ1bU94M3R0dVFqK3hh?=
 =?utf-8?B?cVZhNGNxNnY3cUZ1Z2hWSEJBQk91alFRVk5aY3BTN1BWU0ZxVUlrNktEYkVV?=
 =?utf-8?Q?dwJTkJ7YihwduUaCUw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08dd6ef-5fc1-4ba3-296b-08d929b82102
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 13:28:25.3377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /L4gqpEfZZjsp1xOpEmqlNSdZsqHdxsuh3EvX3hgITIXIo62fmWlFIPuMHZVaDdsewuZVAhEzCSz6twEYTyxqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4201
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <5E7080EA44FD4E419830DCB1A302F593@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy82LzIwMjEgODoxNSBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4+IFllcywgdGhleSBhbGwg
aGF2ZSBzYW1lIHByb2R1Y3QgbnVtYmVyLg0KPj4NCj4+IFRoZXkgYXJlIG9uZSBJUC4NCj4gTy5L
LCB0aGlzIGlzIHRoZSBzb3J0IG9mIGluZm9ybWF0aW9uIHdoaWNoIGlzIHVzZWZ1bCB0byBoYXZl
IGluIHRoZQ0KPiBjb21taXQgbWVzc2FnZS4gQmFzaWNhbGx5IGFueXRoaW5nIHdoaWNoIGlzIG9k
ZCBhYm91dCB5b3VyIFBIWSBpdCBpcw0KPiBnb29kIHRvIG1lbnRpb24sIGJlY2F1c2UgcmV2aWV3
ZXJzIGFyZSBwcm9iYWJseSBnb2luZyB0byBub3RpY2UgYW5kDQo+IGFzay4NClRoYW5rcywgd2ls
bCB1cGRhdGUuDQo+PiBUaGUgZGlmZmVyZW5jZSBpcyBmZWF0dXJlIHNldCBpdCdzIGVuYWJsZWQg
YnkgZnVzaW5nIGluIHNpbGljb24uDQo+Pg0KPj4gRm9yIGV4YW1wbGUsIEdQWTExNSBoYXMgMTAv
MTAwLzEwMDBNYnBzIHN1cHBvcnQsIHNvIGluIHRoZSBhYmlsaXR5DQo+PiByZWdpc3RlciAyLjVH
IGNhcGFibGUgaXMgMC4NCj4+DQo+PiBHUFkyMTEgaGFzIDEwLzEwMC8xMDAwLzI1MDBNYnBzIHN1
cHBvcnQsIHNvIGluIHRoZSBjYXBhYmlsaXR5IHJlZ2lzdGVyDQo+PiAyLjVHIGNhcGFibGUgaXMg
MS4NCj4gSSBhc3N1bWUgaXQgaXMgbW9yZSB0aGFuIGp1c3QgdGhlIGNhcGFiaWxpdHkgcmVnaXN0
ZXI/IExpbnV4IGNvdWxkDQo+IGVhc2lseSBpZ25vcmUgdGhhdCBhbmQgbWFrZSB1c2Ugb2YgMi41
RyBpZiBpdCBzdGlsbCBhY3R1YWxseSB3b3Jrcy4NCj4NCj4gICAgICAgICBBbmRyZXcNCg0KWW91
IGFyZSByaWdodCwgbm90IG9ubHkgY2FwYWJpbGl0eSByZWdpc3Rlci4gVGhlIDIuNUcgZnVuY3Rp
b24gaW5jbHVkaW5nIA0KcmVsYXRpdmUNCg0KcmVnaXN0ZXJzL2JpdC1maWVsZHMgZG8gbm90IHdv
cmsuDQoNCg0K

