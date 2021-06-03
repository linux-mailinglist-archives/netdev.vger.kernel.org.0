Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7558539A998
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhFCR4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:56:24 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:57395 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhFCR4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622742878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=56lIRyVtFMZM0W5kj0jVCS6e9DNwsQ+Bg7GYpDYyORA=;
        b=bNnA0ruKU6+0G55duY3PCmG469qj68i7yZ3AbVjQ6TYHcUcF8n//rs8wkWbNw34xEnOg77
        rOCYJkacaB//yTsFdEoaRi11+SKDmhrQm/DCGKJefAKH0DdY3Sys4vhB7dFXg896Pf0uCl
        HzokM8KJbP2DLYkwmEulIpYDYq43lC0=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-6itlKW-PPDKvMtk-ElZheg-1; Thu, 03 Jun 2021 13:54:35 -0400
X-MC-Unique: 6itlKW-PPDKvMtk-ElZheg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB1055.namprd19.prod.outlook.com (2603:10b6:300:a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 17:54:31 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 17:54:31 +0000
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
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsCAhAAgABiiACAAAMRAIAAAx2AgAAaBQCAAA2gAA==
Date:   Thu, 3 Jun 2021 17:54:31 +0000
Message-ID: <627eca5a-04a5-5b73-2f7e-fab372d74fd3@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
 <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
 <YLjzeMpRDIUV9OAI@lunn.ch>
 <1e580c98-3a0c-2e60-17e3-01ad8bfd69d9@maxlinear.com>
 <YLkL6MWJCheuUJv1@lunn.ch>
In-Reply-To: <YLkL6MWJCheuUJv1@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [27.104.174.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fc34ff5-f0cd-44b6-29c3-08d926b8a3bf
x-ms-traffictypediagnostic: MWHPR19MB1055:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB10555A7859E78CD1B582288EBD3C9@MWHPR19MB1055.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: kmtU5JTrTMOr6nNm7fn4BlkhVIieG8RfaV/am8HxPzi73rfLot2NKeT9XULCPjLb5++eROAECLUJ0xeZOJPPkHh+JibE9hUva9LSOe0TWegXMYsIO/L87aO/VwOVHZOyc3eWZgl/9Vzm5QzD3xeN8Wy3/2IVWBy9dlsekEHG99q/l0wiVhmXizE3Aws0MQMRx48b7uQNYMxUI03rI9MQbJm3PP3R66wLfg7Uarr5T8sQBerzpeulUshajroS5W2qzCuGwVtPFIjqvgCwmQiwZfNJmXSPeqxahOUlzTlQFXYDPOZohMzaTqNbeiOYmlgR5DNQdNajF9SAhPuXEysRujUKR+1kLqdJdLcD2uw7ZnAlva4x8lRpCBFSlfvIKMyDDudTBaBFwcWBX9hn+IUD4Sw8ZVVpec2sDUJOqUekRq7Ye6gnxHao6X6UPsiO7n5hzxsa+YhxOZGn0aZX+6f7jqmsut4yax+c2khhvbw+xgrTbfDXtwt7W0WScWKVCuvGmmi+Us27XHxZXLYWn9s0Lq/LQmmmG5r+dJcODhbcw5RJVpINjjyGTf2UvHRVKskGWzPk8QTvzviJcSaYItxy+M47L/gZK58s9CqM3VK6VM9KrqpVcwaWJH5JfNrhh2B8yfLA6ZRsaR+vy7SDSAPsd7Y6a87/jRNM+HF4ZdgIFBoT73scGke1P9EPYgw2bIa4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39840400004)(136003)(396003)(316002)(107886003)(66446008)(53546011)(6506007)(66476007)(2906002)(86362001)(76116006)(6512007)(66556008)(8936002)(64756008)(31686004)(186003)(36756003)(71200400001)(122000001)(478600001)(91956017)(66946007)(5660300002)(38100700002)(8676002)(6916009)(4326008)(31696002)(26005)(2616005)(6486002)(54906003)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?bmZTZlplK3FMTGlSZm0xT1pTY25za0hscmZkSTNsWEZGcDhWVzBtQ29iWHBJ?=
 =?utf-8?B?OTdWdkdvbG93UzZyTG9LU0VLZXFjaVo5YkFnZXc2RlB5UmNwU0tmSzlPeU0z?=
 =?utf-8?B?bE0vdk9ZMnB5Y0t2NGhyNFMxV2ZwVy81Ry9Fc29OYnFtbFprOG5FSEQ4b2Y3?=
 =?utf-8?B?YVJBaGNhRmlXSGpIWXkvVUFPaEVKcHFPeU9jNDBOcUh1d1UvSjREa3lrZ0lD?=
 =?utf-8?B?eVl3ZmwzYnUwT21xaVVndDI4bEYxNzZXNlUxU0tCaUYxNmtaY3NJUzBUYkFt?=
 =?utf-8?B?THYrQUpselF5eXpiamIyaVV1Sk9SYjExcFpEdVMycXg3ZXZ1TmE0ZHp4RWVu?=
 =?utf-8?B?dUZjZDJ0S2lUeGt2RW5rV1U5UlVzbHFmenkvbHc5UGh5Rlc5MzlDbGhlTkpY?=
 =?utf-8?B?OE9GY3FhbStaNzczMWg1aVpwV1I0WHZDZHo4UDZwMkxHVFU1clhOanNtb3FI?=
 =?utf-8?B?enBTTzVIOE9OeW9oUmtKRlg5UklmN2M1RnlJaDRNOHN1aWFOQU1oeU45Z0lN?=
 =?utf-8?B?MHNBRVpCUG8rL3ZzdjVibjM2UFY5Ni91L0lQaWFuUHZ3L2VJZ2JpbkQ4VExK?=
 =?utf-8?B?bVpuVG54RnZDUEdjYWhNdXQxVEhZaTFGZ0ZwZmVmOG93VmJEWndHOUtJQVJp?=
 =?utf-8?B?T09yMVN4VFF1RGpVdE9qZVorMjdLaEEzUjMyeGUzdnFlV1JUdUk1R2VKOWpS?=
 =?utf-8?B?OTVJdVJEMFRhWmpzeHVobmtQb3JtRk1jdVBaZGlhTW5oM0o3KzVPeVlOcGhN?=
 =?utf-8?B?U0xSMVIxTHFKQVh5NWV3TmpOdlY2Um1MV2VyK0ZkTFF6bk4wUUJmbithRitU?=
 =?utf-8?B?ZmpvdG1LMjZ3bUtITGdQL2t0c1JBQjBNa0VoUlA2WVE5SEw5dEUyYi9BdlI0?=
 =?utf-8?B?RkhKemhoSldBRFMrRjU1Z3hGR25RUzFIWGFiRENPSUJ6elFHOTVhQ3RjZmFN?=
 =?utf-8?B?aStXcS9MRVhZaVJWLzloMHI4eFdVQXViM2FISVkzVGpOaUtJUHNpV3ZTVmFy?=
 =?utf-8?B?S28zQzBqS25xTCtNcmsxc1dEc1QwSGF4ZlJFYWxNRmtJL2kvZDZvK1VwZzYz?=
 =?utf-8?B?UmQrQ25EZkk0V0MrZjVyMnBtdmVPUE1mcGJyWUxjOG1ZcFQ1dGNmaGEzR0lH?=
 =?utf-8?B?ZWsrMlo5bGRPckE2MS9UNmRub1IzaVMzcmU2QzRwZyszUUxFb1N1WjJ6VkZt?=
 =?utf-8?B?ZExOUkJxNkJKNG5Kc0Y2R1pucWJVd2doNWF0M3dhZjc2cTltM3cxRWxuMjNw?=
 =?utf-8?B?dlpCc1lUMS9jb3hsUlVJNkVrZG42bmw0N1YwL3c0VUhwZGo1Vy9hN0g3L2xn?=
 =?utf-8?B?K2tXZms2cUFBcXd3ZDk5Umk2YXN6bGhlKzlBRFhMT3dwbzRaalVkWHBUOTNG?=
 =?utf-8?B?enp0aWpoUDRTdXFKWjZaaHQrMmlDYmdXa3k1cHZMQ3pNaHRUYks2dGJMVHMz?=
 =?utf-8?B?Z3I0TitHUCtKZGx0eVFuaitOMHJrYndSVGpFdm5yMkJydTFKRU9iUVU0ME9N?=
 =?utf-8?B?V0hOVmREdDZ4UWJRbGtYa1ZobjkzZGlVbXlyY0dVak5may9rWXlrbXdlelIx?=
 =?utf-8?B?VDZTbndZeU4zcWVpbU5SOEJwa1VGdldhWE9pdjRaVDM2WE55WDlBN1hQMytn?=
 =?utf-8?B?bFZUdE1XQnVycjNEeDVzR0V2bDcrQ3V0SWVxUER4K3BMdzRXc0V5MFhlMjNm?=
 =?utf-8?B?MGxBd3dHR3BuM1N6MU1UMHQyQVhIOW5lWjV1L0NJN1ZFY2pmelI4RnB0Tkdu?=
 =?utf-8?Q?50xqupmJMUrqOrgJ0zHut3OuYv9A6qyDZ+2zrAd?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc34ff5-f0cd-44b6-29c3-08d926b8a3bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 17:54:31.1388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vchFsijsjFe9RsRuSEYVP5M6ZF+ArdS8locQPD4nP2t+V5/309UdMzfgBumPHpldnmmoj8eEN8ZSfcg07FEKeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1055
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <01CFE0631B528648A0BA90D0C1BB6D60@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC82LzIwMjEgMTowNSBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4+IFRoZSBmaXJtd2FyZSB2
ZXJzaW9uIGNhbiBjaGFuZ2UgYmVjYXVzZSBvZiBzd2l0Y2ggb2YgdGhlIGZpcm13YXJlIGR1cmlu
Zw0KPj4gcnVubmluZyB0aW1lLg0KPiBQbGVhc2UgY291bGQgeW91IGV4cGxhaW4gdGhpcyBzb21l
IG1vcmUuIFdoYXQgaGFwcGVucyBpZiBpIGluaXRpYWxpemUNCj4gdGhlIFBIWSBhbmQgdGhlbiBp
dCBkZWNpZGVkIHRvIHN3aXRjaCBpdHMgZmlybXdhcmUuIElzIHRoZQ0KPiBjb25maWd1cmF0aW9u
IGtlcHQ/IERvZXMgaXQgbmVlZCByZWNvbmZpZ3VyaW5nPw0KPg0KPiAgICAgICAgQW5kcmV3DQo+
DQpJbiBvbmUgb2Ygb3VyIHByb2R1Y3QgKGluIGRldmVsb3BpbmcpLCB0aGUgTklDIGRyaXZlciBj
YW4gZGVjaWRlIHRvIA0Kc3dpdGNoIHRvIDJuZCBmaXJtd2FyZS4NCg0KVGhlIHN3aXRjaCBoYXBw
ZW5zIHdoZW4gbmV0d29yayBpbnRlcmZhY2UgaXMgZG93bi4NCg0KQWZ0ZXIgdGhlIHN3aXRjaCwg
d2hlbiB0aGUgbmV0d29yayBpbnRlcmZhY2UgaXMgdXAsIHBoeV9pbml0X2h3IGlzIA0KdHJpZ2dl
cmVkIHRvIGluaXQgdGhlIHBoeS4NCg0KVGhlIFBIWSBkZXZpY2UgaXRzZWxmIHdvbid0IGRlY2lk
ZSB0byBzd2l0Y2ggZmlybXdhcmUuDQoNCg0K

