Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6D73AE9BE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhFUNJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:09:55 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:23948 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229651AbhFUNJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1624280859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c6OdrZNdf1NmL70jHassUWnUutqUUvubYOCM+CpYGnQ=;
        b=bEdplVNAJFVFte+DljCemB5FtE32E4IULCCdIt5HuR+riRNzGD472XCpeb04xNBHk1u2SW
        pyBM93vy7SCAyR15K8VZWA5Pbw3qrQvTNNFeCIysmW7v7raWo2TgQ9SgYJt9dxrp59EEJX
        Z2aG0zUyDIFwdr4z0sEVYeOFvoRi6KU=
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-2U9McNMQN_CxVydekXULeQ-1; Mon, 21 Jun 2021 09:07:37 -0400
X-MC-Unique: 2U9McNMQN_CxVydekXULeQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB1166.namprd19.prod.outlook.com (2603:10b6:320:2a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Mon, 21 Jun
 2021 13:07:35 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4219.024; Mon, 21 Jun 2021
 13:07:35 +0000
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
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAhoACAAB2SAIAAfDEAgAC87YCAAnCRAIARoG6AgABPWYCAABqdAIAD22mAgAArJoCAAIGQAIAABT4A
Date:   Mon, 21 Jun 2021 13:07:34 +0000
Message-ID: <54c37ec3-c288-7955-ac91-5be9958901e5@maxlinear.com>
References: <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
 <YLuPZTXFrJ9KjNpl@lunn.ch>
 <9a838afe-83e7-b575-db49-f210022966d5@maxlinear.com>
 <334b52a6-30e8-0869-6ffb-52e9955235ff@maxlinear.com>
 <YMynL9c9MpfdC7Se@lunn.ch>
 <2f6c23fd-724e-c9e0-83f2-791cb747d846@maxlinear.com>
 <YM/5z1hgIkx6Fq6I@lunn.ch>
 <298d6268-00d0-cfcf-3689-bd074cbd8e16@maxlinear.com>
 <YNCKsPiIQP/ov39V@lunn.ch>
In-Reply-To: <YNCKsPiIQP/ov39V@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59d96b56-3422-439d-3c43-08d934b58988
x-ms-traffictypediagnostic: MWHPR19MB1166:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB1166ECB8C8E64AFF69EE5DF3BD0A9@MWHPR19MB1166.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: xQW54PTL4E03BOoiWxelcw1pg3ntVJIChKoUan3NKqgqrGbeZPpyVcQ+7OGW6jAh1uagS9i7R9NCOJQIDVeFONgViIcF2ibtK+aHuZrVxxMpAdKz5PSqFqAzgX8MvRGjKumh3fSBWHy4kU1XPA3wMX0fBqYJu4g9eflMPq7Z7u+8HzfwfV0sh5ncUZoTGamrJZXPjcLFEKjNxd0JiZxMf6K0S2wuocK0guL5alSmwaX3eUGYU5EC4oxWx0UEGt80VNadXH7woFlG8f8juWuMTeV4saTxA3LJ4e8lYX89YqoMFYdYwnJrDq4OuC3Iv9wPI2bysesXOLLLVl+C4X/zcxehuIx068vhcZ5bJiEf6/pDgU5oYyN+/g2XR3bq3aSr7HA6GF7YkfCE2t/4ovfqq7MtfRLsn7rCnGLJIHfRCHxCmB8Nv0iGev3CEFRczsfXhXOEenJ6RO1Gy3/Y8tX9l8wL6yv6TkpMSyEtc1niS5k1iBUJ/DUg57T4ZXAeSKyfFsAKgOPG093akG1R25WmFtUWaHj9yC7zmr/gFrV0W0podO193yQ3MWk+/n36KkpyCPAsuwum2ni6ZbKaePNbZahtbJh5zhXz0u9dWFar4veDxcBLup1WazxgGhev27zZk4e9UgvOT69w89+dfJ0Z5XkvaxmEVCE1IJvZRfL9hOeJGM4fsp+r6Nv59urvG5Gj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39850400004)(66446008)(122000001)(38100700002)(8936002)(5660300002)(2616005)(4326008)(31696002)(6486002)(107886003)(478600001)(2906002)(6512007)(36756003)(6916009)(66476007)(53546011)(8676002)(186003)(66946007)(71200400001)(6506007)(316002)(54906003)(76116006)(26005)(31686004)(64756008)(66556008)(86362001)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eW5Dd3BsamxaQkZsbE9UOEFLUlJyZjYza0pZdzdNQXBaN0xwWTcvV3lVWnR6?=
 =?utf-8?B?SldnODR4bnQ4bWs2NXV0ajQrNFRPaTVSMzVHSXFCTTFhaGdYaTkrS2Nra3dV?=
 =?utf-8?B?WEswOUYyMUI3SzhFc292TFo2aXd3SjhaTUdLd05hQkpIcW54Y0cxYVJ3VnB0?=
 =?utf-8?B?Qjhsak81UW5kem9CZFVFcnNObjJ6dzlZeGJGRWRMTUdsSDN6NUFjMnZVWUht?=
 =?utf-8?B?N1kwQXd6Y3g0cWQ3RnprV1QrVk14MzQ2OFFiME9sc3pqYmEyWmxPT1dZYXdo?=
 =?utf-8?B?S3hsRWxZcFcrOC9SZjd5UHFiNy81RWxUczlDbGZLd29uMWZQd2R6UDNiRHJL?=
 =?utf-8?B?eDhDSHhSSVFKZ2pWUE5ac1pWaXc1TytDZUIzdldHYncxNlJsNThCVVE3dDBx?=
 =?utf-8?B?VHJMa2Nsb3R4NTR1RjhlaThKeEdNbnRNTEs0UzRqQTNWYXQ5Zi9rMHNIVU9s?=
 =?utf-8?B?VXhXRjRKWU5Ec0pkWGw5ZVljekRQUGpzeDB6VXo3NEpQbmR1cVVodGNaeThl?=
 =?utf-8?B?STVyakF5THkzV1F0RlFReFM2dXRacG1nOHV5bC9GamxDbjljUGpYNG1uTUM3?=
 =?utf-8?B?b3ZaQ3NDZXQ2V2ZkalE2bm53VTA0ZzZBcWhjOFZYNml3d2ZyWGNONHZneGky?=
 =?utf-8?B?alEzdmZZZk1HaTJmTVA2MzR3Q1BTODFPOWY5aFpzSlhEc0cxbXQrUFE0eWM4?=
 =?utf-8?B?ZVc5T1p6c3QrdDdFSDNEWm5FdXdYeitwMmZxaHJyZkNWL1RHNVMzcGtCRUVV?=
 =?utf-8?B?L2pJQnBPblRFd3Q0cW1oYTM0U09uMlVqd05yb1VCVzlNK3hYOW80WmdIVnQx?=
 =?utf-8?B?Z3A1WWR2TkpxL2x3bTE1K1EraHVOWE9xUzczTi9yZHo2MlVaRUVYc1BmRWFD?=
 =?utf-8?B?VjYvZ2JEZGdTbjdaV0ZOK2hDdXpUTyt5eVhuOGo4ZjNlc0gxU3VFMHZwWDhq?=
 =?utf-8?B?MXg4aVhiOENkbTgxV2Nvd2xvK3ZIdHJIMTdKSlczN01LRUpzYTNUY0VkUjlC?=
 =?utf-8?B?MTdVejFuVnlNeTY3K0IydytIdGtyalNPZDczczU1R1QzY3ArNGNMbEZjaFZT?=
 =?utf-8?B?QVN5Y1FkNlEwZ0dmcnJxMG0ybk9xb215YkVORmNvUFpxaFdkdlZsMm9vOElE?=
 =?utf-8?B?cndsb2NOK0VJWEZkMzdkM25LemwxNm9zdm9TNXBZeVJvYlBNR1JtWDBCUml5?=
 =?utf-8?B?VWFjT0xYbkhZSk9ma3I0VDNnNkVlbGNKZUY5Ny9Ya05pSkRKR08yU2RFNjl3?=
 =?utf-8?B?VTdCQW81Nk9iWjh0bHdHUll5bGhGVjZLSmluVnh2Mno2K2V2R0RBVWpzWjU0?=
 =?utf-8?B?M0lDV1BqckJTNFc4bzJGSTFKWWRPa2F4cTZkOU5XWEp1cHBhMDJ4VThCTWtx?=
 =?utf-8?B?WmhJdDh2SHlpNDBOTForS1F3aW9JNklmaW9wOXF3aHhKc21VR1Y1UVljTmRY?=
 =?utf-8?B?aGlpdjZ0SW4zUHgvWEVKa3hYRllKU2ZBUlRtVnJvZkhrRmVibHhvRlBEYnEx?=
 =?utf-8?B?NzJQaUZlck1BY0dncHI0eUVzazBjZGNNK0dJSis4S2FUMjJJT016T1VydWI4?=
 =?utf-8?B?QWtEbVBIMmk2YWJKNFZLM0pYTG5xZHh5c1VwbWljTjRZeXJwcmhPbDIzUWl5?=
 =?utf-8?B?MTh6MTR5dThZTGZHYUtyaEFkY0dNc0lheDEzV0ViNnRlMEJKZkhSaXh3a2Rh?=
 =?utf-8?B?aFcwRjN2eDd1eE10Q1ByYVd1bjNQcTdtcFNYSEpvYWx4RExFWk02MHJBMWVR?=
 =?utf-8?Q?YBchql6N/T8KxewGWw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d96b56-3422-439d-3c43-08d934b58988
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 13:07:34.9828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1OtxOBNvWGQmV2R0PcB1VdHygU23MaleUW36INN6lybkkElc+b4Q/dTMU5IOqmWLEXM8Ee+FcOS9bcNE7HXbNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1166
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <5EE7BA5DE9602C4BBA66AD78475743D9@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEvNi8yMDIxIDg6NDggcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+IE9uIE1vbiwgSnVuIDIx
LCAyMDIxIGF0IDA1OjA1OjA2QU0gKzAwMDAsIExpYW5nIFh1IHdyb3RlOg0KPj4gT24gMjEvNi8y
MDIxIDEwOjMwIGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBUaGlzIGVtYWlsIHdhcyBzZW50
IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+Pj4NCj4+Pg0KPj4+IE9uIEZyaSwgSnVuIDE4
LCAyMDIxIGF0IDAzOjM2OjM1UE0gKzAwMDAsIExpYW5nIFh1IHdyb3RlOg0KPj4+PiBPbiAxOC82
LzIwMjEgMTA6MDEgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+Pj4gVGhpcyBlbWFpbCB3YXMg
c2VudCBmcm9tIG91dHNpZGUgb2YgTWF4TGluZWFyLg0KPj4+Pj4NCj4+Pj4+DQo+Pj4+Pj4gTmV0
LW5leHQ6DQo+Pj4+Pj4NCj4+Pj4+PiBpbnQgZ2VucGh5X2xvb3BiYWNrKHN0cnVjdCBwaHlfZGV2
aWNlICpwaHlkZXYsIGJvb2wgZW5hYmxlKQ0KPj4+Pj4+IHsNCj4+Pj4+PiAgICAgICAgIGlmIChl
bmFibGUpIHsNCj4+Pj4+PiAgICAgICAgICAgICB1MTYgdmFsLCBjdGwgPSBCTUNSX0xPT1BCQUNL
Ow0KPj4+Pj4+ICAgICAgICAgICAgIGludCByZXQ7DQo+Pj4+Pj4NCj4+Pj4+PiAgICAgICAgICAg
ICBpZiAocGh5ZGV2LT5zcGVlZCA9PSBTUEVFRF8xMDAwKQ0KPj4+Pj4+ICAgICAgICAgICAgICAg
ICBjdGwgfD0gQk1DUl9TUEVFRDEwMDA7DQo+Pj4+Pj4gICAgICAgICAgICAgZWxzZSBpZiAocGh5
ZGV2LT5zcGVlZCA9PSBTUEVFRF8xMDApDQo+Pj4+Pj4gICAgICAgICAgICAgICAgIGN0bCB8PSBC
TUNSX1NQRUVEMTAwOw0KPj4+PiBUaGUgcHJvYmxlbSBoYXBwZW5zIGluIHRoZSBzcGVlZCBjaGFu
Z2Ugbm8gbWF0dGVyIGl0J3MgZm9yY2VkIG9yDQo+Pj4+IGF1dG8tbmVnIGluIG91ciBkZXZpY2Uu
DQo+Pj4gWW91IHNheSBzcGVlZCBjaGFuZ2UuIFNvIGRvIHlvdSBqdXN0IG5lZWQgdG8gYWRkIHN1
cHBvcnQgZm9yIDEwTWJwcywNCj4+PiBzbyB0aGVyZSBpcyBubyBzcGVlZCBjaGFuZ2U/IE9yIGFy
ZSB5b3Ugc2F5aW5nIHBoeWRldi0+c3BlZWQgZG9lcyBub3QNCj4+PiBtYXRjaCB0aGUgYWN0dWFs
IHNwZWVkPw0KPj4+DQo+Pj4gICAgICAgICBBbmRyZXcNCj4+Pg0KPj4gV2UgaGF2ZSAyLjVHIGxp
bmsgc3BlZWQsIHNvIG1pc21hdGNoIGhhcHBlbnMuDQo+IEFoLCB5ZXMuICBTb3JyeS4NCj4NCj4g
UGxlYXNlIGltcGxlbWVudCBpdCBpbiB5b3VyIGRyaXZlci4NCj4NCj4gICAgICAgICBBbmRyZXcN
Cj4NClN1cmUuIFRoYW5rIHlvdSBmb3IgYWR2aWNlLg0KDQoNClJlZ2FyZHMsDQoNClh1IExpYW5n
DQoNCg==

