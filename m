Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B31E39A49D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhFCPe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:34:29 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:46479 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229641AbhFCPe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622734364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MrrOD/ZJ+3kOfJ6dUEtVQ0ke+O/xNTtmIwXrOUCUFU=;
        b=VWUxhmsuBZWwUHguGtBaamk6QlFdJaEcm8NBjSjs/ykxyCUcgl+m5OjxD86aMTJOGwTcxn
        xhR5Btum8KBj7RSACt/My8luiQqqONA4gDPvFJy26YeoTS0TxSVlM1wN23F5VHey3I4lME
        foom0iH/laBGn9bYolUibjV3O3pDXCM=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-e-YFxM3iMviA8N55r0sQXg-1; Thu, 03 Jun 2021 11:32:42 -0400
X-MC-Unique: e-YFxM3iMviA8N55r0sQXg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB0944.namprd19.prod.outlook.com (2603:10b6:300:a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 15:32:39 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 15:32:39 +0000
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
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsCAhAAgABiiACAAAMRAIAAAx2A
Date:   Thu, 3 Jun 2021 15:32:38 +0000
Message-ID: <1e580c98-3a0c-2e60-17e3-01ad8bfd69d9@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
 <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
 <YLjzeMpRDIUV9OAI@lunn.ch>
In-Reply-To: <YLjzeMpRDIUV9OAI@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [27.104.174.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83185b5d-9094-46a8-d1d7-08d926a4d213
x-ms-traffictypediagnostic: MWHPR19MB0944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB0944A1840A96FA03AA60C265BD3C9@MWHPR19MB0944.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: dtUx14x3qLAJDo4bVhy8T9qyd2i2GxKQ8XrVWeBfcrdfxEJ+I2uFEbE0ndNRtTa4ouZR5vez8xRrxhDm09qxuUGTHqmKsDIlJViwNRu5eEGUtuJIsij38/9SZwb9x6vaG0TTZeNUu9UPwWvtJ6A1x1MIWzNtfce+kxEyFSFS1BTTGISBmwuWSTEYsF1mJeSy0ttMTwKh1/8OECfj7IOFX/7N7mII3XhBxhE/t5W2B2xfKS4FEP33MGtCqIL7ujBY0xXG6C6tNsCLwh+hwcXXKKVpH+wXy617YrtXC5XrKqsQLOCtfwrSYAA6WdGDdp2bSg2gyyB5f0+dRlddv2krcpgkYn9uUYrrlq65INHfJpVsShWO6cw2P9RXQJrejlL7pmXX5zRJ6Nyx+1p1u7dVYTcO8BQy3MqAYm8XlxCWH7MDnwYIjxcbbjTjEuwY3fOOQtq5NfqR6ZIRV1DtQZWVH148uevwbGL0Njow6TEZVvSfPRbgLaYrdDfvLFL6Fe9D/YMd3670c1a9AlGIFCcLFP5YEOG4oP4X1nbZOvs3l+sRcnimiGK+9jtoIyTdXOmbKrySLNMhxOEymQen2UckuhFwbVC9caDjWHBFEaKWU2SFY4YR61+zJLIF958EeY9ekzEtYuFxsVets+ZdGGhxWx6E8GkxgM9FpP+lKI6GoJnfGGJnwSOijtc4C5bioQVN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(5660300002)(2906002)(26005)(107886003)(316002)(53546011)(36756003)(2616005)(122000001)(6512007)(186003)(86362001)(66476007)(4326008)(31696002)(8936002)(76116006)(54906003)(91956017)(64756008)(31686004)(66446008)(478600001)(66556008)(71200400001)(6916009)(8676002)(6486002)(6506007)(38100700002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?cEFtU0swUndOMkVJbE14ZzNqWVRsQzEwMzJTdzF6RkpJbUpUenVpOUdyT1ZX?=
 =?utf-8?B?eXREVzhkNzZSY1RMRjJYVlhTY0RKNXQrMk1DWStsc3pFajdTdnc5M0FrVmJ6?=
 =?utf-8?B?aTBaZDNNSy9VdHZEM2ZTQXJyMXg1aEVVT1hJeTJrcVJZSWVvaUhLL1ZVempR?=
 =?utf-8?B?ejBTV3prc25oVHIvWXlwRWJ6RmJYNytIUEdkd0RoWENpYXB0UlZ0b0FPcXdC?=
 =?utf-8?B?UFYxMjdkc0Y0TkkrcTdyd2ZWV2xmNEt6eE1WV1g3cjhKeUtxbEw4YVFaVEZE?=
 =?utf-8?B?K0pvb2I5WUladThncjFUREdqd0dxQXRTeEJZZFl1dUR1Tmg5bDlvekpWQnY4?=
 =?utf-8?B?cmMzSnhIdnY5eGpYcERrWEpqOHFYZ3dIcEtGcWs1bUhJeWtEVkJiQktyT0Uy?=
 =?utf-8?B?dDhCUnpEZDJQQTN4L2Y3aTVZY3FQeW5mZTl6cS95YndCK1YwNkJsUFdzdEtX?=
 =?utf-8?B?QVRGRnBZdVJaZ0RkNGgrN1ZQaTNyTFlOWUUzaG10eTBJbllrZHZJTkp1bmVk?=
 =?utf-8?B?WnZpTkRndjhWRTJBeFRKelhBMWtxZncraXNGUVljNjVHbmtiRW5qQW5FWmlV?=
 =?utf-8?B?aVpySWgrREo0VGdGNnZXOUpJZ0FyMzVPVEFjRXM1Sk9Ga3AxT1hDZW5lcUcz?=
 =?utf-8?B?VkQ1Nzk4ZWNsVklCYVlHYlpWYTVBRkRFYTN1V2N2V1p6RUU2TW5GcGRYQStC?=
 =?utf-8?B?S3FiejA1cGoxd1VDcXJSdXVVOTFjN1pYVGd3RDlzVGxtK3JXOGdzRnorZng0?=
 =?utf-8?B?bzdyK3hGa0NIK3hPTHhPaU9WU3FwV3d2VldSaExOeTZxWXprclVhTmNXRGtP?=
 =?utf-8?B?Z3luSFNmWFYvK0NFNktIRlI1WDM3clZtMTNnUHVZcGRqUnFzY0lhQ3lwenAy?=
 =?utf-8?B?SFlVRzRvSVk0amxROXJ3TUtjU3NmZ2VITzNTdThTSm8zdFlzaWZKTDZxTmM1?=
 =?utf-8?B?am0rM1pOUkx3R2RKNHl1bndzaEVsRDQybTNGMVJ3NVVZeTVGbjRMcFpDWUxo?=
 =?utf-8?B?MklnaEFVd3pWL0Zob0JOaW5yNms2QnZWZnBkVG0yV2xpSTU1R2xrRlBuK3c4?=
 =?utf-8?B?TXVocnB5cWhENE5qMmVyRlBDaXpZdEpkay9GRk9ZRk9HZU9xMVdJNnhtM0tF?=
 =?utf-8?B?ZU1zUFg1akN2c1g0eEJ1Q2VPdnMwNko3R0Y4OGdNOTZocnpjNlltMHRFaFV5?=
 =?utf-8?B?K0tycHRvb1BLVnRSWWloVmgrcVZ6RFdPa1JnYkIwMHNqMDltaC82K3FnNkFa?=
 =?utf-8?B?Y1o3OG5zTnVyUWJhY3RxVmI5ZkkxbzBNaktNaElYWEozRHZOYVhXbWtGKzlm?=
 =?utf-8?B?MklPRGdsV1N5SkU2Q09YU2tyMlRIakJjRFgvcVBWQjZKR0phU3ZIVzM3am5S?=
 =?utf-8?B?L3ZPejFORmk1Vm54R0JpZ1JoSytoYWdNbUtkZ1FnbGkxaCt3bjd5TjlqL3Rt?=
 =?utf-8?B?YXZBZU00dUNtMTdHNWhzSXVxUm9FaEh3bnBMWnFhQ2ZCUGtDVkgxNitndDQx?=
 =?utf-8?B?Wk0yN1VlRDdVcjhSWlVHMEtYU2l5a290cW96UWFrZmo2SGxzOEdlKzBYL1pK?=
 =?utf-8?B?aU9EUy9JcWZFSzFaZnhXbVVhejlOdlJvdUZ4ZWxrNTdZaTZZTlRXZDRKdXo2?=
 =?utf-8?B?Wnp3OW5XMXVaME01NkMwc2d0cnBrT01wZWFFQjhHQVhOOVJBOTdiWFdSdEl4?=
 =?utf-8?B?YWJ3NE5HRDgyMFVIVFB5S29leG8vdzg5SlFFS290UWI4amhycVBseERDanhW?=
 =?utf-8?Q?StT83Q6n3mTsrRifbkgpNYLbn4u9Pji9Oq1yXVj?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83185b5d-9094-46a8-d1d7-08d926a4d213
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 15:32:38.9382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WIh3KBoWYWG3evtCK0UwuKnRIbzF1D1Y10LOoA8OZjj31PQ19el6ucbjYD3C6HjnPU046CORsk3b7yb6mulfkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB0944
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <913586B987FDB64C98FA3165C80ECE86@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy82LzIwMjEgMTE6MjEgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+IE9uIFRodSwgSnVuIDAz
LCAyMDIxIGF0IDAzOjEwOjMxUE0gKzAwMDAsIExpYW5nIFh1IHdyb3RlOg0KPj4gT24gMy82LzIw
MjEgNToxNyBwbSwgUnVzc2VsbCBLaW5nIChPcmFjbGUpIHdyb3RlOg0KPj4+PiArc3RhdGljIGlu
dCBncHlfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+Pj4gK3sNCj4+
Pj4gKyBpbnQgcmV0LCBmd192ZXI7DQo+Pj4+ICsNCj4+Pj4gKyAvKiBTaG93IEdQWSBQSFkgRlcg
dmVyc2lvbiBpbiBkbWVzZyAqLw0KPj4+PiArIGZ3X3ZlciA9IHBoeV9yZWFkKHBoeWRldiwgUEhZ
X0ZXVik7DQo+Pj4+ICsgaWYgKGZ3X3ZlciA8IDApDQo+Pj4+ICsgcmV0dXJuIGZ3X3ZlcjsNCj4+
Pj4gKw0KPj4+PiArIHBoeWRldl9pbmZvKHBoeWRldiwgIkZpcm13YXJlIFZlcnNpb246IDB4JTA0
WCAoJXMpXG4iLCBmd192ZXIsDQo+Pj4+ICsgKGZ3X3ZlciAmIFBIWV9GV1ZfUkVMX01BU0spID8g
InJlbGVhc2UiIDogInRlc3QiKTsNCj4+PiBEb2VzIHRoaXMgbmVlZCB0byBwcmludCB0aGUgZmly
bXdhcmUgdmVyc2lvbiBlYWNoIHRpbWUgY29uZmlnX2luaXQoKQ0KPj4+IGlzIGNhbGxlZD8gSXMg
aXQgbGlrZWx5IHRvIGNoYW5nZSBiZXlvbmQ/IFdvdWxkIGl0IGJlIG1vcmUgc2Vuc2libGUNCj4+
PiB0byBwcmludCBpdCBpbiB0aGUgcHJvYmUoKSBtZXRob2Q/DQo+PiBUaGUgZmlybXdhcmUgdmVy
c2lvbiBjYW4gY2hhbmdlIGluIGRldmljZSB3aXRoIGRpZmZlcmVudCBmaXJtd2FyZQ0KPj4gbG9h
ZGluZyBtZWNoYW5pc20uDQo+Pg0KPj4gSSBtb3ZlZCB0aGUgcHJpbnQgdG8gcHJvYmUgYW5kIHRl
c3RlZCBhIGZldyBkZXZpY2VzLCBmb3VuZCBpbiBzb21lIGNhc2VzDQo+PiBpdCBkaWQgbm90IHBy
aW50IHRoZSBhY3RpdmUgdmVyc2lvbiBudW1iZXIuDQo+IFRoYXQgYWN0dWFsbHkgc291bmRzIGxp
a2UgYSByZWFsIHByb2JsZW0uIElmIGl0IGlzIHN0aWxsIGluIHRoZQ0KPiBib290bG9hZGVyIHdo
ZW4gdGhlIGRyaXZlciBpcyBwcm9iZWQsIHRoZSBkcml2ZXIgc2hvdWxkIG5vdCBiZSB3cml0aW5n
DQo+IGFueSBjb25maWd1cmF0aW9uIHJlZ2lzdGVycyB1bnRpbCB0aGUgcmVhbCBpbWFnZSBpcyBy
dW5uaW5nLiBTbyBpdA0KPiBzb3VuZHMgbGlrZSB5b3UgbmVlZCBhIHByb2JlIGZ1bmN0aW9uIHdo
aWNoIGNoZWNrcyBpZiB0aGUgUEhZIGhhcw0KPiBmaW5pc2hlZCBib290aW5nLCBhbmQgaWYgbm90
LCB3YWl0IGZvciB0aGUgcmVhbCBmaXJtd2FyZSB0byBzdGFydA0KPiBydW5uaW5nLg0KPg0KPiAg
ICAgICAgICBBbmRyZXcNCj4NCkkgdGhpbmsgbXkgd29yZCB3YXMgbWlzbGVhZGluZy4NCg0KVGhl
IGRldmljZSBhbHdheXMgaGFzIHZhbGlkIGZpcm13YXJlIHJ1bm5pbmcuDQoNClRoZSBmaXJtd2Fy
ZSB2ZXJzaW9uIGNhbiBjaGFuZ2UgYmVjYXVzZSBvZiBzd2l0Y2ggb2YgdGhlIGZpcm13YXJlIGR1
cmluZyANCnJ1bm5pbmcgdGltZS4NCg0KDQo=

