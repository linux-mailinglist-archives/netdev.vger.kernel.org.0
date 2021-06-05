Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBB939C58B
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 05:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhFEDsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 23:48:10 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:57511 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhFEDsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 23:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622864782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ulaQS3HPdtbwPgr0+Fpb0u+48HRfaB472826P8XqA8=;
        b=HUmfEQibq8FPSbnGy02tGlfT6t6QtmAT4+2sRiGTpmeDMwb/jSV4lulU0hzfUnrLeHezcH
        ajRynV1aBaD3D05dmJdXDBEQ9a0/jBlV9EoNR+zHi6fmRwVbmeO2CFWOz5W/uH8Ozz1wje
        ll6JIZDee9amYI27CR8s0Tc4dP3UHSI=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-8U5IP0yjOXKs4P8r3P7_Yg-1; Fri, 04 Jun 2021 23:46:20 -0400
X-MC-Unique: 8U5IP0yjOXKs4P8r3P7_Yg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB1296.namprd19.prod.outlook.com (2603:10b6:320:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Sat, 5 Jun
 2021 03:46:18 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Sat, 5 Jun 2021
 03:46:18 +0000
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
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsDxf8AgAAKPYCAAIK/AIAAdxsA
Date:   Sat, 5 Jun 2021 03:46:18 +0000
Message-ID: <f965ae22-c5a8-ec52-322f-33ae04b76404@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <YLoZWho/5a60wqPu@lunn.ch>
 <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
 <YLqPnpNXbd6o019o@lunn.ch>
In-Reply-To: <YLqPnpNXbd6o019o@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [27.104.184.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 939293c6-825d-46a3-9289-08d927d479ec
x-ms-traffictypediagnostic: MWHPR19MB1296:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB12960AC305FDF582B43940CFBD3A9@MWHPR19MB1296.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6tbcV3gcYEX4XNuSZW88C/mTrNOx7lLCo1UmNZHEQ6kjgcqRIwuHyL0ImVVCxyN6ayuXdVDpnj1+O4ovePgu7NR9RQQWVtUKNblknsHCQFSAJyawusEY9RHaCdOVoWOdBn7FC5BjO8wLbo1y7NRZWMiVmZAx1I+hAbrCeBfnVLXwbfMJlj35I+ebV7TatafRElsajCty6jat1OpX3FAXHu76S94PBP4pu/A9Tlfgotof9gsYSNDOYzqttHggqbN/hTzKk1+FbGpIyBHcHDJ7r/ETi1d6Jd6gceaAVhf9p9pafIhIK11VhAr//YuknIFCrdSZbqzQRvguYWjuIHhrS3d4a75jzcZStZpNNPgFEw23PMvwU2u+ANCCfRKmD0oNlVG5/z7T14DhI3s49EdP/y/3JkEerZPdA/BTUtwALGaQHs79BKU11WidaRvBxUKIYjSUf37+bwoydC3ZP8Wqc8SsoQELIG7SfkI+gvidVR610jVIvkMsQxKYETQOO7JeLlE6KYQZyzMm5s8D+iVU4yBGvSpqRoh6iLUxQ01l30xGEJ12ihTzoe73pze6npuz7nUZS+FFZbwmZ9jiknsyxZQS6fekuhGBEYL37Kshao3v7lMtnHdEoArip6sKKOgAfEMVxvS0pyrTTT/zaTXB5hYgFH77nHojN7edqUkgYVAtpN+qR2fkzrCSFJDHIFGz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(39840400004)(376002)(107886003)(31696002)(86362001)(2616005)(31686004)(6486002)(91956017)(4326008)(76116006)(38100700002)(122000001)(316002)(478600001)(66946007)(6506007)(53546011)(54906003)(66476007)(64756008)(66556008)(66446008)(36756003)(6916009)(5660300002)(71200400001)(8676002)(8936002)(6512007)(26005)(186003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?c3Y1YWEyUC92QWw0a3ZHdWRqUTBjT0tYUHR0d2puTTRmY1E1dzNja2VnZERz?=
 =?utf-8?B?SmlOVnhwNGNxZ2tKaTA2bkZjVGxxOE0zNVFIYWlZelhHRmYwVEllWDc3Z0w2?=
 =?utf-8?B?S3ZCeTJrb0RHL1NlbVVkYkxra0RKSGZzaHlwMVRTZCs2N1N5OFZMQ3hRckZp?=
 =?utf-8?B?WCtDL1JpYmVYaDJ1dzgwL3VESDQvR3B6YVdobzZzNk5OT2RoVU5na3lSTzVT?=
 =?utf-8?B?ZFlNYlVPUTJ0bGFBekVUUEt2RlZiSytubWUzTklOdHpHUGNZdU03eVYzZU82?=
 =?utf-8?B?WHRvbmxMMy9rNmZWSjhZSHVuWXdzNS91MWJrVU4vSXZObDVhRDZSSXJGTVlk?=
 =?utf-8?B?OVVqcG5lTzVSVjhCUGpBb3ZqSU1aV0RlS2hsU0dTcHpZRFRHL2NyeGJUN1Qw?=
 =?utf-8?B?TVhPOFhBWWhkeWhNN3FlaXFBTEI5TmRSZkJJMm1XYVRBNE9NSHBtZmREL2RJ?=
 =?utf-8?B?RitFNkVZQnV6U2l4d240cUNYeEZ0bEtvMHRDckFZc0RLYnhHZXFSVkpqWkVB?=
 =?utf-8?B?SmwwTEVrMWhCSGVQc3Q0UmhSTFBzQm54TjlTTHRNSUVIQy9kQUpsVkxOdDFQ?=
 =?utf-8?B?K09BTHZYc0FCcUowQWhkT0Y1djg2c2pGSzBTeVF3S2J4TU9FWTZjTDU2U1Zw?=
 =?utf-8?B?U0hjT0ZFVEU1N0JGWW1QYjZJWnNhK3hEMG9aZS90cldyek5OYnpwbjhra3NX?=
 =?utf-8?B?Y0lVakVISk1ZWldnOEFaRFF6MDFkV3NPZDJZN0dIanArSWlVbUc5cXc0T3Zz?=
 =?utf-8?B?RXRLWXorQk0zeURMVSt6c1krRXg4KzJ1SXd0ODdhVHpBNkxieHlEejZxbEJh?=
 =?utf-8?B?QmlEZWNRNW5ZcmE4L0xCcTl2TlBFcGdPWGNIc3hHcFlXdTUrMjY0a0pQb1o2?=
 =?utf-8?B?OWo0OUlEdFVjNVZWK1VMSkpBQ3pHaFd0MWZjbnExUG9NUUE1bUJuQjFUcncy?=
 =?utf-8?B?V1VwNDZGVkhaR0lHa0dLdlhjZW1MRDZBaGJXV0pUWEhUYmwxTElRbyticzZ3?=
 =?utf-8?B?alpGejRLNkpqZ053V2RmTHdjem1sMy9ONGIzT2JpZk9uSUpMTUZ1N3VnSTVz?=
 =?utf-8?B?ZG5kT0hkbDNJQXppeXYxRTNWc2NHM3o4cnRXRlZoK0wvRkhWNkU3MU43WFFQ?=
 =?utf-8?B?UTBHMXplM0VlTSttVFUzdXpER09OYmVpNHRob1RtYkNZQ1BnK3JJYlRIV2Z0?=
 =?utf-8?B?YTI2NnlzMlVjRlV2UFpLdmZrWThvd2dnQ3hCd1JmQ0F6R2pIeGw3Nlk0U2JM?=
 =?utf-8?B?UThZbG9LbnU1NVB0czN1dmQrL1p2c1o0SDZLeWJTQlJLaVBrUzZkRkh5M1Rw?=
 =?utf-8?B?aWM3cjlNaGptRXZpZzhVaEhVUVpMUFg5UU1uVkJydG02UENkS0I1NGsvcUhs?=
 =?utf-8?B?RGdoVnhDK3UrNkVpMmo2NVhZdi80UFoxZ3o4RVpzVXRLRXNIOFMvMCtza2s2?=
 =?utf-8?B?MFllMFVCYmRMbjJaWXltTTdia2lSaExkTXR1TGVFMmpRcUp4dkVKWStNZ3RO?=
 =?utf-8?B?aGYxcHdMWHZDSVRSVEUrNjlROXEybC9VYUlCd1Y4MUNjTGZCc2o1VkY2ejg4?=
 =?utf-8?B?T0ZIOFpUKzhXQVpDZkRMbFlwRSs0YlpDMmlRNmdFZjA0NnpRVWQ3cGh3VHBv?=
 =?utf-8?B?SFByK3BoYmw1T1dlN0hvWlRiUVJnbjgxM1g2TElXdmxMdEdjbVZoWk4vQjlF?=
 =?utf-8?B?SjZpVTIwR2RhOGVRNmtQSlRlVEZhMTFxdmZnTW90SERRQ21PUjNTM2xVTkIx?=
 =?utf-8?Q?tBTy4h+e6U+PyTnDBo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939293c6-825d-46a3-9289-08d927d479ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2021 03:46:18.0503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8GcGsIMr1qx4TaqLvqfIGT56Hzdhb1G31gv3mM6TqF4GXPW/2YpiwzAssk/6ly1fc919Jy2hC4NJZuUGyTfjlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1296
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <5666210C87F21048B61074D824047176@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS82LzIwMjEgNDozOSBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4gT24gRnJpLCBKdW4gMDQs
IDIwMjEgYXQgMTI6NTI6MDJQTSArMDAwMCwgTGlhbmcgWHUgd3JvdGU6DQo+PiBPbiA0LzYvMjAy
MSA4OjE1IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBUaGlzIGVtYWlsIHdhcyBzZW50IGZy
b20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+Pj4NCj4+Pg0KPj4+PiArY29uZmlnIE1YTF9HUEhZ
DQo+Pj4+ICsgICAgIHRyaXN0YXRlICJNYXhsaW5lYXIgUEhZcyINCj4+Pj4gKyAgICAgaGVscA0K
Pj4+PiArICAgICAgIFN1cHBvcnQgZm9yIHRoZSBNYXhsaW5lYXIgR1BZMTE1LCBHUFkyMTEsIEdQ
WTIxMiwgR1BZMjE1LA0KPj4+PiArICAgICAgIEdQWTI0MSwgR1BZMjQ1IFBIWXMuDQo+Pj4gRG8g
dGhlc2UgUEhZcyBoYXZlIHVuaXF1ZSBJRHMgaW4gcmVnaXN0ZXIgMiBhbmQgMz8gV2hhdCBpcyB0
aGUgZm9ybWF0DQo+Pj4gb2YgdGhlc2UgSURzPw0KPj4+DQo+Pj4gVGhlIE9VSSBpcyBmaXhlZC4g
QnV0IG9mdGVuIHRoZSByZXN0IGlzIHNwbGl0IGludG8gdHdvLiBUaGUgaGlnaGVyDQo+Pj4gcGFy
dCBpbmRpY2F0ZXMgdGhlIHByb2R1Y3QsIGFuZCB0aGUgbG93ZXIgcGFydCBpcyB0aGUgcmV2aXNp
b24uIFdlDQo+Pj4gdGhlbiBoYXZlIGEgc3RydWN0IHBoeV9kcml2ZXIgZm9yIGVhY2ggcHJvZHVj
dCwgYW5kIHRoZSBtYXNrIGlzIHVzZWQNCj4+PiB0byBtYXRjaCBvbiBhbGwgdGhlIHJldmlzaW9u
cyBvZiB0aGUgcHJvZHVjdC4NCj4+Pg0KPj4+ICAgICAgICBBbmRyZXcNCj4+Pg0KPj4gUmVnaXN0
ZXIgMiwgUmVnaXN0ZXIgMyBiaXQgMTB+MTUgLSBPVUkNCj4+DQo+PiBSZWdpc3RlciAzIGJpdCA0
fjkgLSBwcm9kdWN0IG51bWJlcg0KPj4NCj4+IFJlZ2lzdGVyIDMgYml0IDB+MyAtIHJldmlzaW9u
IG51bWJlcg0KPj4NCj4+IFRoZXNlIFBIWXMgaGF2ZSBzYW1lIElEIGluIHJlZ2lzdGVyIDIgYW5k
IDMuDQo+IE8uSywgdGhhdCBpcyBwcmV0dHkgbm9ybWFsLiBQbGVhc2UgYWRkIGEgcGh5X2Rldmlj
ZSBmb3IgZWFjaA0KPiBpbmRpdmlkdWFsIFBIWS4gVGhlcmUgYXJlIG1hY3JvcyB0byBoZWxwIHlv
dSBkbyB0aGlzLg0KPg0KPiAgICAgICAgICBBbmRyZXcNCj4NClNvcnJ5LCBJIGRpZG4ndCBnZXQg
dGhlIHBvaW50Lg0KDQpEbyB5b3UgbWVhbiBjcmVhdGUgdGhlIE1ESU8gZGV2aWNlIGZvciBlYWNo
IFBIWSBsaWtlIGJlbG93Pw0KDQpzdGF0aWMgc3RydWN0IG1kaW9fZGV2aWNlX2lkIF9fbWF5YmVf
dW51c2VkIGdweV90YmxbXSA9IHsNCiDCoMKgwqDCoMKgwqDCoCB7UEhZX0lEX01BVENIX01PREVM
KFBIWV9JRF9HUFkpfSwNCiDCoMKgwqDCoMKgwqDCoCB7IH0NCn07DQpNT0RVTEVfREVWSUNFX1RB
QkxFKG1kaW8sIGdweV90YmwpOw0KDQpUaGVzZSBQSFlzIGhhdmUgc2FtZSBJRCBhbmQgbm8gZGlm
ZmVyZW5jZSBPVUksIHByb2R1Y3QgbnVtYmVyLCByZXZpc2lvbiANCm51bWJlci4NCg0KUGxlYXNl
IGdpdmUgbWUgbW9yZSBndWlkYW5jZSBpZiBteSB1bmRlcnN0YW5kaW5nIGlzIHdyb25nLg0KDQpU
aGFuayB5b3UuDQoNCg==

